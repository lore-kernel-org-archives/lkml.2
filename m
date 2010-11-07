Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0KGQaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 11:30:16 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37805 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab0KGQaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 11:30:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y7igXnbcXyboznQvED7cykkflZ5fIk5DUK/5XaQE/Y1pKtGTKzACth/zzhapQlJBdb
         yZrZoapVdObE75Uk0eTTdj5+gChUbDT48bx/GMJOf7aGcgV+K6A04exWXVvByi8/oxda
         I9CSW5gwb/NZllzYjl3Mnp+Yu9/yWA7DkWNr8=
From: Alexey Charkov <alchark@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Alexey Charkov <alchark@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6 v2] ARM: Add basic architecture support for VIA/WonderMedia 85xx SoC's
Date: Sun,  7 Nov 2010 19:28:52 +0300
Message-Id: <1289147348-31969-1-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the family of Systems-on-Chip produced initially
by VIA and now its subsidiary WonderMedia that have recently become
widespread in lower-end Chinese ARM-based tablets and netbooks.

Support is included for both VT8500 and WM8505. Suitable code is
selected (if compiled in) at early initialization time by reading a
platform-specific identification register, as current bootloaders
do not provide any reliable machine id to the kernel.

Included are basic machine initialization files, register and
interrupt definitions, support for the on-chip interrupt controller,
high-precision OS timer, GPIO lines, necessary macros for early debug,
pulse-width-modulated outputs control, as well as platform device
configurations for the specific drivers implemented elsewhere.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---

Please review and (if appropriate) commit to a relevant git tree for
further integration in 2.6.38.

Compared to the previous submissions, this code introduces boot-time
determintaion of SoC version (instead of just compile-time preselection),
boot-argument override for the LCD panel size (used when preallocating
frame buffer memory), better guesses for PCI I/O space configuration
(thanks to Arnd Bergmann for suggestions), as well as a rebase against
the latest changes introduced in 2.6.37 merge window.

Due credits go to the community for providing feedback, advice and
testing for the code in this patch and follow-ups.

 arch/arm/Kconfig                                |   14 +
 arch/arm/Makefile                               |    1 +
 arch/arm/boot/compressed/Makefile               |    4 +
 arch/arm/boot/compressed/head-vt8500.S          |   46 +++
 arch/arm/mach-vt8500/Kconfig                    |   65 ++++
 arch/arm/mach-vt8500/Makefile                   |    6 +
 arch/arm/mach-vt8500/Makefile.boot              |    3 +
 arch/arm/mach-vt8500/bv07.c                     |   70 ++++
 arch/arm/mach-vt8500/devices.c                  |  429 +++++++++++++++++++++++
 arch/arm/mach-vt8500/devices.h                  |   43 +++
 arch/arm/mach-vt8500/gpio.c                     |  230 ++++++++++++
 arch/arm/mach-vt8500/include/mach/debug-macro.S |   31 ++
 arch/arm/mach-vt8500/include/mach/entry-macro.S |   32 ++
 arch/arm/mach-vt8500/include/mach/gpio.h        |    6 +
 arch/arm/mach-vt8500/include/mach/hardware.h    |   12 +
 arch/arm/mach-vt8500/include/mach/io.h          |   28 ++
 arch/arm/mach-vt8500/include/mach/irq_defs.h    |  124 +++++++
 arch/arm/mach-vt8500/include/mach/irqs.h        |   22 ++
 arch/arm/mach-vt8500/include/mach/memory.h      |   28 ++
 arch/arm/mach-vt8500/include/mach/mmio_regs.h   |   90 +++++
 arch/arm/mach-vt8500/include/mach/system.h      |   18 +
 arch/arm/mach-vt8500/include/mach/timex.h       |   26 ++
 arch/arm/mach-vt8500/include/mach/uncompress.h  |   37 ++
 arch/arm/mach-vt8500/include/mach/vmalloc.h     |   20 +
 arch/arm/mach-vt8500/include/mach/vt8500fb.h    |   31 ++
 arch/arm/mach-vt8500/irq.c                      |  168 +++++++++
 arch/arm/mach-vt8500/irq_defs.c                 |  173 +++++++++
 arch/arm/mach-vt8500/mmio_regs.c                |  118 +++++++
 arch/arm/mach-vt8500/pwm.c                      |  254 ++++++++++++++
 arch/arm/mach-vt8500/timer.c                    |  166 +++++++++
 arch/arm/mach-vt8500/wm8505_7in.c               |   69 ++++
 31 files changed, 2364 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/compressed/head-vt8500.S
 create mode 100644 arch/arm/mach-vt8500/Kconfig
 create mode 100644 arch/arm/mach-vt8500/Makefile
 create mode 100644 arch/arm/mach-vt8500/Makefile.boot
 create mode 100644 arch/arm/mach-vt8500/bv07.c
 create mode 100644 arch/arm/mach-vt8500/devices.c
 create mode 100644 arch/arm/mach-vt8500/devices.h
 create mode 100644 arch/arm/mach-vt8500/gpio.c
 create mode 100644 arch/arm/mach-vt8500/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-vt8500/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-vt8500/include/mach/gpio.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/hardware.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/io.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/irq_defs.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/irqs.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/memory.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/mmio_regs.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/system.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/timex.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/vt8500fb.h
 create mode 100644 arch/arm/mach-vt8500/irq.c
 create mode 100644 arch/arm/mach-vt8500/irq_defs.c
 create mode 100644 arch/arm/mach-vt8500/mmio_regs.c
 create mode 100644 arch/arm/mach-vt8500/pwm.c
 create mode 100644 arch/arm/mach-vt8500/timer.c
 create mode 100644 arch/arm/mach-vt8500/wm8505_7in.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a19a526..e0724ac 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -843,6 +843,18 @@ config PLAT_SPEAR
 	help
 	  Support for ST's SPEAr platform (SPEAr3xx, SPEAr6xx and SPEAr13xx).
 
+config ARCH_VT8500
+	bool "VIA/WonderMedia 85xx"
+	select CPU_ARM926T
+	select GENERIC_GPIO
+	select ARCH_HAS_CPUFREQ
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select ARCH_REQUIRE_GPIOLIB
+	select HAVE_CLK
+	select HAVE_PWM
+	help
+	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
 endchoice
 
 #
@@ -973,6 +985,8 @@ source "arch/arm/mach-versatile/Kconfig"
 
 source "arch/arm/mach-vexpress/Kconfig"
 
+source "arch/arm/mach-vt8500/Kconfig"
+
 source "arch/arm/mach-w90x900/Kconfig"
 
 # Definitions to make life easier
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index b87aed0..b0f219a 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -189,6 +189,7 @@ machine-$(CONFIG_ARCH_U300)		:= u300
 machine-$(CONFIG_ARCH_U8500)		:= ux500
 machine-$(CONFIG_ARCH_VERSATILE)	:= versatile
 machine-$(CONFIG_ARCH_VEXPRESS)		:= vexpress
+machine-$(CONFIG_ARCH_VT8500)		:= vt8500
 machine-$(CONFIG_ARCH_W90X900)		:= w90x900
 machine-$(CONFIG_ARCH_NUC93X)		:= nuc93x
 machine-$(CONFIG_FOOTBRIDGE)		:= footbridge
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 65a7c1c..62cade4 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -29,6 +29,10 @@ ifeq ($(CONFIG_ARCH_SA1100),y)
 OBJS		+= head-sa1100.o
 endif
 
+ifeq ($(CONFIG_ARCH_VT8500),y)
+OBJS		+= head-vt8500.o
+endif
+
 ifeq ($(CONFIG_CPU_XSCALE),y)
 OBJS		+= head-xscale.o
 endif
