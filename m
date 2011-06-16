Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1FPIXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:23:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35099 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1FPIXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pLLfZpx1Sl+mNdqISeyAsHVLh3F3xuYLnMTjSRJkotHVn8ez46Jz3QlDaETqHCE1n8
         YrXf0dodvPW8qwUBsTVy1EA49gdcJcXz9+RhNSyjBpN4x+jFKdN+QLEambCJPvM2DkDJ
         nhjAWx9iwoknEjXRw9XAARuveItgQGXAWFiOc=
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, tony@atomide.com, haojian.zhuang@marvell.com,
        nicolas.pitre@linaro.org, Po-Yu Chuang <ratbert@faraday-tech.com>
Subject: [PATCH] arm: add Faraday SoC A320
Date: Thu, 16 Jun 2011 16:22:58 +0800
Message-Id: <1308212578-1615-1-git-send-email-ratbert.chuang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Po-Yu Chuang <ratbert@faraday-tech.com>


Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
---
 arch/arm/Kconfig                                 |   10 +
 arch/arm/Makefile                                |    1 +
 arch/arm/include/asm/serial.h                    |    6 +
 arch/arm/mach-faraday/Kconfig                    |   31 ++
 arch/arm/mach-faraday/Makefile                   |   11 +
 arch/arm/mach-faraday/Makefile.boot              |    4 +
 arch/arm/mach-faraday/board-a320.c               |  239 +++++++++++
 arch/arm/mach-faraday/clock.c                    |   92 +++++
 arch/arm/mach-faraday/clock.h                    |   40 ++
 arch/arm/mach-faraday/ftintc010.c                |  458 ++++++++++++++++++++++
 arch/arm/mach-faraday/ftpmu010.c                 |  296 ++++++++++++++
 arch/arm/mach-faraday/fttmr010.c                 |  283 +++++++++++++
 arch/arm/mach-faraday/include/mach/board-a320.h  |   66 +++
 arch/arm/mach-faraday/include/mach/clkdev.h      |   26 ++
 arch/arm/mach-faraday/include/mach/debug-macro.S |   44 ++
 arch/arm/mach-faraday/include/mach/entry-macro.S |   87 ++++
 arch/arm/mach-faraday/include/mach/ftintc010.h   |   57 +++
 arch/arm/mach-faraday/include/mach/ftpmu010.h    |  166 ++++++++
 arch/arm/mach-faraday/include/mach/fttmr010.h    |   86 ++++
 arch/arm/mach-faraday/include/mach/hardware.h    |   24 ++
 arch/arm/mach-faraday/include/mach/io.h          |   27 ++
 arch/arm/mach-faraday/include/mach/irqs-a320.h   |   59 +++
 arch/arm/mach-faraday/include/mach/irqs.h        |   28 ++
 arch/arm/mach-faraday/include/mach/memory.h      |   27 ++
 arch/arm/mach-faraday/include/mach/serial-a320.h |   53 +++
 arch/arm/mach-faraday/include/mach/serial.h      |   34 ++
 arch/arm/mach-faraday/include/mach/system.h      |   34 ++
 arch/arm/mach-faraday/include/mach/timex.h       |   25 ++
 arch/arm/mach-faraday/include/mach/uncompress.h  |   47 +++
 arch/arm/mach-faraday/include/mach/vmalloc.h     |   24 ++
 arch/arm/mm/Kconfig                              |    4 +-
 arch/arm/tools/mach-types                        |    1 +
 32 files changed, 2388 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-faraday/Kconfig
 create mode 100644 arch/arm/mach-faraday/Makefile
 create mode 100644 arch/arm/mach-faraday/Makefile.boot
 create mode 100644 arch/arm/mach-faraday/board-a320.c
 create mode 100644 arch/arm/mach-faraday/clock.c
 create mode 100644 arch/arm/mach-faraday/clock.h
 create mode 100644 arch/arm/mach-faraday/ftintc010.c
 create mode 100644 arch/arm/mach-faraday/ftpmu010.c
 create mode 100644 arch/arm/mach-faraday/fttmr010.c
 create mode 100644 arch/arm/mach-faraday/include/mach/board-a320.h
 create mode 100644 arch/arm/mach-faraday/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-faraday/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-faraday/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-faraday/include/mach/ftintc010.h
 create mode 100644 arch/arm/mach-faraday/include/mach/ftpmu010.h
 create mode 100644 arch/arm/mach-faraday/include/mach/fttmr010.h
 create mode 100644 arch/arm/mach-faraday/include/mach/hardware.h
 create mode 100644 arch/arm/mach-faraday/include/mach/io.h
 create mode 100644 arch/arm/mach-faraday/include/mach/irqs-a320.h
 create mode 100644 arch/arm/mach-faraday/include/mach/irqs.h
 create mode 100644 arch/arm/mach-faraday/include/mach/memory.h
 create mode 100644 arch/arm/mach-faraday/include/mach/serial-a320.h
 create mode 100644 arch/arm/mach-faraday/include/mach/serial.h
 create mode 100644 arch/arm/mach-faraday/include/mach/system.h
 create mode 100644 arch/arm/mach-faraday/include/mach/timex.h
 create mode 100644 arch/arm/mach-faraday/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-faraday/include/mach/vmalloc.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 377a7a5..afeb745 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -352,6 +352,14 @@ config ARCH_EP93XX
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
+config ARCH_FARADAY
+	bool "Faraday All SoC Platforms"
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select CLKDEV_LOOKUP
+	help
+	   Support for Faraday SoCs.
+
 config ARCH_FOOTBRIDGE
 	bool "FootBridge"
 	select CPU_SA110
@@ -910,6 +918,8 @@ source "arch/arm/mach-dove/Kconfig"
 
 source "arch/arm/mach-ep93xx/Kconfig"
 
+source "arch/arm/mach-faraday/Kconfig"
+
 source "arch/arm/mach-footbridge/Kconfig"
 
 source "arch/arm/mach-gemini/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index c7d321a..8f9464e 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -139,6 +139,7 @@ machine-$(CONFIG_ARCH_DAVINCI)		:= davinci
 machine-$(CONFIG_ARCH_DOVE)		:= dove
 machine-$(CONFIG_ARCH_EBSA110)		:= ebsa110
 machine-$(CONFIG_ARCH_EP93XX)		:= ep93xx
+machine-$(CONFIG_ARCH_FARADAY)		:= faraday
 machine-$(CONFIG_ARCH_GEMINI)		:= gemini
 machine-$(CONFIG_ARCH_H720X)		:= h720x
 machine-$(CONFIG_ARCH_INTEGRATOR)	:= integrator
diff --git a/arch/arm/include/asm/serial.h b/arch/arm/include/asm/serial.h
index ebb0490..f7c9428 100644
--- a/arch/arm/include/asm/serial.h
+++ b/arch/arm/include/asm/serial.h
@@ -14,6 +14,12 @@
 #ifndef __ASM_SERIAL_H
 #define __ASM_SERIAL_H
 
+#if defined(CONFIG_ARCH_FARADAY)
+#include <mach/serial.h>
+#endif
+
+#ifndef BASE_BAUD
 #define BASE_BAUD	(1843200 / 16)
+#endif
 
 #endif
