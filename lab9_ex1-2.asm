;=================================================
; Name:Zhaoze Sun 
; Email:zsun102@ucr.edu 
; 
; Lab: lab 6, ex 1 & 2
; Lab section:023 
; TA:James Luo 
; 
;=================================================
.orig x3000
		LD R5, MAX
		LD R4, BASE
		LD R6, BASE
		LD R2, OFFSET
		
		LOOP
			LEA R0, PROMPT
			PUTS
			GETC
			OUT
			
			ADD R3, R0, R2
			BRn END_LOOP
			BRz IS_POP
			ADD R3, R3, #-1
			BRz IS_PUSH
			BRp END_LOOP
				
			IS_POP
				LD R1, SUB_STACK_POP_3400
				JSRR R1
				ADD R1, R0, #0
				LEA R0, POPPED_VALUE
				PUTS
				ADD R0, R1, #0
				OUT
				BR LOOP
			
			IS_PUSH
				LEA R0, PUSH_PROMPT
				PUTS
				GETC
				OUT
				LD R1, SUB_STACK_PUSH_3200
				JSRR R1
				BR LOOP

		END_LOOP	  
		LEA R0, GOODBYE
		PUTS 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
SUB_STACK_PUSH_3200 	.FILL x3200
SUB_STACK_POP_3400		.FIll x3400
MAX						.FILL xA005
BASE					.FILL xA000
PROMPT					.STRINGZ "\nEnter 0 for pop, 1 for push, and anything else to quit\n"
PUSH_PROMPT				.STRINGZ "\nEnter value to push\n"
OFFSET					.FILL #-48
NEWLINE					.FILL x0A
GOODBYE					.STRINGZ "\nGoodbye!\n"
POPPED_VALUE			.STRINGZ "\nValue Popped: "

.end
;===============================================================================================


; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3200
;Backup registers
	ST R0, backup_r0_3200
	ST R1, backup_r1_3200
	ST R2, backup_r2_3200
	ST R3, backup_r3_3200
	ST R4, backup_r4_3200
	ST R5, backup_r5_3200
	ST R7, backup_r7_3200 
				 
	NOT R5, R5
	ADD R5, R5, #1
	ADD R1, R5, R6
	BRn UNDER_STACK
		LEA R0, OVERFLOW_MESSAGE
		PUTS
		BR END_OF_SUB
	UNDER_STACK
	ADD R6, R6, #1
	STR R0, R6, #0	 
	END_OF_SUB
				 
;Restore registers
	LD R0, backup_r0_3200
	LD R1, backup_r1_3200
	LD R2, backup_r2_3200
	LD R3, backup_r3_3200
	LD R4, backup_r4_3200
	LD R5, backup_r5_3200
	LD R7, backup_r7_3200			 			 
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data
	backup_r0_3200 	.BLKW #1
	backup_r1_3200 	.BLKW #1
	backup_r2_3200 	.BLKW #1
	backup_r3_3200 	.BLKW #1
	backup_r4_3200 	.BLKW #1
	backup_r5_3200 	.BLKW #1
	backup_r7_3200 	.BLKW #1
	OVERFLOW_MESSAGE  .STRINGZ "\nOverflow Error"

.end
;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3400
;Backup registers
	ST R1, backup_r1_3400
	ST R2, backup_r2_3400
	ST R3, backup_r3_3400
	ST R4, backup_r4_3400
	ST R5, backup_r5_3400
	ST R7, backup_r7_3400 
	
	NOT R4, R4
	ADD R4, R4, #1
	
	ADD R1, R4, R6
	BRp NOT_UNDERFLOW
		LEA R0, UNDERFLOW_MESSAGE
		PUTS
		BR END_OF_SUB_3400
	NOT_UNDERFLOW
	LDR R0, R6, #0
	ADD R6, R6, #-1
	END_OF_SUB_3400
				 
;Restore registers
	LD R1, backup_r1_3400
	LD R2, backup_r2_3400
	LD R3, backup_r3_3400
	LD R4, backup_r4_3400
	LD R5, backup_r5_3400
	LD R7, backup_r7_3400	
					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
	backup_r1_3400 	.BLKW #1
	backup_r2_3400 	.BLKW #1
	backup_r3_3400 	.BLKW #1
	backup_r4_3400 	.BLKW #1
	backup_r5_3400 	.BLKW #1
	backup_r7_3400 	.BLKW #1
	UNDERFLOW_MESSAGE .STRINGZ "\nUnderflow Error"
	.end