diff --git a/arch/arm/boot/compressed/head-vt8500.S b/arch/arm/boot/compressed/head-vt8500.S
new file mode 100644
index 0000000..1dc1e21
--- /dev/null
+++ b/arch/arm/boot/compressed/head-vt8500.S
@@ -0,0 +1,46 @@
+/*
+ * linux/arch/arm/boot/compressed/head-vt8500.S
+ *
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * VIA VT8500 specific tweaks. This is merged into head.S by the linker.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/mach-types.h>
+
+		.section        ".start", "ax"
+
+__VT8500_start:
+	@ Compare the SCC ID register against a list of known values
+	ldr	r1, .SCCID
+	ldr	r3, [r1]
+
+	@ VT8500 override
+	ldr	r4, .VT8500SCC
+	cmp	r3, r4
+	ldreq	r7, .ID_BV07
+	beq	.Lendvt8500
+
+	@ WM8505 override
+	ldr	r4, .WM8505SCC
+	cmp	r3, r4
+	ldreq	r7, .ID_8505
+	beq	.Lendvt8500
+
+	@ Otherwise, leave the bootloader's machine id untouched
+
+.SCCID:
+	.word	0xd8120000
+.VT8500SCC:
+	.word	0x34000102
+.WM8505SCC:
+	.word	0x34260103
+
+.ID_BV07:
+	.word	MACH_TYPE_BV07
+.ID_8505:
+	.word	MACH_TYPE_WM8505_7IN_NETBOOK
+
+.Lendvt8500:
diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
new file mode 100644
index 0000000..e0c6268
--- /dev/null
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -0,0 +1,65 @@
+if ARCH_VT8500
+
+config VTWM_VERSION_VT8500
+	bool
+	default n
+
+config VTWM_VERSION_WM8505
+	bool
+	default n
+
+config MACH_BV07
+	bool "Benign BV07-8500 Mini Netbook"
+	depends on ARCH_VT8500
+	select VTWM_VERSION_VT8500
+	help
+	  Add support for the inexpensive 7-inch netbooks sold by many
+	  Chinese distributors under various names. Note that there are
+	  many hardware implementations in identical exterior, make sure
+	  that yours is indeed based on a VIA VT8500 chip.
+
+config MACH_WM8505_7IN_NETBOOK
+	bool "WM8505 7-inch generic netbook"
+	depends on ARCH_VT8500
+	select VTWM_VERSION_WM8505
+	help
+	  Add support for the inexpensive 7-inch netbooks sold by many
+	  Chinese distributors under various names. Note that there are
+	  many hardware implementations in identical exterior, make sure
+	  that yours is indeed based on a WonderMedia WM8505 chip.
+
+comment "LCD panel size"
+
+config WMT_PANEL_800X480
+	bool "7-inch with 800x480 resolution"
+	depends on (FB_VT8500 || FB_WM8505)
+	default y
+	help
+	  These are found in most of the netbooks in generic cases, as
+	  well as in Eken M001 tablets and possibly elsewhere.
+
+	  To select this panel at runtime, say y here and append
+	  'panel=800x480' to your kernel command line. Otherwise, the
+	  largest one available will be used.
+
+config WMT_PANEL_800X600
+	bool "8-inch with 800x600 resolution"
+	depends on (FB_VT8500 || FB_WM8505)
+	help
+	  These are found in Eken M003 tablets and possibly elsewhere.
+
+	  To select this panel at runtime, say y here and append
+	  'panel=800x600' to your kernel command line. Otherwise, the
+	  largest one available will be used.
+
+config WMT_PANEL_1024X600
+	bool "10-inch with 1024x600 resolution"
+	depends on (FB_VT8500 || FB_WM8505)
+	help
+	  These are found in Eken M006 tablets and possibly elsewhere.
+
+	  To select this panel at runtime, say y here and append
+	  'panel=1024x600' to your kernel command line. Otherwise, the
+	  largest one available will be used.
+
+endif
diff --git a/arch/arm/mach-vt8500/Makefile b/arch/arm/mach-vt8500/Makefile
new file mode 100644
index 0000000..aff4159
--- /dev/null
+++ b/arch/arm/mach-vt8500/Makefile
@@ -0,0 +1,6 @@
+obj-y += devices.o gpio.o irq.o irq_defs.o mmio_regs.o timer.o
+
+obj-$(CONFIG_MACH_BV07) += bv07.o
+obj-$(CONFIG_MACH_WM8505_7IN_NETBOOK) += wm8505_7in.o
+
+obj-$(CONFIG_HAVE_PWM) += pwm.o
diff --git a/arch/arm/mach-vt8500/Makefile.boot b/arch/arm/mach-vt8500/Makefile.boot
new file mode 100644
index 0000000..a8acc4e
--- /dev/null
+++ b/arch/arm/mach-vt8500/Makefile.boot
@@ -0,0 +1,3 @@
+   zreladdr-y	:= 0x00008000
+params_phys-y	:= 0x00000100
+initrd_phys-y	:= 0x01000000
diff --git a/arch/arm/mach-vt8500/bv07.c b/arch/arm/mach-vt8500/bv07.c
new file mode 100644
index 0000000..83c1542
--- /dev/null
+++ b/arch/arm/mach-vt8500/bv07.c
@@ -0,0 +1,70 @@
+/*
+ *  arch/arm/mach-vt8500/bv07.c
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <linux/io.h>
+#include <linux/pm.h>
+
+#include <mach/mmio_regs.h>
+#include <mach/irq_defs.h>
+#include "devices.h"
+
+static void __iomem *pmc_hiber;
+
+static struct platform_device *devices[] __initdata = {
+	&vt8500_device_uart0,
+	&vt8500_device_lcdc,
+	&vt8500_device_ehci,
+	&vt8500_device_ge_rops,
+	&vt8500_device_pwm,
+	&vt8500_device_pwmbl,
+	&vt8500_device_rtc,
+};
+
+static void vt8500_power_off(void)
+{
+	local_irq_disable();
+	writew(5, pmc_hiber);
+	asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
+}
+
+void __init bv07_init(void)
+{
+#ifdef CONFIG_FB_VT8500
+	void __iomem *gpio_mux_reg = ioremap(wmt_current_regs->gpio
+					     + 0x200, 4);
+
+	writel(readl(gpio_mux_reg) | 1, gpio_mux_reg);
+	iounmap(gpio_mux_reg);
+#endif
+	pmc_hiber = ioremap(wmt_current_regs->pmc + 0x12, 2);
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+	vt8500_gpio_init();
+	pm_power_off = &vt8500_power_off;
+}
+
+MACHINE_START(BV07, "Benign BV07 Mini Netbook")
+	.boot_params	= 0x00000100,
+	.map_io		= vt8500_map_io,
+	.init_irq	= vt8500_init_irq,
+	.timer		= &vt8500_timer,
+	.init_machine	= bv07_init,
+MACHINE_END
diff --git a/arch/arm/mach-vt8500/devices.c b/arch/arm/mach-vt8500/devices.c
new file mode 100644
index 0000000..156cd5f
--- /dev/null
+++ b/arch/arm/mach-vt8500/devices.c
@@ -0,0 +1,429 @@
+/* linux/arch/arm/mach-vt8500/devices.c
+ *
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/pwm_backlight.h>
+#include <linux/memblock.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include <mach/mmio_regs.h>
+#include <mach/irq_defs.h>
+#include <mach/vt8500fb.h>
+#include "devices.h"
+
+static struct resource resources_lcdc[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static u64 fb_dma_mask = DMA_BIT_MASK(32);
+
+struct platform_device vt8500_device_lcdc = {
+	.name           = "vt8500-lcd",
+	.id             = 0,
+	.dev		= {
+		.dma_mask	= &fb_dma_mask,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
+	},
+	.num_resources  = ARRAY_SIZE(resources_lcdc),
+	.resource       = resources_lcdc,
+};
+
+static struct resource resources_wm8505_fb[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+struct platform_device vt8500_device_wm8505_fb = {
+	.name           = "wm8505-fb",
+	.id             = 0,
+	.num_resources  = ARRAY_SIZE(resources_wm8505_fb),
+	.resource       = resources_wm8505_fb,
+};
+
+/* Smallest to largest */
+static struct vt8500fb_platform_data panels[] = {
+#ifdef CONFIG_WMT_PANEL_800X480
+{
+	.xres_virtual	= 800,
+	.yres_virtual	= 480 * 2,
+	.mode		= {
+		.name		= "800x480",
+		.xres		= 800,
+		.yres		= 480,
+		.left_margin	= 88,
+		.right_margin	= 40,
+		.upper_margin	= 32,
+		.lower_margin	= 11,
+		.hsync_len	= 0,
+		.vsync_len	= 0,
+		.vmode		= FB_VMODE_NONINTERLACED,
+	},
+},
+#endif
+#ifdef CONFIG_WMT_PANEL_800X600
+{
+	.xres_virtual	= 800,
+	.yres_virtual	= 600 * 2,
+	.mode		= {
+		.name		= "800x600",
+		.xres		= 800,
+		.yres		= 600,
+		.left_margin	= 88,
+		.right_margin	= 40,
+		.upper_margin	= 32,
+		.lower_margin	= 11,
+		.hsync_len	= 0,
+		.vsync_len	= 0,
+		.vmode		= FB_VMODE_NONINTERLACED,
+	},
+},
+#endif
+#ifdef CONFIG_WMT_PANEL_1024X600
+{
+	.xres_virtual	= 1024,
+	.yres_virtual	= 600 * 2,
+	.mode		= {
+		.name		= "1024x600",
+		.xres		= 1024,
+		.yres		= 600,
+		.left_margin	= 43,
+		.right_margin	= 2,
+		.upper_margin	= 10,
+		.lower_margin	= 2,
+		.hsync_len	= 23,
+		.vsync_len	= 8,
+		.vmode		= FB_VMODE_NONINTERLACED,
+	},
+},
+#endif
+};
+
+static int current_panel_idx __initdata = ARRAY_SIZE(panels) - 1;
+
+static int __init panel_setup(char *str)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(panels); i++) {
+		int len = strlen(panels[i].mode.name);
+
+		if (memcmp(panels[i].mode.name, str, len) == 0) {
+			current_panel_idx = i;
+			break;
+		}
+	}
+	return 0;
+}
+
+early_param("panel", panel_setup);
+
+static inline void preallocate_fb(struct vt8500fb_platform_data *p,
+				  unsigned long align) {
+	p->video_mem_len = (p->xres_virtual * p->yres_virtual * 4) >>
+			(p->bpp > 16 ? 0 : (p->bpp > 8 ? 1 :
+					(8 / p->bpp) + 1));
+	p->video_mem_phys = (unsigned long)memblock_alloc(p->video_mem_len,
+							  align);
+	p->video_mem_virt = phys_to_virt(p->video_mem_phys);
+}
+
+static struct resource resources_uart0[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource resources_uart1[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource resources_uart2[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource resources_uart3[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource resources_uart4[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource resources_uart5[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device vt8500_device_uart0 = {
+	.name		= "vt8500_serial",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(resources_uart0),
+	.resource	= resources_uart0,
+};
+
+struct platform_device vt8500_device_uart1 = {
+	.name		= "vt8500_serial",
+	.id		= 1,
+	.num_resources	= ARRAY_SIZE(resources_uart1),
+	.resource	= resources_uart1,
+};
+
+struct platform_device vt8500_device_uart2 = {
+	.name		= "vt8500_serial",
+	.id		= 2,
+	.num_resources	= ARRAY_SIZE(resources_uart2),
+	.resource	= resources_uart2,
+};
+
+struct platform_device vt8500_device_uart3 = {
+	.name		= "vt8500_serial",
+	.id		= 3,
+	.num_resources	= ARRAY_SIZE(resources_uart3),
+	.resource	= resources_uart3,
+};
+
+struct platform_device vt8500_device_uart4 = {
+	.name		= "vt8500_serial",
+	.id		= 4,
+	.num_resources	= ARRAY_SIZE(resources_uart4),
+	.resource	= resources_uart4,
+};
+
+struct platform_device vt8500_device_uart5 = {
+	.name		= "vt8500_serial",
+	.id		= 5,
+	.num_resources	= ARRAY_SIZE(resources_uart5),
+	.resource	= resources_uart5,
+};
+
+static struct resource resources_ehci[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static u64 ehci_dma_mask = DMA_BIT_MASK(32);
+
+struct platform_device vt8500_device_ehci = {
+	.name		= "vt8500-ehci",
+	.id		= 0,
+	.dev		= {
+		.dma_mask	= &ehci_dma_mask,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
+	},
+	.num_resources	= ARRAY_SIZE(resources_ehci),
+	.resource	= resources_ehci,
+};
+
+static struct resource resources_ge_rops[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+struct platform_device vt8500_device_ge_rops = {
+	.name		= "wmt_ge_rops",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(resources_ge_rops),
+	.resource	= resources_ge_rops,
+};
+
+static struct resource resources_pwm[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+struct platform_device vt8500_device_pwm = {
+	.name		= "vt8500-pwm",
+	.id		= 0,
+	.resource	= resources_pwm,
+	.num_resources	= ARRAY_SIZE(resources_pwm),
+};
+
+static struct platform_pwm_backlight_data vt8500_pwmbl_data = {
+	.pwm_id		= 0,
+	.max_brightness	= 128,
+	.dft_brightness = 70,
+	.pwm_period_ns	= 250000, /* revisit when clocks are implemented */
+};
+
+struct platform_device vt8500_device_pwmbl = {
+	.name		= "pwm-backlight",
+	.id		= 0,
+	.dev		= {
+		.platform_data = &vt8500_pwmbl_data,
+	},
+};
+
+static struct resource resources_rtc[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+	[2] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device vt8500_device_rtc = {
+	.name		= "vt8500-rtc",
+	.id		= 0,
+	.resource	= resources_rtc,
+	.num_resources	= ARRAY_SIZE(resources_rtc),
+};
+
+static struct map_desc vt8500_io_desc[] __initdata = {
+	/* SoC MMIO registers, to be filled in later */
+	[0] = {
+		.type		= MT_DEVICE
+	},
+	/* PCI I/O space, numbers tied to those in <mach/io.h> */
+	[1] = {
+		.virtual	= 0xf0000000,
+		.pfn		= __phys_to_pfn(0xc0000000),
+		.length		= SZ_64K,
+		.type		= MT_DEVICE
+	},
+};
+
+static inline void set_data(void)
+{
+	vt8500_io_desc[0].virtual = wmt_current_regs->mmio_regs_virt;
+	vt8500_io_desc[0].pfn =
+			__phys_to_pfn(wmt_current_regs->mmio_regs_start);
+	vt8500_io_desc[0].length = wmt_current_regs->mmio_regs_length;
+
+	resources_lcdc[0].start = wmt_current_regs->lcdc;
+	resources_lcdc[0].end = wmt_current_regs->lcdc + SZ_1K - 1;
+	resources_lcdc[1].start = wmt_current_irqs->lcdc;
+	resources_lcdc[1].end = wmt_current_irqs->lcdc;
+
+	resources_wm8505_fb[0].start = wmt_current_regs->govr;
+	resources_wm8505_fb[0].end = wmt_current_regs->govr + 512 - 1;
+
+	resources_uart0[0].start = wmt_current_regs->uart0;
+	resources_uart0[0].end = wmt_current_regs->uart0 + 0x103f;
+	resources_uart0[1].start = wmt_current_irqs->uart0;
+	resources_uart0[1].end = wmt_current_irqs->uart0;
+	resources_uart1[0].start = wmt_current_regs->uart1;
+	resources_uart1[0].end = wmt_current_regs->uart1 + 0x103f;
+	resources_uart1[1].start = wmt_current_irqs->uart1;
+	resources_uart1[1].end = wmt_current_irqs->uart1;
+	resources_uart2[0].start = wmt_current_regs->uart2;
+	resources_uart2[0].end = wmt_current_regs->uart2 + 0x103f;
+	resources_uart2[1].start = wmt_current_irqs->uart2;
+	resources_uart2[1].end = wmt_current_irqs->uart2;
+	resources_uart3[0].start = wmt_current_regs->uart3;
+	resources_uart3[0].end = wmt_current_regs->uart3 + 0x103f;
+	resources_uart3[1].start = wmt_current_irqs->uart3;
+	resources_uart3[1].end = wmt_current_irqs->uart3;
+	resources_uart4[0].start = wmt_current_regs->uart4;
+	resources_uart4[0].end = wmt_current_regs->uart4 + 0x103f;
+	resources_uart4[1].start = wmt_current_irqs->uart4;
+	resources_uart4[1].end = wmt_current_irqs->uart4;
+	resources_uart5[0].start = wmt_current_regs->uart5;
+	resources_uart5[0].end = wmt_current_regs->uart5 + 0x103f;
+	resources_uart5[1].start = wmt_current_irqs->uart5;
+	resources_uart5[1].end = wmt_current_irqs->uart5;
+
+	resources_ehci[0].start = wmt_current_regs->ehci;
+	resources_ehci[0].end = wmt_current_regs->ehci + 512 - 1;
+	resources_ehci[1].start = wmt_current_irqs->ehci;
+	resources_ehci[1].end = wmt_current_irqs->ehci;
+
+	resources_ge_rops[0].start = wmt_current_regs->ge;
+	resources_ge_rops[0].end = wmt_current_regs->ge + 0xff;
+
+	resources_pwm[0].start = wmt_current_regs->pwm;
+	resources_pwm[0].end = wmt_current_regs->pwm + 0x43;
+
+	resources_rtc[0].start = wmt_current_regs->rtc;
+	resources_rtc[0].end = wmt_current_regs->rtc + 0x2c - 1;
+	resources_rtc[1].start = wmt_current_irqs->rtc;
+	resources_rtc[1].end = wmt_current_irqs->rtc;
+	resources_rtc[2].start = wmt_current_irqs->rtc_hz;
+	resources_rtc[2].end = wmt_current_irqs->rtc_hz;
+}
+
+void __init vt8500_map_io(void)
+{
+	wmt_current_regs = &wmt_regmaps[VT8500_INDEX];
+	wmt_current_irqs = &wmt_irqs[VT8500_INDEX];
+	set_data();
+#ifdef CONFIG_FB_VT8500
+	panels[current_panel_idx].bpp = 16; /* Always use RGB565 */
+	preallocate_fb(&panels[current_panel_idx], SZ_4M);
+	vt8500_device_lcdc.dev.platform_data = &panels[current_panel_idx];
+#endif
+	iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
+}
+
+void __init wm8505_map_io(void)
+{
+	wmt_current_regs = &wmt_regmaps[WM8505_INDEX];
+	wmt_current_irqs = &wmt_irqs[WM8505_INDEX];
+	set_data();
+#ifdef CONFIG_FB_WM8505
+	panels[current_panel_idx].bpp = 32; /* Always use RGB888 */
+	preallocate_fb(&panels[current_panel_idx], 32);
+	vt8500_device_wm8505_fb.dev.platform_data = &panels[current_panel_idx];
+#endif
+	iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
+}
diff --git a/arch/arm/mach-vt8500/devices.h b/arch/arm/mach-vt8500/devices.h
new file mode 100644
index 0000000..dacaf77
--- /dev/null
+++ b/arch/arm/mach-vt8500/devices.h
@@ -0,0 +1,43 @@
+/* linux/arch/arm/mach-vt8500/devices.h
+ *
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ARCH_ARM_MACH_VT8500_DEVICES_H
+#define __ARCH_ARM_MACH_VT8500_DEVICES_H
+
+#include <linux/platform_device.h>
+
+void __init vt8500_init_irq(void);
+void __init wm8505_init_irq(void);
+void __init vt8500_map_io(void);
+void __init wm8505_map_io(void);
+void __init vt8500_gpio_init(void);
+
+extern struct sys_timer vt8500_timer;
+
+extern struct platform_device vt8500_device_uart0;
+extern struct platform_device vt8500_device_uart1;
+extern struct platform_device vt8500_device_uart2;
+extern struct platform_device vt8500_device_uart3;
+extern struct platform_device vt8500_device_uart4;
+extern struct platform_device vt8500_device_uart5;
+
+extern struct platform_device vt8500_device_lcdc;
+extern struct platform_device vt8500_device_wm8505_fb;
+extern struct platform_device vt8500_device_ehci;
+extern struct platform_device vt8500_device_ge_rops;
+extern struct platform_device vt8500_device_pwm;
+extern struct platform_device vt8500_device_pwmbl;
+extern struct platform_device vt8500_device_rtc;
+#endif
diff --git a/arch/arm/mach-vt8500/gpio.c b/arch/arm/mach-vt8500/gpio.c
new file mode 100644
index 0000000..f533ff0
--- /dev/null
+++ b/arch/arm/mach-vt8500/gpio.c
@@ -0,0 +1,230 @@
+/* linux/arch/arm/mach-vt8500/gpio.c
+ *
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+
+#include <mach/gpio.h>
+#include <mach/mmio_regs.h>
+#include <mach/irq_defs.h>
+
+#define to_vt8500(__chip) container_of(__chip, struct vt8500_gpio_chip, chip)
+
+static void __iomem *regbase;
+
+struct vt8500_gpio_chip {
+	struct gpio_chip	chip;
+	unsigned int		shift;
+	unsigned int		regoff;
+};
+
+static int gpio_to_irq_map[8];
+
+static int vt8500_muxed_gpio_request(struct gpio_chip *chip,
+				     unsigned offset)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	writel(readl(regbase + vt8500_chip->regoff) |
+		(1 << vt8500_chip->shift << offset),
+		regbase + vt8500_chip->regoff);
+
+	return 0;
+}
+
+static void vt8500_muxed_gpio_free(struct gpio_chip *chip,
+				   unsigned offset)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	writel(readl(regbase + vt8500_chip->regoff) &
+		~(1 << vt8500_chip->shift << offset),
+		regbase + vt8500_chip->regoff);
+}
+
+static int vt8500_muxed_gpio_direction_input(struct gpio_chip *chip,
+				       unsigned offset)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	writel(readl(regbase + 0x20 + vt8500_chip->regoff) &
+		~(1 << vt8500_chip->shift << offset),
+		regbase + 0x20 + vt8500_chip->regoff);
+
+	return 0;
+}
+
+static int vt8500_muxed_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	writel(readl(regbase + 0x20 + vt8500_chip->regoff) |
+		(1 << vt8500_chip->shift << offset),
+		regbase + 0x20 + vt8500_chip->regoff);
+
+	if (value)
+		writel(readl(regbase + 0x40 + vt8500_chip->regoff) |
+			(1 << vt8500_chip->shift << offset),
+			regbase + 0x40 + vt8500_chip->regoff);
+	return 0;
+}
+
+static int vt8500_muxed_gpio_get_value(struct gpio_chip *chip,
+				       unsigned offset)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	return (readl(regbase + 0x60 + vt8500_chip->regoff)
+		>> vt8500_chip->shift >> offset) & 1;
+}
+
+static void vt8500_muxed_gpio_set_value(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	if (value)
+		writel(readl(regbase + 0x40 + vt8500_chip->regoff) |
+			(1 << vt8500_chip->shift << offset),
+			regbase + 0x40 + vt8500_chip->regoff);
+	else
+		writel(readl(regbase + 0x40 + vt8500_chip->regoff) &
+			~(1 << vt8500_chip->shift << offset),
+			regbase + 0x40 + vt8500_chip->regoff);
+}
+
+#define VT8500_GPIO_BANK(__name, __shift, __off, __base, __num)		\
+{									\
+	.chip = {							\
+		.label			= __name,			\
+		.request		= vt8500_muxed_gpio_request,	\
+		.free			= vt8500_muxed_gpio_free,	\
+		.direction_input  = vt8500_muxed_gpio_direction_input,	\
+		.direction_output = vt8500_muxed_gpio_direction_output,	\
+		.get			= vt8500_muxed_gpio_get_value,	\
+		.set			= vt8500_muxed_gpio_set_value,	\
+		.can_sleep		= 0,				\
+		.base			= __base,			\
+		.ngpio			= __num,			\
+	},								\
+	.shift		= __shift,					\
+	.regoff		= __off,					\
+}
+
+static struct vt8500_gpio_chip vt8500_muxed_gpios[] = {
+	VT8500_GPIO_BANK("uart0", 0, 0x0, 8, 4),
+	VT8500_GPIO_BANK("uart1", 4, 0x0, 12, 4),
+	VT8500_GPIO_BANK("spi0", 8, 0x0, 16, 4),
+	VT8500_GPIO_BANK("spi1", 12, 0x0, 20, 4),
+	VT8500_GPIO_BANK("spi2", 16, 0x0, 24, 4),
+	VT8500_GPIO_BANK("pwmout", 24, 0x0, 28, 2),
+
+	VT8500_GPIO_BANK("sdmmc", 0, 0x4, 30, 11),
+	VT8500_GPIO_BANK("ms", 16, 0x4, 41, 7),
+	VT8500_GPIO_BANK("i2c0", 24, 0x4, 48, 2),
+	VT8500_GPIO_BANK("i2c1", 26, 0x4, 50, 2),
+
+	VT8500_GPIO_BANK("mii", 0, 0x8, 52, 20),
+	VT8500_GPIO_BANK("see", 20, 0x8, 72, 4),
+	VT8500_GPIO_BANK("ide", 24, 0x8, 76, 7),
+
+	VT8500_GPIO_BANK("ccir", 0, 0xc, 83, 19),
+
+	VT8500_GPIO_BANK("ts", 8, 0x10, 102, 11),
+
+	VT8500_GPIO_BANK("lcd", 0, 0x14, 113, 23),
+};
+
+static int vt8500_gpio_direction_input(struct gpio_chip *chip,
+				       unsigned offset)
+{
+	writel(readl(regbase + 0x3c) & ~(1 << offset), regbase + 0x3c);
+	return 0;
+}
+
+static int vt8500_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	writel(readl(regbase + 0x3c) | (1 << offset), regbase + 0x3c);
+
+	if (value)
+		writel(readl(regbase + 0x5c) | (1 << offset),
+		       regbase + 0x5c);
+	return 0;
+}
+
+static int vt8500_gpio_get_value(struct gpio_chip *chip,
+				       unsigned offset)
+{
+	return (readl(regbase + 0x7c) >> offset) & 1;
+}
+
+static void vt8500_gpio_set_value(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	if (value)
+		writel(readl(regbase + 0x5c) | (1 << offset),
+		       regbase + 0x5c);
+	else
+		writel(readl(regbase + 0x5c) & ~(1 << offset),
+			regbase + 0x5c);
+}
+
+static int vt8500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	if (offset > 7)
+		return -EINVAL;
+
+	return gpio_to_irq_map[offset];
+}
+
+static struct gpio_chip vt8500_external_gpios = {
+	.label			= "extgpio",
+	.direction_input	= vt8500_gpio_direction_input,
+	.direction_output	= vt8500_gpio_direction_output,
+	.get			= vt8500_gpio_get_value,
+	.set			= vt8500_gpio_set_value,
+	.to_irq			= vt8500_gpio_to_irq,
+	.can_sleep		= 0,
+	.base			= 0,
+	.ngpio			= 8,
+};
+
+void __init vt8500_gpio_init(void)
+{
+	int i;
+
+	gpio_to_irq_map[0] = wmt_current_irqs->ext0;
+	gpio_to_irq_map[1] = wmt_current_irqs->ext1;
+	gpio_to_irq_map[2] = wmt_current_irqs->ext2;
+	gpio_to_irq_map[3] = wmt_current_irqs->ext3;
+	gpio_to_irq_map[4] = wmt_current_irqs->ext4;
+	gpio_to_irq_map[5] = wmt_current_irqs->ext5;
+	gpio_to_irq_map[6] = wmt_current_irqs->ext6;
+	gpio_to_irq_map[7] = wmt_current_irqs->ext7;
+
+	regbase = ioremap(wmt_current_regs->gpio, SZ_64K);
+	if (!regbase) {
+		printk(KERN_ERR "Failed to map MMIO registers for GPIO\n");
+		return;
+	}
+
+	gpiochip_add(&vt8500_external_gpios);
+
+	for (i = 0; i < ARRAY_SIZE(vt8500_muxed_gpios); i++)
+		gpiochip_add(&vt8500_muxed_gpios[i].chip);
+}
diff --git a/arch/arm/mach-vt8500/include/mach/debug-macro.S b/arch/arm/mach-vt8500/include/mach/debug-macro.S
new file mode 100644
index 0000000..f119162
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/debug-macro.S
@@ -0,0 +1,31 @@
+/*
+ * arch/arm/mach-vt8500/include/mach/debug-macro.S
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * Debugging macro include header
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+	.macro	addruart, rp, rv
+	mov	\rp,      #0x00200000
+	orr	\rv, \rp, #0xf8000000
+	orr	\rp, \rp, #0xd8000000
+	.endm
+
+	.macro	senduart,rd,rx
+	strb	\rd, [\rx, #0]
+	.endm
+
+	.macro	busyuart,rd,rx
+1001:	ldr	\rd, [\rx, #0x1c]
+	ands	\rd, \rd, #0x2
+	bne	1001b
+	.endm
+
+	.macro	waituart,rd,rx
+	.endm
diff --git a/arch/arm/mach-vt8500/include/mach/entry-macro.S b/arch/arm/mach-vt8500/include/mach/entry-macro.S
new file mode 100644
index 0000000..92684c7
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/entry-macro.S
@@ -0,0 +1,32 @@
+/*
+ * arch/arm/mach-vt8500/include/mach/entry-macro.S
+ *
+ * Low-level IRQ helper macros for VIA VT8500
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+	.macro	disable_fiq
+	.endm
+
+	.macro  get_irqnr_preamble, base, tmp
+	@ physical 0xd8140000 is virtual 0xf8140000
+	mov	\base, #0xf8000000
+	orr	\base, \base, #0x00140000
+	.endm
+
+	.macro  arch_ret_to_user, tmp1, tmp2
+	.endm
+
+	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
+	ldr	\irqnr, [\base]
+	cmp	\irqnr, #63 @ may be false positive, check interrupt status
+	bne	1001f
+	ldr	\irqstat, [\base, #0x84]
+	ands	\irqstat, #0x80000000
+	moveq	\irqnr, #0
+1001:
+	.endm
+
diff --git a/arch/arm/mach-vt8500/include/mach/gpio.h b/arch/arm/mach-vt8500/include/mach/gpio.h
new file mode 100644
index 0000000..94ff276
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/gpio.h
@@ -0,0 +1,6 @@
+#include <asm-generic/gpio.h>
+
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
+#define gpio_to_irq	__gpio_to_irq
diff --git a/arch/arm/mach-vt8500/include/mach/hardware.h b/arch/arm/mach-vt8500/include/mach/hardware.h
new file mode 100644
index 0000000..db4163f
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/hardware.h
@@ -0,0 +1,12 @@
+/* arch/arm/mach-vt8500/include/mach/hardware.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
diff --git a/arch/arm/mach-vt8500/include/mach/io.h b/arch/arm/mach-vt8500/include/mach/io.h
new file mode 100644
index 0000000..8dd55c8
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/io.h
@@ -0,0 +1,28 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/io.h
+ *
+ *  Copyright (C) 2010 Alexey Charkov
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
+#ifndef __ASM_ARM_ARCH_IO_H
+#define __ASM_ARM_ARCH_IO_H
+
+#define IO_SPACE_LIMIT 0xffff
+
+#define __io(a)		((void __iomem *)((a) + 0xf0000000))
+#define __mem_pci(a)	(a)
+
+#endif
diff --git a/arch/arm/mach-vt8500/include/mach/irq_defs.h b/arch/arm/mach-vt8500/include/mach/irq_defs.h
new file mode 100644
index 0000000..fa8f4b3
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/irq_defs.h
@@ -0,0 +1,124 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/irq_defs.h
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
+#ifndef VT8500_IRQ_DEFS_H
+#define VT8500_IRQ_DEFS_H
+
+#include <linux/types.h>
+
+struct wmt_irq_srcs {
+	u8 nr_irqs;
+	u8 jpegenc;
+	u8 jpegdec;
+	u8 pata;
+	u8 dma;
+	u8 ext0;
+	u8 ext1;
+	u8 ext2;
+	u8 ext3;
+	u8 ext4;
+	u8 ext5;
+	u8 ext6;
+	u8 ext7;
+	u8 ether;
+	u8 mpegts;
+	u8 ge;
+	u8 gov;
+	u8 lcdc;
+	u8 lcdf;
+	u8 vpp;
+	u8 vpu;
+	u8 vid;
+	u8 spu;
+	u8 pip;
+	u8 dvo;
+	u8 govw;
+	u8 govrsdscd;
+	u8 govrsdmif;
+	u8 govrhdscd;
+	u8 govrhdmif;
+	u8 cipher;
+	u8 i2c0;
+	u8 i2c1;
+	u8 sdmmc;
+	u8 sdmmc_dma;
+	u8 pmc_wu;
+	u8 spi0;
+	u8 spi1;
+	u8 spi2;
+	u8 nand;
+	u8 nand_dma;
+	u8 nor;
+	u8 memstick;
+	u8 memstick_dma;
+	u8 uart0;
+	u8 uart1;
+	u8 uart2;
+	u8 uart3;
+	u8 uart4;
+	u8 uart5;
+	u8 i2s;
+	u8 pcm;
+	u8 ac97;
+	u8 timer_match0;
+	u8 timer_match1;
+	u8 timer_match2;
+	u8 timer_match3;
+	u8 ehci;
+	u8 uhci;
+	u8 udc;
+	u8 udc_dma;
+	u8 keypad;
+	u8 ps2mouse;
+	u8 ps2kbd;
+	u8 rtc;
+	u8 rtc_hz;
+	u8 adc;
+	u8 cir;
+	u8 dma0;
+	u8 dma1;
+	u8 dma2;
+	u8 dma3;
+	u8 dma4;
+	u8 dma5;
+	u8 dma6;
+	u8 dma7;
+	u8 dma8;
+	u8 dma9;
+	u8 dma10;
+	u8 dma11;
+	u8 dma12;
+	u8 dma13;
+	u8 dma14;
+	u8 dma15;
+	u8 irq0;
+	u8 irq1;
+	u8 irq2;
+	u8 irq3;
+	u8 irq4;
+	u8 irq5;
+	u8 irq6;
+	u8 irq7;
+	u8 sae;
+};
+
+extern struct wmt_irq_srcs wmt_irqs[] __initdata;
+extern struct wmt_irq_srcs *wmt_current_irqs __initdata;
+
+#endif
diff --git a/arch/arm/mach-vt8500/include/mach/irqs.h b/arch/arm/mach-vt8500/include/mach/irqs.h
new file mode 100644
index 0000000..a129fd1
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/irqs.h
@@ -0,0 +1,22 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/irqs.h
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
+/* This value is just to make the core happy, never used otherwise */
+#define NR_IRQS 128
diff --git a/arch/arm/mach-vt8500/include/mach/memory.h b/arch/arm/mach-vt8500/include/mach/memory.h
new file mode 100644
index 0000000..175f914
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/memory.h
@@ -0,0 +1,28 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/memory.h
+ *
+ *  Copyright (C) 2003 ARM Limited
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
+#ifndef __ASM_ARCH_MEMORY_H
+#define __ASM_ARCH_MEMORY_H
+
+/*
+ * Physical DRAM offset.
+ */
+#define PHYS_OFFSET	UL(0x00000000)
+
+#endif
diff --git a/arch/arm/mach-vt8500/include/mach/mmio_regs.h b/arch/arm/mach-vt8500/include/mach/mmio_regs.h
new file mode 100644
index 0000000..76439dd
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/mmio_regs.h
@@ -0,0 +1,90 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/mmio_regs.h
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
+#ifndef __ASM_ARM_ARCH_MMIO_REGS_H
+#define __ASM_ARM_ARCH_MMIO_REGS_H
+
+#include <linux/init.h>
+
+struct wmt_mmio_regs {
+	unsigned long mmio_regs_start;
+	unsigned long mmio_regs_length;
+	unsigned long mmio_regs_virt;
+	unsigned long ddr;
+	unsigned long dma;
+	unsigned long vdma;
+	unsigned long sflash;
+	unsigned long ether;
+	unsigned long cipher;
+	unsigned long ehci;
+	unsigned long uhci;
+	unsigned long pata;
+	unsigned long ps2;
+	unsigned long nand;
+	unsigned long nor;
+	unsigned long sdmmc;
+	unsigned long memstick;
+	unsigned long lcdc;
+	unsigned long vpu;
+	unsigned long gov;
+	unsigned long ge;
+	unsigned long govr;
+	unsigned long scl;
+	unsigned long lcdf;
+	unsigned long vid;
+	unsigned long vpp;
+	unsigned long tsbk;
+	unsigned long jpegdec;
+	unsigned long jpegenc;
+	unsigned long rtc;
+	unsigned long gpio;
+	unsigned long scc;
+	unsigned long pmc;
+	unsigned long ic0;
+	unsigned long ic1;
+	unsigned long uart0;
+	unsigned long uart1;
+	unsigned long uart2;
+	unsigned long uart3;
+	unsigned long uart4;
+	unsigned long uart5;
+	unsigned long pwm;
+	unsigned long spi0;
+	unsigned long spi1;
+	unsigned long spi2;
+	unsigned long cir;
+	unsigned long i2c0;
+	unsigned long i2c1;
+	unsigned long ac97;
+	unsigned long pcm;
+	unsigned long i2s;
+	unsigned long adc;
+	unsigned long keypad;
+};
+
+enum {
+	VT8500_INDEX,
+	WM8505_INDEX,
+};
+
+extern struct wmt_mmio_regs wmt_regmaps[] __initdata;
+extern struct wmt_mmio_regs *wmt_current_regs __initdata;
+
+#endif
+
diff --git a/arch/arm/mach-vt8500/include/mach/system.h b/arch/arm/mach-vt8500/include/mach/system.h
new file mode 100644
index 0000000..ba4cd40
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/system.h
@@ -0,0 +1,18 @@
+/*
+ * arch/arm/mach-vt8500/include/mach/system.h
+ *
+ */
+#include <asm/io.h>
+
+/* PM Software Reset request register */
+#define VT8500_PMSR	0xd8130060
+
+static inline void arch_idle(void)
+{
+	cpu_do_idle();
+}
+
+static inline void arch_reset(char mode, const char *cmd)
+{
+	writel(1, ioremap(VT8500_PMSR, 4));
+}
diff --git a/arch/arm/mach-vt8500/include/mach/timex.h b/arch/arm/mach-vt8500/include/mach/timex.h
new file mode 100644
index 0000000..8487e4c
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/timex.h
@@ -0,0 +1,26 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/timex.h
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
+#ifndef MACH_TIMEX_H
+#define MACH_TIMEX_H
+
+#define CLOCK_TICK_RATE		(3000000)
+
+#endif /* MACH_TIMEX_H */
diff --git a/arch/arm/mach-vt8500/include/mach/uncompress.h b/arch/arm/mach-vt8500/include/mach/uncompress.h
new file mode 100644
index 0000000..bb9e2d2
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/uncompress.h
@@ -0,0 +1,37 @@
+/* arch/arm/mach-vt8500/include/mach/uncompress.h
+ *
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * Based on arch/arm/mach-dove/include/mach/uncompress.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#define UART0_PHYS 0xd8200000
+#include <asm/io.h>
+
+static void putc(const char c)
+{
+	while (readb(UART0_PHYS + 0x1c) & 0x2)
+		/* Tx busy, wait and poll */;
+
+	writeb(c, UART0_PHYS);
+}
+
+static void flush(void)
+{
+}
+
+/*
+ * nothing to do
+ */
+#define arch_decomp_setup()
+#define arch_decomp_wdog()
diff --git a/arch/arm/mach-vt8500/include/mach/vmalloc.h b/arch/arm/mach-vt8500/include/mach/vmalloc.h
new file mode 100644
index 0000000..75a6912
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/vmalloc.h
@@ -0,0 +1,20 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/vmalloc.h
+ *
+ *  Copyright (C) 2000 Russell King.
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
+#define VMALLOC_END		(PAGE_OFFSET + 0x10000000)
diff --git a/arch/arm/mach-vt8500/include/mach/vt8500fb.h b/arch/arm/mach-vt8500/include/mach/vt8500fb.h
new file mode 100644
index 0000000..cc7f25e
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/vt8500fb.h
@@ -0,0 +1,31 @@
+/*
+ *  VT8500/WM8505 Frame Buffer platform data definitions
+ *
+ *  Copyright (C) 2010 Ed Spiridonov <edo.rus@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VT8500FB_H
+#define _VT8500FB_H
+
+#include <linux/fb.h>
+
+struct vt8500fb_platform_data {
+	struct fb_videomode	mode;
+	__u32			xres_virtual;
+	__u32			yres_virtual;
+	__u32			bpp;
+	unsigned long		video_mem_phys;
+	void			*video_mem_virt;
+	unsigned long		video_mem_len;
+};
+
+#endif /* _VT8500FB_H */
diff --git a/arch/arm/mach-vt8500/irq.c b/arch/arm/mach-vt8500/irq.c
new file mode 100644
index 0000000..085a9c6
--- /dev/null
+++ b/arch/arm/mach-vt8500/irq.c
@@ -0,0 +1,168 @@
+/*
+ *  arch/arm/mach-vt8500/irq.c
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+
+#include <asm/irq.h>
+
+#include <mach/mmio_regs.h>
+#include <mach/irq_defs.h>
+
+#define VT8500_IC_DCTR		0x40		/* Destination control
+						register, 64*u8 */
+#define VT8500_INT_ENABLE	(1 << 3)
+#define VT8500_TRIGGER_HIGH	(0 << 4)
+#define VT8500_TRIGGER_RISING	(1 << 4)
+#define VT8500_TRIGGER_FALLING	(2 << 4)
+#define VT8500_IC_STATUS	0x80		/* Interrupt status, 2*u32 */
+
+static void __iomem *ic_regbase;
+static void __iomem *sic_regbase;
+
+static void vt8500_irq_mask(unsigned int irq)
+{
+	void __iomem *base = ic_regbase;
+	u8 edge;
+	if (irq >= 64) {
+		base = sic_regbase;
+		irq -= 64;
+	}
+	edge = readb(base + VT8500_IC_DCTR + irq) & (3 << 4);
+	if (edge)
+		writel(readl(base
+			+ VT8500_IC_STATUS + (irq < 32 ? 0 : 4))
+			| (1 << (irq & 0x1f)), base
+			+ VT8500_IC_STATUS + (irq & 0x20 ? 4 : 0));
+	else
+		writeb(readb(base
+			+ VT8500_IC_DCTR + irq) & ~VT8500_INT_ENABLE,
+			base + VT8500_IC_DCTR + irq);
+}
+
+static void vt8500_irq_unmask(unsigned int irq)
+{
+	void __iomem *base = ic_regbase;
+	if (irq >= 64) {
+		base = sic_regbase;
+		irq -= 64;
+	}
+	writeb(readb(base
+		+ VT8500_IC_DCTR + irq) | VT8500_INT_ENABLE,
+		base + VT8500_IC_DCTR + irq);
+}
+
+static int vt8500_irq_set_wake(unsigned int irq, unsigned int on)
+{
+	return -EINVAL;
+}
+
+static int vt8500_irq_set_type(unsigned int irq, unsigned int flow_type)
+{
+	void __iomem *base = ic_regbase;
+	unsigned int orig_irq = irq;
+	if (irq >= 64) {
+		base = sic_regbase;
+		irq -= 64;
+	}
+	switch (flow_type) {
+	case IRQF_TRIGGER_LOW:
+		return -EINVAL;
+	case IRQF_TRIGGER_HIGH:
+		writeb((readb(base
+			+ VT8500_IC_DCTR + irq) & ~(3 << 4))
+			| VT8500_TRIGGER_HIGH, base
+			+ VT8500_IC_DCTR + irq);
+		set_irq_handler(orig_irq, handle_level_irq);
+		break;
+	case IRQF_TRIGGER_FALLING:
+		writeb((readb(base
+			+ VT8500_IC_DCTR + irq) & ~(3 << 4))
+			| VT8500_TRIGGER_FALLING, base
+			+ VT8500_IC_DCTR + irq);
+		set_irq_handler(orig_irq, handle_edge_irq);
+		break;
+	case IRQF_TRIGGER_RISING:
+		writeb((readb(base
+			+ VT8500_IC_DCTR + irq) & ~(3 << 4))
+			| VT8500_TRIGGER_RISING, base
+			+ VT8500_IC_DCTR + irq);
+		set_irq_handler(orig_irq, handle_edge_irq);
+		break;
+	}
+
+	return 0;
+}
+
+static struct irq_chip vt8500_irq_chip = {
+	.name      = "vt8500",
+	.ack       = vt8500_irq_mask,
+	.mask      = vt8500_irq_mask,
+	.unmask    = vt8500_irq_unmask,
+	.set_wake  = vt8500_irq_set_wake,
+	.set_type  = vt8500_irq_set_type,
+};
+
+void __init vt8500_init_irq(void)
+{
+	unsigned int i;
+
+	ic_regbase = ioremap(wmt_current_regs->ic0, SZ_64K);
+
+	/* Enable rotating priority for IRQ */
+	writel((1 << 6), ic_regbase + 0x20);
+	writel(0, ic_regbase + 0x24);
+
+	for (i = 0; i < wmt_current_irqs->nr_irqs; i++) {
+		/* Disable all interrupts and route them to IRQ */
+		writeb(0x00, ic_regbase + VT8500_IC_DCTR + i);
+
+		set_irq_chip(i, &vt8500_irq_chip);
+		set_irq_handler(i, handle_level_irq);
+		set_irq_flags(i, IRQF_VALID);
+	}
+}
+
+void __init wm8505_init_irq(void)
+{
+	unsigned int i;
+
+	ic_regbase = ioremap(wmt_current_regs->ic0, SZ_64K);
+	sic_regbase = ioremap(wmt_current_regs->ic1, SZ_64K);
+
+	/* Enable rotating priority for IRQ */
+	writel((1 << 6), ic_regbase + 0x20);
+	writel(0, ic_regbase + 0x24);
+	writel((1 << 6), sic_regbase + 0x20);
+	writel(0, sic_regbase + 0x24);
+
+	for (i = 0; i < wmt_current_irqs->nr_irqs; i++) {
+		/* Disable all interrupts and route them to IRQ */
+		if (i < 64)
+			writeb(0x00, ic_regbase + VT8500_IC_DCTR + i);
+		else
+			writeb(0x00, sic_regbase + VT8500_IC_DCTR + i - 64);
+
+		set_irq_chip(i, &vt8500_irq_chip);
+		set_irq_handler(i, handle_level_irq);
+		set_irq_flags(i, IRQF_VALID);
+	}
+}
diff --git a/arch/arm/mach-vt8500/irq_defs.c b/arch/arm/mach-vt8500/irq_defs.c
new file mode 100644
index 0000000..b338c04
--- /dev/null
+++ b/arch/arm/mach-vt8500/irq_defs.c
@@ -0,0 +1,173 @@
+/* linux/arch/arm/mach-vt8500/irq_defs.c
+ *
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/init.h>
+
+#include <mach/irq_defs.h>
+#include <mach/mmio_regs.h>
+
+struct wmt_irq_srcs *wmt_current_irqs __initdata;
+
+struct wmt_irq_srcs wmt_irqs[] __initdata = {
+	[VT8500_INDEX] = {
+		.jpegenc	= 0,
+		.jpegdec	= 1,
+		.pata		= 3,
+		.dma		= 5,
+		.ext0		= 6,
+		.ext1		= 7,
+		.ge		= 8,
+		.gov		= 9,
+		.ether		= 10,
+		.mpegts		= 11,
+		.lcdc		= 12,
+		.ext2		= 13,
+		.ext3		= 14,
+		.ext4		= 15,
+		.cipher		= 16,
+		.vpp		= 17,
+		.i2c1		= 18,
+		.i2c0		= 19,
+		.sdmmc		= 20,
+		.sdmmc_dma	= 21,
+		.pmc_wu		= 22,
+		.spi0		= 24,
+		.spi1		= 25,
+		.spi2		= 26,
+		.lcdf		= 27,
+		.nand		= 28,
+		.nand_dma	= 29,
+		.memstick	= 30,
+		.memstick_dma	= 31,
+		.uart0		= 32,
+		.uart1		= 33,
+		.i2s		= 34,
+		.pcm		= 35,
+		.timer_match0	= 36,
+		.timer_match1	= 37,
+		.timer_match2	= 38,
+		.timer_match3	= 39,
+		.vpu		= 40,
+		.vid		= 41,
+		.ac97		= 42,
+		.ehci		= 43,
+		.nor		= 44,
+		.ps2mouse	= 45,
+		.ps2kbd		= 46,
+		.uart2		= 47,
+		.rtc		= 48,
+		.rtc_hz		= 49,
+		.uart3		= 50,
+		.adc		= 51,
+		.ext5		= 52,
+		.ext6		= 53,
+		.ext7		= 54,
+		.cir		= 55,
+		.dma0		= 56,
+		.dma1		= 57,
+		.dma2		= 58,
+		.dma3		= 59,
+		.dma4		= 60,
+		.dma5		= 61,
+		.dma6		= 62,
+		.dma7		= 63,
+		.nr_irqs	= 64,
+	},
+	[WM8505_INDEX] = {
+		.uhci		= 0,
+		.ehci		= 1,
+		.udc_dma	= 2,
+		.ps2mouse	= 4,
+		.udc		= 5,
+		.ext0		= 6,
+		.ext1		= 7,
+		.keypad		= 8,
+		.dma		= 9,
+		.ether		= 10,
+		.ext2		= 13,
+		.ext3		= 14,
+		.ext4		= 15,
+		.dma0		= 17,
+		.i2c1		= 18,
+		.i2c0		= 19,
+		.sdmmc		= 20,
+		.sdmmc_dma	= 21,
+		.pmc_wu		= 22,
+		.ps2kbd		= 23,
+		.spi0		= 24,
+		.spi1		= 25,
+		.spi2		= 26,
+		.dma1		= 27,
+		.nand		= 28,
+		.nand_dma	= 29,
+		.uart5		= 30,
+		.uart4		= 31,
+		.uart0		= 32,
+		.uart1		= 33,
+		.dma2		= 34,
+		.i2s		= 35,
+		.timer_match0	= 36,
+		.timer_match1	= 37,
+		.timer_match2	= 38,
+		.timer_match3	= 39,
+		.dma3		= 40,
+		.dma4		= 41,
+		.ac97		= 42,
+		.nor		= 44,
+		.dma5		= 45,
+		.dma6		= 46,
+		.uart2		= 47,
+		.rtc		= 48,
+		.rtc_hz		= 49,
+		.uart3		= 50,
+		.dma7		= 51,
+		.ext5		= 52,
+		.ext6		= 53,
+		.ext7		= 54,
+		.cir		= 55,
+		.irq0		= 56,
+		.irq1		= 57,
+		.irq2		= 58,
+		.irq3		= 59,
+		.irq4		= 60,
+		.irq5		= 61,
+		.irq6		= 62,
+		.irq7		= 63,
+		.jpegdec	= 65,
+		.sae		= 66,
+		.vpu		= 79,
+		.vpp		= 80,
+		.vid		= 81,
+		.spu		= 82,
+		.pip		= 83,
+		.ge		= 84,
+		.gov		= 85,
+		.dvo		= 86,
+		.dma8		= 92,
+		.dma9		= 93,
+		.dma10		= 94,
+		.dma11		= 95,
+		.dma12		= 96,
+		.dma13		= 97,
+		.dma14		= 98,
+		.dma15		= 99,
+		.govw		= 111,
+		.govrsdscd	= 112,
+		.govrsdmif	= 113,
+		.govrhdscd	= 114,
+		.govrhdmif	= 115,
+		.nr_irqs	= 116,
+	},
+};
diff --git a/arch/arm/mach-vt8500/mmio_regs.c b/arch/arm/mach-vt8500/mmio_regs.c
new file mode 100644
index 0000000..e9b3264
--- /dev/null
+++ b/arch/arm/mach-vt8500/mmio_regs.c
@@ -0,0 +1,118 @@
+/* linux/arch/arm/mach-vt8500/mmio_regs.c
+ *
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/init.h>
+
+#include <mach/mmio_regs.h>
+
+struct wmt_mmio_regs *wmt_current_regs __initdata;
+
+struct wmt_mmio_regs wmt_regmaps[] __initdata = {
+	[VT8500_INDEX] = {
+		.mmio_regs_start	= 0xd8000000,
+		.mmio_regs_length	= 0x00350000,
+		.mmio_regs_virt		= 0xf8000000,
+		.ddr			= 0xd8000000,
+		.dma			= 0xd8001000,
+		.sflash			= 0xd8002000,
+		.ether			= 0xd8004000,
+		.cipher			= 0xd8006000,
+		.ehci			= 0xd8007900,
+		.uhci			= 0xd8007b01,
+		.pata			= 0xd8008000,
+		.ps2			= 0xd8008800,
+		.nand			= 0xd8009000,
+		.nor			= 0xd8009400,
+		.sdmmc			= 0xd800a000,
+		.memstick		= 0xd800b400,
+		.lcdc			= 0xd800e400,
+		.vpu			= 0xd8050000,
+		.gov			= 0xd8050300,
+		.ge			= 0xd8050400,
+		.lcdf			= 0xd8050900,
+		.vid			= 0xd8050a00,
+		.vpp			= 0xd8050b00,
+		.tsbk			= 0xd80f4000,
+		.jpegdec		= 0xd80fe000,
+		.jpegenc		= 0xd80ff000,
+		.rtc			= 0xd8100000,
+		.gpio			= 0xd8110000,
+		.scc			= 0xd8120000,
+		.pmc			= 0xd8130000,
+		.ic0			= 0xd8140000,
+		.uart0			= 0xd8200000,
+		.uart2			= 0xd8210000,
+		.pwm			= 0xd8220000,
+		.spi0			= 0xd8240000,
+		.spi1			= 0xd8250000,
+		.cir			= 0xd8270000,
+		.i2c0			= 0xd8280000,
+		.ac97			= 0xd8290000,
+		.spi2			= 0xd82a0000,
+		.uart1			= 0xd82b0000,
+		.uart3			= 0xd82c0000,
+		.pcm			= 0xd82d0000,
+		.i2c1			= 0xd8320000,
+		.i2s			= 0xd8330000,
+		.adc			= 0xd8340000,
+	},
+	[WM8505_INDEX] = {
+		.mmio_regs_start	= 0xd8000000,
+		.mmio_regs_length	= 0x00390000,
+		.mmio_regs_virt		= 0xf8000000,
+		.ddr			= 0xd8000400,
+		.dma			= 0xd8001800,
+		.vdma			= 0xd8001c00,
+		.sflash			= 0xd8002000,
+		.ether			= 0xd8004000,
+		.cipher			= 0xd8006000,
+		.ehci			= 0xd8007100,
+		.uhci			= 0xd8007301,
+		.ps2			= 0xd8008800,
+		.nand			= 0xd8009000,
+		.nor			= 0xd8009400,
+		.sdmmc			= 0xd800a000,
+		.vpu			= 0xd8050000,
+		.gov			= 0xd8050300,
+		.ge			= 0xd8050400,
+		.govr			= 0xd8050800,
+		.vid			= 0xd8050a00,
+		.scl			= 0xd8050d00,
+		.vpp			= 0xd8050f00,
+		.jpegdec		= 0xd80fe000,
+		.rtc			= 0xd8100000,
+		.gpio			= 0xd8110000,
+		.scc			= 0xd8120000,
+		.pmc			= 0xd8130000,
+		.ic0			= 0xd8140000,
+		.ic1			= 0xd8150000,
+		.uart0			= 0xd8200000,
+		.uart2			= 0xd8210000,
+		.pwm			= 0xd8220000,
+		.spi0			= 0xd8240000,
+		.spi1			= 0xd8250000,
+		.keypad			= 0xd8260000,
+		.cir			= 0xd8270000,
+		.i2c0			= 0xd8280000,
+		.ac97			= 0xd8290000,
+		.spi2			= 0xd82a0000,
+		.uart1			= 0xd82b0000,
+		.uart3			= 0xd82c0000,
+		.i2c1			= 0xd8320000,
+		.i2s			= 0xd8330000,
+		.uart4			= 0xd8370000,
+		.uart5			= 0xd8380000,
+	},
+};
diff --git a/arch/arm/mach-vt8500/pwm.c b/arch/arm/mach-vt8500/pwm.c
new file mode 100644
index 0000000..47c55e6
--- /dev/null
+++ b/arch/arm/mach-vt8500/pwm.c
@@ -0,0 +1,254 @@
+/*
+ * arch/arm/mach-vt8500/pwm.c
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/pwm.h>
+
+#include <asm/div64.h>
+
+#define VT8500_NR_PWMS 4
+
+struct pwm_device {
+	struct list_head	node;
+	struct platform_device	*pdev;
+
+	const char	*label;
+
+	void __iomem	*regbase;
+
+	unsigned int	use_count;
+	unsigned int	pwm_id;
+};
+
+/*
+ * period_ns = 10^9 * (PRESCALE + 1) * (PV + 1) / PWM_CLK_RATE
+ * duty_ns   = 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
+ */
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	unsigned long long c;
+	unsigned long period_cycles, prescale, pv, dc;
+
+	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
+		return -EINVAL;
+
+	c = 25000000/2; /* wild guess --- need to implement clocks */
+	c = c * period_ns;
+	do_div(c, 1000000000);
+	period_cycles = c;
+
+	if (period_cycles < 1)
+		period_cycles = 1;
+	prescale = (period_cycles - 1) / 4096;
+	pv = period_cycles / (prescale + 1) - 1;
+	if (pv > 4095)
+		pv = 4095;
+
+	if (prescale > 1023)
+		return -EINVAL;
+
+	dc = pv * duty_ns / period_ns;
+
+	while (readb(pwm->regbase + 0x40 + pwm->pwm_id) & (1 << 1))
+		/* busy-wait */;
+	writel(prescale, pwm->regbase + 0x4 + (pwm->pwm_id << 4));
+	while (readb(pwm->regbase + 0x40 + pwm->pwm_id) & (1 << 2))
+		/* busy-wait */;
+	writel(pv, pwm->regbase + 0x8 + (pwm->pwm_id << 4));
+	while (readb(pwm->regbase + 0x40 + pwm->pwm_id) & (1 << 3))
+		/* busy-wait */;
+	writel(dc, pwm->regbase + 0xc + (pwm->pwm_id << 4));
+
+	return 0;
+}
+EXPORT_SYMBOL(pwm_config);
+
+int pwm_enable(struct pwm_device *pwm)
+{
+	while (readb(pwm->regbase + 0x40 + pwm->pwm_id) & (1 << 0))
+		/* busy-wait */;
+	writel(5, pwm->regbase + (pwm->pwm_id << 4));
+	return 0;
+}
+EXPORT_SYMBOL(pwm_enable);
+
+void pwm_disable(struct pwm_device *pwm)
+{
+	while (readb(pwm->regbase + 0x40 + pwm->pwm_id) & (1 << 0))
+		/* busy-wait */;
+	writel(0, pwm->regbase + (pwm->pwm_id << 4));
+}
+EXPORT_SYMBOL(pwm_disable);
+
+static DEFINE_MUTEX(pwm_lock);
+static LIST_HEAD(pwm_list);
+
+struct pwm_device *pwm_request(int pwm_id, const char *label)
+{
+	struct pwm_device *pwm;
+	int found = 0;
+
+	mutex_lock(&pwm_lock);
+
+	list_for_each_entry(pwm, &pwm_list, node) {
+		if (pwm->pwm_id == pwm_id) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		if (pwm->use_count == 0) {
+			pwm->use_count++;
+			pwm->label = label;
+		} else
+			pwm = ERR_PTR(-EBUSY);
+	} else
+		pwm = ERR_PTR(-ENOENT);
+
+	mutex_unlock(&pwm_lock);
+	return pwm;
+}
+EXPORT_SYMBOL(pwm_request);
+
+void pwm_free(struct pwm_device *pwm)
+{
+	mutex_lock(&pwm_lock);
+
+	if (pwm->use_count) {
+		pwm->use_count--;
+		pwm->label = NULL;
+	} else
+		pr_warning("PWM device already freed\n");
+
+	mutex_unlock(&pwm_lock);
+}
+EXPORT_SYMBOL(pwm_free);
+
+static inline void __add_pwm(struct pwm_device *pwm)
+{
+	mutex_lock(&pwm_lock);
+	list_add_tail(&pwm->node, &pwm_list);
+	mutex_unlock(&pwm_lock);
+}
+
+static int __devinit pwm_probe(struct platform_device *pdev)
+{
+	struct pwm_device *pwms;
+	struct resource *r;
+	int ret = 0;
+	int i;
+
+	pwms = kzalloc(sizeof(struct pwm_device) * VT8500_NR_PWMS, GFP_KERNEL);
+	if (pwms == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < VT8500_NR_PWMS; i++) {
+		pwms[i].use_count = 0;
+		pwms[i].pwm_id = i;
+		pwms[i].pdev = pdev;
+	}
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		dev_err(&pdev->dev, "no memory resource defined\n");
+		ret = -ENODEV;
+		goto err_free;
+	}
+
+	r = request_mem_region(r->start, resource_size(r), pdev->name);
+	if (r == NULL) {
+		dev_err(&pdev->dev, "failed to request memory resource\n");
+		ret = -EBUSY;
+		goto err_free;
+	}
+
+	pwms[0].regbase = ioremap(r->start, resource_size(r));
+	if (pwms[0].regbase == NULL) {
+		dev_err(&pdev->dev, "failed to ioremap() registers\n");
+		ret = -ENODEV;
+		goto err_free_mem;
+	}
+
+	for (i = 1; i < VT8500_NR_PWMS; i++)
+		pwms[i].regbase = pwms[1].regbase;
+
+	for (i = 0; i < VT8500_NR_PWMS; i++)
+		__add_pwm(&pwms[i]);
+
+	platform_set_drvdata(pdev, pwms);
+	return 0;
+
+err_free_mem:
+	release_mem_region(r->start, resource_size(r));
+err_free:
+	kfree(pwms);
+	return ret;
+}
+
+static int __devexit pwm_remove(struct platform_device *pdev)
+{
+	struct pwm_device *pwms;
+	struct resource *r;
+	int i;
+
+	pwms = platform_get_drvdata(pdev);
+	if (pwms == NULL)
+		return -ENODEV;
+
+	mutex_lock(&pwm_lock);
+
+	for (i = 0; i < VT8500_NR_PWMS; i++)
+		list_del(&pwms[i].node);
+	mutex_unlock(&pwm_lock);
+
+	iounmap(pwms[0].regbase);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(r->start, resource_size(r));
+
+	kfree(pwms);
+	return 0;
+}
+
+static struct platform_driver pwm_driver = {
+	.driver		= {
+		.name	= "vt8500-pwm",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= pwm_probe,
+	.remove		= __devexit_p(pwm_remove),
+};
+
+static int __init pwm_init(void)
+{
+	return platform_driver_register(&pwm_driver);
+}
+arch_initcall(pwm_init);
+
+static void __exit pwm_exit(void)
+{
+	platform_driver_unregister(&pwm_driver);
+}
+module_exit(pwm_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/arch/arm/mach-vt8500/timer.c b/arch/arm/mach-vt8500/timer.c
new file mode 100644
index 0000000..ab7dee4
--- /dev/null
+++ b/arch/arm/mach-vt8500/timer.c
@@ -0,0 +1,166 @@
+/*
+ *  arch/arm/mach-vt8500/timer.c
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+
+#include <asm/mach/time.h>
+
+#include <mach/mmio_regs.h>
+#include <mach/irq_defs.h>
+
+#define VT8500_TIMER_OFFSET	0x0100
+#define TIMER_MATCH_VAL		0x0000
+#define TIMER_COUNT_VAL		0x0010
+#define TIMER_STATUS_VAL	0x0014
+#define TIMER_IER_VAL		0x001c		/* interrupt enable */
+#define TIMER_CTRL_VAL		0x0020
+#define TIMER_AS_VAL		0x0024		/* access status */
+#define TIMER_COUNT_R_ACTIVE	(1 << 5)	/* not ready for read */
+#define TIMER_COUNT_W_ACTIVE	(1 << 4)	/* not ready for write */
+#define TIMER_MATCH_W_ACTIVE	(1 << 0)	/* not ready for write */
+#define VT8500_TIMER_HZ		3000000
+
+static void __iomem *regbase;
+
+/*
+ * Kernel assumes that sched_clock can be called early but may not have
+ * things ready yet.
+ */
+static cycle_t vt8500_timer_read_dummy(struct clocksource *cs)
+{
+	return 0;
+}
+
+static cycle_t vt8500_timer_read(struct clocksource *cs)
+{
+	writel(3, regbase + TIMER_CTRL_VAL);
+	while (readl((regbase + TIMER_AS_VAL)) & TIMER_COUNT_R_ACTIVE)
+		/* wait and poll */;
+	return readl(regbase + TIMER_COUNT_VAL);
+}
+
+struct clocksource clocksource = {
+	.name           = "vt8500_timer",
+	.rating         = 200,
+	.read           = vt8500_timer_read_dummy,
+	.mask           = CLOCKSOURCE_MASK(32),
+	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+unsigned long long sched_clock(void)
+{
+	return clocksource_cyc2ns(clocksource.read(&clocksource),
+				clocksource.mult, clocksource.shift);
+}
+
+static int vt8500_timer_set_next_event(unsigned long cycles,
+				    struct clock_event_device *evt)
+{
+	cycle_t alarm = clocksource.read(&clocksource) + cycles;
+	while (readl(regbase + TIMER_AS_VAL) & TIMER_MATCH_W_ACTIVE)
+		/* wait and poll */;
+	writel((unsigned long)alarm, regbase + TIMER_MATCH_VAL);
+
+	if ((signed)(alarm - clocksource.read(&clocksource)) <= 16)
+		return -ETIME;
+
+	writel(1, regbase + TIMER_IER_VAL);
+
+	return 0;
+}
+
+static void vt8500_timer_set_mode(enum clock_event_mode mode,
+			      struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_PERIODIC:
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		writel(readl(regbase + TIMER_CTRL_VAL) | 1,
+			regbase + TIMER_CTRL_VAL);
+		writel(0, regbase + TIMER_IER_VAL);
+		break;
+	}
+}
+
+struct clock_event_device clockevent = {
+	.name           = "vt8500_timer",
+	.features       = CLOCK_EVT_FEAT_ONESHOT,
+	.rating         = 200,
+	.set_next_event = vt8500_timer_set_next_event,
+	.set_mode       = vt8500_timer_set_mode,
+};
+
+static irqreturn_t vt8500_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+	writel(0xf, regbase + TIMER_STATUS_VAL);
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+struct irqaction irq = {
+	.name    = "vt8500_timer",
+	.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.handler = vt8500_timer_interrupt,
+	.dev_id  = &clockevent,
+};
+
+static void __init vt8500_timer_init(void)
+{
+	regbase = ioremap(wmt_current_regs->pmc + VT8500_TIMER_OFFSET, 0x28);
+	if (!regbase)
+		printk(KERN_ERR "vt8500_timer_init: failed to map MMIO "
+				"registers\n");
+
+	writel(1, regbase + TIMER_CTRL_VAL);
+	writel(0xf, regbase + TIMER_STATUS_VAL);
+	writel(~0, regbase + TIMER_MATCH_VAL);
+
+	clocksource.read = vt8500_timer_read;
+	if (clocksource_register_hz(&clocksource, VT8500_TIMER_HZ))
+		printk(KERN_ERR "vt8500_timer_init: clocksource_register "
+			"failed for %s\n", clocksource.name);
+
+	clockevents_calc_mult_shift(&clockevent, VT8500_TIMER_HZ, 4);
+
+	/* copy-pasted from mach-msm; no idea */
+	clockevent.max_delta_ns =
+		clockevent_delta2ns(0xf0000000, &clockevent);
+	clockevent.min_delta_ns = clockevent_delta2ns(4, &clockevent);
+	clockevent.cpumask = cpumask_of(0);
+
+	if (setup_irq(wmt_current_irqs->timer_match0, &irq))
+		printk(KERN_ERR "vt8500_timer_init: setup_irq "
+			"failed for %s\n", clockevent.name);
+	clockevents_register_device(&clockevent);
+}
+
+struct sys_timer vt8500_timer = {
+	.init = vt8500_timer_init
+};
diff --git a/arch/arm/mach-vt8500/wm8505_7in.c b/arch/arm/mach-vt8500/wm8505_7in.c
new file mode 100644
index 0000000..c8e65e7
--- /dev/null
+++ b/arch/arm/mach-vt8500/wm8505_7in.c
@@ -0,0 +1,69 @@
+/*
+ *  arch/arm/mach-vt8500/wm8505_7in.c
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <linux/io.h>
+#include <linux/pm.h>
+
+#include <mach/mmio_regs.h>
+#include "devices.h"
+
+static void __iomem *pmc_hiber;
+
+static struct platform_device *devices[] __initdata = {
+	&vt8500_device_uart0,
+	&vt8500_device_ehci,
+	&vt8500_device_wm8505_fb,
+	&vt8500_device_ge_rops,
+	&vt8500_device_pwm,
+	&vt8500_device_pwmbl,
+	&vt8500_device_rtc,
+};
+
+static void vt8500_power_off(void)
+{
+	local_irq_disable();
+	writew(5, pmc_hiber);
+	asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
+}
+
+void __init wm8505_7in_init(void)
+{
+#ifdef CONFIG_FB_WM8505
+	void __iomem *gpio_mux_reg = ioremap(wmt_current_regs->gpio
+					     + 0x200, 4);
+
+	writel(readl(gpio_mux_reg) | 0x80000000, gpio_mux_reg);
+	iounmap(gpio_mux_reg);
+#endif
+	pmc_hiber = ioremap(wmt_current_regs->pmc + 0x12, 2);
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+	vt8500_gpio_init();
+	pm_power_off = &vt8500_power_off;
+}
+
+MACHINE_START(WM8505_7IN_NETBOOK, "WM8505 7-inch generic netbook")
+	.boot_params	= 0x00000100,
+	.map_io		= wm8505_map_io,
+	.init_irq	= wm8505_init_irq,
+	.timer		= &vt8500_timer,
+	.init_machine	= wm8505_7in_init,
+MACHINE_END
-- 
1.7.3.2

