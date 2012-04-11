Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab2DKRiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:38:03 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42627 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab2DKRh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:37:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6677"; a="178446572"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: msm: remove unused MSM boards
Date: Wed, 11 Apr 2012 10:37:50 -0700
Message-Id: <1334165870-12487-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "mahimahi" and "sapphire" were never finished, and have never been
built.

The "halibut" target was a dev board that hasn't ever been widely
available (MSM7201 "SURF").

Signed-off-by: David Brown <davidb@codeaurora.org>
---
I've compile tested this to make sure that the HTC Dream (TROUT) still
builds, but it'd be nice if someone who still has one of these would
be able to test that this doesn't break it.

 arch/arm/mach-msm/Kconfig          |    9 +--
 arch/arm/mach-msm/Makefile         |    1 -
 arch/arm/mach-msm/board-halibut.c  |  108 ----------------------------------
 arch/arm/mach-msm/board-mahimahi.c |   83 --------------------------
 arch/arm/mach-msm/board-sapphire.c |  112 ------------------------------------
 5 files changed, 1 insertion(+), 312 deletions(-)
 delete mode 100644 arch/arm/mach-msm/board-halibut.c
 delete mode 100644 arch/arm/mach-msm/board-mahimahi.c
 delete mode 100644 arch/arm/mach-msm/board-sapphire.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 1cd40ad..f27f4d9 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -6,7 +6,7 @@ choice
 
 config ARCH_MSM7X00A
 	bool "MSM7x00A / MSM7x01A"
-	select MACH_TROUT if !MACH_HALIBUT
+	select MACH_TROUT
 	select ARCH_MSM_ARM11
 	select MSM_SMD
 	select MSM_SMD_PKG3
@@ -79,13 +79,6 @@ config  MSM_VIC
 
 menu "Qualcomm MSM Board Type"
 
