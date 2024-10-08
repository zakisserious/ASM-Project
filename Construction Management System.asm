;----------------------------------CSLLT FINAL ASM FILE----------------------------------------------
;----------------------------------------ZAKARIA OMAR-------------------------------------------------
.model small
.stack 100h
.data

        ; Initial Values of Materials
        cementStock dw 16
        sandStock dw 3
        brickStock dw 117

        ; Prices of Materials
        cementPrice dw 20
        sandPrice dw 15
        brickPrice dw 40

        ; Sales
        cart db 3 dup(0) ; Cart For User
        total dw 0
        totalSales dw 0

        ; User's username
        askUsername db 10,10 ,'Enter Your Name: $'
        greetingMessage db 13,10,10,'Welcome to the system $'
        buffer db 100 dup(0)

        mainMenu db 10,10,10, "-------------------------------"
                db 10, " Construction Materials System"
                db 10, "-------------------------------"
                db 10, " 1. Purchase Materials"
                db 10, " 2. Sales Report"
                db 10, " 3. Inventory Management"
                db 10, " 4. Cart and Checkout"
                db 10, " 5. Exit"
                db 10, "------------------------"
                db 10, "Input a number(1-5) for your choice: $"
        
        badInput db 10, 10, "------------------ Error -------------------"
        db 10, "Invalid input. Please follow the instructions and input 1-5"
                db 10, "--------------------------------------------$"

        purchaseItemMenu db 10,10,10, "-----------------------------"
                db 10, "----- List of Materials -----"
                db 10, "-----------------------------"
                db 10, "1. Cement     = RM 20"
                db 10, "2. Sand     = RM 15"
                db 10, "3. Brick  = RM 40"
                db 10, "4. Back"
                db 10, "-------------------------"
                db 10, "Which material do you want to buy?: $"

                purchaseItemInput db 10, "How many of this item?: $"

                addedToCartMessage db 10, 10, "Items Successfully added to Cart."
                db 10, "View your cart and complete checkout in the cart page!$" 
        
                purchaseExceed db 10, 10, "We do not have enough stock to fulfill your request."
                db 10, "Put in a lower number of items to purchase$"

                addToCartQuestion db 10, 10, "Would you like to add anything to your purchase?"
                db 10, "1. Yes"
                db 10, "2. No"
                db 10, "Input choice: $"

        totalSalesHeader db 10,10,10,"Total Sales: RM$"

        manageInventoryHeader db 10,10,10,"-------------------------"
                db 10, "------- Inventory -------"
                db 10, "-------------------------"
                db 10
                db 10, "Stock: "
                db 10, "Cement    =  $"

        sandString db 10, "Sand    =  $"
        brickString db 10, "Brick =  $"

        manageInventoryMenu db 10,10,"1. Add Stock"
                db 10, "2. Back"
                db 10,10,"WARNING! If stock amount is highlighted,order more!"
                db 10, "Input Choice: $"

        addStockMenuText db 10,10,10,"-------------------------"
                db 10, "------- Add Stock -------"
                db 10, "-------------------------"
                db 10
                db 10, "1. Cement"
                db 10, "2. Sand"
                db 10, "3. Brick"
                db 10, 10, "Input a number to purchase more stock: $"

        addInput db 10, "Enter the number to add: $"

        cartInterfaceMenu db 10,10,10, "----------------"
                db 10, "----- Cart -----"
                db 10, "----------------"
                db 10
                db 10, "Cement    =  $"

        cartOptions db 10,10, "1. Checkout"
                db 10, "2. Back"
                db 10, "Input Choice: $"

        cartTotal db 10, 10, "Total(RM) = $"
        checkoutSuccessMessage db 10, 10, "Materials purchased successfully!$"
        cartEmptyValidationMessage db 10, 10, "Cart Is Empty! Add Items to Cart before Checkout Process!"
        db 10, "Checkout Unsuccessful $"
                

.code

purchaseItemProc proc

purchaseItemMacro Macro stock, price, cartIndex

        ; Display Message
        mov ah, 09h
        mov dx, offset purchaseItemInput
        int 21h

        ; Character Input (Quantity of Item)
        mov ah, 01h
        int 21h
        sub al, 30h

        mov bx, offset stock ; Load Stock

        ; Ensure the quantity purchased does not exceed current stock
        cmp [bx], al
        jl unableToPurchase

        sub [bx], al ; Deduct Quantity From Stock

        add cartIndex, al ; Add quantity inputted by user to cart

        ; Multiply character input by itemPrice
        mov bl, al
        mov ax, [price] ; load itemPrice to AX
        mul bl ; multiply AX and BL, result in AX

        mov bx, offset total 
        add [bx], ax

        jmp addToCart                     