diff --git a/arch/arm/mach-faraday/Kconfig b/arch/arm/mach-faraday/Kconfig
new file mode 100644
index 0000000..0424c2d
--- /dev/null
+++ b/arch/arm/mach-faraday/Kconfig
@@ -0,0 +1,31 @@
+if ARCH_FARADAY
+
+choice
+	prompt "Platform Selection"
+	default PLATFORM_A320
+
+config PLATFORM_A320
+	bool "A320 evaluation board"
+	select FTINTC010
+	select FTPMU010
+	select FTTMR010
+
+endchoice
+
+config FTINTC010
+	bool
+
+config FTINTC010EX
+	bool
+	select FTINTC010
+	help
+	  Newer version of FTINTC010 interrupt controller which supports
+	  up to 64 IRQ.
+
+config FTPMU010
+	bool
+
+config FTTMR010
+	bool
+
+endif
diff --git a/arch/arm/mach-faraday/Makefile b/arch/arm/mach-faraday/Makefile
new file mode 100644
index 0000000..b0878c3
--- /dev/null
+++ b/arch/arm/mach-faraday/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for the linux kernel.
+#
+
+obj-y				:= clock.o
+
+obj-$(CONFIG_PLATFORM_A320)	+= board-a320.o
+
+obj-$(CONFIG_FTINTC010)		+= ftintc010.o
+obj-$(CONFIG_FTPMU010)		+= ftpmu010.o
+obj-$(CONFIG_FTTMR010)		+= fttmr010.o
diff --git a/arch/arm/mach-faraday/Makefile.boot b/arch/arm/mach-faraday/Makefile.boot
new file mode 100644
index 0000000..c7e75ac
--- /dev/null
+++ b/arch/arm/mach-faraday/Makefile.boot
@@ -0,0 +1,4 @@
+   zreladdr-y	:= 0x00008000
+params_phys-y	:= 0x00000100
+initrd_phys-y	:= 0x00800000
+
diff --git a/arch/arm/mach-faraday/board-a320.c b/arch/arm/mach-faraday/board-a320.c
new file mode 100644
index 0000000..184ad5f
--- /dev/null
+++ b/arch/arm/mach-faraday/board-a320.c
@@ -0,0 +1,239 @@
+/*
+ * Copyright (C) 2009-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+
+#include <asm/mach-types.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/time.h>
+
+#include <mach/board-a320.h>
+#include <mach/ftintc010.h>
+#include <mach/fttmr010.h>
+#include <mach/ftpmu010.h>
+
+#include "clock.h"
+
+/******************************************************************************
+ * platform devices
+ *****************************************************************************/
+static struct resource ftmac100_0_resources[] = {
+	{
+		.start	= A320_FTMAC100_0_PA_BASE,
+		.end	= A320_FTMAC100_0_PA_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.start	= IRQ_A320_FTMAC100_0,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device ftmac100_0_device = {
+	.name		= "ftmac100",
+	.id		= 0,
+	.dev		= {
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+	.num_resources	= ARRAY_SIZE(ftmac100_0_resources),
+	.resource	= ftmac100_0_resources,
+};
+
+static struct platform_device *a320_devices[] __initdata = {
+	&ftmac100_0_device,
+};
+
+/******************************************************************************
+ * clock functions
+ *****************************************************************************/
+static struct clk_lookup a320_clk_lookups[] = {
+	{
+		.con_id = "cpuclk",
+		.clk	= &ftpmu010_cpuclk,
+	}, {
+		.con_id	= "hclk",
+		.clk	= &ftpmu010_hclk,
+	}, {
+		.con_id	= "pclk",
+		.clk	= &ftpmu010_pclk,
+	}, {
+		.con_id	= "irda",
+		.clk	= &ftpmu010_irda_clk,
+	}, {
+		.con_id	= "ssp",
+		.clk	= &ftpmu010_ssp_clk,
+	}, {
+		.con_id	= "i2s",
+		.clk	= &ftpmu010_i2s_clk,
+	}, {
+		.con_id	= "ac97:1",
+		.clk	= &ftpmu010_ac97_clk1,
+	}, {
+		.con_id	= "ac97:2",
+		.clk	= &ftpmu010_ac97_clk2,
+	}, {
+		.con_id	= "uart",
+		.clk	= &ftpmu010_uart_clk,
+	}, {
+		.con_id	= "32768hz",
+		.clk	= &ftpmu010_32768hz_clk,
+	}
+};
+
+static int __init a320_clk_init(void)
+{
+	void __iomem *base = (void __iomem *)A320_FTPMU010_0_VA_BASE;
+
+	ftpmu010_main_clk.rate = MAIN_CLK;
+	ftpmu010_init(base);
+	clkdev_add_table(a320_clk_lookups, ARRAY_SIZE(a320_clk_lookups));
+	return 0;
+}
+
+/******************************************************************************
+ * timer - clockevent and clocksource
+ *****************************************************************************/
+static struct fttmr010_clockevent fttmr010_0_clockevent = {
+	.clockevent = {
+		.name	= "fttmr010:0",
+		.irq	= IRQ_A320_FTTMR010_0_T0,
+	},
+	.base	= (void __iomem *)A320_FTTMR010_0_VA_BASE,
+	.id	= 0,
+};
+
+static struct fttmr010_clocksource fttmr010_1_clocksource = {
+	.clocksource = {
+		.name	= "fttmr010:1",
+	},
+	.base	= (void __iomem *)A320_FTTMR010_0_VA_BASE,
+	.id	= 1,
+};
+
+static void __init a320_sys_timer_init(void)
+{
+	struct clk *clk;
+	unsigned long cpuclk;
+	unsigned long hclk;
+	unsigned long pclk;
+
+	clk = clk_get(NULL, "cpuclk");
+	clk_enable(clk);
+	cpuclk = clk_get_rate(clk);
+
+	clk = clk_get(NULL, "hclk");
+	clk_enable(clk);
+	hclk = clk_get_rate(clk);
+
+	clk = clk_get(NULL, "pclk");
+	clk_enable(clk);
+	pclk = clk_get_rate(clk);
+
+	printk(KERN_INFO "CPU: %ld Hz, HCLK: %ld Hz, PCLK: %ld Hz\n",
+	       cpuclk, hclk, pclk);
+
+	fttmr010_0_clockevent.freq = pclk;
+	fttmr010_clockevent_init(&fttmr010_0_clockevent);
+
+	fttmr010_1_clocksource.freq = pclk;
+	fttmr010_clocksource_init(&fttmr010_1_clocksource);
+}
+
+static struct sys_timer a320_sys_timer = {
+	.init	= a320_sys_timer_init,
+};
+
+/******************************************************************************
+ * platform dependent functions
+ *****************************************************************************/
+static struct map_desc a320_io_desc[] __initdata = {
+	{
+		.virtual	= A320_FTINTC010_0_VA_BASE,
+		.pfn		= __phys_to_pfn(A320_FTINTC010_0_PA_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= A320_FTUART010_0_VA_BASE,
+		.pfn		= __phys_to_pfn(A320_FTUART010_0_PA_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= A320_FTUART010_1_VA_BASE,
+		.pfn		= __phys_to_pfn(A320_FTUART010_1_PA_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= A320_FTUART010_2_VA_BASE,
+		.pfn		= __phys_to_pfn(A320_FTUART010_2_PA_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= A320_FTTMR010_0_VA_BASE,
+		.pfn		= __phys_to_pfn(A320_FTTMR010_0_PA_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= A320_FTPMU010_0_VA_BASE,
+		.pfn		= __phys_to_pfn(A320_FTPMU010_0_PA_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	},
+};
+
+static void __init a320_map_io(void)
+{
+	iotable_init((struct map_desc *)a320_io_desc, ARRAY_SIZE(a320_io_desc));
+	a320_clk_init();
+}
+
+void __iomem *ftintc010_base_addr;
+
+static void __init a320_init_irq(void)
+{
+	/*
+	 * initialize primary interrupt controller
+	 */
+	ftintc010_base_addr = __io(A320_FTINTC010_0_VA_BASE);
+
+	ftintc010_init(0, ftintc010_base_addr, IRQ_A320_START);
+
+	ftintc010_set_irq_type(IRQ_A320_FTGPIO010_0, IRQ_TYPE_EDGE_RISING);
+	ftintc010_set_irq_type(IRQ_A320_FTTMR010_0_T1, IRQ_TYPE_EDGE_RISING);
+	ftintc010_set_irq_type(IRQ_A320_FTTMR010_0_T2, IRQ_TYPE_EDGE_RISING);
+	ftintc010_set_irq_type(IRQ_A320_FTRTC010_0_ALRM, IRQ_TYPE_EDGE_RISING);
+	ftintc010_set_irq_type(IRQ_A320_FTRTC010_0_SEC, IRQ_TYPE_EDGE_RISING);
+	ftintc010_set_irq_type(IRQ_A320_FTTMR010_0_T0, IRQ_TYPE_EDGE_RISING);
+}
+
+static void __init a320_board_init(void)
+{
+	platform_add_devices(a320_devices, ARRAY_SIZE(a320_devices));
+}
+
+MACHINE_START(FARADAY, "A320")
+	.boot_params	= PHYS_OFFSET + 0x100,
+	.map_io		= a320_map_io,
+	.init_irq	= a320_init_irq,
+	.timer		= &a320_sys_timer,
+	.init_machine	= a320_board_init,
+MACHINE_END
diff --git a/arch/arm/mach-faraday/clock.c b/arch/arm/mach-faraday/clock.c
new file mode 100644
index 0000000..7a8dd5f
--- /dev/null
+++ b/arch/arm/mach-faraday/clock.c
@@ -0,0 +1,92 @@
+/*
+ * Copyright (C) 2010-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+
+#include <asm/clkdev.h>
+
+#include "clock.h"
+
+static DEFINE_SPINLOCK(clk_lock);
+
+void __clk_enable(struct clk *clk)
+{
+	if (clk->parent)
+		__clk_enable(clk->parent);
+	if (clk->users++ == 0 && clk->mode)
+		clk->mode(clk, 1);
+}
+
+int clk_enable(struct clk *clk)
+{
+	unsigned long	flags;
+
+	spin_lock_irqsave(&clk_lock, flags);
+	__clk_enable(clk);
+	spin_unlock_irqrestore(&clk_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void __clk_disable(struct clk *clk)
+{
+	BUG_ON(clk->users == 0);
+	if (--clk->users == 0 && clk->mode)
+		clk->mode(clk, 0);
+	if (clk->parent)
+		__clk_disable(clk->parent);
+}
+
+void clk_disable(struct clk *clk)
+{
+	unsigned long	flags;
+
+	spin_lock_irqsave(&clk_lock, flags);
+	__clk_disable(clk);
+	spin_unlock_irqrestore(&clk_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long __clk_get_rate(struct clk *clk)
+{
+	unsigned long rate;
+
+	rate = clk->rate;
+	if (rate == 0) {
+		if (clk->get_rate)
+			rate = clk->get_rate(clk);
+		else if (clk->parent)
+			rate = __clk_get_rate(clk->parent);
+	}
+
+	return rate;
+}
+unsigned long clk_get_rate(struct clk *clk)
+{
+	unsigned long flags;
+	unsigned long rate;
+
+	spin_lock_irqsave(&clk_lock, flags);
+	rate = __clk_get_rate(clk);
+	spin_unlock_irqrestore(&clk_lock, flags);
+	return rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
diff --git a/arch/arm/mach-faraday/clock.h b/arch/arm/mach-faraday/clock.h
new file mode 100644
index 0000000..1635c38
--- /dev/null
+++ b/arch/arm/mach-faraday/clock.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2010-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#ifndef __ARCH_ARM_FARADAY_CLOCK_H
+#define __ARCH_ARM_FARADAY_CLOCK_H
+
+struct clk {
+	struct clk	*parent;
+	int		users;
+	unsigned long	rate;
+	void __iomem	*base;	/* base address of controller if any */
+	unsigned long	(*get_rate)(struct clk *);
+	int		(*mode)(struct clk *, int);
+	void		*params;
+};
+
+/*
+ * These functions assume that lock is already held.
+ */
+void __clk_enable(struct clk *clk);
+void __clk_disable(struct clk *clk);
+unsigned long __clk_get_rate(struct clk *clk);
+
+#endif
diff --git a/arch/arm/mach-faraday/ftintc010.c b/arch/arm/mach-faraday/ftintc010.c
new file mode 100644
index 0000000..72955dd
--- /dev/null
+++ b/arch/arm/mach-faraday/ftintc010.c
@@ -0,0 +1,458 @@
+/*
+ * Faraday FTINTC010 Interrupt Controller
+ *
+ * Based on arch/arm/common/gic.c
+ *
+ * Copyright (C) 2009-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+
+#include <asm/mach/irq.h>
+#include <mach/ftintc010.h>
+
+struct ftintc010_chip_data {
+	unsigned int irq_offset;
+	void __iomem *base;
+};
+
+#ifndef MAX_FTINTC010_NR
+#define MAX_FTINTC010_NR	1
+#endif
+
+static struct ftintc010_chip_data ftintc010_data[MAX_FTINTC010_NR];
+static DEFINE_SPINLOCK(ftintc010_lock);
+
+/******************************************************************************
+ * internal functions
+ *****************************************************************************/
+static inline void __iomem *ftintc010_base(struct irq_data *d)
+{
+	struct ftintc010_chip_data *chip_data = irq_data_get_irq_chip_data(d);
+	return chip_data->base;
+}
+
+/*
+ * return hardware irq number
+ */
+static inline unsigned int ftintc010_irq(struct irq_data *d)
+{
+	struct ftintc010_chip_data *chip_data = irq_data_get_irq_chip_data(d);
+	return d->irq - chip_data->irq_offset;
+}
+
+#ifdef CONFIG_FTINTC010EX
+static inline void ftintc010_clear_irq(void __iomem *base, unsigned int hw_irq)
+{
+	unsigned int mask;
+
+	if (hw_irq < 32) {
+		mask = 1 << hw_irq;
+
+		writel(mask, base + FTINTC010_OFFSET_IRQCLEAR);
+	} else {
+		mask = 1 << (hw_irq - 32);
+		writel(mask, base + FTINTC010_OFFSET_IRQCLEAREX);
+	}
+}
+
+static inline void ftintc010_mask_irq(void __iomem *base, unsigned int hw_irq)
+{
+	unsigned int mask;
+
+	/*
+	 * 0: masked
+	 * 1: unmasked
+	 */
+	if (hw_irq < 32) {
+		mask = readl(base + FTINTC010_OFFSET_IRQMASK);
+		mask &= ~(1 << hw_irq);
+		writel(mask, base + FTINTC010_OFFSET_IRQMASK);
+	} else {
+		mask = readl(base + FTINTC010_OFFSET_IRQMASKEX);
+		mask &= ~(1 << (hw_irq - 32));
+		writel(mask, base + FTINTC010_OFFSET_IRQMASKEX);
+	}
+}
+
+static inline void ftintc010_unmask_irq(void __iomem *base, unsigned int hw_irq)
+{
+	unsigned int mask;
+
+	/*
+	 * 0: masked
+	 * 1: unmasked
+	 */
+	if (hw_irq < 32) {
+		mask = readl(base + FTINTC010_OFFSET_IRQMASK);
+		mask |= 1 << hw_irq;
+		writel(mask, base + FTINTC010_OFFSET_IRQMASK);
+	} else {
+		mask = readl(base + FTINTC010_OFFSET_IRQMASKEX);
+		mask |= 1 << (hw_irq - 32);
+		writel(mask, base + FTINTC010_OFFSET_IRQMASKEX);
+	}
+}
+
+static inline void ftintc010_set_trig_mode(void __iomem *base,
+					   unsigned int hw_irq, int mode)
+{
+	unsigned int irqmode;
+
+	/*
+	 * 0: level trigger
+	 * 1: edge trigger
+	 */
+	if (hw_irq < 32) {
+		irqmode = readl(base + FTINTC010_OFFSET_IRQMODE);
+		if (mode)
+			irqmode |= 1 << hw_irq;
+		else
+			irqmode &= ~(1 << hw_irq);
+		writel(irqmode, base + FTINTC010_OFFSET_IRQMODE);
+	} else {
+		irqmode = readl(base + FTINTC010_OFFSET_IRQMODEEX);
+		if (mode)
+			irqmode |= 1 << (hw_irq - 32);
+		else
+			irqmode &= ~(1 << (hw_irq - 32));
+		writel(irqmode, base + FTINTC010_OFFSET_IRQMODEEX);
+	}
+}
+
+static inline void ftintc010_set_trig_level(void __iomem *base,
+					    unsigned int hw_irq, int level)
+{
+	unsigned int irqlevel;
+
+	/*
+	 * 0: active-high level trigger / rising edge trigger
+	 * 1: active-low level trigger / falling edge trigger
+	 */
+	if (hw_irq < 32) {
+		irqlevel = readl(base + FTINTC010_OFFSET_IRQLEVEL);
+		if (level)
+			irqlevel |= 1 << hw_irq;
+		else
+			irqlevel &= ~(1 << hw_irq);
+		writel(irqlevel, base + FTINTC010_OFFSET_IRQLEVEL);
+	} else {
+		irqlevel = readl(base + FTINTC010_OFFSET_IRQLEVELEX);
+		if (level)
+			irqlevel |= 1 << (hw_irq - 32);
+		else
+			irqlevel &= ~(1 << (hw_irq - 32));
+		writel(irqlevel, base + FTINTC010_OFFSET_IRQLEVELEX);
+	}
+}
+#else	/* CONFIG_FTINTC010EX */
+static inline void ftintc010_clear_irq(void __iomem *base, unsigned int hw_irq)
+{
+	unsigned int mask = 1 << hw_irq;
+
+	writel(mask, base + FTINTC010_OFFSET_IRQCLEAR);
+}
+
+static inline void ftintc010_mask_irq(void __iomem *base, unsigned int hw_irq)
+{
+	unsigned int mask;
+
+	/*
+	 * 0: masked
+	 * 1: unmasked
+	 */
+	mask = readl(base + FTINTC010_OFFSET_IRQMASK);
+	mask &= ~(1 << hw_irq);
+	writel(mask, base + FTINTC010_OFFSET_IRQMASK);
+}
+
+static inline void ftintc010_unmask_irq(void __iomem *base, unsigned int hw_irq)
+{
+	unsigned int mask;
+
+	/*
+	 * 0: masked
+	 * 1: unmasked
+	 */
+	mask = readl(base + FTINTC010_OFFSET_IRQMASK);
+	mask |= 1 << hw_irq;
+	writel(mask, base + FTINTC010_OFFSET_IRQMASK);
+}
+
+static inline void ftintc010_set_trig_mode(void __iomem *base,
+					   unsigned int hw_irq, int mode)
+{
+	unsigned int irqmode;
+
+	irqmode = readl(base + FTINTC010_OFFSET_IRQMODE);
+
+	/*
+	 * 0: level trigger
+	 * 1: edge trigger
+	 */
+	if (mode)
+		irqmode |= 1 << hw_irq;
+	else
+		irqmode &= ~(1 << hw_irq);
+
+	writel(irqmode, base + FTINTC010_OFFSET_IRQMODE);
+}
+
+static inline void ftintc010_set_trig_level(void __iomem *base,
+					    unsigned int hw_irq, int level)
+{
+	unsigned int irqlevel;
+
+	irqlevel = readl(base + FTINTC010_OFFSET_IRQLEVEL);
+
+	/*
+	 * 0: active-high level trigger / rising edge trigger
+	 * 1: active-low level trigger / falling edge trigger
+	 */
+	if (level)
+		irqlevel |= 1 << hw_irq;
+	else
+		irqlevel &= ~(1 << hw_irq);
+
+	writel(irqlevel, base + FTINTC010_OFFSET_IRQLEVEL);
+}
+#endif	/* CONFIG_FTINTC010EX */
+
+/******************************************************************************
+ * struct irq_chip functions
+ *****************************************************************************/
+static void ftintc010_edge_ack(struct irq_data *d)
+{
+	unsigned int hw_irq = ftintc010_irq(d);
+	void __iomem *base = ftintc010_base(d);
+
+	spin_lock(&ftintc010_lock);
+	ftintc010_clear_irq(base, hw_irq);
+	spin_unlock(&ftintc010_lock);
+}
+
+static void ftintc010_level_ack(struct irq_data *d)
+{
+	/* do nothing */
+}
+
+static void ftintc010_mask(struct irq_data *d)
+{
+	unsigned int hw_irq = ftintc010_irq(d);
+	void __iomem *base = ftintc010_base(d);
+
+	spin_lock(&ftintc010_lock);
+	ftintc010_mask_irq(base, hw_irq);
+	spin_unlock(&ftintc010_lock);
+}
+
+static void ftintc010_unmask(struct irq_data *d)
+{
+	unsigned int hw_irq = ftintc010_irq(d);
+	void __iomem *base = ftintc010_base(d);
+
+	spin_lock(&ftintc010_lock);
+	ftintc010_unmask_irq(base, hw_irq);
+	spin_unlock(&ftintc010_lock);
+}
+
+static int ftintc010_set_type(struct irq_data *d, unsigned int type)
+{
+	unsigned int hw_irq = ftintc010_irq(d);
+	void __iomem *base = ftintc010_base(d);
+	int mode = 0;
+	int level = 0;
+
+	switch (type) {
+	case IRQ_TYPE_LEVEL_LOW:
+		level = 1;
+		/* fall through */
+
+	case IRQ_TYPE_LEVEL_HIGH:
+		break;
+
+	case IRQ_TYPE_EDGE_FALLING:
+		level = 1;
+		/* fall through */
+
+	case IRQ_TYPE_EDGE_RISING:
+		mode = 1;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	spin_lock(&ftintc010_lock);
+	ftintc010_set_trig_mode(base, hw_irq, mode);
+	ftintc010_set_trig_level(base, hw_irq, level);
+	spin_unlock(&ftintc010_lock);
+	return 0;
+}
+
+static struct irq_chip ftintc010_edge_chip = {
+	.irq_ack	= ftintc010_edge_ack,
+	.irq_mask	= ftintc010_mask,
+	.irq_unmask	= ftintc010_unmask,
+	.irq_set_type	= ftintc010_set_type,
+};
+
+static struct irq_chip ftintc010_level_chip = {
+	.irq_ack	= ftintc010_level_ack,
+	.irq_mask	= ftintc010_mask,
+	.irq_unmask	= ftintc010_unmask,
+	.irq_set_type	= ftintc010_set_type,
+};
+
+/******************************************************************************
+ * initialization functions
+ *****************************************************************************/
+static void ftintc010_handle_cascade_irq(unsigned int irq,
+					 struct irq_desc *desc)
+{
+	struct ftintc010_chip_data *chip_data = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_get_chip(irq);
+	unsigned int cascade_irq, hw_irq;
+	unsigned long status;
+
+	/* primary controller ack'ing */
+	chip->irq_mask(&desc->irq_data);
+	chip->irq_ack(&desc->irq_data);
+
+	spin_lock(&ftintc010_lock);
+	status = readl(chip_data->base + FTINTC010_OFFSET_IRQSTATUS);
+	spin_unlock(&ftintc010_lock);
+
+#ifdef CONFIG_FTINTC010EX
+	if (status) {
+		hw_irq = ffs(status) - 1;
+	} else {
+		status = readl(chip_data->base + FTINTC010_OFFSET_IRQSTATUSEX);
+
+		if (!status)
+			goto out;
+
+		hw_irq = ffs(status) - 1 + 32;
+	}
+#else
+	if (!status)
+		goto out;
+
+	hw_irq = ffs(status) - 1;
+#endif
+
+	cascade_irq = hw_irq + chip_data->irq_offset;
+	generic_handle_irq(cascade_irq);
+
+out:
+	/* primary controller unmasking */
+	chip->irq_unmask(&desc->irq_data);
+}
+
+void __init ftintc010_cascade_irq(unsigned int ftintc010_nr, unsigned int irq)
+{
+	if (ftintc010_nr >= MAX_FTINTC010_NR)
+		BUG();
+	if (irq_set_handler_data(irq, &ftintc010_data[ftintc010_nr]) != 0)
+		BUG();
+
+	irq_set_chained_handler(irq, ftintc010_handle_cascade_irq);
+}
+
+int ftintc010_set_irq_type(unsigned int irq, unsigned int type)
+{
+	switch (type) {
+	case IRQ_TYPE_LEVEL_LOW:
+	case IRQ_TYPE_LEVEL_HIGH:
+		irq_set_chip_and_handler(irq, &ftintc010_level_chip,
+					 handle_level_irq);
+		break;
+
+	case IRQ_TYPE_EDGE_FALLING:
+	case IRQ_TYPE_EDGE_RISING:
+		irq_set_chip_and_handler(irq, &ftintc010_edge_chip,
+					 handle_edge_irq);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return irq_set_irq_type(irq, type);
+}
+
+/*
+ * Initialization of master interrupt controller, after this INTC is
+ * enabled, the rest of Linux initialization codes can then be completed.
+ * For example, timer interrupts and UART interrupts must be enabled during
+ * the boot process.
+ */
+void __init ftintc010_init(unsigned int ftintc010_nr, void __iomem *base,
+			   unsigned int irq_start)
+{
+	unsigned int irq;
+	unsigned int irq_end;
+
+	if (ftintc010_nr >= MAX_FTINTC010_NR)
+		BUG();
+
+	ftintc010_data[ftintc010_nr].base = base;
+	ftintc010_data[ftintc010_nr].irq_offset = irq_start;
+
+	/*
+	 * mask all interrupts
+	 */
+	writel(0, base + FTINTC010_OFFSET_IRQMASK);
+	writel(0, base + FTINTC010_OFFSET_FIQMASK);
+	writel(0xffffffff, base + FTINTC010_OFFSET_IRQCLEAR);
+	writel(0xffffffff, base + FTINTC010_OFFSET_FIQCLEAR);
+#ifdef CONFIG_FTINTC010EX
+	writel(0, base + FTINTC010_OFFSET_IRQMASKEX);
+	writel(0xffffffff, base + FTINTC010_OFFSET_IRQCLEAREX);
+#endif
+
+	/*
+	 * initial trigger mode and level
+	 */
+	writel(0, base + FTINTC010_OFFSET_IRQMODE);
+	writel(0, base + FTINTC010_OFFSET_IRQLEVEL);
+	writel(0, base + FTINTC010_OFFSET_FIQMODE);
+	writel(0, base + FTINTC010_OFFSET_FIQLEVEL);
+#ifdef CONFIG_FTINTC010EX
+	writel(0, base + FTINTC010_OFFSET_IRQMODEEX);
+	writel(0, base + FTINTC010_OFFSET_IRQLEVELEX);
+#endif
+
+	/*
+	 * setup the linux irq subsystem
+	 */
+#ifdef CONFIG_FTINTC010EX
+	irq_end = irq_start + 64;
+#else
+	irq_end = irq_start + 32;
+#endif
+	for (irq = irq_start; irq < irq_end; irq++) {
+		irq_set_chip_and_handler(irq, &ftintc010_level_chip,
+					 handle_level_irq);
+		irq_set_chip_data(irq, &ftintc010_data[ftintc010_nr]);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+		irq_set_irq_type(irq, IRQ_TYPE_LEVEL_HIGH);
+	}
+}
diff --git a/arch/arm/mach-faraday/ftpmu010.c b/arch/arm/mach-faraday/ftpmu010.c
new file mode 100644
index 0000000..358a3bb
--- /dev/null
+++ b/arch/arm/mach-faraday/ftpmu010.c
@@ -0,0 +1,296 @@
+/*
+ * Faraday FTPMU010 Power Management Unit
+ *
+ * Copyright (C) 2009-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+
+#include <asm/clkdev.h>
+
+#include <mach/ftpmu010.h>
+
+#include "clock.h"
+
+struct ftpmu010_clk_params {
+	int	mult;
+	int	div;
+};
+
+/******************************************************************************
+ * internal functions
+ *****************************************************************************/
+static unsigned int __ftpmu010_in_turbo_mode(void __iomem *base)
+{
+	unsigned int pmode = readl(base + FTPMU010_OFFSET_PMODE);
+
+	return pmode & FTPMU010_PMODE_TURBO;
+}
+
+static unsigned int __ftpmu010_get_divahbclk(void __iomem *base)
+{
+	static const unsigned int bits2div[] = { 2, 3, 4, 6, 8, };
+	unsigned int pmode = readl(base + FTPMU010_OFFSET_PMODE);
+	unsigned int divbits = FTPMU010_PMODE_DIVAHBCLK(pmode);
+
+	if (divbits > 4) {
+		printk(KERN_ERR "unknown DIVAHBCLK %d\n", divbits);
+		return 8;
+	}
+
+	return bits2div[divbits];
+}
+
+static unsigned long __ftpmu010_get_pll1_freq(void __iomem *base,
+					      unsigned long rate)
+{
+	unsigned int pdllcr0 = readl(base + FTPMU010_OFFSET_PDLLCR0);
+
+	if (!(pdllcr0 & FTPMU010_PDLLCR0_PLL1DIS)) {
+		unsigned long mul = FTPMU010_PDLLCR0_PLL1NS(pdllcr0);
+
+		rate *= mul;
+	}
+
+	return rate;
+}
+
+static unsigned long __ftpmu010_get_hclk(void __iomem *base, unsigned long rate)
+{
+	unsigned int div = __ftpmu010_get_divahbclk(base);
+
+	return __ftpmu010_get_pll1_freq(base, rate) / div;
+}
+
+static unsigned long __ftpmu010_get_cpuclk(void __iomem *base,
+					   unsigned long rate)
+{
+	if (__ftpmu010_in_turbo_mode(base))
+		return __ftpmu010_get_pll1_freq(base, rate);
+
+	return __ftpmu010_get_hclk(base, rate);
+}
+
+static int __ftpmu010_enable_32768hz_osc(void __iomem *base)
+{
+	unsigned int oscc;
+
+	/* enable the 32768Hz oscillator */
+	oscc = readl(base + FTPMU010_OFFSET_OSCC);
+	oscc &= ~(FTPMU010_OSCC_OSCL_OFF | FTPMU010_OSCC_OSCL_TRI);
+	writel(oscc, base + FTPMU010_OFFSET_OSCC);
+
+	/* wait until ready */
+	oscc = readl(base + FTPMU010_OFFSET_OSCC);
+	while (!(oscc & FTPMU010_OSCC_OSCL_STABLE)) {
+		udelay(1);
+		oscc = readl(base + FTPMU010_OFFSET_OSCC);
+	}
+
+	/* select 32768Hz oscillator */
+	oscc |= FTPMU010_OSCC_OSCL_RTCLSEL;
+	writel(oscc, base + FTPMU010_OFFSET_OSCC);
+
+	return 0;
+}
+
+static int __ftpmu010_disable_32768hz_osc(void __iomem *base)
+{
+	unsigned int oscc;
+
+	/* deselect 32768Hz oscillator */
+	oscc = readl(base + FTPMU010_OFFSET_OSCC);
+	oscc &= ~FTPMU010_OSCC_OSCL_RTCLSEL;
+	writel(oscc, base + FTPMU010_OFFSET_OSCC);
+
+	/* disable the 32768Hz oscillator */
+	oscc = readl(base + FTPMU010_OFFSET_OSCC);
+	oscc |= FTPMU010_OSCC_OSCL_OFF | FTPMU010_OSCC_OSCL_TRI;
+	writel(oscc, base + FTPMU010_OFFSET_OSCC);
+
+	return 0;
+}
+
+/******************************************************************************
+ * struct clk functions
+ *****************************************************************************/
+
+static unsigned long ftpmu010_get_scaled_clk(struct clk *clk)
+{
+	struct ftpmu010_clk_params *params = clk->params;
+	int mult = params->mult;
+	int div = params->div;
+	unsigned long rate;
+
+	rate = __clk_get_rate(clk->parent);
+	clk->rate = rate * mult / div;
+	return clk->rate;
+}
+
+static unsigned long ftpmu010_get_cpuclk(struct clk *clk)
+{
+	unsigned long rate;
+
+	rate = __clk_get_rate(clk->parent);
+	clk->rate = __ftpmu010_get_cpuclk(clk->base, rate);
+	return clk->rate;
+}
+
+static unsigned long ftpmu010_get_hclk(struct clk *clk)
+{
+	unsigned long rate;
+
+	rate = __clk_get_rate(clk->parent);
+	clk->rate = __ftpmu010_get_hclk(clk->base, rate);
+	return clk->rate;
+}
+
+static int ftpmu010_32768hz_osc_mode(struct clk *clk, int on)
+{
+	if (on)
+		return __ftpmu010_enable_32768hz_osc(clk->base);
+	else
+		return __ftpmu010_disable_32768hz_osc(clk->base);
+}
+
+/******************************************************************************
+ * clocks
+ *****************************************************************************/
+struct clk ftpmu010_main_clk;
+
+struct clk ftpmu010_cpuclk = {
+	.parent		= &ftpmu010_main_clk,
+	.get_rate	= ftpmu010_get_cpuclk,
+};
+
+struct clk ftpmu010_hclk = {
+	.parent		= &ftpmu010_main_clk,
+	.get_rate	= ftpmu010_get_hclk,
+};
+
+static struct ftpmu010_clk_params ftpmu010_pclk_params = {
+	.mult	= 1,
+	.div	= 2,
+};
+
+struct clk ftpmu010_pclk = {
+	.parent		= &ftpmu010_hclk,
+	.get_rate	= ftpmu010_get_scaled_clk,
+	.params		= &ftpmu010_pclk_params,
+};
+
+static struct ftpmu010_clk_params ftpmu010_pll2_params = {
+	.mult	= 13,
+	.div	= 1,
+};
+
+struct clk ftpmu010_pll2_clk = {
+	.parent		= &ftpmu010_main_clk,
+	.get_rate	= ftpmu010_get_scaled_clk,
+	.params		= &ftpmu010_pll2_params,
+};
+
+struct clk ftpmu010_irda_clk = {
+	.parent		= &ftpmu010_pll2_clk,
+};
+
+static struct ftpmu010_clk_params ftpmu010_pll3_params = {
+	.mult	= 40,
+	.div	= 1,
+};
+
+struct clk ftpmu010_pll3_clk = {
+	.parent		= &ftpmu010_main_clk,
+	.get_rate	= ftpmu010_get_scaled_clk,
+	.params		= &ftpmu010_pll3_params,
+};
+
+static struct ftpmu010_clk_params ftpmu010_ssp_params = {
+	.mult	= 1,
+	.div	= 6,
+};
+
+struct clk ftpmu010_ssp_clk = {
+	.parent		= &ftpmu010_pll3_clk,
+	.get_rate	= ftpmu010_get_scaled_clk,
+	.params		= &ftpmu010_ssp_params,
+};
+
+static struct ftpmu010_clk_params ftpmu010_i2s_params = {
+	.mult	= 1,
+	.div	= 12,
+};
+
+struct clk ftpmu010_i2s_clk = {
+	.parent		= &ftpmu010_pll3_clk,
+	.get_rate	= ftpmu010_get_scaled_clk,
+	.params		= &ftpmu010_i2s_params,
+};
+
+static struct ftpmu010_clk_params ftpmu010_ac97_params1 = {
+	.mult	= 1,
+	.div	= 3,
+};
+
+struct clk ftpmu010_ac97_clk1 = {
+	.parent		= &ftpmu010_pll3_clk,
+	.get_rate	= ftpmu010_get_scaled_clk,
+	.params		= &ftpmu010_ac97_params1,
+};
+
+static struct ftpmu010_clk_params ftpmu010_ac97_params2 = {
+	.mult	= 1,
+	.div	= 6,
+};
+
+struct clk ftpmu010_ac97_clk2 = {
+	.parent		= &ftpmu010_pll3_clk,
+	.get_rate	= ftpmu010_get_scaled_clk,
+	.params		= &ftpmu010_ac97_params2,
+};
+
+static struct ftpmu010_clk_params ftpmu010_uart_params = {
+	.mult	= 1,
+	.div	= 8,
+};
+
+struct clk ftpmu010_uart_clk = {
+	.parent		= &ftpmu010_pll3_clk,
+	.get_rate	= ftpmu010_get_scaled_clk,
+	.params		= &ftpmu010_uart_params,
+};
+
+struct clk ftpmu010_32768hz_clk = {
+	.rate	= 32768,
+	.mode	= ftpmu010_32768hz_osc_mode,
+};
+
+/******************************************************************************
+ * initial functions
+ *****************************************************************************/
+void ftpmu010_init(void __iomem *base)
+{
+	ftpmu010_cpuclk.base		= base;
+	ftpmu010_hclk.base		= base;
+	ftpmu010_pclk.base		= base;
+	ftpmu010_32768hz_clk.base	= base;
+}
diff --git a/arch/arm/mach-faraday/fttmr010.c b/arch/arm/mach-faraday/fttmr010.c
new file mode 100644
index 0000000..5d75d8f
--- /dev/null
+++ b/arch/arm/mach-faraday/fttmr010.c
@@ -0,0 +1,283 @@
+/*
+ * Faraday FTTMR010 Timer
+ *
+ * Copyright (C) 2009-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <asm/mach/irq.h>
+
+#include <mach/fttmr010.h>
+
+/******************************************************************************
+ * internal functions
+ *****************************************************************************/
+static const unsigned int fttmr010_cr_mask[3] = {
+	FTTMR010_TM1_ENABLE | FTTMR010_TM1_CLOCK |
+	FTTMR010_TM1_OFENABLE | FTTMR010_TM1_UPDOWN,
+
+	FTTMR010_TM2_ENABLE | FTTMR010_TM2_CLOCK |
+	FTTMR010_TM2_OFENABLE | FTTMR010_TM2_UPDOWN,
+
+	FTTMR010_TM3_ENABLE | FTTMR010_TM3_CLOCK |
+	FTTMR010_TM3_OFENABLE | FTTMR010_TM3_UPDOWN,
+};
+
+/* we always use down counter */
+static const unsigned int fttmr010_cr_enable_flag[3] = {
+	FTTMR010_TM1_ENABLE | FTTMR010_TM1_OFENABLE,
+	FTTMR010_TM2_ENABLE | FTTMR010_TM2_OFENABLE,
+	FTTMR010_TM3_ENABLE | FTTMR010_TM3_OFENABLE,
+};
+
+static const unsigned int fttmr010_cr_enable_noirq_flag[3] = {
+	FTTMR010_TM1_ENABLE,
+	FTTMR010_TM2_ENABLE,
+	FTTMR010_TM3_ENABLE,
+};
+
+static void fttmr010_enable(void __iomem *base, unsigned int id)
+{
+	unsigned int cr = readl(base + FTTMR010_OFFSET_CR);
+
+	cr &= ~fttmr010_cr_mask[id];
+	cr |= fttmr010_cr_enable_flag[id];
+	writel(cr, base + FTTMR010_OFFSET_CR);
+}
+
+static void fttmr010_enable_noirq(void __iomem *base, unsigned int id)
+{
+	unsigned int cr = readl(base + FTTMR010_OFFSET_CR);
+
+	cr &= ~fttmr010_cr_mask[id];
+	cr |= fttmr010_cr_enable_noirq_flag[id];
+	writel(cr, base + FTTMR010_OFFSET_CR);
+}
+
+static void fttmr010_disable(void __iomem *base, unsigned int id)
+{
+	unsigned int cr = readl(base + FTTMR010_OFFSET_CR);
+
+	cr &= ~fttmr010_cr_mask[id];
+	writel(cr, base + FTTMR010_OFFSET_CR);
+}
+
+static const unsigned int fttmr010_irq_mask[3] = {
+	FTTMR010_TM1_MATCH1 | FTTMR010_TM1_MATCH2 | FTTMR010_TM1_OVERFLOW,
+	FTTMR010_TM2_MATCH1 | FTTMR010_TM2_MATCH2 | FTTMR010_TM2_OVERFLOW,
+	FTTMR010_TM3_MATCH1 | FTTMR010_TM3_MATCH2 | FTTMR010_TM3_OVERFLOW,
+};
+
+static void fttmr010_unmask_irq(void __iomem *base, unsigned int id)
+{
+	unsigned int mask;
+
+	mask = readl(base + FTTMR010_OFFSET_INTR_MASK);
+	mask &= ~fttmr010_irq_mask[id];
+	writel(mask, base + FTTMR010_OFFSET_INTR_MASK);
+}
+
+static void fttmr010_ack_irq(void __iomem *base, unsigned int id)
+{
+	unsigned int state;
+
+	state = readl(base + FTTMR010_OFFSET_INTR_STATE);
+	state &= ~fttmr010_irq_mask[id];
+	writel(state, base + FTTMR010_OFFSET_INTR_STATE);
+}
+
+static void fttmr010_write_timer(void __iomem *base, unsigned int id,
+				 unsigned int reg, unsigned int value)
+{
+	void __iomem *addr = base + FTTMR010_OFFSET_TIMER(id) + reg;
+	writel(value, addr);
+}
+
+static unsigned int fttmr010_read_timer(void __iomem *base, unsigned int id,
+					unsigned int reg)
+{
+	void __iomem *addr = base + FTTMR010_OFFSET_TIMER(id) + reg;
+	return readl(addr);
+}
+
+static void fttmr010_set_counter(void __iomem *base, unsigned int id,
+				 unsigned int value)
+{
+	fttmr010_write_timer(base, id, FTTMR010_OFFSET_COUNTER, value);
+}
+
+static unsigned int fttmr010_get_counter(void __iomem *base, unsigned int id)
+{
+	return fttmr010_read_timer(base, id, FTTMR010_OFFSET_COUNTER);
+}
+
+static void fttmr010_set_reload(void __iomem *base, unsigned int id,
+				unsigned int value)
+{
+	fttmr010_write_timer(base, id, FTTMR010_OFFSET_LOAD, value);
+}
+
+static void fttmr010_set_match1(void __iomem *base, unsigned int id,
+				unsigned int value)
+{
+	fttmr010_write_timer(base, id, FTTMR010_OFFSET_MATCH1, value);
+}
+
+static void fttmr010_set_match2(void __iomem *base, unsigned int id,
+				unsigned int value)
+{
+	fttmr010_write_timer(base, id, FTTMR010_OFFSET_MATCH2, value);
+}
+
+/******************************************************************************
+ * clockevent functions
+ *****************************************************************************/
+static int fttmr010_set_next_event(unsigned long clc,
+				   struct clock_event_device *ce)
+{
+	struct fttmr010_clockevent *fttmr010;
+
+	fttmr010 = container_of(ce, struct fttmr010_clockevent, clockevent);
+
+	fttmr010_set_counter(fttmr010->base, fttmr010->id, clc);
+	return 0;
+}
+
+static void fttmr010_set_mode(enum clock_event_mode mode,
+			      struct clock_event_device *ce)
+{
+	struct fttmr010_clockevent *fttmr010;
+
+	fttmr010 = container_of(ce, struct fttmr010_clockevent, clockevent);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		fttmr010_set_reload(fttmr010->base, fttmr010->id,
+				    fttmr010->reload);
+		fttmr010_set_counter(fttmr010->base, fttmr010->id,
+				     fttmr010->reload);
+		fttmr010_enable(fttmr010->base, fttmr010->id);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		fttmr010_enable(fttmr010->base, fttmr010->id);
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		fttmr010_set_reload(fttmr010->base, fttmr010->id, 0);
+		fttmr010_enable(fttmr010->base, fttmr010->id);
+		break;
+
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		fttmr010_disable(fttmr010->base, fttmr010->id);
+		break;
+	}
+}
+
+static irqreturn_t fttmr010_clockevent_interrupt(int irq, void *dev_id)
+{
+	struct fttmr010_clockevent *fttmr010 = dev_id;
+	struct clock_event_device *ce = &fttmr010->clockevent;
+
+	fttmr010_ack_irq(fttmr010->base, fttmr010->id);
+	ce->event_handler(ce);
+	return IRQ_HANDLED;
+}
+
+void __init fttmr010_clockevent_init(struct fttmr010_clockevent *fttmr010)
+{
+	struct clock_event_device *ce = &fttmr010->clockevent;
+	struct irqaction *action = &fttmr010->irqaction;
+
+	if (!fttmr010->base || fttmr010->id >= 3)
+		BUG();
+
+	/* initialize to a known state */
+	fttmr010_disable(fttmr010->base, fttmr010->id);
+	fttmr010_set_match1(fttmr010->base, fttmr010->id, 0);
+	fttmr010_set_match2(fttmr010->base, fttmr010->id, 0);
+	fttmr010_unmask_irq(fttmr010->base, fttmr010->id);
+
+	/* setup reload value for periodic clockevents */
+	fttmr010->reload	= fttmr010->freq / HZ;
+
+	/* Make irqs happen for the system timer */
+	action->name	= ce->name;
+	action->handler	= fttmr010_clockevent_interrupt;
+	action->flags	= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL;
+	action->dev_id	= fttmr010;
+
+	setup_irq(ce->irq, action);
+
+	/* setup struct clock_event_device */
+	ce->features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	ce->shift	= 32;
+	ce->rating	= 200;
+	ce->cpumask	= cpumask_of(0),
+	ce->mult	= div_sc(fttmr010->freq, NSEC_PER_SEC, ce->shift);
+	ce->max_delta_ns	= clockevent_delta2ns(0xffffffff, ce);
+	ce->min_delta_ns	= clockevent_delta2ns(0xf, ce);
+
+	ce->set_next_event	= fttmr010_set_next_event;
+	ce->set_mode		= fttmr010_set_mode;
+
+	clockevents_register_device(ce);
+}
+
+/******************************************************************************
+ * clocksource functions
+ *****************************************************************************/
+static cycle_t fttmr010_clocksource_read(struct clocksource *cs)
+{
+	struct fttmr010_clocksource *fttmr010;
+	cycle_t counter;
+
+	fttmr010 = container_of(cs, struct fttmr010_clocksource, clocksource);
+	counter = fttmr010_get_counter(fttmr010->base, fttmr010->id);
+	return ~counter;
+}
+
+void __init fttmr010_clocksource_init(struct fttmr010_clocksource *fttmr010)
+{
+	struct clocksource *cs = &fttmr010->clocksource;
+
+	if (!fttmr010->base || fttmr010->id >= 3)
+		BUG();
+
+	cs->rating	= 300;
+	cs->read	= fttmr010_clocksource_read;
+	cs->mask	= CLOCKSOURCE_MASK(32);
+	cs->shift	= 20;
+	cs->flags	= CLOCK_SOURCE_IS_CONTINUOUS;
+	cs->mult	= clocksource_hz2mult(fttmr010->freq, cs->shift);
+
+	/* setup as free-running clocksource */
+	fttmr010_disable(fttmr010->base, fttmr010->id);
+	fttmr010_set_match1(fttmr010->base, fttmr010->id, 0);
+	fttmr010_set_match2(fttmr010->base, fttmr010->id, 0);
+	fttmr010_set_reload(fttmr010->base, fttmr010->id, 0xffffffff);
+	fttmr010_set_counter(fttmr010->base, fttmr010->id, 0xffffffff);
+	fttmr010_enable_noirq(fttmr010->base, fttmr010->id);
+
+	clocksource_register(cs);
+}
diff --git a/arch/arm/mach-faraday/include/mach/board-a320.h b/arch/arm/mach-faraday/include/mach/board-a320.h
new file mode 100644
index 0000000..3578fc1
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/board-a320.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#ifndef __MACH_BOARD_A320_H
+#define __MACH_BOARD_A320_H
+
+#ifdef CONFIG_PLATFORM_A320
+
+/*
+ * Base addresses
+ */
+#define A320_FTFLH010_0_PA_BASE		0x80440000
+#define A320_FTDMAC020_0_PA_BASE	0x90400000
+#define A320_FTAPBB020_0_PA_BASE	0x90500000
+#define A320_FTLCDC100_0_PA_BASE	0x90600000
+#define A320_FTMAC100_0_PA_BASE		0x90900000
+#define A320_FTNANDC020_0_PA_BASE	0x90c00000
+#define A320_FTSDC020_0_PA_BASE		0x92000000
+#define A320_FTPMU010_0_PA_BASE		0x98100000
+#define A320_FTUART010_0_PA_BASE	0x98200000
+#define A320_FTUART010_1_PA_BASE	0x98300000
+#define A320_FTTMR010_0_PA_BASE		0x98400000
+#define A320_FTWDT010_0_PA_BASE		0x98500000
+#define A320_FTRTC010_0_PA_BASE		0x98600000
+#define A320_FTGPIO010_0_PA_BASE	0x98700000
+#define A320_FTINTC010_0_PA_BASE	0x98800000
+#define A320_FTI2C010_0_PA_BASE		0x98a00000
+#define A320_FTCFC010_0_PA_BASE		0x98d00000
+#define A320_FTSDC010_0_PA_BASE		0x98e00000
+#define A320_FTSSP010_0_PA_BASE		0x99400000
+#define A320_FTUART010_2_PA_BASE	0x99600000
+
+#define A320_FTPMU010_0_VA_BASE		0xf9810000
+#define A320_FTUART010_0_VA_BASE	0xf9820000
+#define A320_FTUART010_1_VA_BASE	0xf9830000
+#define A320_FTTMR010_0_VA_BASE		0xf9840000
+#define A320_FTINTC010_0_VA_BASE	0xf9880000
+#define A320_FTUART010_2_VA_BASE	0xf9960000
+
+#define DEBUG_LL_FTUART010_PA_BASE	A320_FTUART010_0_PA_BASE
+#define DEBUG_LL_FTUART010_VA_BASE	A320_FTUART010_0_VA_BASE
+
+/*
+ * The "Main CLK" Oscillator on the board which is used by the PLL to generate
+ * CPU/AHB/APB clocks.
+ */
+#define MAIN_CLK	3686400
+
+#endif	/* CONFIG_PLATFORM_A320 */
+
+#endif	/* __MACH_BOARD_A320_H */
diff --git a/arch/arm/mach-faraday/include/mach/clkdev.h b/arch/arm/mach-faraday/include/mach/clkdev.h
new file mode 100644
index 0000000..7399304
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/clkdev.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2010-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#ifndef __ASM_MACH_CLKDEV_H
+#define __ASM_MACH_CLKDEV_H
+
+#define __clk_get(clk) ({ 1; })
+#define __clk_put(clk) do { } while (0)
+
+#endif
diff --git a/arch/arm/mach-faraday/include/mach/debug-macro.S b/arch/arm/mach-faraday/include/mach/debug-macro.S
new file mode 100644
index 0000000..d46f304
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/debug-macro.S
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#include <linux/linkage.h>
+#include <mach/hardware.h>
+#include <mach/serial.h>
+
+	.macro	addruart,rx
+	mrc	p15, 0, \rx, c1, c0
+	tst	\rx, #1		@ MMU enabled ?
+	ldreq	\rx, =DEBUG_LL_FTUART010_PA_BASE
+	ldrne	\rx, =DEBUG_LL_FTUART010_VA_BASE
+	.endm
+
+	.macro	senduart,rd,rx
+	strb	\rd, [\rx, #SERIAL_THR]
+	.endm
+
+	.macro	waituart,rd,rx
+1001:	ldrb	\rd, [\rx, #SERIAL_LSR]	@ LSR
+	tst	\rd, #SERIAL_LSR_THRE	@ test empty
+	beq	1001b
+	.endm
+
+	.macro	busyuart,rd,rx
+	mov	\rd, #0x100
+1010:	subs	\rd, \rd, #1
+	bne	1010b
+	.endm
diff --git a/arch/arm/mach-faraday/include/mach/entry-macro.S b/arch/arm/mach-faraday/include/mach/entry-macro.S
new file mode 100644
index 0000000..a294d33
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/entry-macro.S
@@ -0,0 +1,87 @@
+/*
+ * Low-level IRQ helper macros for Faraday platforms
+ *
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#include <mach/ftintc010.h>
+
+	.macro	disable_fiq
+	.endm
+
+	.macro	get_irqnr_preamble, base, tmp
+	ldr	\base, =ftintc010_base_addr
+	ldr	\base, [\base]
+	.endm
+
+	.macro	arch_ret_to_user, tmp1, tmp2
+	.endm
+
+	/*
+	 * Get IRQ number and base
+	 * Input: base
+	 * Output: irqnr, Z flag
+	 * Local R/W: irqstat, tmp
+	 */
+	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
+
+	ldr	\irqstat, [\base, #FTINTC010_OFFSET_IRQSTATUS]
+	cmp	\irqstat, #0
+
+#ifndef CONFIG_FTINTC010EX
+	beq	1001f
+#endif
+	movne	\irqnr, #0
+
+#ifdef CONFIG_FTINTC010EX
+	bne	1002f
+
+	ldr	\irqstat, [\base, #FTINTC010_OFFSET_IRQSTATUSEX]
+	cmp	\irqstat, #0
+
+	beq	1001f
+	mov	\irqnr, #32
+1002:
+#endif
+
+#if __LINUX_ARM_ARCH__ >= 5
+	clz	\tmp, \irqstat
+	rsb	\tmp, \tmp, #31
+	add	\irqnr, \irqnr, \tmp
+#else
+	movs	\tmp, \irqstat, lsl #16
+	movne	\irqstat, \tmp
+	addeq	\irqnr, \irqnr, #16
+
+	movs	\tmp, \irqstat, lsl #8
+	movne	\irqstat, \tmp
+	addeq	\irqnr, \irqnr, #8
+
+	movs	\tmp, \irqstat, lsl #4
+	movne	\irqstat, \tmp
+	addeq	\irqnr, \irqnr, #4
+
+	movs	\tmp, \irqstat, lsl #2
+	movne	\irqstat, \tmp
+	addeq	\irqnr, \irqnr, #2
+
+	movs	\tmp, \irqstat, lsl #1
+	addeqs	\irqnr, \irqnr, #1
+#endif
+
+1001:
+	.endm	/* get_irqnr_and_base */
diff --git a/arch/arm/mach-faraday/include/mach/ftintc010.h b/arch/arm/mach-faraday/include/mach/ftintc010.h
new file mode 100644
index 0000000..f0d8fec
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/ftintc010.h
@@ -0,0 +1,57 @@
+/*
+ * Faraday FTINTC010 Interrupt Controller
+ *
+ * Copyright (C) 2009-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#ifndef __FTINTC010_H
+#define __FTINTC010_H
+
+#define FTINTC010_OFFSET_IRQSRC		0x00
+#define FTINTC010_OFFSET_IRQMASK	0x04
+#define FTINTC010_OFFSET_IRQCLEAR	0x08
+#define FTINTC010_OFFSET_IRQMODE	0x0c
+#define FTINTC010_OFFSET_IRQLEVEL	0x10
+#define FTINTC010_OFFSET_IRQSTATUS	0x14
+
+#define FTINTC010_OFFSET_FIQSRC		0x20
+#define FTINTC010_OFFSET_FIQMASK	0x24
+#define FTINTC010_OFFSET_FIQCLEAR	0x28
+#define FTINTC010_OFFSET_FIQMODE	0x2c
+#define FTINTC010_OFFSET_FIQLEVEL	0x30
+#define FTINTC010_OFFSET_FIQSTATUS	0x34
+
+#define FTINTC010_OFFSET_IRQSRCEX	0x60
+#define FTINTC010_OFFSET_IRQMASKEX	0x64
+#define FTINTC010_OFFSET_IRQCLEAREX	0x68
+#define FTINTC010_OFFSET_IRQMODEEX	0x6c
+#define FTINTC010_OFFSET_IRQLEVELEX	0x70
+#define FTINTC010_OFFSET_IRQSTATUSEX	0x74
+
+#ifndef __ASSEMBLY__
+
+#include <linux/irq.h>
+
+void __init ftintc010_init(unsigned int ftintc010_nr, void __iomem *base,
+			   unsigned int irq_start);
+void __init ftintc010_cascade_irq(unsigned int ftintc010_nr, unsigned int irq);
+int ftintc010_set_irq_type(unsigned int irq, unsigned int type);
+
+#endif	/* __ASSEMBLY__ */
+
+#endif /* __FTINTC010_H */
diff --git a/arch/arm/mach-faraday/include/mach/ftpmu010.h b/arch/arm/mach-faraday/include/mach/ftpmu010.h
new file mode 100644
index 0000000..f8a0461
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/ftpmu010.h
@@ -0,0 +1,166 @@
+/*
+ * Faraday FTPMU010 Power Management Unit
+ *
+ * Copyright (C) 2009-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#ifndef __FTPMU010_H
+#define __FTPMU010_H
+
+#define FTPMU010_OFFSET_IDNMBR0		0x00
+#define FTPMU010_OFFSET_OSCC		0x08
+#define FTPMU010_OFFSET_PMODE		0x0c
+#define FTPMU010_OFFSET_PMCR		0x10
+#define FTPMU010_OFFSET_PED		0x14
+#define FTPMU010_OFFSET_PEDSR		0x18
+#define FTPMU010_OFFSET_PMSR		0x20
+#define FTPMU010_OFFSET_PGSR		0x24
+#define FTPMU010_OFFSET_MFPSR		0x28
+#define FTPMU010_OFFSET_MISC		0x2c
+#define FTPMU010_OFFSET_PDLLCR0		0x30
+#define FTPMU010_OFFSET_PDLLCR1		0x34
+#define FTPMU010_OFFSET_AHBMCLKOFF	0x38
+#define FTPMU010_OFFSET_APBMCLKOFF	0x3c
+#define FTPMU010_OFFSET_DCSRCR0		0x40
+#define FTPMU010_OFFSET_DCSRCR1		0x44
+#define FTPMU010_OFFSET_DCSRCR2		0x48
+#define FTPMU010_OFFSET_SDRAMHTC	0x4c
+#define FTPMU010_OFFSET_PSPR0		0x50
+#define FTPMU010_OFFSET_PSPR1		0x54
+#define FTPMU010_OFFSET_PSPR2		0x58
+#define FTPMU010_OFFSET_PSPR3		0x5c
+#define FTPMU010_OFFSET_PSPR4		0x60
+#define FTPMU010_OFFSET_PSPR5		0x64
+#define FTPMU010_OFFSET_PSPR6		0x68
+#define FTPMU010_OFFSET_PSPR7		0x6c
+#define FTPMU010_OFFSET_PSPR8		0x70
+#define FTPMU010_OFFSET_PSPR9		0x74
+#define FTPMU010_OFFSET_PSPR10		0x78
+#define FTPMU010_OFFSET_PSPR11		0x7c
+#define FTPMU010_OFFSET_PSPR12		0x80
+#define FTPMU010_OFFSET_PSPR13		0x84
+#define FTPMU010_OFFSET_PSPR14		0x88
+#define FTPMU010_OFFSET_PSPR15		0x8c
+#define FTPMU010_OFFSET_AHBDMA_RACCS	0x90
+#define FTPMU010_OFFSET_JSS		0x9c
+#define FTPMU010_OFFSET_CFC_RACC	0xa0
+#define FTPMU010_OFFSET_SSP1_RACC	0xa4
+#define FTPMU010_OFFSET_UART1TX_RACC	0xa8
+#define FTPMU010_OFFSET_UART1RX_RACC	0xac
+#define FTPMU010_OFFSET_UART2TX_RACC	0xb0
+#define FTPMU010_OFFSET_UART2RX_RACC	0xb4
+#define FTPMU010_OFFSET_SDC_RACC	0xb8
+#define FTPMU010_OFFSET_I2SAC97_RACC	0xbc
+#define FTPMU010_OFFSET_IRDATX_RACC	0xc0
+#define FTPMU010_OFFSET_USBD_RACC	0xc8
+#define FTPMU010_OFFSET_IRDARX_RACC	0xcc
+#define FTPMU010_OFFSET_IRDA_RACC	0xd0
+#define FTPMU010_OFFSET_ED0_RACC	0xd4
+#define FTPMU010_OFFSET_ED1_RACC	0xd8
+
+/*
+ * ID Number 0 Register
+ */
+#define FTPMU010_ID_A320A	0x03200000
+#define FTPMU010_ID_A320C	0x03200010
+#define FTPMU010_ID_A320D	0x03200030
+
+/*
+ * OSC Control Register
+ */
+#define FTPMU010_OSCC_OSCH_TRI		(1 << 11)
+#define FTPMU010_OSCC_OSCH_STABLE	(1 << 9)
+#define FTPMU010_OSCC_OSCH_OFF		(1 << 8)
+#define FTPMU010_OSCC_OSCL_TRI		(1 << 3)
+#define FTPMU010_OSCC_OSCL_RTCLSEL	(1 << 2)
+#define FTPMU010_OSCC_OSCL_STABLE	(1 << 1)
+#define FTPMU010_OSCC_OSCL_OFF		(1 << 0)
+
+/*
+ * Power Mode Register
+ */
+#define FTPMU010_PMODE_DIVAHBCLK_MASK	(0x7 << 4)
+#define FTPMU010_PMODE_DIVAHBCLK_2	(0x0 << 4)
+#define FTPMU010_PMODE_DIVAHBCLK_3	(0x1 << 4)
+#define FTPMU010_PMODE_DIVAHBCLK_4	(0x2 << 4)
+#define FTPMU010_PMODE_DIVAHBCLK_6	(0x3 << 4)
+#define FTPMU010_PMODE_DIVAHBCLK_8	(0x4 << 4)
+#define FTPMU010_PMODE_DIVAHBCLK(pmode)	(((pmode) >> 4) & 0x7)
+#define FTPMU010_PMODE_FCS		(1 << 2)
+#define FTPMU010_PMODE_TURBO		(1 << 1)
+#define FTPMU010_PMODE_SLEEP		(1 << 0)
+
+/*
+ * Power Manager Status Register
+ */
+#define FTPMU010_PMSR_SMR	(1 << 10)
+#define FTPMU010_PMSR_RDH	(1 << 2)
+#define FTPMU010_PMSR_PH	(1 << 1)
+#define FTPMU010_PMSR_CKEHLOW	(1 << 0)
+
+/*
+ * Multi-Function Port Setting Register
+ */
+#define FTPMU010_MFPSR_MODEMPINSEL	(1 << 14)
+#define FTPMU010_MFPSR_AC97CLKOUTSEL	(1 << 13)
+#define FTPMU010_MFPSR_AC97PINSEL	(1 << 3)
+
+/*
+ * PLL/DLL Control Register 0
+ */
+#define FTPMU010_PDLLCR0_HCLKOUTDIS(cr0)	(((cr0) >> 20) & 0xf)
+#define FTPMU010_PDLLCR0_DLLFRAG		(1 << 19)
+#define FTPMU010_PDLLCR0_DLLSTSEL		(1 << 18)
+#define FTPMU010_PDLLCR0_DLLSTABLE		(1 << 17)
+#define FTPMU010_PDLLCR0_DLLDIS			(1 << 16)
+#define FTPMU010_PDLLCR0_PLL1NS(cr0)		(((cr0) >> 3) & 0x1ff)
+#define FTPMU010_PDLLCR0_PLL1STSEL		(1 << 2)
+#define FTPMU010_PDLLCR0_PLL1STABLE		(1 << 1)
+#define FTPMU010_PDLLCR0_PLL1DIS		(1 << 0)
+
+/*
+ * PLL/DLL Control Register 1
+ */
+#define FTPMU010_PDLLCR1_PWMCLKDIV(x)		(((x) & 0xf) << 20)
+#define FTPMU010_PDLLCR1_PWMCLKDIV_OF(cr1)	(((cr1) >> 20) & 0xf)
+#define FTPMU010_PDLLCR1_I2SCLKDIV(x)		(((x) & 0xf) << 16)
+#define FTPMU010_PDLLCR1_I2SCLKDIV_OF(cr1)	(((cr1) >> 16) & 0xf)
+#define FTPMU010_PDLLCR1_PLL2STSEL		(1 << 10)
+#define FTPMU010_PDLLCR1_PLL2STABLE		(1 << 9)
+#define FTPMU010_PDLLCR1_PLL2DIS		(1 << 8)
+#define FTPMU010_PDLLCR1_PLL3STSEL		(1 << 2)
+#define FTPMU010_PDLLCR1_PLL3STABLE		(1 << 1)
+#define FTPMU010_PDLLCR1_PLL3DIS		(1 << 0)
+
+void ftpmu010_init(void __iomem *base);
+
+extern struct clk ftpmu010_main_clk;
+extern struct clk ftpmu010_cpuclk;
+extern struct clk ftpmu010_hclk;
+extern struct clk ftpmu010_pclk;
+extern struct clk ftpmu010_pll2_clk;
+extern struct clk ftpmu010_irda_clk;
+extern struct clk ftpmu010_pll3_clk;
+extern struct clk ftpmu010_ssp_clk;
+extern struct clk ftpmu010_i2s_clk;
+extern struct clk ftpmu010_ac97_clk1;
+extern struct clk ftpmu010_ac97_clk2;
+extern struct clk ftpmu010_uart_clk;
+extern struct clk ftpmu010_32768hz_clk;
+
+#endif	/* __FTPMU010_H */
diff --git a/arch/arm/mach-faraday/include/mach/fttmr010.h b/arch/arm/mach-faraday/include/mach/fttmr010.h
new file mode 100644
index 0000000..22f97c6
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/fttmr010.h
@@ -0,0 +1,86 @@
+/*
+ * Faraday FTTMR010 Timer
+ *
+ * Copyright (C) 2009-2011 Faraday Technology
+ * Po-Yu Chuang <ratbert@faraday-tech.com>
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
+#ifndef __FTTMR010_H
+#define __FTTMR010_H
+
+#define FTTMR010_OFFSET_COUNTER		0x00
+#define FTTMR010_OFFSET_LOAD		0x04
+#define FTTMR010_OFFSET_MATCH1		0x08
+#define FTTMR010_OFFSET_MATCH2		0x0c
+#define FTTMR010_OFFSET_TIMER(x)	((x) * 0x10)
+#define FTTMR010_OFFSET_CR		0x30
+#define FTTMR010_OFFSET_INTR_STATE	0x34
+#define FTTMR010_OFFSET_INTR_MASK	0x38
+
+/*
+ * Timer Control Register
+ */
+#define FTTMR010_TM3_UPDOWN	(1 << 11)
+#define FTTMR010_TM2_UPDOWN	(1 << 10)
+#define FTTMR010_TM1_UPDOWN	(1 << 9)
+#define FTTMR010_TM3_OFENABLE	(1 << 8)
+#define FTTMR010_TM3_CLOCK	(1 << 7)
+#define FTTMR010_TM3_ENABLE	(1 << 6)
+#define FTTMR010_TM2_OFENABLE	(1 << 5)
+#define FTTMR010_TM2_CLOCK	(1 << 4)
+#define FTTMR010_TM2_ENABLE	(1 << 3)
+#define FTTMR010_TM1_OFENABLE	(1 << 2)
+#define FTTMR010_TM1_CLOCK	(1 << 1)
+#define FTTMR010_TM1_ENABLE	(1 << 0)
+
+/*
+ * Timer Interrupt State & Mask Registers
+ */
+#define FTTMR010_TM3_OVERFLOW	(1 << 8)
+#define FTTMR010_TM3_MATCH2	(1 << 7)
+#define FTTMR010_TM3_MATCH1	(1 << 6)
+#define FTTMR010_TM2_OVERFLOW	(1 << 5)
+#define FTTMR010_TM2_MATCH2	(1 << 4)
+#define FTTMR010_TM2_MATCH1	(1 << 3)
+#define FTTMR010_TM1_OVERFLOW	(1 << 2)
+#define FTTMR010_TM1_MATCH2	(1 << 1)
+#define FTTMR010_TM1_MATCH1	(1 << 0)
+
+#include <linux/interrupt.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+
+struct fttmr010_clockevent {
+	struct clock_event_device	clockevent;
+	struct irqaction		irqaction;
+	void __iomem			*base;
+	unsigned int			id;	/* one of 3 counters */
+	unsigned int			reload;
+	unsigned int			freq;
+};
+
+struct fttmr010_clocksource {
+	struct clocksource	clocksource;
+	void __iomem		*base;
+	unsigned int		id;	/* one of 3 counters */
+	unsigned int		freq;
+};
+
+void __init fttmr010_clockevent_init(struct fttmr010_clockevent *fttmr010);
+void __init fttmr010_clocksource_init(struct fttmr010_clocksource *fttmr010);
+
+#endif	/* __FTTMR010_H */
diff --git a/arch/arm/mach-faraday/include/mach/hardware.h b/arch/arm/mach-faraday/include/mach/hardware.h
new file mode 100644
index 0000000..81c894e
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/hardware.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#ifndef __ASM_ARCH_HARDWARE_H
+#define __ASM_ARCH_HARDWARE_H
+
+#include <mach/board-a320.h>
+
+#endif /* __ASM_ARCH_HARDWARE_H */
diff --git a/arch/arm/mach-faraday/include/mach/io.h b/arch/arm/mach-faraday/include/mach/io.h
new file mode 100644
index 0000000..58652e7
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/io.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#ifndef __ASM_ARM_ARCH_IO_H
+#define __ASM_ARM_ARCH_IO_H
+
+#define IO_SPACE_LIMIT      0xffffffff
+
+#define __io(a)		__typesafe_io(a)
+#define __mem_pci(a)	(a)
+
+#endif /* __ASM_ARM_ARCH_IO_H */
diff --git a/arch/arm/mach-faraday/include/mach/irqs-a320.h b/arch/arm/mach-faraday/include/mach/irqs-a320.h
new file mode 100644
index 0000000..3a239c2
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/irqs-a320.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2010-2011 Faraday Technology
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
+#ifndef __MACH_IRQS_A320_H
+#define __MACH_IRQS_A320_H
+
+#ifdef CONFIG_PLATFORM_A320
+
+/*
+ * Interrupt numbers of Hierarchical Architecture
+ */
+#define IRQ_A320_START	0
+
+#define IRQ_A320_FTCFC010_0_CD		(IRQ_A320_START + 0)
+#define IRQ_A320_FTCFC010_0_DMA		(IRQ_A320_START + 1)
+#define IRQ_A320_FTI2C010_0		(IRQ_A320_START + 3)
+#define IRQ_A320_FTSDC010_0		(IRQ_A320_START + 5)
+#define IRQ_A320_FTSSP010_0		(IRQ_A320_START + 6)
+#define IRQ_A320_FTUART010_2		(IRQ_A320_START + 7)
+#define IRQ_A320_FTPMU010_0		(IRQ_A320_START + 8)
+#define IRQ_A320_FTUART010_0		(IRQ_A320_START + 10)
+#define IRQ_A320_FTUART010_1		(IRQ_A320_START + 11)
+#define IRQ_A320_FTGPIO010_0		(IRQ_A320_START + 13)
+#define IRQ_A320_FTTMR010_0_T1		(IRQ_A320_START + 14)
+#define IRQ_A320_FTTMR010_0_T2		(IRQ_A320_START + 15)
+#define IRQ_A320_FTWDT010_0		(IRQ_A320_START + 16)
+#define IRQ_A320_FTRTC010_0_ALRM	(IRQ_A320_START + 17)
+#define IRQ_A320_FTRTC010_0_SEC		(IRQ_A320_START + 18)
+#define IRQ_A320_FTTMR010_0_T0		(IRQ_A320_START + 19)
+#define IRQ_A320_FTLCDC100_0		(IRQ_A320_START + 20)
+#define IRQ_A320_FTDMAC020_0		(IRQ_A320_START + 21)
+#define IRQ_A320_FTAPBB020_0		(IRQ_A320_START + 24)
+#define IRQ_A320_FTMAC100_0		(IRQ_A320_START + 25)
+#define IRQ_A320_FUSB220_0		(IRQ_A320_START + 26)
+#define IRQ_A320_FTSDC020_0		(IRQ_A320_START + 29)
+#define IRQ_A320_FTNANDC020_0		(IRQ_A320_START + 29)
+#define IRQ_A320_FOTG2XX_0		(IRQ_A320_START + 29)
+#define IRQ_A320_FUSBH200_0		(IRQ_A320_START + 29)
+
+#define NR_IRQS				(IRQ_A320_START + 32)
+
+#endif	/* CONFIG_PLATFORM_A320 */
+
+#endif	/* __MACH_IRQS_A320_H */
diff --git a/arch/arm/mach-faraday/include/mach/irqs.h b/arch/arm/mach-faraday/include/mach/irqs.h
new file mode 100644
index 0000000..87a43fb
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/irqs.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#ifndef __MACH_IRQS_H
+#define __MACH_IRQS_H
+
+#include <mach/irqs-a320.h>
+
+#ifndef NR_IRQS
+#error "NR_IRQS not defined by the board-specific files"
+#endif
+
+#endif /* __MACH_IRQS_H */
diff --git a/arch/arm/mach-faraday/include/mach/memory.h b/arch/arm/mach-faraday/include/mach/memory.h
new file mode 100644
index 0000000..c48bb79
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/memory.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#ifndef __ASM_ARCH_MEMORY_H
+#define __ASM_ARCH_MEMORY_H
+
+#include <asm/sizes.h>
+
+#define PHYS_OFFSET	UL(0x00000000)
+#define MEM_SIZE	SZ_64M
+
+#endif /* __ASM_ARCH_MEMORY_H */
diff --git a/arch/arm/mach-faraday/include/mach/serial-a320.h b/arch/arm/mach-faraday/include/mach/serial-a320.h
new file mode 100644
index 0000000..72a0e93
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/serial-a320.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2010-2011 Faraday Technology
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
+#ifndef __MACH_SERIAL_A320_H
+#define __MACH_SERIAL_A320_H
+
+#ifdef CONFIG_PLATFORM_A320
+
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+
+#define SERIAL_PORT_DFNS						\
+	{	/* ttyS0 */						\
+		.baud_base	= BASE_BAUD,				\
+		.iomem_base	= (u8 *)A320_FTUART010_0_VA_BASE,	\
+		.irq		= IRQ_A320_FTUART010_0,			\
+		.flags		= STD_COM_FLAGS,			\
+		.io_type	= UPIO_MEM32,				\
+		.iomem_reg_shift = 2,					\
+	}, {	/* ttyS1 */						\
+		.baud_base	= BASE_BAUD,				\
+		.iomem_base	= (u8 *)A320_FTUART010_1_VA_BASE,	\
+		.irq		= IRQ_A320_FTUART010_1,			\
+		.flags		= STD_COM_FLAGS,			\
+		.io_type	= UPIO_MEM32,				\
+		.iomem_reg_shift = 2,					\
+	}, {	/* ttyS2 */						\
+		.baud_base	= BASE_BAUD,				\
+		.iomem_base	= (u8 *)A320_FTUART010_2_VA_BASE,	\
+		.irq		= IRQ_A320_FTUART010_2,			\
+		.flags		= STD_COM_FLAGS,			\
+		.io_type	= UPIO_MEM32,				\
+		.iomem_reg_shift = 2,					\
+	},
+
+#endif	/* CONFIG_PLATFORM_A320 */
+
+#endif	/* __MACH_SERIAL_A320_H */
diff --git a/arch/arm/mach-faraday/include/mach/serial.h b/arch/arm/mach-faraday/include/mach/serial.h
new file mode 100644
index 0000000..987a8fa
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/serial.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#ifndef __ASM_ARCH_SERIAL_H
+#define __ASM_ARCH_SERIAL_H
+
+#include <linux/serial.h>
+
+/*
+ * We use a 18.432MHz clock rather than typical 1.8432 MHz clock for UART.
+ */
+#define UART_CLK	18432000
+
+#define BASE_BAUD	(UART_CLK / 16)
+#define STD_COM_FLAGS	(UPF_BOOT_AUTOCONF)
+
+#include <mach/serial-a320.h>
+
+#endif /* __ASM_ARCH_SERIAL_H */
diff --git a/arch/arm/mach-faraday/include/mach/system.h b/arch/arm/mach-faraday/include/mach/system.h
new file mode 100644
index 0000000..632a21c
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/system.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#ifndef __ASM_ARCH_SYSTEM_H
+#define __ASM_ARCH_SYSTEM_H
+
+#include <asm/proc-fns.h>
+
+static inline void arch_idle(void)
+{
+	cpu_do_idle();
+}
+
+static inline void arch_reset(char mode, const char *cmd)
+{
+	/* NOP */
+}
+
+#endif /* __ASM_ARCH_SYSTEM_H */
diff --git a/arch/arm/mach-faraday/include/mach/timex.h b/arch/arm/mach-faraday/include/mach/timex.h
new file mode 100644
index 0000000..ffac83e
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/timex.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#ifndef __ASM_ARCH_TIMEX_H
+#define __ASM_ARCH_TIMEX_H
+
+#define CLOCK_TICK_RATE	16588800
+
+#endif /* __ASM_ARCH_TIMEX_H */
+
diff --git a/arch/arm/mach-faraday/include/mach/uncompress.h b/arch/arm/mach-faraday/include/mach/uncompress.h
new file mode 100644
index 0000000..2c18274
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/uncompress.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#include <mach/hardware.h>
+
+#define SERIAL_THR	0x00
+#define SERIAL_LSR	0x14
+#define SERIAL_LSR_THRE	0x20
+
+/*
+ * This does not append a newline
+ */
+static inline void putc(int c)
+{
+	unsigned long base = DEBUG_LL_FTUART010_PA_BASE;
+
+	while ((readl(base + SERIAL_LSR) & SERIAL_LSR_THRE) == 0)
+		barrier();
+
+	writel(c, base + SERIAL_THR);
+}
+
+static inline void flush(void)
+{
+}
+
+/*
+ * nothing to do
+ */
+#define arch_decomp_setup()
+#define arch_decomp_wdog()
diff --git a/arch/arm/mach-faraday/include/mach/vmalloc.h b/arch/arm/mach-faraday/include/mach/vmalloc.h
new file mode 100644
index 0000000..a6fd938
--- /dev/null
+++ b/arch/arm/mach-faraday/include/mach/vmalloc.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2005-2011 Faraday Technology
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
+#ifndef __ASM_ARCH_VMALLOC_H
+#define __ASM_ARCH_VMALLOC_H
+
+#define VMALLOC_END	0xe0000000
+
+#endif /* __ASM_ARCH_VMALLOC_H */
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 3fc87b1..e174fdf 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -163,7 +163,7 @@ config CPU_ARM925T
 
 # ARM926T
 config CPU_ARM926T
-	bool "Support ARM926T processor" if ARCH_INTEGRATOR || MACH_REALVIEW_EB
+	bool "Support ARM926T processor" if ARCH_INTEGRATOR || MACH_REALVIEW_EB || ARCH_FARADAY
 	select CPU_32v5
 	select CPU_ABRT_EV5TJ
 	select CPU_PABRT_LEGACY
@@ -181,7 +181,7 @@ config CPU_ARM926T
 
 # FA526
 config CPU_FA526
-	bool
+	bool  "Support FA526 processor" if ARCH_FARADAY
 	select CPU_32v4
 	select CPU_ABRT_EV4
 	select CPU_PABRT_LEGACY
diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 7ca41f0..452ef36 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -153,6 +153,7 @@ anubis			MACH_ANUBIS		ANUBIS			734
 akita			MACH_AKITA		AKITA			744
 e330			MACH_E330		E330			753
 nokia770		MACH_NOKIA770		NOKIA770		755
+faraday			MACH_FARADAY		FARADAY			758
 carmeva			MACH_CARMEVA		CARMEVA			769
 edb9315a		MACH_EDB9315A		EDB9315A		772
 stargate2		MACH_STARGATE2		STARGATE2		774
-- 
1.6.3.3

