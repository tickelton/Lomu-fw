#######################################################################
# Makefile for STM32L562CET6

PROJECT = main
CUBE_PATH ?= STM32CubeL5
HEAP_SIZE = 0x100
FLASH_OFFSET=0x08000000

################
# Sources

SOURCES_S = ${CUBE_PATH}/Drivers/CMSIS/Device/ST/STM32L5xx/Source/Templates/gcc/startup_stm32l562xx.s

SOURCES_C = src/main.c

SOURCES_C += src/stm32l5xx_hal_msp.c
SOURCES_C += src/stm32l5xx_it.c
SOURCES_C += src/syscalls.c
SOURCES_C += src/sysmem.c

SOURCES_C += ${CUBE_PATH}/Drivers/CMSIS/Device/ST/STM32L5xx/Source/Templates/system_stm32l5xx.c
#SOURCES_C += ${CUBE_PATH}/Drivers/BSP/STM32L5xx_Nucleo_144/stm32l5xx_nucleo_144.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_cortex.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_dma.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_exti.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_flash.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_flash_ex.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_gpio.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_i2c.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_i2c_ex.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_pwr.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_pwr_ex.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_rcc.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_rcc_ex.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_tim.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_tim_ex.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_uart.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_uart_ex.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_icache.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_pcd.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_pcd_ex.c
SOURCES_C += ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_ll_usb.c

SOURCES_CPP =

SOURCES = $(SOURCES_S) $(SOURCES_C) $(SOURCES_CPP)
OBJS = $(SOURCES_S:.s=.o) $(SOURCES_C:.c=.o) $(SOURCES_CPP:.cpp=.o)

################
# Includes and Defines

INCLUDES += -I src
INCLUDES += -I ${CUBE_PATH}/Drivers/CMSIS/Include
INCLUDES += -I ${CUBE_PATH}/Drivers/CMSIS/Device/ST/STM32L5xx/Include
INCLUDES += -I ${CUBE_PATH}/Drivers/STM32L5xx_HAL_Driver/Inc
#INCLUDES += -I ${CUBE_PATH}/Drivers/BSP/STM32L5xx_Nucleo_144
#INCLUDES += -I ${CUBE_PATH}/Drivers/BSP/STM32L5xx-Nucleo

#DEFINES = -DSTM32 -DSTM32F3 -DSTM32F302xx
#DEFINES = -DUSE_HAL_DRIVER -DSTM32 -DSTM32F3 -DSTM32F302x8
DEFINES = -DUSE_HAL_DRIVER -DSTM32L562xx

################
# Compiler/Assembler/Linker/etc

PREFIX = arm-none-eabi

CC = $(PREFIX)-gcc
AS = $(PREFIX)-as
AR = $(PREFIX)-ar
LD = $(PREFIX)-gcc
NM = $(PREFIX)-nm
OBJCOPY = $(PREFIX)-objcopy
OBJDUMP = $(PREFIX)-objdump
READELF = $(PREFIX)-readelf
SIZE = $(PREFIX)-size
GDB = $(PREFIX)-gdb
RM = rm -f

################
# Compiler options

MCUFLAGS = -mcpu=cortex-m33 -mlittle-endian
MCUFLAGS += -mfloat-abi=hard -mfpu=fpv5-sp-d16
MCUFLAGS += -mthumb

DEBUG_OPTIMIZE_FLAGS = -O0 -g -ggdb3
#DEBUG_OPTIMIZE_FLAGS = -O2

CFLAGS = -std=c11
CFLAGS += -Wall -Wextra --pedantic
# generate listing files
CFLAGS += -Wa,-aghlms=$(<:%.c=%.lst)
CFLAGS += -DHEAP_SIZE=$(HEAP_SIZE)
CFLAGS += -fstack-usage

CFLAGS_EXTRA = -nostartfiles -nodefaultlibs -nostdlib
CFLAGS_EXTRA += -fdata-sections -ffunction-sections

CFLAGS += $(DEFINES) $(MCUFLAGS) $(DEBUG_OPTIMIZE_FLAGS) $(CFLAGS_EXTRA) $(INCLUDES)

LDFLAGS = -static $(MCUFLAGS)
LDFLAGS += -Wl,--start-group -lgcc -lm -lc -lg -lstdc++ -lsupc++ -Wl,--end-group
LDFLAGS += -Wl,--gc-sections -Wl,--print-gc-sections -Wl,--cref,-Map=$(@:%.elf=%.map)
LDFLAGS += -Wl,--print-memory-usage
LDFLAGS += -L ${CUBE_PATH}/Drivers/CMSIS/Device/ST/STM32L5xx/Source/Templates/gcc/linker/ -T STM32L562xE_FLASH.ld

################
# phony rules

.PHONY: all clean flash erase

all: $(PROJECT).bin $(PROJECT).hex $(PROJECT).asm

clean:
	$(RM) $(OBJS) $(OBJS:$.o=$.lst) $(OBJS:$.o=$.su) $(PROJECT).elf $(PROJECT).bin $(PROJECT).hex $(PROJECT).map $(PROJECT).asm

JLINK_CPUNAME ?= STM32L562CE 
flash-jlink: $(PROJECT).bin
	# assuming:
	#  * any type of Segger JLINK that is usable with an STM32
	#    (e.g. the embedded jlink on the DK)
	#  * compatible board connected via SWD
	#  * installed JLink Software
	printf "erase\nloadfile $< ${FLASH_OFFSET}\nr\nq\n" | JLinkExe -nogui 1 -autoconnect 1 -device $(JLINK_CPUNAME) -if swd -speed 4000

erase-jlink:
	printf "erase\nr\nq\n" | JLinkExe -nogui 1 -autoconnect 1 -device $(JLINK_CPUNAME) -if swd -speed 4000

################
# dependency graphs for wildcard rules

$(PROJECT).elf: $(OBJS)

################
# wildcard rules

%.elf:
	$(LD) $(OBJS) $(LDFLAGS) -o $@
	$(SIZE) -A $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.hex: %.elf
	$(OBJCOPY) -O ihex $< $@

%.asm: %.elf
	$(OBJDUMP) -dgCxwsSh --show-raw-insn $< > $@

# EOF