endm

printPurchaseItemHeader:
        ; Display Message
        mov ah, 09h
        mov dx, offset purchaseItemMenu
        int 21h

        ; Character Input
        mov ah, 01h
        int 21h       

        ; Conditions
        cmp al, '1' ; If user wants to purchase cement
        je purchaseCement

        cmp al, '2' ; If user wants to purchase sand
        je purchaseSand

        cmp al, '3' ; If user wants to purchase brick
        je purchaseBrick

        cmp al, '4' ; Go back to Main Menu
        je return

        ; If input is not 1 to 3
        jmp purchaseItemBadInput

return:
        ret

addToCart:
        ; Display Message
        mov ah, 09h 
        mov dx, offset addToCartQuestion
        int 21h

        ; Character Input (Quantity of Item)
        mov ah, 01h
        int 21h

        cmp al, '1' ; If user still wants to add more materials into cart
        je printPurchaseItemHeader

        jmp addEverything

purchaseCement:

        purchaseItemMacro cementStock, cementPrice, cart[0]

purchaseSand:

        purchaseItemMacro sandStock, sandPrice, cart[1]

purchaseBrick:

        purchaseItemMacro brickStock, brickPrice, cart[2]

addEverything: 

        ; Display Message
        mov ah, 09h
        mov dx, offset addedToCartMessage
        int 21h    

        jmp return  

unableToPurchase:
        ; Display Message
        mov ah, 09h 
        mov dx, offset purchaseExceed
        int 21h

        jmp printPurchaseItemHeader

purchaseItemBadInput:
        ; Display Message
        mov ah, 09h 
        mov dx, offset badInput
        int 21h    

        jmp printPurchaseItemHeader    

purchaseItemProc endp

addStock proc

addStockMacro Macro stock

        ; Display Message
        mov ah, 09h
        mov dx, offset addInput
        int 21h

        ; Character Input
        mov ah, 01h
        int 21h
        sub al, 30h

        mov bx, offset stock
        add [bx], al     ; add user input with stock                           

endm

printAddStockHeader:
        ; Display Message
        mov ah, 09h
        mov dx, offset addStockMenuText
        int 21h

        ; Character Input
        mov ah, 01h
        int 21h

        ; Conditions
        cmp al, '1' ; If user wants to add cement
        je addCement

        cmp al, '2' ; If user wants to add sand
        je addSand

        cmp al, '3' ; If user wants to add brick
        je addBrick

        jmp addStockBadInput

addCement:

        addStockMacro cementStock
        jmp addStockReturn

addSand:

        addStockMacro sandStock
        jmp addStockReturn

addBrick:

        addStockMacro brickStock
        jmp addStockReturn

addStockBadInput:
        ; Display Message
        mov ah, 09h
        mov dx, offset badInput
        int 21h

        jmp printAddStockHeader

addStockReturn:
        ret

addStock endp

displayInteger proc

        ; If stock less than 3, use lowStock (Highlighting the ones under 3)
        cmp ax, 3       
        jle lowStock

        ; To determine how many times to loop after constantly dividing by 10
        mov cx, 0         
        mov bx, 10        ; Used for dividing by 10 later

convertToString:
        ; Divide 10 with AX (Remainder will be in dx)
        mov dx, 0     
        div bx       
        
        push ax      ; Save the quotient in the stack
        add dl, '0'  ; Convert the remainder to a character

        pop ax       ; Restore the quotient from the stack
        push dx      ; Push the converted remainder onto the stack
        inc cx       ; Increment the counter (used for printing later)
        cmp ax, 0    ; Compare the quotient to 0
        jnz convertToString ; If the quotient is not 0, loop again

        mov ah, 02h

displayString:
        pop dx    ; Pop the top character from the stack into register DX
        int 21h   ; Display
        dec cx    ; Decrement the counter
        jnz displayString ; If there are still characters to print, loop again

        ret

lowStock:
        mov ah, 09h
        add ax, '0'
        mov bh, 0
        mov bl, 4Fh ; Red background
        mov cx, 1 ; Since lesser than 5 will only be highlighted, it will always be 1 character
        int 10h
        ret        

displayInteger endp

checkoutProc proc

printCartMacro Macro cartIndex
        ; Display Stock Amount in Cart
        mov ah, 02h
        mov al, cartIndex
        add al, '0' ; convert ASCII code
        mov dl, al
        int 21h        

endm

