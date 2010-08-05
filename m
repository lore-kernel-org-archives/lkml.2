Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab0HEMeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:34:01 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:45554 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933239Ab0HEMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:33:57 -0400
From: Philippe Langlais <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <gregkh@suse.de>
Cc: <akpm@linux-foundation.org>, <STEricsson_nomadik_linux@list.st.com>,
        <etienne.carriere@stericsson.com>, <vincent.guittot@stericsson.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Subject: [PATCH 1/5] U6/U6715 ARM architecture files
Date: Thu, 5 Aug 2010 14:28:51 +0200
Message-ID: <1281011335-25761-2-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281011335-25761-1-git-send-email-philippe.langlais@stericsson.com>
References: <1281011335-25761-1-git-send-email-philippe.langlais@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
---
 arch/arm/Kconfig                               |   11 +
 arch/arm/Makefile                              |    2 +
 arch/arm/mach-u67xx/Kconfig                    |   12 +
 arch/arm/mach-u67xx/Makefile                   |   11 +
 arch/arm/mach-u67xx/Makefile.boot              |    4 +
 arch/arm/mach-u67xx/board_u67xx_wavex.c        |   47 +++
 arch/arm/mach-u67xx/devices.c                  |   28 ++
 arch/arm/plat-u6xxx/Kconfig                    |   22 ++
 arch/arm/plat-u6xxx/Makefile                   |    8 +
 arch/arm/plat-u6xxx/include/mach/cpu.h         |   36 ++
 arch/arm/plat-u6xxx/include/mach/debug-macro.S |   38 ++
 arch/arm/plat-u6xxx/include/mach/entry-macro.S |   32 ++
 arch/arm/plat-u6xxx/include/mach/hardware.h    |   41 +++
 arch/arm/plat-u6xxx/include/mach/io.h          |   30 ++
 arch/arm/plat-u6xxx/include/mach/irqs.h        |  102 ++++++
 arch/arm/plat-u6xxx/include/mach/memory.h      |   17 +
 arch/arm/plat-u6xxx/include/mach/regs-u6.h     |  121 +++++++
 arch/arm/plat-u6xxx/include/mach/system.h      |   42 +++
 arch/arm/plat-u6xxx/include/mach/timer.h       |   16 +
 arch/arm/plat-u6xxx/include/mach/timex.h       |   23 ++
 arch/arm/plat-u6xxx/include/mach/uncompress.h  |   47 +++
 arch/arm/plat-u6xxx/include/mach/vmalloc.h     |   10 +
 arch/arm/plat-u6xxx/io.c                       |   34 ++
 arch/arm/plat-u6xxx/irq.c                      |  254 ++++++++++++++
 arch/arm/plat-u6xxx/timer.c                    |  442 ++++++++++++++++++++++++
 25 files changed, 1430 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-u67xx/Kconfig
 create mode 100644 arch/arm/mach-u67xx/Makefile
 create mode 100644 arch/arm/mach-u67xx/Makefile.boot
 create mode 100644 arch/arm/mach-u67xx/board_u67xx_wavex.c
 create mode 100644 arch/arm/mach-u67xx/devices.c
 create mode 100644 arch/arm/plat-u6xxx/Kconfig
 create mode 100644 arch/arm/plat-u6xxx/Makefile
 create mode 100644 arch/arm/plat-u6xxx/include/mach/cpu.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/debug-macro.S
 create mode 100644 arch/arm/plat-u6xxx/include/mach/entry-macro.S
 create mode 100644 arch/arm/plat-u6xxx/include/mach/hardware.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/io.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/irqs.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/memory.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/regs-u6.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/system.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/timer.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/timex.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/uncompress.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/vmalloc.h
 create mode 100644 arch/arm/plat-u6xxx/io.c
 create mode 100644 arch/arm/plat-u6xxx/irq.c
 create mode 100644 arch/arm/plat-u6xxx/timer.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cf30fc9..1ae089c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -739,6 +739,14 @@ config ARCH_U300
 	help
 	  Support for ST-Ericsson U300 series mobile platforms.
 
+config PLAT_U6XXX
+	bool "ST-Ericsson U6XXX Series"
+	select CPU_ARM926T
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	help
+	  Support for ST-Ericsson's U6XXX architecture
+
 config ARCH_U8500
 	bool "ST-Ericsson U8500 Series"
 	select CPU_V7
@@ -910,6 +918,9 @@ source "arch/arm/mach-tegra/Kconfig"
 
 source "arch/arm/mach-u300/Kconfig"
 
+source "arch/arm/plat-u6xxx/Kconfig"
+source "arch/arm/mach-u67xx/Kconfig"
+
 source "arch/arm/mach-ux500/Kconfig"
 
 source "arch/arm/mach-versatile/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 2de67c9..c510a64 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -176,6 +176,7 @@ machine-$(CONFIG_ARCH_STMP378X)		:= stmp378x
 machine-$(CONFIG_ARCH_STMP37XX)		:= stmp37xx
 machine-$(CONFIG_ARCH_TEGRA)		:= tegra
 machine-$(CONFIG_ARCH_U300)		:= u300
+machine-$(CONFIG_ARCH_U67XX)		:= u67xx
 machine-$(CONFIG_ARCH_U8500)		:= ux500
 machine-$(CONFIG_ARCH_VERSATILE)	:= versatile
 machine-$(CONFIG_ARCH_VEXPRESS)		:= vexpress
@@ -200,6 +201,7 @@ plat-$(CONFIG_PLAT_PXA)		:= pxa
 plat-$(CONFIG_PLAT_S3C24XX)	:= s3c24xx samsung
 plat-$(CONFIG_PLAT_S5P)		:= s5p samsung
 plat-$(CONFIG_PLAT_SPEAR)	:= spear
+plat-$(CONFIG_PLAT_U6XXX)	:= u6xxx
 plat-$(CONFIG_PLAT_VERSATILE)	:= versatile
 
 ifeq ($(CONFIG_ARCH_EBSA110),y)