-config MACH_HALIBUT
-	depends on ARCH_MSM
-	depends on ARCH_MSM7X00A
-	bool "Halibut Board (QCT SURF7201A)"
-	help
-	  Support for the Qualcomm SURF7201A eval board.
-
 config MACH_TROUT
 	depends on ARCH_MSM
 	depends on ARCH_MSM7X00A
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 4ad3969..a185f07 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -22,7 +22,6 @@ obj-$(CONFIG_SMP) += headsmp.o platsmp.o
 
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o board-trout-panel.o devices-msm7x00.o
-obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
deleted file mode 100644
index 3698a37..0000000
--- a/arch/arm/mach-msm/board-halibut.c
+++ /dev/null
@@ -1,108 +0,0 @@
-/* linux/arch/arm/mach-msm/board-halibut.c
- *
- * Copyright (C) 2007 Google, Inc.
- * Author: Brian Swetland <swetland@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/input.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-
-#include <mach/hardware.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/flash.h>
-#include <asm/setup.h>
-
-#include <mach/irqs.h>
-#include <mach/board.h>
-#include <mach/msm_iomap.h>
-
-#include <linux/mtd/nand.h>
-#include <linux/mtd/partitions.h>
-
-#include "devices.h"
-
-static struct resource smc91x_resources[] = {
-	[0] = {
-		.start	= 0x9C004300,
-		.end	= 0x9C004400,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= MSM_GPIO_TO_INT(49),
-		.end	= MSM_GPIO_TO_INT(49),
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device smc91x_device = {
-	.name		= "smc91x",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(smc91x_resources),
-	.resource	= smc91x_resources,
-};
-
-static struct platform_device *devices[] __initdata = {
-	&msm_device_uart3,
-	&msm_device_smd,
-	&msm_device_nand,
-	&msm_device_hsusb,
-	&msm_device_i2c,
-	&smc91x_device,
-};
-
-extern struct sys_timer msm_timer;
-
-static void __init halibut_init_early(void)
-{
-	arch_ioremap_caller = __msm_ioremap_caller;
-}
-
-static void __init halibut_init_irq(void)
-{
-	msm_init_irq();
-}
-
-static void __init halibut_init(void)
-{
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-}
-
-static void __init halibut_fixup(struct tag *tags, char **cmdline,
-				 struct meminfo *mi)
-{
-	mi->nr_banks=1;
-	mi->bank[0].start = PHYS_OFFSET;
-	mi->bank[0].size = (101*1024*1024);
-}
-
-static void __init halibut_map_io(void)
-{
-	msm_map_common_io();
-	msm_clock_init(msm_clocks_7x01a, msm_num_clocks_7x01a);
-}
-
-MACHINE_START(HALIBUT, "Halibut Board (QCT SURF7200A)")
-	.atag_offset	= 0x100,
-	.fixup		= halibut_fixup,
-	.map_io		= halibut_map_io,
-	.init_early	= halibut_init_early,
-	.init_irq	= halibut_init_irq,
-	.init_machine	= halibut_init,
-	.timer		= &msm_timer,
-MACHINE_END
diff --git a/arch/arm/mach-msm/board-mahimahi.c b/arch/arm/mach-msm/board-mahimahi.c
deleted file mode 100644
index 5a4882f..0000000
--- a/arch/arm/mach-msm/board-mahimahi.c
+++ /dev/null
@@ -1,83 +0,0 @@
-/* linux/arch/arm/mach-msm/board-mahimahi.c
- *
- * Copyright (C) 2009 Google, Inc.
- * Copyright (C) 2009 HTC Corporation.
- * Author: Dima Zavin <dima@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/delay.h>
-#include <linux/gpio.h>
-#include <linux/init.h>
-#include <linux/input.h>
-#include <linux/io.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/setup.h>
-
-#include <mach/board.h>
-#include <mach/hardware.h>
-#include <mach/system.h>
-
-#include "board-mahimahi.h"
-#include "devices.h"
-#include "proc_comm.h"
-
-static uint debug_uart;
-
-module_param_named(debug_uart, debug_uart, uint, 0);
-
-static struct platform_device *devices[] __initdata = {
-#if !defined(CONFIG_MSM_SERIAL_DEBUGGER)
-	&msm_device_uart1,
-#endif
-	&msm_device_uart_dm1,
-	&msm_device_nand,
-};
-
-static void __init mahimahi_init(void)
-{
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-}
-
-static void __init mahimahi_fixup(struct tag *tags, char **cmdline,
-				  struct meminfo *mi)
-{
-	mi->nr_banks = 2;
-	mi->bank[0].start = PHYS_OFFSET;
-	mi->bank[0].node = PHYS_TO_NID(PHYS_OFFSET);
-	mi->bank[0].size = (219*1024*1024);
-	mi->bank[1].start = MSM_HIGHMEM_BASE;
-	mi->bank[1].node = PHYS_TO_NID(MSM_HIGHMEM_BASE);
-	mi->bank[1].size = MSM_HIGHMEM_SIZE;
-}
-
-static void __init mahimahi_map_io(void)
-{
-	msm_map_common_io();
-	msm_clock_init();
-}
-
-extern struct sys_timer msm_timer;
-
-MACHINE_START(MAHIMAHI, "mahimahi")
-	.atag_offset	= 0x100,
-	.fixup		= mahimahi_fixup,
-	.map_io		= mahimahi_map_io,
-	.init_irq	= msm_init_irq,
-	.init_machine	= mahimahi_init,
-	.timer		= &msm_timer,
-MACHINE_END
diff --git a/arch/arm/mach-msm/board-sapphire.c b/arch/arm/mach-msm/board-sapphire.c
deleted file mode 100644
index 4a8ea0d..0000000
--- a/arch/arm/mach-msm/board-sapphire.c
+++ /dev/null
@@ -1,112 +0,0 @@
-/* linux/arch/arm/mach-msm/board-sapphire.c
- * Copyright (C) 2007-2009 HTC Corporation.
- * Author: Thomas Tsai <thomas_tsai@htc.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
-*/
-#include <linux/gpio.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/input.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/device.h>
-
-#include <linux/delay.h>
-
-#include <mach/hardware.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/flash.h>
-#include <mach/system.h>
-#include <mach/vreg.h>
-#include <mach/board.h>
-
-#include <asm/io.h>
-#include <asm/delay.h>
-#include <asm/setup.h>
-
-#include <linux/mtd/nand.h>
-#include <linux/mtd/partitions.h>
-
-#include "gpio_chip.h"
-#include "board-sapphire.h"
-#include "proc_comm.h"
-#include "devices.h"
-
-void msm_init_irq(void);
-void msm_init_gpio(void);
-
-static struct platform_device *devices[] __initdata = {
-	&msm_device_smd,
-	&msm_device_dmov,
-	&msm_device_nand,
-	&msm_device_uart1,
-	&msm_device_uart3,
-};
-
-extern struct sys_timer msm_timer;
-
-static void __init sapphire_init_irq(void)
-{
-	msm_init_irq();
-}
-
-static void __init sapphire_init(void)
-{
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-}
-
-static struct map_desc sapphire_io_desc[] __initdata = {
-	{
-		.virtual = SAPPHIRE_CPLD_BASE,
-		.pfn     = __phys_to_pfn(SAPPHIRE_CPLD_START),
-		.length  = SAPPHIRE_CPLD_SIZE,
-		.type    = MT_DEVICE_NONSHARED
-	}
-};
-
-static void __init sapphire_fixup(struct tag *tags, char **cmdline,
-				  struct meminfo *mi)
-{
-	int smi_sz = parse_tag_smi((const struct tag *)tags);
-
-	mi->nr_banks = 1;
-	mi->bank[0].start = PHYS_OFFSET;
-	mi->bank[0].node = PHYS_TO_NID(PHYS_OFFSET);
-	if (smi_sz == 32) {
-		mi->bank[0].size = (84*1024*1024);
-	} else if (smi_sz == 64) {
-		mi->bank[0].size = (101*1024*1024);
-	} else {
-		/* Give a default value when not get smi size */
-		smi_sz = 64;
-		mi->bank[0].size = (101*1024*1024);
-	}
-}
-
-static void __init sapphire_map_io(void)
-{
-	msm_map_common_io();
-	iotable_init(sapphire_io_desc, ARRAY_SIZE(sapphire_io_desc));
-	msm_clock_init();
-}
-
-MACHINE_START(SAPPHIRE, "sapphire")
-/* Maintainer: Brian Swetland <swetland@google.com> */
-	.atag_offset    = 0x100,
-	.fixup          = sapphire_fixup,
-	.map_io         = sapphire_map_io,
-	.init_irq       = sapphire_init_irq,
-	.init_machine   = sapphire_init,
-	.timer          = &msm_timer,
-MACHINE_END
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