printCart:
        ; Display Message
        mov ah, 09h
        mov dx, offset cartInterfaceMenu
        int 21h

        printCartMacro cart[0]

        ; Display Sand String
        mov ah, 09h
        mov dx, offset sandString
        int 21h

        printCartMacro cart[1]

        ; Display Brick String
        mov ah, 09h
        mov dx, offset brickString
        int 21h

        printCartMacro cart[2]

        ; Display Message
        mov ah, 09h
        mov dx, offset cartTotal
        int 21h

        ; Display total price
        mov ax, total
        call displayInteger

        jmp cartInterfaceOptions      

cartInterfaceOptions:
        ; Display Message
        mov ah, 09h
        mov dx, offset cartOptions
        int 21h

        ; Character Input
        mov ah, 01h
        int 21h 

        ; Conditions
        cmp al, '1' ; Checkout
        je addSales

        cmp al, '2' ; Return back to main menu
        je returnCart

        jmp cartInputError ; Input not 1 or 2

addSales:

        ; Validation (total cant be 0)
        cmp total, 0
        je cartEmptyValidationError

        ; Add ax to totalSales
        mov ax, [total]
        add ax, [totalSales]
        mov [totalSales], ax
        mov total, 0 ; Reset total to 0

        ; Reseting Cart
        mov cart[0], 0
        mov cart[1], 0
        mov cart[2], 0

        ; Display Success Message
        mov ah, 09h
        mov dx, offset checkoutSuccessMessage
        int 21h

        jmp return

cartInputError:
        mov ah, 09h
        mov dx, offset badInput
        int 21h

        jmp printCart

cartEmptyValidationError:
        mov ah, 09h
        mov dx, offset cartEmptyValidationMessage
        int 21h

        jmp returnCart

returnCart:
        ret

checkoutProc endp

Main proc

        ; Initialize data segment
        mov ax, @data
        mov ds, ax    

        ; Ask user's username
        mov ah, 09h
        mov dx, offset askUsername
        int 21h

        ; Read String (Not Character)
        mov buffer[0], 21
        mov ah, 0Ah
        mov dx, offset buffer
        int 21h

        mov ah, 09h
        mov dx, offset greetingMessage
        int 21h

        mov bx, 2
        add bl, buffer[1]
        mov buffer[bx], '$'

        mov ah, 09h
        mov dx, offset buffer
        add dx, 2
        int 21h        

        jmp MainInterface

MainInterface:
        ; Display Message        
        mov ah, 09h
        mov dx, offset mainMenu
        int 21h 

        ; Character Input
        mov ah, 01h
        int 21h
        
        ; Conditions
        cmp al, '1'
        je purchaseItem ; Page that allow user to purchase materials
        
        cmp al, '2'
                je displayTotalSale ; Page that displays total sales

        cmp al, '3'
        je manageInventory ; Manages Inventory

        cmp al, '4'
        je cartInterface ; displays cart + checkout

        cmp al, '5'
        je exit ; Exit program

        ; If input is not 1 to 5
        jmp mainInputError

purchaseItem:
        call purchaseItemProc
        jmp MainInterface

displayTotalSale:
        ; Display Total Sales Message
        mov ah, 09h
        mov dx, offset totalSalesHeader
        int 21h

        ; Display total sales
        mov ax, totalSales
        call displayInteger

        jmp MainInterface

manageInventory:
        ; Display Inventory Management Menu
        mov ah, 09h
        mov dx, offset manageInventoryHeader
        int 21h

        ; Display cement stock
        mov ax, cementStock
        call displayInteger

        ; Display sand stock
        mov ah, 09h
        mov dx, offset sandString
        int 21h

        mov ax, sandStock
        call displayInteger

        ; Display brick stock
        mov ah, 09h
        mov dx, offset brickString
        int 21h

        mov ax, brickStock
        call displayInteger

        ; Display options
        mov ah, 09h
        mov dx, offset manageInventoryMenu
        int 21h

        ; Character input
        mov ah, 01h
        int 21h

        ; Conditions
        cmp al, '1' ; If user wants to add stock
        je callAddStockMenu

        cmp al, '2' ; Go back to main menu
        je MainInterface

        jmp manageInventoryInputError

callAddStockMenu:
        call addStock
        jmp manageInventory

manageInventoryInputError:
        mov ah, 09h
        mov dx, offset badInput
        int 21h

        jmp manageInventory

cartInterface:
        call checkoutProc
        jmp MainInterface

mainInputError:
        ; Display Error Message
        mov ah, 09h
        mov dx, offset badInput
        int 21h

        jmp MainInterface

exit:
        ; Exit program
        mov ah, 4Ch
        int 21h

Main endp
end Main