diff --git a/arch/arm/mach-u67xx/Kconfig b/arch/arm/mach-u67xx/Kconfig
new file mode 100644
index 0000000..f02f6e2
--- /dev/null
+++ b/arch/arm/mach-u67xx/Kconfig
@@ -0,0 +1,12 @@
+comment "U67XX Board Type"
+	depends on ARCH_U67XX
+
+choice
+	depends on ARCH_U67XX
+	prompt "Choose the U67XX Board type"
+	default MACH_U67XX_WAVEC_2GB
+	help
+		Choose the ST-Ericsson Reference Design Board
+config MACH_U67XX_WAVEC_2GB
+	bool "U67XX WaveC Board with 2Gb Micron combo"
+endchoice
diff --git a/arch/arm/mach-u67xx/Makefile b/arch/arm/mach-u67xx/Makefile
new file mode 100644
index 0000000..38cf624
--- /dev/null
+++ b/arch/arm/mach-u67xx/Makefile
@@ -0,0 +1,11 @@
+#
+## Makefile for the linux kernel, hardware dependent part of ST-Ericsson U67xx
+#
+#
+## Object file lists.
+
+# Common support
+obj-y			:= devices.o
+
+# Specific board support
+obj-$(CONFIG_MACH_U67XX_WAVEC_2GB) += board_u67xx_wavex.o
diff --git a/arch/arm/mach-u67xx/Makefile.boot b/arch/arm/mach-u67xx/Makefile.boot
new file mode 100644
index 0000000..c4e8c02
--- /dev/null
+++ b/arch/arm/mach-u67xx/Makefile.boot
@@ -0,0 +1,4 @@
+   zreladdr-y		:= 0x20008000
+params_phys-y		:= 0x20000100
+initrd_phys-y		:= 0x26000000
+
diff --git a/arch/arm/mach-u67xx/board_u67xx_wavex.c b/arch/arm/mach-u67xx/board_u67xx_wavex.c
new file mode 100644
index 0000000..633989f
--- /dev/null
+++ b/arch/arm/mach-u67xx/board_u67xx_wavex.c
@@ -0,0 +1,47 @@
+/*
+ * linux/arch/arm/mach-u67xx/board_u67xx_wavex.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Platform machine definition for U6XXX WAVEx Board.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ioport.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <asm/setup.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+#include <mach/timer.h>
+
+/* List of board specific devices */
+static struct platform_device *devices[] __initdata = {
+};
+
+void __init u67xx_init(void)
+{
+	/* Add specific board devices */
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+}
+
+MACHINE_START(U6715, "STE_U67xx_refd")
+	/* Maintainer: Philippe Langlais <philippe.langlais@stericsson.com> */
+	.phys_io	= UART1_BASE,
+	.io_pg_offst	= (IO_ADDRESS(UART1_BASE) >> 18) & 0xfffc,
+	.boot_params	= PHYS_OFFSET + 0x100,
+	.map_io		= u6xxx_map_io,
+	.init_irq	= u6_init_irq,
+	.init_machine	= u67xx_init,
+	.timer		= &u6_timer,
+MACHINE_END
+
diff --git a/arch/arm/mach-u67xx/devices.c b/arch/arm/mach-u67xx/devices.c
new file mode 100644
index 0000000..1d00b35
--- /dev/null
+++ b/arch/arm/mach-u67xx/devices.c
@@ -0,0 +1,28 @@
+/*
+ * linux/arch/arm/mach-u67xx/devices.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Device specification for the U67XX
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+
+/* list of devices */
+static struct platform_device *platform_devs[] __initdata = {
+};
+
+/* register generic devices */
+
+static int __init u67xx_devices_init(void)
+{
+	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
+	return 0;
+}
+
+arch_initcall(u67xx_devices_init);
diff --git a/arch/arm/plat-u6xxx/Kconfig b/arch/arm/plat-u6xxx/Kconfig
new file mode 100644
index 0000000..10929ea
--- /dev/null
+++ b/arch/arm/plat-u6xxx/Kconfig
@@ -0,0 +1,22 @@
+if PLAT_U6XXX
+
+menu "STE U6XXX Implementations"
+
+choice
+	prompt "U67XX System Type"
+	default ARCH_U67XX
+
+config ARCH_U67XX
+	bool "U67XX"
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select U6_MTU_TIMER
+endchoice
+
+endmenu
+
+config U6_MTU_TIMER
+	bool
+	default y
+
+endif
diff --git a/arch/arm/plat-u6xxx/Makefile b/arch/arm/plat-u6xxx/Makefile
new file mode 100644
index 0000000..12c832c
--- /dev/null
+++ b/arch/arm/plat-u6xxx/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the linux kernel hardware independant part of STE U6XXX.
+#
+
+# Common support
+obj-y := io.o irq.o
+
+obj-$(CONFIG_U6_MTU_TIMER) += timer.o
diff --git a/arch/arm/plat-u6xxx/include/mach/cpu.h b/arch/arm/plat-u6xxx/include/mach/cpu.h
new file mode 100644
index 0000000..4f1f57f
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/cpu.h
@@ -0,0 +1,36 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/cpu.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ * U6 cpu type detection
+ */
+
+#ifndef __ASM_PLAT_CPU_H
+#define __ASM_PLAT_CPU_H
+
+/*
+ * Macros to group U6xxx into cpu classes.
+ * These can be used in most places.
+ * cpu_is_u67xx():	True for U67XX
+ */
+
+#define GET_U6XXX_CLASS		((readl(SCON_SYSVER_REG)&0x0F00)>>8)
+#define GET_U6XXX_SUBCLASS	((readl(SCON_SYSVER_REG)&0x0FF0)>>4)
+
+#define cpu_is_u67xx()		0
+#define cpu_is_u67xx_v2()	0
+#define cpu_is_u67xx_v3()	0
+
+#if defined(CONFIG_ARCH_U67XX)
+#  undef cpu_is_u67xx
+#  undef cpu_is_u67xx_v2
+#  undef cpu_is_u67xx_v3
+#  define cpu_is_u67xx()	(GET_U6XXX_CLASS == 0x6)
+#  define cpu_is_u67xx_v2()	(GET_U6XXX_SUBCLASS == 0x62)
+#  define cpu_is_u67xx_v3()	(GET_U6XXX_SUBCLASS == 0x63)
+#endif
+
+#endif /* __ASM_PLAT_CPU_H */
+
diff --git a/arch/arm/plat-u6xxx/include/mach/debug-macro.S b/arch/arm/plat-u6xxx/include/mach/debug-macro.S
new file mode 100644
index 0000000..039c810
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/debug-macro.S
@@ -0,0 +1,38 @@
+/* linux/arch/arm/plat-u6xxx/include/mach/debug-macro.S
+ *
+ * Debugging macro include header
+ *
+ *  Copyright (C) 2010 ST-Ericsson
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+#include <mach/hardware.h>
+
+		.macro	addruart,rx
+		mrc	p15, 0, \rx, c1, c0
+		tst	\rx, #1                       @ MMU enabled?
+		ldreq	\rx, = UART1_BASE             @ physical base address
+		ldrne	\rx, = IO_ADDRESS(UART1_BASE) @ virtual base
+		.endm
+
+		.macro	senduart,rd,rx
+		strb	\rd, [\rx]
+		.endm
+
+		.macro	waituart,rd,rx
+1001:
+		ldr	\rd, [\rx, #20]
+		tst	\rd, #1 << 5	@ LSR_THRE - 0 when full
+		beq	1001b
+		.endm
+
+		.macro	busyuart,rd,rx
+1001:
+		ldr	\rd, [\rx, #20]
+		tst	\rd, #1 << 6	@ LSR_TEMT - 0 when busy
+		beq	1001b
+		.endm
diff --git a/arch/arm/plat-u6xxx/include/mach/entry-macro.S b/arch/arm/plat-u6xxx/include/mach/entry-macro.S
new file mode 100644
index 0000000..cae8824
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/entry-macro.S
@@ -0,0 +1,32 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/entry-macro.S
+ *
+ * Low-level IRQ helper macros for U6-based platforms
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+
+	.macro  arch_ret_to_user, tmp1, tmp2
+	.endm
+
+	.macro	disable_fiq
+	.endm
+
+	.macro  get_irqnr_preamble, base, tmp
+	ldr	\base, =IO_ADDRESS(INTC_BASE)
+	.endm
+
+	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
+	ldr	\irqnr, [\base, #INTC_VECTOR_IRQ_OFFSET] @ load intc vector reg
+	mov	\irqnr, \irqnr, lsr #3              @ Bits[0..2] are reserved
+	ands	\irqnr, \irqnr, #0x00FF             @ mask Bits[11..31]
+	.endm
+
+	.macro	irq_prio_table
+	.endm
+
diff --git a/arch/arm/plat-u6xxx/include/mach/hardware.h b/arch/arm/plat-u6xxx/include/mach/hardware.h
new file mode 100644
index 0000000..79199ec
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/hardware.h
@@ -0,0 +1,41 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/hardware.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef __ASM_ARCH_HARDWARE_H
+#define __ASM_ARCH_HARDWARE_H
+
+#include <asm/sizes.h>
+#ifndef __ASSEMBLER__
+#include <mach/cpu.h>
+#endif
+
+/*
+ * Processor specific registers defines
+ */
+#include "regs-u6.h"
+
+/*
+ * Where in virtual memory the IO devices (timers, system controllers
+ * and so on)
+ */
+
+#define IO_BASE_VIRT            0xE8000000        /* VA of IO */
+
+/* macro to get at IO space when running virtually */
+/* this version gives more IO address range to map*/
+#define IO_ADDRESS(x)   ((x) - IO_BASE_PHYS + IO_BASE_VIRT)
+
+/* typesafe io address */
+#define __io_address(n)		__io(IO_ADDRESS(n))
+
+/*
+ * Board specific defines
+ */
+
+#endif
+
diff --git a/arch/arm/plat-u6xxx/include/mach/io.h b/arch/arm/plat-u6xxx/include/mach/io.h
new file mode 100644
index 0000000..e8a93b4
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/io.h
@@ -0,0 +1,30 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/io.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Dummy IO map & IO definitions
+ */
+#ifndef __ASM_ARM_ARCH_IO_H
+#define __ASM_ARM_ARCH_IO_H
+
+#define IO_SPACE_LIMIT 0xffffffff
+
+#define __io(a)       __typesafe_io(a)
+#define __mem_pci(a)  (a)
+
+/*
+ * I/O mapping
+ */
+#ifdef __ASSEMBLER__
+#define IOMEM(x)		(x)
+#else
+#define IOMEM(x)		((void __force __iomem *)(x))
+#endif
+#define U6_IO_ADDRESS(pa)	IOMEM(IO_ADDRESS(pa))
+
+void u6xxx_map_io(void);
+
+#endif /* __ASM_ARM_ARCH_IO_H */
diff --git a/arch/arm/plat-u6xxx/include/mach/irqs.h b/arch/arm/plat-u6xxx/include/mach/irqs.h
new file mode 100644
index 0000000..2943882
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/irqs.h
@@ -0,0 +1,102 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/irqs.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef __ASM_PLAT_U6_IRQS_H
+#define __ASM_PLAT_U6_IRQS_H
+
+#define IRQ_COUNT             65
+
+/* external IRQ definition EXTINT */
+#define IRQ_EXTINT(num)       (IRQ_COUNT+(num))
+#define EXTINT_NUM(irq)       ((irq)-IRQ_COUNT)
+
+#define NR_EXTINT             24
+#define NR_IRQS	              (IRQ_COUNT+NR_EXTINT)
+
+#ifndef __ASSEMBLY__
+extern unsigned char extint_to_gpio[NR_EXTINT];
+
+#define EXTINT_TO_GPIO(gpio_irq)    extint_to_gpio[gpio_irq-IRQ_COUNT]
+
+void /*__init */ u6_init_irq(void);
+void u6_monitor_irq_enter(unsigned int irq);
+void u6_monitor_irq_exit(unsigned int irq);
+#endif /* __ASSEMBLY__ */
+
+/*
+ * Interrupt numbers
+ */
+#define IRQ_GHOST                       0
+#define IRQ_EXTINT1                     1
+#define IRQ_EXTINT2                     2
+#define IRQ_EXTINT3                     3
+#define IRQ_RFRD                        4
+#define IRQ_MMTU                        5
+#define IRQ_IIS                         6
+#define IRQ_USB                         7
+#define IRQ_I2C2                        8
+#define IRQ_TVO                         9
+#define IRQ_3G_WUP                      10
+#define IRQ_3G_CALINT                   11
+#define IRQ_3G_FRAME_IT                 12
+#define IRQ_GPADCINT                    13
+#define IRQ_ARM9_COMMTX                 14
+#define IRQ_ARM9_COMMRX                 15
+#define IRQ_KBS                         16
+#define IRQ_SCTU2                       17
+#define IRQ_SCTU1                       18
+#define IRQ_PIO1                        19
+#define IRQ_PIO2                        20
+#define IRQ_FINT0                       21
+#define IRQ_FINT1                       22
+#define IRQ_UART2                       23
+#define IRQ_UART1                       24
+#define IRQ_SPI2                        25
+#define IRQ_SPI1                        26
+#define IRQ_FCI                         27
+#define IRQ_I2C1                        28
+#define IRQ_DMAU                        29
+#define IRQ_USIM                        30
+#define IRQ_HSDPA                       31    /* reserved */
+#define IRQ_MSI                         32
+#define IRQ_JDI                         33
+#define IRQ_JDU                         34
+#define IRQ_NFI                         35
+#define IRQ_IPP                         36
+#define IRQ_VDC                         37
+#define IRQ_VEC                         38
+#define IRQ_VDE                         39
+#define IRQ_CAM                         40
+#define IRQ_ETB_ACQ                     41
+#define IRQ_ETB_FULL                    42
+#define IRQ_RESERVED43                  43
+#define IRQ_RESERVED44                  44
+#define IRQ_RESERVED45                  45    /* reserved */
+#define IRQ_RESERVED46                  46
+#define IRQ_RESERVED47                  47
+#define IRQ_PDCU                        48
+#define IRQ_MC2SC0                      49
+#define IRQ_MC2SC1                      50
+#define IRQ_MC2SC2                      51
+#define IRQ_MC2SC3                      52
+#define IRQ_MC2SC4                      53
+#define IRQ_MC2SC5                      54
+#define IRQ_MC2SC6                      55
+#define IRQ_MC2SC7                      56
+
+/* INTC VECTOR_IRQ Register (32 bits) */
+#define INTC_VECTOR_IRQ_OFFSET   0x100
+
+/* INTC REQUEST 64 Registers (32 bits) */
+#define INTC_REQUEST1_OFFSET     0x404
+#define INTC_REQUEST64_OFFSET    0x500
+
+/* interrupt x [1..64] request configuration */
+#define INTC_REQUESTx(x)  U6_IO_ADDRESS(INTC_BASE+INTC_REQUEST1_OFFSET+(x-1)*4)
+
+#endif /* __ASM_PLAT_U6_IRQS_H */
diff --git a/arch/arm/plat-u6xxx/include/mach/memory.h b/arch/arm/plat-u6xxx/include/mach/memory.h
new file mode 100644
index 0000000..71a5c60
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/memory.h
@@ -0,0 +1,17 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/memory.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef __ASM_ARCH_MEMORY_H
+#define __ASM_ARCH_MEMORY_H
+
+/*
+ * Physical DRAM offset.
+ */
+#define PHYS_OFFSET		UL(0x20000000)
+
+#endif
diff --git a/arch/arm/plat-u6xxx/include/mach/regs-u6.h b/arch/arm/plat-u6xxx/include/mach/regs-u6.h
new file mode 100644
index 0000000..aa2fbb0
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/regs-u6.h
@@ -0,0 +1,121 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/regs-u6.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ * Basic register address definitions in physical memory
+ */
+
+#if !defined(__REGS_U6_H__)
+#define __REGS_U6_H__
+
+#define IO_BASE_PHYS              0xC1000000  /* phys base address of reg */
+#define IO_SIZE                   0x03400000  /* How much */
+
+/*
+ * System Controller Core devices base address table
+ */
+
+/* DMA Controller */
+#define DMAU_BASE                 (IO_BASE_PHYS + 0x0000000)
+
+/* Interrupt Controller */
+#define INTC_BASE                 (IO_BASE_PHYS + 0x0100000)
+
+/* SDRam controller */
+#define SDI_BASE                  (IO_BASE_PHYS + 0x0200000)
+
+/* Nand Flash Inteface controller */
+#define NFI_BASE                  (IO_BASE_PHYS + 0x0300000)
+
+/* USB controller */
+#define USB_BASE                  (IO_BASE_PHYS + 0x0400000)
+
+/* Video Display Engine */
+#define VDE_BASE                  (IO_BASE_PHYS + 0x0500000)
+
+/* Video Decoder */
+#define VDC_BASE                  (IO_BASE_PHYS + 0x1000000)
+
+/* Viedo Encoder */
+#define VEC_BASE                  (IO_BASE_PHYS + 0x1100000)
+
+/* Texture Codec, MPEG4 encoder sub module */
+#define TC_BASE                   (IO_BASE_PHYS + 0x1102000)
+
+/* Image Post-Processor */
+#define IPP2_BASE                 (IO_BASE_PHYS + 0x1200000)
+
+/* JPEG Decoder Unit */
+#define JDU_BASE                  (IO_BASE_PHYS + 0x1300000)
+
+/* TV output controller */
+#define TVO_BASE                  (IO_BASE_PHYS + 0x1400000)
+
+/* Camera controller */
+#define CAM_BASE                  (IO_BASE_PHYS + 0x1800000)
+
+/* External Bus Interfaces */
+#define EBI_BASE                  (IO_BASE_PHYS + 0x2001000)
+
+/* SPI controllers */
+#define SPI1_BASE                 (IO_BASE_PHYS + 0x2002000)
+#define SPI2_BASE                 (IO_BASE_PHYS + 0x2003000)
+
+/* SD/MMC controller */
+#define FCI_BASE                  (IO_BASE_PHYS + 0x2008000)
+
+/* Crypto Acceleration Engine */
+#define CAE_BASE                  (IO_BASE_PHYS + 0x2009000)
+
+/* Multimedia Timer Unit, aka MTU in Datasheet */
+#define MMTU_BASE                 (IO_BASE_PHYS + 0x2101000)
+
+/* System controller timer units */
+#define SCTU1_BASE                (IO_BASE_PHYS + 0x2102000)
+#define SCTU2_BASE                (IO_BASE_PHYS + 0x2103000)
+
+/* General Purpose I/O units */
+#define GPIOA_BASE                (IO_BASE_PHYS + 0x2104000)
+#define GPIOB_BASE                (IO_BASE_PHYS + 0x2104200)
+#define GPIOC_BASE                (IO_BASE_PHYS + 0x2104400)
+#define GPIOD_BASE                (IO_BASE_PHYS + 0x2104600)
+#define GPIOE_BASE                (IO_BASE_PHYS + 0x2104800)
+#define GPIOF_BASE                (IO_BASE_PHYS + 0x2104A00)
+
+/* External Interrupt controller */
+#define EXTINT_BASE               (IO_BASE_PHYS + 0x2105000)
+
+/* Keyboard Scanner */
+#define KBS_BASE                  (IO_BASE_PHYS + 0x2106000)
+
+/* Pulse Width Modulators */
+#define PWM1_BASE                 (IO_BASE_PHYS + 0x2108000)
+#define PWM2_BASE                 (IO_BASE_PHYS + 0x2109000)
+#define PWM3_BASE                 (IO_BASE_PHYS + 0x210A000)
+
+/* I2C controllers */
+#define I2C1_BASE                 (IO_BASE_PHYS + 0x210C000)
+#define I2C2_BASE                 (IO_BASE_PHYS + 0x210D000)
+
+/* UARTs */
+#define UART1_BASE                (IO_BASE_PHYS + 0x210E000)
+#define UART2_BASE                (IO_BASE_PHYS + 0x210F000)
+
+/* Clock Generation Unit */
+#define CGU_BASE                  (IO_BASE_PHYS + 0x2200000)
+
+/* Time base Unit */
+#define TBU_BASE                  (IO_BASE_PHYS + 0x2201000)
+
+/* Power Down Control Unit */
+#define PDCU_BASE                 (IO_BASE_PHYS + 0x2202000)
+
+/* Watchdog & Reset Unit */
+#define WDRU_BASE                 (IO_BASE_PHYS + 0x2203000)
+
+/* System Configuration */
+#define SCON_BASE                 (IO_BASE_PHYS + 0x2204000)
+
+#endif /* __REGS_U6_H__ */
diff --git a/arch/arm/plat-u6xxx/include/mach/system.h b/arch/arm/plat-u6xxx/include/mach/system.h
new file mode 100644
index 0000000..8799e57
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/system.h
@@ -0,0 +1,42 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/system.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef __ASM_ARCH_SYSTEM_H
+#define __ASM_ARCH_SYSTEM_H
+
+#include <mach/hardware.h>
+
+/* Watchdog & Reset Unit TIMER Register (16 bits) */
+#define WDRU_TIM_OFFSET                0x4
+
+static inline void arch_idle(void)
+{
+	/*
+	 * This should do all the clock switching
+	 * and wait for interrupt tricks
+	 */
+	cpu_do_idle();
+}
+
+static inline void arch_reset(char mode, const char *cmd)
+{
+	unsigned long flags;
+	/*
+	 * To reset, we hit the on-board reset register
+	 * in the system FPGA
+	 */
+	/* diasble HW interruption */
+	raw_local_irq_save(flags);
+	/* load watchdog with reset value */
+	writel(0x5, IO_ADDRESS(WDRU_BASE + WDRU_TIM_OFFSET));
+	/* wait for wachdog expiration */
+	while (1)
+		;
+}
+
+#endif
diff --git a/arch/arm/plat-u6xxx/include/mach/timer.h b/arch/arm/plat-u6xxx/include/mach/timer.h
new file mode 100644
index 0000000..614d6cf
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/timer.h
@@ -0,0 +1,16 @@
+/*
+ *  linux/arch/arm/plat-u6xxx/include/mach/timer.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef __PLAT_TIMER_H
+#define __PLAT_TIMER_H
+
+struct sys_timer;
+
+extern struct sys_timer u6_timer;
+
+#endif
diff --git a/arch/arm/plat-u6xxx/include/mach/timex.h b/arch/arm/plat-u6xxx/include/mach/timex.h
new file mode 100644
index 0000000..1e71241
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/timex.h
@@ -0,0 +1,23 @@
+/*
+ *  linux/arch/arm/plat-u6xxx/include/mach/timex.h
+ *
+ *  Integrator architecture timex specifications
+ *
+ *  Copyright (C) 1999 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#define CLOCK_TICK_RATE		(50000000 / 16)
diff --git a/arch/arm/plat-u6xxx/include/mach/uncompress.h b/arch/arm/plat-u6xxx/include/mach/uncompress.h
new file mode 100644
index 0000000..e37f0b4
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/uncompress.h
@@ -0,0 +1,47 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/uncompress.h
+ *
+ * Copyright (C) 2010 ST-Ericsson SA
+ * Copyright (C) 2003 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/io.h>
+#include "mach/hardware.h"
+
+/* UART THR Register (8 bits) */
+#define UART1_THR_OFFSET      0x0
+#define UART1_THR_REG         IO_ADDRESS(UART1_BASE + UART1_THR_OFFSET)
+
+/* UART LSR Register (8 bits) */
+#define UART1_LSR_OFFSET      0x14
+#define UART1_LSR_REG         IO_ADDRESS(UART1_BASE + UART1_LSR_OFFSET)
+
+static void putc(int c)
+{
+	while (!(readb(UART1_LSR_REG) & (1<<5)))
+		barrier();
+	writeb(c, UART1_THR_REG);
+}
+
+static inline void flush(void)
+{
+}
+
+/* nothing to do */
+#define arch_decomp_setup()
+
+#define arch_decomp_wdog()
diff --git a/arch/arm/plat-u6xxx/include/mach/vmalloc.h b/arch/arm/plat-u6xxx/include/mach/vmalloc.h
new file mode 100644
index 0000000..cb89107
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/vmalloc.h
@@ -0,0 +1,10 @@
+/*
+ * linux/arch/arm/plat-u6/include/mach/vmalloc.h
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Virtual memory allocations
+ * End must be above the I/O registers and on an even 2MiB boundary.
+ */
+#define VMALLOC_END       0xe8000000UL
diff --git a/arch/arm/plat-u6xxx/io.c b/arch/arm/plat-u6xxx/io.c
new file mode 100644
index 0000000..01d447c
--- /dev/null
+++ b/arch/arm/plat-u6xxx/io.c
@@ -0,0 +1,34 @@
+/*
+ * linux/arch/arm/plat-u6xxx/io.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/io.h>
+
+#include <mach/hardware.h>
+#include <asm/pgtable.h>
+#include <asm/page.h>
+
+#include <asm/mach/map.h>
+
+
+static struct map_desc u6xxx_io_desc[] __initdata = {
+	{
+		.virtual  = IO_BASE_VIRT,	/* only peripherals */
+		.pfn      = __phys_to_pfn(IO_BASE_PHYS),
+		.length   = IO_SIZE,
+		.type     = MT_DEVICE,
+	}
+};
+
+void __init u6xxx_map_io(void)
+{
+    iotable_init(u6xxx_io_desc, ARRAY_SIZE(u6xxx_io_desc));
+}
+
diff --git a/arch/arm/plat-u6xxx/irq.c b/arch/arm/plat-u6xxx/irq.c
new file mode 100644
index 0000000..2ede5f0
--- /dev/null
+++ b/arch/arm/plat-u6xxx/irq.c
@@ -0,0 +1,254 @@
+/*
+ *  linux/arch/arm/plat-u6xxx/irq.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Loic Pallardy <loic.pallardy@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <asm/irq.h>
+#include <mach/hardware.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/irq.h>
+#include <mach/irqs.h>		/* U6 specific constants, types */
+
+/* INTC PRIOMASK_IRQ Register (32 bits) */
+#define INTC_PRIOMASK_IRQ_OFFSET 0x0
+#define INTC_PRIOMASK_IRQ_REG  IO_ADDRESS(INTC_BASE + INTC_PRIOMASK_IRQ_OFFSET)
+
+/* INTC PRIOMASK_FIQ Register (32 bits) */
+#define INTC_PRIOMASK_FIQ_OFFSET 0x4
+#define INTC_PRIOMASK_FIQ_REG  IO_ADDRESS(INTC_BASE + INTC_PRIOMASK_FIQ_OFFSET)
+
+/* INTC VECTOR_IRQ Register (32 bits) */
+#define INTC_VECTOR_IRQ_REG      IO_ADDRESS(INTC_BASE + INTC_VECTOR_IRQ_OFFSET)
+
+/* INTC VECTOR_FIQ Register (32 bits) */
+#define INTC_VECTOR_FIQ_OFFSET   0x104
+#define INTC_VECTOR_FIQ_REG      IO_ADDRESS(INTC_BASE + INTC_VECTOR_FIQ_OFFSET)
+
+/* INTC PENDING_* Registers (32 bits) */
+#define INTC_PENDING_1_OFFSET    0x200
+#define INTC_PENDING_2_OFFSET    0x204
+#define INTC_PENDING_3_OFFSET    0x208
+#define INTC_FEATURES_OFFSET     0x300
+
+#define INTC_REQUESTx_PENDING_MASK       (1 << 31)
+#define INTC_REQUESTx_SET_SWINT_MASK     (1 << 30)
+#define INTC_REQUESTx_CLR_SWINT_MASK     (1 << 29)
+#define INTC_REQUESTx_WE_PRIORITY_MASK   (1 << 28)
+#define INTC_REQUESTx_WE_TARGET_MASK     (1 << 27)
+#define INTC_REQUESTx_WE_ENABLE_MASK     (1 << 26)
+#define INTC_REQUESTx_WE_ACTIVE_LOW_MASK (1 << 25)
+#define INTC_REQUESTx_ACTIVE_LOW_MASK    (1 << 17)
+#define INTC_REQUESTx_ENABLE_MASK        (1 << 16)
+#define INTC_REQUESTx_TARGET_MASK        (1 <<  8)
+
+#define INTC_IID_USB_LP_INT 13
+
+static void u6_irq_mask(uint32_t irqno)
+{
+	if (irqno > 0 || irqno < IRQ_COUNT) {
+		unsigned long flags;
+		void __iomem *a;
+		uint32_t v;
+
+		raw_local_irq_save(flags);
+
+		a = INTC_REQUESTx(irqno);
+		v = readl(a);
+		v &= ~INTC_REQUESTx_ENABLE_MASK;
+		v |= INTC_REQUESTx_WE_ENABLE_MASK;
+		v |= INTC_REQUESTx_CLR_SWINT_MASK;
+		writel(v, a);
+
+		raw_local_irq_restore(flags);
+	}
+}
+
+static void u6_irq_unmask(uint32_t irqno)
+{
+	if (irqno > 0 || irqno < IRQ_COUNT) {
+		unsigned long flags;
+		void __iomem *a;
+		uint32_t v;
+
+		raw_local_irq_save(flags);
+
+		a = INTC_REQUESTx(irqno);
+		v = readl(a);
+		v |= INTC_REQUESTx_ENABLE_MASK;
+		v |= INTC_REQUESTx_WE_ENABLE_MASK;
+		v |= INTC_REQUESTx_CLR_SWINT_MASK;
+		writel(v, a);
+
+		raw_local_irq_restore(flags);
+	}
+}
+
+static int u6_irq_type(unsigned irqno, unsigned type)
+{
+	int l;
+	void __iomem *reg = INTC_REQUESTx(irqno);
+
+	if (irqno > 0 || irqno < IRQ_COUNT) {
+		if (type == IRQF_TRIGGER_LOW) {
+			l = (INTC_REQUESTx_ACTIVE_LOW_MASK
+			     | INTC_REQUESTx_WE_ACTIVE_LOW_MASK);
+		} else if (type == IRQF_TRIGGER_HIGH) {
+			l = (INTC_REQUESTx_WE_ACTIVE_LOW_MASK);
+		} else {
+			goto bad;
+		}
+
+		writel(l, reg);
+		return 0;
+
+	}
+
+bad:
+	return -EINVAL;
+}
+
+int u6_irq_enabled(uint32_t irqno)
+{
+	if (irqno > 0 || irqno < IRQ_COUNT) {
+		void __iomem *a = INTC_REQUESTx(irqno);
+		uint32_t v = readl(a);
+
+		return v & INTC_REQUESTx_ENABLE_MASK;
+	} else
+		return 0;
+}
+
+static struct irq_chip u6_irq_chip = {
+	.ack = u6_irq_mask,
+	.mask = u6_irq_mask,	/* disable irqs */
+	.unmask = u6_irq_unmask,	/* enable irqs */
+	.set_type = u6_irq_type,
+};
+
+
+#if defined(CONFIG_ARCH_U67XX)
+
+static const uint32_t u6_irq_config[] = {
+	0,			/* GHOST      0 */
+	INTC_REQUESTx_ACTIVE_LOW_MASK,	/* EXTINT1    1 */
+	INTC_REQUESTx_ACTIVE_LOW_MASK,	/* EXTINT2    2 */
+	INTC_REQUESTx_ACTIVE_LOW_MASK,	/* EXTINT3    3 */
+	0,			/* RFRD       4 */
+	0,			/* MTU        5 */
+	0,			/* IIS        6 */
+	0,			/* USB        7 */
+	INTC_REQUESTx_ACTIVE_LOW_MASK,	/* I2C2       8 */
+	0,			/* TVO        9 */
+	0,			/* 3G_WUP     10 */
+	0,			/* 3G_CALINT  11 */
+	0,			/* 3G_FRAME_IT 12 */
+	0,			/* GPADCINT    13 */
+	0,			/* ARM9_COMMTX 14 */
+	0,			/* ARM9_COMMRX 15 */
+	0,			/* KBS        16 */
+	0,			/* SCTU2      17 */
+	0,			/* SCTU1      18 */
+	0,			/* PIO1       19 */
+	0,			/* PIO2       20 */
+	0,			/* FINT0      21 */
+	0,			/* FINT1      22 */
+	0,			/* UART2      23 */
+	0,			/* UART1      24 */
+	0,			/* SPI2       25 */
+	0,			/* SPI1       26 */
+	0,			/* FCI        27 */
+	INTC_REQUESTx_ACTIVE_LOW_MASK,	/* I2C1       28 */
+	0,			/* DMAU       29 */
+	0,			/* USIM       30 */
+	0,			/* RESERVED31 31 */
+	INTC_REQUESTx_ACTIVE_LOW_MASK,	/* MSI        32 */
+	0,			/* JDI        33 */
+	0,			/* JDU        34 */
+	0,			/* NFI        35 */
+	0,			/* IPP        36 */
+	0,			/* VDC        37 */
+	0,			/* VEC        38 */
+	0,			/* VDE        39 */
+	INTC_REQUESTx_ACTIVE_LOW_MASK,	/* CAM        40 */
+	0,			/* ETB_ACQ    41 */
+	0,			/* ETB_FULL   42 */
+	0,			/* DIGRF_TX   43 */
+	0,			/* DIGRF_RX   44 */
+	0,			/* RESERVED45 45 */
+	0,			/* FIR_FI     46 */
+	0,			/* FIR        47 */
+	0,			/* PDCU       48 */
+	0,			/* MC2SC0     49 */
+	0,			/* MC2SC1     50 */
+	0,			/* MC2SC2     51 */
+	0,			/* MC2SC3     52 */
+	0,			/* MC2SC4     53 */
+	0,			/* MC2SC5     54 */
+	0,			/* MC2SC6     55 */
+	0,			/* MC2SC7     56 */
+	0,			/* Reserved   57 */
+	0,			/* Reserved   58 */
+	0,			/* Reserved   59 */
+	0,			/* Reserved   60 */
+	0,			/* Reserved   61 */
+	0,			/* Reserved   62 */
+	0,			/* Reserved   63 */
+	0,			/* Reserved   64 */
+};
+
+#endif
+
+static const uint32_t u6_irq_irq_priority;
+static const uint32_t u6_irq_fiq_priority;
+
+void __init u6_init_irq(void)
+{
+	unsigned int irqno;
+
+	/* Clock interrupt controller.
+	 */
+	struct clk *clk = clk_get(NULL, "INTC");
+	clk_enable(clk);
+	clk_put(clk);
+
+	/* The address of the vector table INTCdata.asm is assumed to be aligned
+	 * to a 2KB boundary. Thus the register access value will be padded with
+	 * zeroes, which is conforming to the 'READ_ONLY' attributes of the LS
+	 * 11 bits. We are using the same table for both IRQ and FIQ.
+	 */
+	writel(0, INTC_VECTOR_FIQ_REG);	/* no vector IRQ */
+	writel(0, INTC_VECTOR_IRQ_REG);	/* no vector FIQ */
+
+	writel(u6_irq_irq_priority, INTC_PRIOMASK_IRQ_REG);
+	writel(u6_irq_fiq_priority, INTC_PRIOMASK_FIQ_REG);
+
+	/* Initialize the individual interrupt sources.
+	 */
+	for (irqno = 1; irqno < IRQ_COUNT; irqno += 1) {
+		void __iomem *a = INTC_REQUESTx(irqno);
+		uint32_t v = u6_irq_config[irqno];
+
+		v |= 4;
+		v |= INTC_REQUESTx_WE_ACTIVE_LOW_MASK;
+		v |= INTC_REQUESTx_WE_TARGET_MASK;
+		v |= INTC_REQUESTx_WE_PRIORITY_MASK;
+		v |= INTC_REQUESTx_WE_ENABLE_MASK;
+		v |= INTC_REQUESTx_CLR_SWINT_MASK;
+
+		writel(v, a);
+
+		set_irq_chip(irqno, &u6_irq_chip);
+		set_irq_handler(irqno, handle_level_irq);
+		set_irq_flags(irqno, IRQF_VALID | IRQF_PROBE);
+	}
+}
diff --git a/arch/arm/plat-u6xxx/timer.c b/arch/arm/plat-u6xxx/timer.c
new file mode 100644
index 0000000..b72e8cf
--- /dev/null
+++ b/arch/arm/plat-u6xxx/timer.c
@@ -0,0 +1,442 @@
+/*
+ * linux/arch/arm/plat-u6xxx/timer.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Vincent Guittot <vincent.guittot@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+
+#include <asm/mach/time.h>
+#include <asm/mach/irq.h>
+
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+#include <mach/clock.h>
+
+/*** System timer variable ***/
+struct sys_timer u6_timer;
+
+/*** Module definition ***/
+/*************************/
+
+#define MODULE_NAME "U6_TIMER"
+#define PKMOD MODULE_NAME ": "
+
+/*#define DEBUG*/
+#define U6_MMTU_CLOCK_SOURCE
+
+/*** MMTU clock devices ***/
+/*************************/
+
+/*** MMTU HW ip register index definition ***/
+#define MMTU_CON_IDX 0
+#define MMTU_TCVAL_IDX 0x4
+#define MMTU_PRESCALER_IDX 0x8
+#define MMTU_MATCH_CON_IDX 0xC
+#define MMTU_MATCH0_IDX 0x14
+#define MMTU_MATCH1_IDX 0x18
+
+#define MMTU_INT_OFFSET 0xFD0
+#define MMTU_MOD_CONF_IDX 0x4
+#define MMTU_INT_CLR_ENA_IDX 0x8
+#define MMTU_INT_SET_ENA_IDX 0xC
+#define MMTU_INT_STATUS_IDX 0x10
+#define MMTU_INT_ENABLE_IDX 0x14
+#define MMTU_INT_CLR_STAT_IDX 0x18
+#define MMTU_INT_SET_STAT_IDX 0x1C
+
+#define MMTU_IRQ_MASK		0x1
+#define MMTU_USED_MATCH_IDX	MMTU_MATCH0_IDX
+
+/* MMTU sys clock definition */
+#define MMTU_SYS_FRQ 13000000
+
+/*** MMTU Clock event device ***/
+#define MMTU_ROOT_FRQ 8000
+static int u6_mmtu_set_next_event(unsigned long cycles,
+				struct clock_event_device *evt);
+static void u6_mmtu_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt);
+
+static struct clock_event_device clockevent_mmtu = {
+	.name = "mmtu_timer",
+	.rating = 360,
+	.shift = 30,
+	.features = CLOCK_EVT_FEAT_ONESHOT,
+	.set_next_event = u6_mmtu_set_next_event,
+	.set_mode = u6_mmtu_set_mode,
+};
+
+/*** MMTU Clock source device ***/
+#ifdef U6_MMTU_CLOCK_SOURCE
+static cycle_t u6_mmtu_read(struct clocksource *);
+
+static struct clocksource clocksource_mmtu = {
+	.name = "mmtu_timer",
+	.rating = 360,
+	.read = u6_mmtu_read,
+	.mask = CLOCKSOURCE_MASK(32),
+	.shift = 8,
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+#endif
+
+/*** MMTU driver ***/
+#define RELOAD_COUNTER_POWER_MMTU 32
+#define RELOAD_COUNTER_MMTU (1 << RELOAD_COUNTER_POWER_MMTU)
+
+struct mmtu_ctxt {
+	void __iomem *base;
+	uint32_t compvalue;
+	uint32_t endvalue;
+	struct clk *clk;
+	int mode;
+};
+
+struct mmtu_ctxt mmtu_table[1] = {
+	{
+		.base = U6_IO_ADDRESS(MMTU_BASE),
+	},
+};
+
+static inline struct mmtu_ctxt *u6_mmtu_get_context(int id)
+{
+	return &(mmtu_table[id]);
+}
+
+static inline int u6_mmtu_timer_start(unsigned long cycles, int id);
+static inline void u6_mmtu_clk_enable(int id);
+static inline void u6_mmtu_clk_disable(int id);
+
+static irqreturn_t
+u6_mmtu_timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+{
+	uint8_t status, enable;
+	struct mmtu_ctxt *mmtu;
+
+	mmtu = u6_mmtu_get_context(0);
+
+	status = readl((mmtu->base + MMTU_INT_OFFSET + MMTU_INT_STATUS_IDX));
+	enable = readl((mmtu->base + MMTU_INT_OFFSET + MMTU_INT_ENABLE_IDX));
+
+	pr_debug(PKMOD "mmtu_timer_interrupt %d\n", status);
+
+	if (status & enable & MMTU_IRQ_MASK) {
+		struct clock_event_device *evt = &clockevent_mmtu;
+
+		writel(MMTU_IRQ_MASK, (mmtu->base + MMTU_INT_OFFSET
+					+ MMTU_INT_CLR_STAT_IDX));
+		writel(MMTU_IRQ_MASK,
+				(mmtu->base + MMTU_INT_OFFSET +
+				 MMTU_INT_CLR_ENA_IDX));
+
+		if (evt->event_handler)
+			evt->event_handler(evt);
+	}
+	return IRQ_HANDLED;
+}
+
+static struct irqaction u6_mmtu_timer_irq = {
+	.name = "U6 MMTU timer Tick",
+	.flags = IRQF_DISABLED,
+	.handler = (irq_handler_t) u6_mmtu_timer_interrupt,
+};
+
+static inline void u6_mmtu_clk_enable(int id)
+{
+	struct mmtu_ctxt *mmtu = u6_mmtu_get_context(id);
+
+	/* Clock Multimedia Timer Unit.
+	 */
+	if ((mmtu->clk != NULL) && (mmtu->mode == 0)) {
+		pr_debug(PKMOD "mmtu_clk_enable\n");
+		mmtu->mode = 1;
+		clk_enable(mmtu->clk);
+	}
+}
+
+static inline void u6_mmtu_clk_disable(int id)
+{
+	struct mmtu_ctxt *mmtu = u6_mmtu_get_context(id);
+
+	/* Clock Multimedia Timer Unit.
+	 */
+	if ((mmtu->clk != NULL) && (mmtu->mode == 1)) {
+		pr_debug(PKMOD "mmtu_clk_disable\n");
+		clk_disable(mmtu->clk);
+		mmtu->mode = 0;
+	}
+}
+
+static inline int u6_mmtu_timer_start(unsigned long cycles, int id)
+{
+	struct mmtu_ctxt *mmtu = u6_mmtu_get_context(id);
+
+	pr_debug(PKMOD "mmtu_timer_start %ld\n", cycles);
+	u6_mmtu_clk_enable(id);
+
+	/* MMTU limitation : can't set a value smaller or equal to tcval + 1 */
+	cycles = cycles < 2 ? 2 : cycles;
+
+	mmtu->compvalue = cycles;
+
+	mmtu->endvalue = mmtu->compvalue
+		+ readl((mmtu->base + MMTU_TCVAL_IDX));
+
+	writel(MMTU_IRQ_MASK,
+	       (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_CLR_STAT_IDX));
+
+	writel(mmtu->endvalue, (mmtu->base + MMTU_USED_MATCH_IDX));
+
+	writel(MMTU_IRQ_MASK,
+	       (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_SET_ENA_IDX));
+
+	/* the value has already expired */
+	if ((mmtu->endvalue <= readl((mmtu->base + MMTU_TCVAL_IDX)))
+	    && (mmtu->endvalue > mmtu->compvalue)
+	    && !(readl((mmtu->base + MMTU_INT_OFFSET
+				    + MMTU_INT_STATUS_IDX)) & MMTU_IRQ_MASK))
+		writel(MMTU_IRQ_MASK, (mmtu->base + MMTU_INT_OFFSET
+					+ MMTU_INT_SET_STAT_IDX));
+
+	return 0;
+}
+
+static int u6_mmtu_timer_init(int id, unsigned long reload,
+			     unsigned long prescale, int over_it)
+{
+
+	struct mmtu_ctxt *mmtu = u6_mmtu_get_context(id);
+
+	pr_debug(PKMOD "mmtu_timer_init %d\n", id);
+
+	/* Enable clock */
+/*
+	u6_mmtu_clk_enable(id);
+	clk mngt not available yet
+	directly enable it
+*/
+	{
+		unsigned long flags;
+		unsigned long reg;
+		local_irq_save(flags);
+		reg = readl(CGU_GATESC2_REG);
+		reg |= 0x1 << 2;
+		writel(reg, CGU_GATESC2_REG);
+		local_irq_restore(flags);
+	}
+
+	/* Reset timer */
+	/* reset control register */
+	writel(0x0000, (mmtu->base + MMTU_CON_IDX));
+	writel(0x0002, (mmtu->base + MMTU_CON_IDX));
+	/* reset control register */
+	writel(0x0000, (mmtu->base + MMTU_CON_IDX));
+
+	/* clear whole enable irq register */
+	writel(0xFF, (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_CLR_ENA_IDX));
+	/* clear whole status register */
+	writel(0xFF, (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_CLR_STAT_IDX));
+
+	/* reset pre-scaler reload register */
+	writel(0x00000000, (mmtu->base + MMTU_PRESCALER_IDX));
+
+	/* reset match control register */
+	writel(0x0000, (mmtu->base + MMTU_MATCH_CON_IDX));
+	/* reset match 0 register */
+	writel(0x00000000, (mmtu->base + MMTU_MATCH0_IDX));
+	/* reset match 1 register */
+	writel(0x00000000, (mmtu->base + MMTU_MATCH1_IDX));
+
+	/* Initialize timer */
+	writel(prescale - 1, (mmtu->base + MMTU_PRESCALER_IDX));
+	/* power of 2 system clock */
+	writel(reload, (mmtu->base + MMTU_MATCH0_IDX));
+
+	/* enable counter register */
+	writel(0x0001, (mmtu->base + MMTU_CON_IDX));
+
+	/* clear whole status register */
+	writel(0xFF, (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_CLR_STAT_IDX));
+
+	if (id == 0)
+		setup_irq(IRQ_MMTU, &u6_mmtu_timer_irq);
+
+	/* Disable clock */
+#ifndef U6_MMTU_CLOCK_SOURCE
+	u6_mmtu_clk_disable(id);
+#endif
+	return 0;
+}
+
+/*** MMTU Clock event device ***/
+
+static int u6_mmtu_set_next_event(unsigned long cycles,
+				 struct clock_event_device *evt)
+{
+	pr_debug(PKMOD "mmtu_set_next_event %ld\n", cycles);
+	u6_mmtu_timer_start(cycles, 0);
+
+	return 0;
+}
+
+static void u6_mmtu_set_mode(enum clock_event_mode mode,
+			    struct clock_event_device *evt)
+{
+	struct mmtu_ctxt *mmtu = u6_mmtu_get_context(0);
+	unsigned long reg;
+
+	pr_debug(PKMOD "mmtu_set_mode %d\n", mode);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_UNUSED:
+		writel(MMTU_IRQ_MASK,
+		       (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_CLR_ENA_IDX));
+		writel(MMTU_IRQ_MASK,
+		       (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_CLR_STAT_IDX));
+
+		reg = readl((mmtu->base + MMTU_TCVAL_IDX));
+		writel(reg - 1, (mmtu->base + MMTU_USED_MATCH_IDX));
+
+#ifndef U6_MMTU_CLOCK_SOURCE
+		u6_mmtu_clk_disable(0);
+
+		if (mmtu->clk != NULL)
+			clk_put(mmtu->clk);
+#endif
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		if (mmtu->clk == NULL) {
+			mmtu->clk = clk_get(NULL, "MMTU");
+			if (IS_ERR(mmtu->clk))
+				mmtu->clk = NULL;
+		}
+
+		writel(MMTU_IRQ_MASK,
+		       (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_CLR_STAT_IDX));
+		writel(MMTU_IRQ_MASK,
+		       (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_SET_ENA_IDX));
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+		writel(MMTU_IRQ_MASK,
+		       (mmtu->base + MMTU_INT_OFFSET + MMTU_INT_SET_ENA_IDX));
+		break;
+	}
+}
+
+static void u6_clockevent_init_mmtu(void)
+{
+	printk(PKMOD "clockevent_init_mmtu\n");
+
+	/* prescale 13Mhz -> 1Mhz */
+#ifndef U6_MMTU_CLOCK_SOURCE
+	u6_mmtu_timer_init(0, 0, (MMTU_SYS_FRQ / MMTU_ROOT_FRQ), 0);
+#endif
+
+	/* issue it is shorter than reality and generates spurious irq */
+	/*      clockevent_mmtu.mult = div_sc(MMTU_ROOT_FRQ, NSEC_PER_SEC,
+	 *      clockevent_mmtu.shift) + 1;*/
+	clockevent_mmtu.mult =
+		div_sc(MMTU_ROOT_FRQ, NSEC_PER_SEC, clockevent_mmtu.shift);
+
+	/*      clockevent_mmtu.max_delta_ns = div_sc(RELOAD_COUNTER_MMTU,
+	 *      clockevent_mmtu.mult, clockevent_mmtu.shift);*/
+	/*  In fact it is wider than the 32bits variable !!! */
+	clockevent_mmtu.max_delta_ns = 0xFFFFFFFF;
+
+	/*  MMTU HW limitation: match register can't be set w/ tcval+1 */
+	/*      clockevent_mmtu.min_delta_ns = div_sc(1, clockevent_mmtu.mult,
+	 *      clockevent_mmtu.shift)+1;*/
+	clockevent_mmtu.min_delta_ns =
+		div_sc(2, clockevent_mmtu.mult, clockevent_mmtu.shift) + 1;
+	/* avoid to much timer interrupt with 10us min between 2 irq */
+	if (clockevent_mmtu.min_delta_ns < 10000)
+		clockevent_mmtu.min_delta_ns = 10000;
+	else if (clockevent_mmtu.max_delta_ns < 10000)
+		clockevent_mmtu.min_delta_ns = clockevent_mmtu.max_delta_ns>>1;
+
+	clockevent_mmtu.cpumask = get_cpu_mask(0);
+	clockevents_register_device(&clockevent_mmtu);
+
+	u6_mmtu_set_next_event(MMTU_ROOT_FRQ / HZ, &clockevent_mmtu);
+}
+
+/*** MMTU Clock source device ***/
+#ifdef U6_MMTU_CLOCK_SOURCE
+
+static cycle_t u6_mmtu_read(struct clocksource *source)
+{
+	struct mmtu_ctxt *mmtu = u6_mmtu_get_context(0);
+
+	return readl(mmtu->base + MMTU_TCVAL_IDX);
+}
+
+static void u6_clocksource_init_mmtu(void)
+{
+	printk(PKMOD "clocksource_init_mmtu\n");
+
+	if (MMTU_ROOT_FRQ >= 1000000)
+		clocksource_mmtu.mult =
+			clocksource_khz2mult((MMTU_ROOT_FRQ / 1000),
+					clocksource_mmtu.shift);
+	else
+		clocksource_mmtu.mult = clocksource_hz2mult((MMTU_ROOT_FRQ),
+				clocksource_mmtu.shift);
+
+	u6_mmtu_timer_init(0, 0, (MMTU_SYS_FRQ / MMTU_ROOT_FRQ), 0);
+
+	clocksource_register(&clocksource_mmtu);
+}
+
+#endif
+
+/*** System timer init ***/
+/*************************/
+
+void __init u6_timer_init(void)
+{
+	printk(PKMOD "mmtu_timer_init\n");
+
+#ifdef U6_MMTU_CLOCK_SOURCE
+	u6_clocksource_init_mmtu();
+#endif
+
+	u6_clockevent_init_mmtu();
+}
+
+struct sys_timer u6_timer = {
+	.init = u6_timer_init,
+};
+
+#ifdef CONFIG_U6_POWER_SYSFS
+static int __init u6_mmtu_init_sysfs(void)
+{
+	printk(PKMOD "mmtu_init_sysfs\n");
+
+#ifdef U6_MMTU_CLOCK_SOURCE
+	if (sysfs_create_group(&u6_power_kobj, &dbs_attr_srce_group))
+		printk(PKMOD "Unable to register %s in sysfs\n",
+		       dbs_attr_srce_group.name);
+#endif
+
+	if (sysfs_create_group(&u6_power_kobj, &dbs_attr_event_group))
+		printk(PKMOD "Unable to register %s in sysfs\n",
+		       dbs_attr_event_group.name);
+
+	return 0;
+}
+
+module_init(u6_mmtu_init_sysfs);
+#endif
-- 
1.7.1

