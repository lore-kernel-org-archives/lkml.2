Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab0LVVSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 16:18:24 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:33508 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0LVVSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 16:18:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e/1ENvBsnyZJlnFo7QkfciZr5tAeIToxiqzNHXpZoJ8drzwdHnQHTVkt0IsYDC/kUJ
         KU2MOYsJJFPOuCCjUbk0hezzwGqh+kFDJdRS8Yu1KUcRyUfiFJEqB5erOhWxaGML1Uio
         5leiokGkvc3fz0nDWYXiDZsigXI2+jnvNXUpk=
Date: Thu, 23 Dec 2010 00:18:15 +0300
From: Alexey Charkov <alchark@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Alexey Charkov <alchark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6 v10] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
Message-ID: <20101222211815.GA31054@alchark-u3s>
References: <20101220195423.GA14509@alchark-u3s>
 <4D0FC1AE.2050708@bluewatersys.com>
 <AANLkTin4XqbGwznp56Xjt_zest6rxNmir0QDJWTySY4+@mail.gmail.com>
 <4D0FD747.9020700@bluewatersys.com>
 <AANLkTikAWjK7ACyt=LedhyyrhsCk1WCiyWz182CXMe9C@mail.gmail.com>
 <4D0FE546.7050302@bluewatersys.com>
 <AANLkTinyYKrhTcBMMCE4A2oFQHm11cqSZQozytGu+d6o@mail.gmail.com>
 <4D1011CF.9080800@bluewatersys.com>
 <AANLkTi=7O-HwQRcybnLSt+r+A64g=D7rZY7NbdEMFys3@mail.gmail.com>
 <4D110269.9030805@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D110269.9030805@bluewatersys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the family of Systems-on-Chip produced initially
by VIA and now its subsidiary WonderMedia that have recently become
widespread in lower-end Chinese ARM-based tablets and netbooks.

Support is included for both VT8500 and WM8505, selectable by a
configuration switch at kernel build time.

Included are basic machine initialization files, register and
interrupt definitions, support for the on-chip interrupt controller,
high-precision OS timer, GPIO lines, necessary macros for early debug,
pulse-width-modulated outputs control, as well as platform device
configurations for the specific drivers implemented elsewhere.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---

Welcome the jubilee tenth revision of this patch ;-)

I've tried to incorporate the suggestions by Ryan and Arnd, hope that
there is nothing left out. There was a massive reorganization of code
to remove less-than-obvious magic with MMIO registers and irqs being
held in huge structs, now they are again macro definitions. Those
macros are, however, only included in single isolated files, and
actual values to use are chosen at runtime by calling the respective
routines at machine initialization. There are also stylistic changes
all around, where Ryan suggested.

As a result, i8042 should again be adjusted a bit to reflect the new
place to find respective register/irq definitions, that one will be
sent in the respective thread shortly.

Best regards,
Alexey

 arch/arm/Kconfig                                |   12 +
 arch/arm/Makefile                               |    1 +
 arch/arm/boot/compressed/Makefile               |    4 +
 arch/arm/boot/compressed/head-vt8500.S          |   46 ++++
 arch/arm/mach-vt8500/Kconfig                    |   73 ++++++
 arch/arm/mach-vt8500/Makefile                   |    9 +
 arch/arm/mach-vt8500/Makefile.boot              |    3 +
 arch/arm/mach-vt8500/bv07.c                     |   77 +++++++
 arch/arm/mach-vt8500/devices-vt8500.c           |  117 ++++++++++
 arch/arm/mach-vt8500/devices-wm8505.c           |  125 +++++++++++
 arch/arm/mach-vt8500/devices.c                  |  270 +++++++++++++++++++++++
 arch/arm/mach-vt8500/devices.h                  |   59 +++++
 arch/arm/mach-vt8500/gpio.c                     |  233 +++++++++++++++++++
 arch/arm/mach-vt8500/include/mach/debug-macro.S |   31 +++
 arch/arm/mach-vt8500/include/mach/entry-macro.S |   32 +++
 arch/arm/mach-vt8500/include/mach/gpio.h        |    6 +
 arch/arm/mach-vt8500/include/mach/hardware.h    |   12 +
 arch/arm/mach-vt8500/include/mach/i8042.h       |   18 ++
 arch/arm/mach-vt8500/include/mach/io.h          |   28 +++
 arch/arm/mach-vt8500/include/mach/irqs.h        |   22 ++
 arch/arm/mach-vt8500/include/mach/memory.h      |   28 +++
 arch/arm/mach-vt8500/include/mach/system.h      |   18 ++
 arch/arm/mach-vt8500/include/mach/timex.h       |   26 +++
 arch/arm/mach-vt8500/include/mach/uncompress.h  |   37 +++
 arch/arm/mach-vt8500/include/mach/vmalloc.h     |   20 ++
 arch/arm/mach-vt8500/include/mach/vt8500_irqs.h |   88 ++++++++
 arch/arm/mach-vt8500/include/mach/vt8500_regs.h |   79 +++++++
 arch/arm/mach-vt8500/include/mach/vt8500fb.h    |   31 +++
 arch/arm/mach-vt8500/include/mach/wm8505_irqs.h |  115 ++++++++++
 arch/arm/mach-vt8500/include/mach/wm8505_regs.h |   78 +++++++
 arch/arm/mach-vt8500/irq.c                      |  177 +++++++++++++++
 arch/arm/mach-vt8500/pwm.c                      |  265 ++++++++++++++++++++++
 arch/arm/mach-vt8500/timer.c                    |  155 +++++++++++++
 arch/arm/mach-vt8500/wm8505_7in.c               |   77 +++++++
 34 files changed, 2372 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/compressed/head-vt8500.S
 create mode 100644 arch/arm/mach-vt8500/Kconfig
 create mode 100644 arch/arm/mach-vt8500/Makefile
 create mode 100644 arch/arm/mach-vt8500/Makefile.boot
 create mode 100644 arch/arm/mach-vt8500/bv07.c
 create mode 100644 arch/arm/mach-vt8500/devices-vt8500.c
 create mode 100644 arch/arm/mach-vt8500/devices-wm8505.c
 create mode 100644 arch/arm/mach-vt8500/devices.c
 create mode 100644 arch/arm/mach-vt8500/devices.h
 create mode 100644 arch/arm/mach-vt8500/gpio.c
 create mode 100644 arch/arm/mach-vt8500/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-vt8500/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-vt8500/include/mach/gpio.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/hardware.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/i8042.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/io.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/irqs.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/memory.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/system.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/timex.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/vt8500_irqs.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/vt8500_regs.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/vt8500fb.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/wm8505_irqs.h
 create mode 100644 arch/arm/mach-vt8500/include/mach/wm8505_regs.h
 create mode 100644 arch/arm/mach-vt8500/irq.c
 create mode 100644 arch/arm/mach-vt8500/pwm.c
 create mode 100644 arch/arm/mach-vt8500/timer.c
 create mode 100644 arch/arm/mach-vt8500/wm8505_7in.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d56d21c..53052fa 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -843,6 +843,16 @@ config PLAT_SPEAR
 	help
 	  Support for ST's SPEAr platform (SPEAr3xx, SPEAr6xx and SPEAr13xx).
 
+config ARCH_VT8500
+	bool "VIA/WonderMedia 85xx"
+	select CPU_ARM926T
+	select GENERIC_GPIO
+	select ARCH_HAS_CPUFREQ
+	select GENERIC_CLOCKEVENTS
+	select ARCH_REQUIRE_GPIOLIB
+	select HAVE_PWM
+	help
+	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
 endchoice
 
 #
@@ -973,6 +983,8 @@ source "arch/arm/mach-versatile/Kconfig"
 
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
index 0000000..2c20a34
--- /dev/null
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -0,0 +1,73 @@
+if ARCH_VT8500
+
+config VTWM_VERSION_VT8500
+	bool
+
+config VTWM_VERSION_WM8505
+	bool
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
+config WMT_PANEL_1024X576
+	bool "10-inch with 1024x576 resolution"
+	depends on (FB_VT8500 || FB_WM8505)
+	help
+	  These are found in CherryPal netbooks and possibly elsewhere.
+
+	  To select this panel at runtime, say y here and append
+	  'panel=1024x576' to your kernel command line. Otherwise, the
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
index 0000000..81aedb7
--- /dev/null
+++ b/arch/arm/mach-vt8500/Makefile
@@ -0,0 +1,9 @@
+obj-y += devices.o gpio.o irq.o timer.o
+
+obj-$(CONFIG_VTWM_VERSION_VT8500) += devices-vt8500.o
+obj-$(CONFIG_VTWM_VERSION_WM8505) += devices-wm8505.o
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
index 0000000..94a261d
--- /dev/null
+++ b/arch/arm/mach-vt8500/bv07.c
@@ -0,0 +1,77 @@
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
+#include <linux/io.h>
+#include <linux/pm.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
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
+	void __iomem *gpio_mux_reg = ioremap(wmt_gpio_base + 0x200, 4);
+	if (gpio_mux_reg) {
+		writel(readl(gpio_mux_reg) | 1, gpio_mux_reg);
+		iounmap(gpio_mux_reg);
+	} else {
+		printk(KERN_ERR "Could not remap the GPIO mux register, display may not work properly!\n");
+	}
+#endif
+	pmc_hiber = ioremap(wmt_pmc_base + 0x12, 2);
+	if (pmc_hiber)
+		pm_power_off = &vt8500_power_off;
+	else
+		printk(KERN_ERR "PMC Hibernation register could not be remapped, not enabling power off!\n");
+
+	vt8500_set_resources();
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+	vt8500_gpio_init();
+}
+
+MACHINE_START(BV07, "Benign BV07 Mini Netbook")
+	.boot_params	= 0x00000100,
+	.reserve	= vt8500_reserve_mem,
+	.map_io		= vt8500_map_io,
+	.init_irq	= vt8500_init_irq,
+	.timer		= &vt8500_timer,
+	.init_machine	= bv07_init,
+MACHINE_END
diff --git a/arch/arm/mach-vt8500/devices-vt8500.c b/arch/arm/mach-vt8500/devices-vt8500.c
new file mode 100644
index 0000000..88384c7
--- /dev/null
+++ b/arch/arm/mach-vt8500/devices-vt8500.c
@@ -0,0 +1,117 @@
+/* linux/arch/arm/mach-vt8500/devices-vt8500.c
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
+#include <linux/platform_device.h>
+
+#include <mach/vt8500_regs.h>
+#include <mach/vt8500_irqs.h>
+#include <mach/i8042.h>
+#include "devices.h"
+
+static inline struct resource WMT_MMIO_RES(u32 start, u32 size)
+{
+	struct resource tmp = {
+		.flags = IORESOURCE_MEM,
+		.start = start,
+		.end = start + size - 1,
+	};
+
+	return tmp;
+}
+
+static inline struct resource WMT_IRQ_RES(int irq)
+{
+	struct resource tmp = {
+		.flags = IORESOURCE_IRQ,
+		.start = irq,
+		.end = irq,
+	};
+
+	return tmp;
+}
+
+#define WMT_RES_ADD(__device, __resource, __num) \
+if (platform_device_add_resources(__device, __resource, __num)) \
+	pr_err("Failed to assign resources to __device##\n");
+
+void __init vt8500_set_resources(void)
+{
+	struct resource tmp[3];
+
+	tmp[0] = WMT_MMIO_RES(VT8500_LCDC_BASE, SZ_1K);
+	tmp[1] = WMT_IRQ_RES(IRQ_LCDC);
+	WMT_RES_ADD(&vt8500_device_lcdc, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(VT8500_UART0_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART0);
+	WMT_RES_ADD(&vt8500_device_uart0, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(VT8500_UART1_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART1);
+	WMT_RES_ADD(&vt8500_device_uart1, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(VT8500_UART2_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART2);
+	WMT_RES_ADD(&vt8500_device_uart2, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(VT8500_UART3_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART3);
+	WMT_RES_ADD(&vt8500_device_uart3, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(VT8500_EHCI_BASE, SZ_512);
+	tmp[1] = WMT_IRQ_RES(IRQ_EHCI);
+	WMT_RES_ADD(&vt8500_device_ehci, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(VT8500_GEGEA_BASE, SZ_256);
+	WMT_RES_ADD(&vt8500_device_ge_rops, tmp, 1);
+
+	tmp[0] = WMT_MMIO_RES(VT8500_PWM_BASE, 0x44);
+	WMT_RES_ADD(&vt8500_device_pwm, tmp, 1);
+
+	tmp[0] = WMT_MMIO_RES(VT8500_RTC_BASE, 0x2c);
+	tmp[1] = WMT_IRQ_RES(IRQ_RTC);
+	tmp[2] = WMT_IRQ_RES(IRQ_RTCSM);
+	WMT_RES_ADD(&vt8500_device_rtc, tmp, 3);
+}
+
+static void __init vt8500_set_externs(void)
+{
+	/* Non-resource-aware stuff */
+	wmt_ic_base = VT8500_IC_BASE;
+	wmt_gpio_base = VT8500_GPIO_BASE;
+	wmt_pmc_base = VT8500_PMC_BASE;
+	wmt_i8042_base = VT8500_PS2_BASE;
+
+	wmt_nr_irqs = VT8500_NR_IRQS;
+	wmt_timer_irq = IRQ_PMCOS0;
+	wmt_gpio_ext_irq[0] = IRQ_EXT0;
+	wmt_gpio_ext_irq[1] = IRQ_EXT1;
+	wmt_gpio_ext_irq[2] = IRQ_EXT2;
+	wmt_gpio_ext_irq[3] = IRQ_EXT3;
+	wmt_gpio_ext_irq[4] = IRQ_EXT4;
+	wmt_gpio_ext_irq[5] = IRQ_EXT5;
+	wmt_gpio_ext_irq[6] = IRQ_EXT6;
+	wmt_gpio_ext_irq[7] = IRQ_EXT7;
+	wmt_i8042_kbd_irq = IRQ_PS2KBD;
+	wmt_i8042_aux_irq = IRQ_PS2MOUSE;
+}
+
+void __init vt8500_map_io(void)
+{
+	iotable_init(wmt_io_desc, ARRAY_SIZE(wmt_io_desc));
+
+	/* Should be done before interrupts and timers are initialized */
+	vt8500_set_externs();
+}
diff --git a/arch/arm/mach-vt8500/devices-wm8505.c b/arch/arm/mach-vt8500/devices-wm8505.c
new file mode 100644
index 0000000..ad53e7d
--- /dev/null
+++ b/arch/arm/mach-vt8500/devices-wm8505.c
@@ -0,0 +1,125 @@
+/* linux/arch/arm/mach-vt8500/devices-wm8505.c
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
+#include <linux/platform_device.h>
+
+#include <mach/wm8505_regs.h>
+#include <mach/wm8505_irqs.h>
+#include <mach/i8042.h>
+#include "devices.h"
+
+static inline struct resource WMT_MMIO_RES(u32 start, u32 size)
+{
+	struct resource tmp = {
+		.flags = IORESOURCE_MEM,
+		.start = start,
+		.end = start + size - 1,
+	};
+
+	return tmp;
+}
+
+static inline struct resource WMT_IRQ_RES(int irq)
+{
+	struct resource tmp = {
+		.flags = IORESOURCE_IRQ,
+		.start = irq,
+		.end = irq,
+	};
+
+	return tmp;
+}
+
+#define WMT_RES_ADD(__device, __resource, __num) \
+if (platform_device_add_resources(__device, __resource, __num)) \
+	pr_err("Failed to assign resources to __device##\n");
+
+void __init wm8505_set_resources(void)
+{
+	struct resource tmp[3];
+
+	tmp[0] = WMT_MMIO_RES(WM8505_GOVR_BASE, SZ_512);
+	WMT_RES_ADD(&vt8500_device_wm8505_fb, tmp, 1);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_UART0_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART0);
+	WMT_RES_ADD(&vt8500_device_uart0, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_UART1_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART1);
+	WMT_RES_ADD(&vt8500_device_uart1, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_UART2_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART2);
+	WMT_RES_ADD(&vt8500_device_uart2, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_UART3_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART3);
+	WMT_RES_ADD(&vt8500_device_uart3, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_UART4_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART4);
+	WMT_RES_ADD(&vt8500_device_uart4, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_UART5_BASE, 0x1040);
+	tmp[1] = WMT_IRQ_RES(IRQ_UART5);
+	WMT_RES_ADD(&vt8500_device_uart5, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_EHCI_BASE, SZ_512);
+	tmp[1] = WMT_IRQ_RES(IRQ_EHCI);
+	WMT_RES_ADD(&vt8500_device_ehci, tmp, 2);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_GEGEA_BASE, SZ_256);
+	WMT_RES_ADD(&vt8500_device_ge_rops, tmp, 1);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_PWM_BASE, 0x44);
+	WMT_RES_ADD(&vt8500_device_pwm, tmp, 1);
+
+	tmp[0] = WMT_MMIO_RES(WM8505_RTC_BASE, 0x2c);
+	tmp[1] = WMT_IRQ_RES(IRQ_RTC);
+	tmp[2] = WMT_IRQ_RES(IRQ_RTCSM);
+	WMT_RES_ADD(&vt8500_device_rtc, tmp, 3);
+}
+
+static void __init wm8505_set_externs(void)
+{
+	/* Non-resource-aware stuff */
+	wmt_ic_base = WM8505_IC_BASE;
+	wmt_sic_base = WM8505_SIC_BASE;
+	wmt_gpio_base = WM8505_GPIO_BASE;
+	wmt_pmc_base = WM8505_PMC_BASE;
+	wmt_i8042_base = WM8505_PS2_BASE;
+
+	wmt_nr_irqs = WM8505_NR_IRQS;
+	wmt_timer_irq = IRQ_PMCOS0;
+	wmt_gpio_ext_irq[0] = IRQ_EXT0;
+	wmt_gpio_ext_irq[1] = IRQ_EXT1;
+	wmt_gpio_ext_irq[2] = IRQ_EXT2;
+	wmt_gpio_ext_irq[3] = IRQ_EXT3;
+	wmt_gpio_ext_irq[4] = IRQ_EXT4;
+	wmt_gpio_ext_irq[5] = IRQ_EXT5;
+	wmt_gpio_ext_irq[6] = IRQ_EXT6;
+	wmt_gpio_ext_irq[7] = IRQ_EXT7;
+	wmt_i8042_kbd_irq = IRQ_PS2KBD;
+	wmt_i8042_aux_irq = IRQ_PS2MOUSE;
+}
+
+void __init wm8505_map_io(void)
+{
+	iotable_init(wmt_io_desc, ARRAY_SIZE(wmt_io_desc));
+
+	/* Should be done before interrupts and timers are initialized */
+	wm8505_set_externs();
+}
diff --git a/arch/arm/mach-vt8500/devices.c b/arch/arm/mach-vt8500/devices.c
new file mode 100644
index 0000000..1fcdc36
--- /dev/null
+++ b/arch/arm/mach-vt8500/devices.c
@@ -0,0 +1,270 @@
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
+
+#include <mach/vt8500fb.h>
+#include <mach/i8042.h>
+#include "devices.h"
+
+/* These can't use resources currently */
+unsigned long wmt_ic_base __initdata;
+unsigned long wmt_sic_base __initdata;
+unsigned long wmt_gpio_base __initdata;
+unsigned long wmt_pmc_base __initdata;
+unsigned long wmt_i8042_base __initdata;
+
+int wmt_nr_irqs __initdata;
+int wmt_timer_irq __initdata;
+int wmt_gpio_ext_irq[8] __initdata;
+
+/* Should remain accessible after init.
+ * i8042 driver desperately calls for attention...
+ */
+int wmt_i8042_kbd_irq;
+int wmt_i8042_aux_irq;
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
+};
+
+struct platform_device vt8500_device_wm8505_fb = {
+	.name           = "wm8505-fb",
+	.id             = 0,
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
+		.vsync_len	= 1,
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
+		.vsync_len	= 1,
+		.vmode		= FB_VMODE_NONINTERLACED,
+	},
+},
+#endif
+#ifdef CONFIG_WMT_PANEL_1024X576
+{
+	.xres_virtual	= 1024,
+	.yres_virtual	= 576 * 2,
+	.mode		= {
+		.name		= "1024x576",
+		.xres		= 1024,
+		.yres		= 576,
+		.left_margin	= 40,
+		.right_margin	= 24,
+		.upper_margin	= 32,
+		.lower_margin	= 11,
+		.hsync_len	= 96,
+		.vsync_len	= 2,
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
+		.left_margin	= 66,
+		.right_margin	= 2,
+		.upper_margin	= 19,
+		.lower_margin	= 1,
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
+		if (strcmp(panels[i].mode.name, str) == 0) {
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
+struct platform_device vt8500_device_uart0 = {
+	.name		= "vt8500_serial",
+	.id		= 0,
+};
+
+struct platform_device vt8500_device_uart1 = {
+	.name		= "vt8500_serial",
+	.id		= 1,
+};
+
+struct platform_device vt8500_device_uart2 = {
+	.name		= "vt8500_serial",
+	.id		= 2,
+};
+
+struct platform_device vt8500_device_uart3 = {
+	.name		= "vt8500_serial",
+	.id		= 3,
+};
+
+struct platform_device vt8500_device_uart4 = {
+	.name		= "vt8500_serial",
+	.id		= 4,
+};
+
+struct platform_device vt8500_device_uart5 = {
+	.name		= "vt8500_serial",
+	.id		= 5,
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
+};
+
+struct platform_device vt8500_device_ge_rops = {
+	.name		= "wmt_ge_rops",
+	.id		= -1,
+};
+
+struct platform_device vt8500_device_pwm = {
+	.name		= "vt8500-pwm",
+	.id		= 0,
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
+struct platform_device vt8500_device_rtc = {
+	.name		= "vt8500-rtc",
+	.id		= 0,
+};
+
+struct map_desc wmt_io_desc[] __initdata = {
+	/* SoC MMIO registers */
+	[0] = {
+		.virtual	= 0xf8000000,
+		.pfn		= __phys_to_pfn(0xd8000000),
+		.length		= 0x00390000, /* max of all chip variants */
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
+void __init vt8500_reserve_mem(void)
+{
+#ifdef CONFIG_FB_VT8500
+	panels[current_panel_idx].bpp = 16; /* Always use RGB565 */
+	preallocate_fb(&panels[current_panel_idx], SZ_4M);
+	vt8500_device_lcdc.dev.platform_data = &panels[current_panel_idx];
+#endif
+}
+
+void __init wm8505_reserve_mem(void)
+{
+#if defined CONFIG_FB_WM8505
+	panels[current_panel_idx].bpp = 32; /* Always use RGB888 */
+	preallocate_fb(&panels[current_panel_idx], 32);
+	vt8500_device_wm8505_fb.dev.platform_data = &panels[current_panel_idx];
+#endif
+}
diff --git a/arch/arm/mach-vt8500/devices.h b/arch/arm/mach-vt8500/devices.h
new file mode 100644
index 0000000..ba0418b
--- /dev/null
+++ b/arch/arm/mach-vt8500/devices.h
@@ -0,0 +1,59 @@
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
+#include <asm/mach/map.h>
+
+void __init vt8500_init_irq(void);
+void __init wm8505_init_irq(void);
+void __init vt8500_map_io(void);
+void __init wm8505_map_io(void);
+void __init vt8500_reserve_mem(void);
+void __init wm8505_reserve_mem(void);
+void __init vt8500_gpio_init(void);
+void __init vt8500_set_resources(void);
+void __init wm8505_set_resources(void);
+
+extern unsigned long wmt_ic_base __initdata;
+extern unsigned long wmt_sic_base __initdata;
+extern unsigned long wmt_gpio_base __initdata;
+extern unsigned long wmt_pmc_base __initdata;
+
+extern int wmt_nr_irqs __initdata;
+extern int wmt_timer_irq __initdata;
+extern int wmt_gpio_ext_irq[8] __initdata;
+
+extern struct map_desc wmt_io_desc[2] __initdata;
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
index 0000000..445397e
--- /dev/null
+++ b/arch/arm/mach-vt8500/gpio.c
@@ -0,0 +1,233 @@
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
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+
+#include "devices.h"
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
+	unsigned val = readl(regbase + vt8500_chip->regoff);
+
+	val |= (1 << vt8500_chip->shift << offset);
+	writel(val, regbase + vt8500_chip->regoff);
+
+	return 0;
+}
+
+static void vt8500_muxed_gpio_free(struct gpio_chip *chip,
+				   unsigned offset)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+	unsigned val = readl(regbase + vt8500_chip->regoff);
+
+	val &= ~(1 << vt8500_chip->shift << offset);
+	writel(val, regbase + vt8500_chip->regoff);
+}
+
+static int vt8500_muxed_gpio_direction_input(struct gpio_chip *chip,
+				       unsigned offset)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+	unsigned val = readl(regbase + 0x20 + vt8500_chip->regoff);
+
+	val &= ~(1 << vt8500_chip->shift << offset);
+	writel(val, regbase + 0x20 + vt8500_chip->regoff);
+
+	return 0;
+}
+
+static int vt8500_muxed_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+	unsigned val = readl(regbase + 0x20 + vt8500_chip->regoff);
+
+	val |= (1 << vt8500_chip->shift << offset);
+	writel(val, regbase + 0x20 + vt8500_chip->regoff);
+
+	if (value) {
+		val = readl(regbase + 0x40 + vt8500_chip->regoff);
+		val |= (1 << vt8500_chip->shift << offset);
+		writel(val, regbase + 0x40 + vt8500_chip->regoff);
+	}
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
+	unsigned val = readl(regbase + 0x40 + vt8500_chip->regoff);
+
+	if (value)
+		val |= (1 << vt8500_chip->shift << offset);
+	else
+		val &= ~(1 << vt8500_chip->shift << offset);
+
+	writel(val, regbase + 0x40 + vt8500_chip->regoff);
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
+	VT8500_GPIO_BANK("uart0",	0,	0x0,	8,	4),
+	VT8500_GPIO_BANK("uart1",	4,	0x0,	12,	4),
+	VT8500_GPIO_BANK("spi0",	8,	0x0,	16,	4),
+	VT8500_GPIO_BANK("spi1",	12,	0x0,	20,	4),
+	VT8500_GPIO_BANK("spi2",	16,	0x0,	24,	4),
+	VT8500_GPIO_BANK("pwmout",	24,	0x0,	28,	2),
+
+	VT8500_GPIO_BANK("sdmmc",	0,	0x4,	30,	11),
+	VT8500_GPIO_BANK("ms",		16,	0x4,	41,	7),
+	VT8500_GPIO_BANK("i2c0",	24,	0x4,	48,	2),
+	VT8500_GPIO_BANK("i2c1",	26,	0x4,	50,	2),
+
+	VT8500_GPIO_BANK("mii",		0,	0x8,	52,	20),
+	VT8500_GPIO_BANK("see",		20,	0x8,	72,	4),
+	VT8500_GPIO_BANK("ide",		24,	0x8,	76,	7),
+
+	VT8500_GPIO_BANK("ccir",	0,	0xc,	83,	19),
+
+	VT8500_GPIO_BANK("ts",		8,	0x10,	102,	11),
+
+	VT8500_GPIO_BANK("lcd",		0,	0x14,	113,	23),
+};
+
+static int vt8500_gpio_direction_input(struct gpio_chip *chip,
+				       unsigned offset)
+{
+	unsigned val = readl(regbase + 0x3c);
+
+	val &= ~(1 << offset);
+	writel(val, regbase + 0x3c);
+	return 0;
+}
+
+static int vt8500_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	unsigned val = readl(regbase + 0x3c);
+
+	val |= (1 << offset);
+	writel(val, regbase + 0x3c);
+
+	if (value) {
+		val = readl(regbase + 0x5c);
+		val |= (1 << offset);
+		writel(val, regbase + 0x5c);
+	}
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
+	unsigned val = readl(regbase + 0x5c);
+
+	if (value)
+		val |= (1 << offset);
+	else
+		val &= ~(1 << offset);
+
+	writel(val, regbase + 0x5c);
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
+	for (i = 0; i < 8; i++)
+		gpio_to_irq_map[i] = wmt_gpio_ext_irq[i];
+
+	regbase = ioremap(wmt_gpio_base, SZ_64K);
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
diff --git a/arch/arm/mach-vt8500/include/mach/i8042.h b/arch/arm/mach-vt8500/include/mach/i8042.h
new file mode 100644
index 0000000..cd7143c
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/i8042.h
@@ -0,0 +1,18 @@
+/* arch/arm/mach-vt8500/include/mach/i8042.h
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
+extern unsigned long wmt_i8042_base __initdata;
+extern int wmt_i8042_kbd_irq;
+extern int wmt_i8042_aux_irq;
diff --git a/arch/arm/mach-vt8500/include/mach/io.h b/arch/arm/mach-vt8500/include/mach/io.h
new file mode 100644
index 0000000..9077239
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
+#define __io(a)		__typesafe_io((a) + 0xf0000000)
+#define __mem_pci(a)	(a)
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
diff --git a/arch/arm/mach-vt8500/include/mach/system.h b/arch/arm/mach-vt8500/include/mach/system.h
new file mode 100644
index 0000000..d6c757e
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
+#define VT8500_PMSR_VIRT	0xf8130060
+
+static inline void arch_idle(void)
+{
+	cpu_do_idle();
+}
+
+static inline void arch_reset(char mode, const char *cmd)
+{
+	writel(1, VT8500_PMSR_VIRT);
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
index 0000000..4642290
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
+#define VMALLOC_END	0xd0000000UL
diff --git a/arch/arm/mach-vt8500/include/mach/vt8500_irqs.h b/arch/arm/mach-vt8500/include/mach/vt8500_irqs.h
new file mode 100644
index 0000000..ecfee91
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/vt8500_irqs.h
@@ -0,0 +1,88 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/vt8500_irqs.h
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
+/* VT8500 Interrupt Sources */
+
+#define IRQ_JPEGENC	0	/* JPEG Encoder */
+#define IRQ_JPEGDEC	1	/* JPEG Decoder */
+				/* Reserved */
+#define IRQ_PATA	3	/* PATA Controller */
+				/* Reserved */
+#define IRQ_DMA		5	/* DMA Controller */
+#define IRQ_EXT0	6	/* External Interrupt 0 */
+#define IRQ_EXT1	7	/* External Interrupt 1 */
+#define IRQ_GE		8	/* Graphic Engine */
+#define IRQ_GOV		9	/* Graphic Overlay Engine */
+#define IRQ_ETHER	10	/* Ethernet MAC */
+#define IRQ_MPEGTS	11	/* Transport Stream Interface */
+#define IRQ_LCDC	12	/* LCD Controller */
+#define IRQ_EXT2	13	/* External Interrupt 2 */
+#define IRQ_EXT3	14	/* External Interrupt 3 */
+#define IRQ_EXT4	15	/* External Interrupt 4 */
+#define IRQ_CIPHER	16	/* Cipher */
+#define IRQ_VPP		17	/* Video Post-Processor */
+#define IRQ_I2C1	18	/* I2C 1 */
+#define IRQ_I2C0	19	/* I2C 0 */
+#define IRQ_SDMMC	20	/* SD/MMC Controller */
+#define IRQ_SDMMC_DMA	21	/* SD/MMC Controller DMA */
+#define IRQ_PMC_WU	22	/* Power Management Controller Wakeup */
+				/* Reserved */
+#define IRQ_SPI0	24	/* SPI 0 */
+#define IRQ_SPI1	25	/* SPI 1 */
+#define IRQ_SPI2	26	/* SPI 2 */
+#define IRQ_LCDDF	27	/* LCD Data Formatter */
+#define IRQ_NAND	28	/* NAND Flash Controller */
+#define IRQ_NAND_DMA	29	/* NAND Flash Controller DMA */
+#define IRQ_MS		30	/* MemoryStick Controller */
+#define IRQ_MS_DMA	31	/* MemoryStick Controller DMA */
+#define IRQ_UART0	32	/* UART 0 */
+#define IRQ_UART1	33	/* UART 1 */
+#define IRQ_I2S		34	/* I2S */
+#define IRQ_PCM		35	/* PCM */
+#define IRQ_PMCOS0	36	/* PMC OS Timer 0 */
+#define IRQ_PMCOS1	37	/* PMC OS Timer 1 */
+#define IRQ_PMCOS2	38	/* PMC OS Timer 2 */
+#define IRQ_PMCOS3	39	/* PMC OS Timer 3 */
+#define IRQ_VPU		40	/* Video Processing Unit */
+#define IRQ_VID		41	/* Video Digital Input Interface */
+#define IRQ_AC97	42	/* AC97 Interface */
+#define IRQ_EHCI	43	/* USB */
+#define IRQ_NOR		44	/* NOR Flash Controller */
+#define IRQ_PS2MOUSE	45	/* PS/2 Mouse */
+#define IRQ_PS2KBD	46	/* PS/2 Keyboard */
+#define IRQ_UART2	47	/* UART 2 */
+#define IRQ_RTC		48	/* RTC Interrupt */
+#define IRQ_RTCSM	49	/* RTC Second/Minute Update Interrupt */
+#define IRQ_UART3	50	/* UART 3 */
+#define IRQ_ADC		51	/* ADC */
+#define IRQ_EXT5	52	/* External Interrupt 5 */
+#define IRQ_EXT6	53	/* External Interrupt 6 */
+#define IRQ_EXT7	54	/* External Interrupt 7 */
+#define IRQ_CIR		55	/* CIR */
+#define IRQ_DMA0	56	/* DMA Channel 0 */
+#define IRQ_DMA1	57	/* DMA Channel 1 */
+#define IRQ_DMA2	58	/* DMA Channel 2 */
+#define IRQ_DMA3	59	/* DMA Channel 3 */
+#define IRQ_DMA4	60	/* DMA Channel 4 */
+#define IRQ_DMA5	61	/* DMA Channel 5 */
+#define IRQ_DMA6	62	/* DMA Channel 6 */
+#define IRQ_DMA7	63	/* DMA Channel 7 */
+
+#define VT8500_NR_IRQS		64
diff --git a/arch/arm/mach-vt8500/include/mach/vt8500_regs.h b/arch/arm/mach-vt8500/include/mach/vt8500_regs.h
new file mode 100644
index 0000000..29c63ec
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/vt8500_regs.h
@@ -0,0 +1,79 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/vt8500_regs.h
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
+#ifndef __ASM_ARM_ARCH_VT8500_REGS_H
+#define __ASM_ARM_ARCH_VT8500_REGS_H
+
+/* VT8500 Registers Map */
+
+#define VT8500_REGS_START_PHYS	0xd8000000	/* Start of MMIO registers */
+#define VT8500_REGS_START_VIRT	0xf8000000	/* Virtual mapping start */
+
+#define VT8500_DDR_BASE		0xd8000000	/* 1k	DDR/DDR2 Memory
+							Controller */
+#define VT8500_DMA_BASE		0xd8001000	/* 1k	DMA Controller */
+#define VT8500_SFLASH_BASE	0xd8002000	/* 1k	Serial Flash Memory
+							Controller */
+#define VT8500_ETHER_BASE	0xd8004000	/* 1k	Ethernet MAC 0 */
+#define VT8500_CIPHER_BASE	0xd8006000	/* 4k	Cipher */
+#define VT8500_USB_BASE		0xd8007800	/* 2k	USB OTG */
+# define VT8500_EHCI_BASE	0xd8007900	/*	EHCI */
+# define VT8500_UHCI_BASE	0xd8007b01	/*	UHCI */
+#define VT8500_PATA_BASE	0xd8008000	/* 512	PATA */
+#define VT8500_PS2_BASE		0xd8008800	/* 1k	PS/2 */
+#define VT8500_NAND_BASE	0xd8009000	/* 1k	NAND Controller */
+#define VT8500_NOR_BASE		0xd8009400	/* 1k	NOR Controller */
+#define VT8500_SDMMC_BASE	0xd800a000	/* 1k	SD/MMC Controller */
+#define VT8500_MS_BASE		0xd800b000	/* 1k	MS/MSPRO Controller */
+#define VT8500_LCDC_BASE	0xd800e400	/* 1k	LCD Controller */
+#define VT8500_VPU_BASE		0xd8050000	/* 256	VPU */
+#define VT8500_GOV_BASE		0xd8050300	/* 256	GOV */
+#define VT8500_GEGEA_BASE	0xd8050400	/* 768	GE/GE Alpha Mixing */
+#define VT8500_LCDF_BASE	0xd8050900	/* 256	LCD Formatter */
+#define VT8500_VID_BASE		0xd8050a00	/* 256	VID */
+#define VT8500_VPP_BASE		0xd8050b00	/* 256	VPP */
+#define VT8500_TSBK_BASE	0xd80f4000	/* 4k	TSBK */
+#define VT8500_JPEGDEC_BASE	0xd80fe000	/* 4k	JPEG Decoder */
+#define VT8500_JPEGENC_BASE	0xd80ff000	/* 4k	JPEG Encoder */
+#define VT8500_RTC_BASE		0xd8100000	/* 64k	RTC */
+#define VT8500_GPIO_BASE	0xd8110000	/* 64k	GPIO Configuration */
+#define VT8500_SCC_BASE		0xd8120000	/* 64k	System Configuration*/
+#define VT8500_PMC_BASE		0xd8130000	/* 64k	PMC Configuration */
+#define VT8500_IC_BASE		0xd8140000	/* 64k	Interrupt Controller*/
+#define VT8500_UART0_BASE	0xd8200000	/* 64k	UART 0 */
+#define VT8500_UART2_BASE	0xd8210000	/* 64k	UART 2 */
+#define VT8500_PWM_BASE		0xd8220000	/* 64k	PWM Configuration */
+#define VT8500_SPI0_BASE	0xd8240000	/* 64k	SPI 0 */
+#define VT8500_SPI1_BASE	0xd8250000	/* 64k	SPI 1 */
+#define VT8500_CIR_BASE		0xd8270000	/* 64k	CIR */
+#define VT8500_I2C0_BASE	0xd8280000	/* 64k	I2C 0 */
+#define VT8500_AC97_BASE	0xd8290000	/* 64k	AC97 */
+#define VT8500_SPI2_BASE	0xd82a0000	/* 64k	SPI 2 */
+#define VT8500_UART1_BASE	0xd82b0000	/* 64k	UART 1 */
+#define VT8500_UART3_BASE	0xd82c0000	/* 64k	UART 3 */
+#define VT8500_PCM_BASE		0xd82d0000	/* 64k	PCM */
+#define VT8500_I2C1_BASE	0xd8320000	/* 64k	I2C 1 */
+#define VT8500_I2S_BASE		0xd8330000	/* 64k	I2S */
+#define VT8500_ADC_BASE		0xd8340000	/* 64k	ADC */
+
+#define VT8500_REGS_END_PHYS	0xd834ffff	/* End of MMIO registers */
+#define VT8500_REGS_LENGTH	(VT8500_REGS_END_PHYS \
+				- VT8500_REGS_START_PHYS + 1)
+
+#endif
diff --git a/arch/arm/mach-vt8500/include/mach/vt8500fb.h b/arch/arm/mach-vt8500/include/mach/vt8500fb.h
new file mode 100644
index 0000000..7f399c3
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
+	u32			xres_virtual;
+	u32			yres_virtual;
+	u32			bpp;
+	unsigned long		video_mem_phys;
+	void			*video_mem_virt;
+	unsigned long		video_mem_len;
+};
+
+#endif /* _VT8500FB_H */
diff --git a/arch/arm/mach-vt8500/include/mach/wm8505_irqs.h b/arch/arm/mach-vt8500/include/mach/wm8505_irqs.h
new file mode 100644
index 0000000..6128627
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/wm8505_irqs.h
@@ -0,0 +1,115 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/wm8505_irqs.h
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
+/* WM8505 Interrupt Sources */
+
+#define IRQ_UHCI	0	/* UHC FS (UHCI?) */
+#define IRQ_EHCI	1	/* UHC HS */
+#define IRQ_UDCDMA	2	/* UDC DMA */
+				/* Reserved */
+#define IRQ_PS2MOUSE	4	/* PS/2 Mouse */
+#define IRQ_UDC		5	/* UDC */
+#define IRQ_EXT0	6	/* External Interrupt 0 */
+#define IRQ_EXT1	7	/* External Interrupt 1 */
+#define IRQ_KEYPAD	8	/* Keypad */
+#define IRQ_DMA		9	/* DMA Controller */
+#define IRQ_ETHER	10	/* Ethernet MAC */
+				/* Reserved */
+				/* Reserved */
+#define IRQ_EXT2	13	/* External Interrupt 2 */
+#define IRQ_EXT3	14	/* External Interrupt 3 */
+#define IRQ_EXT4	15	/* External Interrupt 4 */
+#define IRQ_APB		16	/* APB Bridge */
+#define IRQ_DMA0	17	/* DMA Channel 0 */
+#define IRQ_I2C1	18	/* I2C 1 */
+#define IRQ_I2C0	19	/* I2C 0 */
+#define IRQ_SDMMC	20	/* SD/MMC Controller */
+#define IRQ_SDMMC_DMA	21	/* SD/MMC Controller DMA */
+#define IRQ_PMC_WU	22	/* Power Management Controller Wakeup */
+#define IRQ_PS2KBD	23	/* PS/2 Keyboard */
+#define IRQ_SPI0	24	/* SPI 0 */
+#define IRQ_SPI1	25	/* SPI 1 */
+#define IRQ_SPI2	26	/* SPI 2 */
+#define IRQ_DMA1	27	/* DMA Channel 1 */
+#define IRQ_NAND	28	/* NAND Flash Controller */
+#define IRQ_NAND_DMA	29	/* NAND Flash Controller DMA */
+#define IRQ_UART5	30	/* UART 5 */
+#define IRQ_UART4	31	/* UART 4 */
+#define IRQ_UART0	32	/* UART 0 */
+#define IRQ_UART1	33	/* UART 1 */
+#define IRQ_DMA2	34	/* DMA Channel 2 */
+#define IRQ_I2S		35	/* I2S */
+#define IRQ_PMCOS0	36	/* PMC OS Timer 0 */
+#define IRQ_PMCOS1	37	/* PMC OS Timer 1 */
+#define IRQ_PMCOS2	38	/* PMC OS Timer 2 */
+#define IRQ_PMCOS3	39	/* PMC OS Timer 3 */
+#define IRQ_DMA3	40	/* DMA Channel 3 */
+#define IRQ_DMA4	41	/* DMA Channel 4 */
+#define IRQ_AC97	42	/* AC97 Interface */
+				/* Reserved */
+#define IRQ_NOR		44	/* NOR Flash Controller */
+#define IRQ_DMA5	45	/* DMA Channel 5 */
+#define IRQ_DMA6	46	/* DMA Channel 6 */
+#define IRQ_UART2	47	/* UART 2 */
+#define IRQ_RTC		48	/* RTC Interrupt */
+#define IRQ_RTCSM	49	/* RTC Second/Minute Update Interrupt */
+#define IRQ_UART3	50	/* UART 3 */
+#define IRQ_DMA7	51	/* DMA Channel 7 */
+#define IRQ_EXT5	52	/* External Interrupt 5 */
+#define IRQ_EXT6	53	/* External Interrupt 6 */
+#define IRQ_EXT7	54	/* External Interrupt 7 */
+#define IRQ_CIR		55	/* CIR */
+#define IRQ_SIC0	56	/* SIC IRQ0 */
+#define IRQ_SIC1	57	/* SIC IRQ1 */
+#define IRQ_SIC2	58	/* SIC IRQ2 */
+#define IRQ_SIC3	59	/* SIC IRQ3 */
+#define IRQ_SIC4	60	/* SIC IRQ4 */
+#define IRQ_SIC5	61	/* SIC IRQ5 */
+#define IRQ_SIC6	62	/* SIC IRQ6 */
+#define IRQ_SIC7	63	/* SIC IRQ7 */
+				/* Reserved */
+#define IRQ_JPEGDEC	65	/* JPEG Decoder */
+#define IRQ_SAE		66	/* SAE (?) */
+				/* Reserved */
+#define IRQ_VPU		79	/* Video Processing Unit */
+#define IRQ_VPP		80	/* Video Post-Processor */
+#define IRQ_VID		81	/* Video Digital Input Interface */
+#define IRQ_SPU		82	/* SPU (?) */
+#define IRQ_PIP		83	/* PIP Error */
+#define IRQ_GE		84	/* Graphic Engine */
+#define IRQ_GOV		85	/* Graphic Overlay Engine */
+#define IRQ_DVO		86	/* Digital Video Output */
+				/* Reserved */
+#define IRQ_DMA8	92	/* DMA Channel 8 */
+#define IRQ_DMA9	93	/* DMA Channel 9 */
+#define IRQ_DMA10	94	/* DMA Channel 10 */
+#define IRQ_DMA11	95	/* DMA Channel 11 */
+#define IRQ_DMA12	96	/* DMA Channel 12 */
+#define IRQ_DMA13	97	/* DMA Channel 13 */
+#define IRQ_DMA14	98	/* DMA Channel 14 */
+#define IRQ_DMA15	99	/* DMA Channel 15 */
+				/* Reserved */
+#define IRQ_GOVW	111	/* GOVW (?) */
+#define IRQ_GOVRSDSCD	112	/* GOVR SDSCD (?) */
+#define IRQ_GOVRSDMIF	113	/* GOVR SDMIF (?) */
+#define IRQ_GOVRHDSCD	114	/* GOVR HDSCD (?) */
+#define IRQ_GOVRHDMIF	115	/* GOVR HDMIF (?) */
+
+#define WM8505_NR_IRQS		116
diff --git a/arch/arm/mach-vt8500/include/mach/wm8505_regs.h b/arch/arm/mach-vt8500/include/mach/wm8505_regs.h
new file mode 100644
index 0000000..df15509
--- /dev/null
+++ b/arch/arm/mach-vt8500/include/mach/wm8505_regs.h
@@ -0,0 +1,78 @@
+/*
+ *  arch/arm/mach-vt8500/include/mach/wm8505_regs.h
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
+#ifndef __ASM_ARM_ARCH_WM8505_REGS_H
+#define __ASM_ARM_ARCH_WM8505_REGS_H
+
+/* WM8505 Registers Map */
+
+#define WM8505_REGS_START_PHYS	0xd8000000	/* Start of MMIO registers */
+#define WM8505_REGS_START_VIRT	0xf8000000	/* Virtual mapping start */
+
+#define WM8505_DDR_BASE		0xd8000400	/* 1k	DDR/DDR2 Memory
+							Controller */
+#define WM8505_DMA_BASE		0xd8001800	/* 1k	DMA Controller */
+#define WM8505_VDMA_BASE	0xd8001c00	/* 1k	VDMA */
+#define WM8505_SFLASH_BASE	0xd8002000	/* 1k	Serial Flash Memory
+							Controller */
+#define WM8505_ETHER_BASE	0xd8004000	/* 1k	Ethernet MAC 0 */
+#define WM8505_CIPHER_BASE	0xd8006000	/* 4k	Cipher */
+#define WM8505_USB_BASE		0xd8007000	/* 2k	USB 2.0 Host */
+# define WM8505_EHCI_BASE	0xd8007100	/*	EHCI */
+# define WM8505_UHCI_BASE	0xd8007301	/*	UHCI */
+#define WM8505_PS2_BASE		0xd8008800	/* 1k	PS/2 */
+#define WM8505_NAND_BASE	0xd8009000	/* 1k	NAND Controller */
+#define WM8505_NOR_BASE		0xd8009400	/* 1k	NOR Controller */
+#define WM8505_SDMMC_BASE	0xd800a000	/* 1k	SD/MMC Controller */
+#define WM8505_VPU_BASE		0xd8050000	/* 256	VPU */
+#define WM8505_GOV_BASE		0xd8050300	/* 256	GOV */
+#define WM8505_GEGEA_BASE	0xd8050400	/* 768	GE/GE Alpha Mixing */
+#define WM8505_GOVR_BASE	0xd8050800	/* 512	GOVR (frambuffer) */
+#define WM8505_VID_BASE		0xd8050a00	/* 256	VID */
+#define WM8505_SCL_BASE		0xd8050d00	/* 256	SCL */
+#define WM8505_VPP_BASE		0xd8050f00	/* 256	VPP */
+#define WM8505_JPEGDEC_BASE	0xd80fe000	/* 4k	JPEG Decoder */
+#define WM8505_RTC_BASE		0xd8100000	/* 64k	RTC */
+#define WM8505_GPIO_BASE	0xd8110000	/* 64k	GPIO Configuration */
+#define WM8505_SCC_BASE		0xd8120000	/* 64k	System Configuration*/
+#define WM8505_PMC_BASE		0xd8130000	/* 64k	PMC Configuration */
+#define WM8505_IC_BASE		0xd8140000	/* 64k	Interrupt Controller*/
+#define WM8505_SIC_BASE		0xd8150000	/* 64k	Secondary IC */
+#define WM8505_UART0_BASE	0xd8200000	/* 64k	UART 0 */
+#define WM8505_UART2_BASE	0xd8210000	/* 64k	UART 2 */
+#define WM8505_PWM_BASE		0xd8220000	/* 64k	PWM Configuration */
+#define WM8505_SPI0_BASE	0xd8240000	/* 64k	SPI 0 */
+#define WM8505_SPI1_BASE	0xd8250000	/* 64k	SPI 1 */
+#define WM8505_KEYPAD_BASE	0xd8260000	/* 64k	Keypad control */
+#define WM8505_CIR_BASE		0xd8270000	/* 64k	CIR */
+#define WM8505_I2C0_BASE	0xd8280000	/* 64k	I2C 0 */
+#define WM8505_AC97_BASE	0xd8290000	/* 64k	AC97 */
+#define WM8505_SPI2_BASE	0xd82a0000	/* 64k	SPI 2 */
+#define WM8505_UART1_BASE	0xd82b0000	/* 64k	UART 1 */
+#define WM8505_UART3_BASE	0xd82c0000	/* 64k	UART 3 */
+#define WM8505_I2C1_BASE	0xd8320000	/* 64k	I2C 1 */
+#define WM8505_I2S_BASE		0xd8330000	/* 64k	I2S */
+#define WM8505_UART4_BASE	0xd8370000	/* 64k	UART 4 */
+#define WM8505_UART5_BASE	0xd8380000	/* 64k	UART 5 */
+
+#define WM8505_REGS_END_PHYS	0xd838ffff	/* End of MMIO registers */
+#define WM8505_REGS_LENGTH	(WM8505_REGS_END_PHYS \
+				- WM8505_REGS_START_PHYS + 1)
+
+#endif
diff --git a/arch/arm/mach-vt8500/irq.c b/arch/arm/mach-vt8500/irq.c
new file mode 100644
index 0000000..5f4ddde
--- /dev/null
+++ b/arch/arm/mach-vt8500/irq.c
@@ -0,0 +1,177 @@
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
+#include "devices.h"
+
+#define VT8500_IC_DCTR		0x40		/* Destination control
+						register, 64*u8 */
+#define VT8500_INT_ENABLE	(1 << 3)
+#define VT8500_TRIGGER_HIGH	(0 << 4)
+#define VT8500_TRIGGER_RISING	(1 << 4)
+#define VT8500_TRIGGER_FALLING	(2 << 4)
+#define VT8500_EDGE		( VT8500_TRIGGER_RISING \
+				| VT8500_TRIGGER_FALLING)
+#define VT8500_IC_STATUS	0x80		/* Interrupt status, 2*u32 */
+
+static void __iomem *ic_regbase;
+static void __iomem *sic_regbase;
+
+static void vt8500_irq_mask(unsigned int irq)
+{
+	void __iomem *base = ic_regbase;
+	u8 edge;
+
+	if (irq >= 64) {
+		base = sic_regbase;
+		irq -= 64;
+	}
+	edge = readb(base + VT8500_IC_DCTR + irq) & VT8500_EDGE;
+	if (edge) {
+		void __iomem *stat_reg = base + VT8500_IC_STATUS
+						+ (irq < 32 ? 0 : 4);
+		unsigned status = readl(stat_reg);
+
+		status |= (1 << (irq & 0x1f));
+		writel(status, stat_reg);
+	} else {
+		u8 dctr = readb(base + VT8500_IC_DCTR + irq);
+
+		dctr &= ~VT8500_INT_ENABLE;
+		writeb(dctr, base + VT8500_IC_DCTR + irq);
+	}
+}
+
+static void vt8500_irq_unmask(unsigned int irq)
+{
+	void __iomem *base = ic_regbase;
+	u8 dctr;
+
+	if (irq >= 64) {
+		base = sic_regbase;
+		irq -= 64;
+	}
+	dctr = readb(base + VT8500_IC_DCTR + irq);
+	dctr |= VT8500_INT_ENABLE;
+	writeb(dctr, base + VT8500_IC_DCTR + irq);
+}
+
+static int vt8500_irq_set_type(unsigned int irq, unsigned int flow_type)
+{
+	void __iomem *base = ic_regbase;
+	unsigned int orig_irq = irq;
+	u8 dctr;
+
+	if (irq >= 64) {
+		base = sic_regbase;
+		irq -= 64;
+	}
+
+	dctr = readb(base + VT8500_IC_DCTR + irq);
+	dctr &= ~VT8500_EDGE;
+
+	switch (flow_type) {
+	case IRQF_TRIGGER_LOW:
+		return -EINVAL;
+	case IRQF_TRIGGER_HIGH:
+		dctr |= VT8500_TRIGGER_HIGH;
+		irq_desc[orig_irq].handle_irq = handle_level_irq;
+		break;
+	case IRQF_TRIGGER_FALLING:
+		dctr |= VT8500_TRIGGER_FALLING;
+		irq_desc[orig_irq].handle_irq = handle_edge_irq;
+		break;
+	case IRQF_TRIGGER_RISING:
+		dctr |= VT8500_TRIGGER_RISING;
+		irq_desc[orig_irq].handle_irq = handle_edge_irq;
+		break;
+	}
+	writeb(dctr, base + VT8500_IC_DCTR + irq);
+
+	return 0;
+}
+
+static struct irq_chip vt8500_irq_chip = {
+	.name      = "vt8500",
+	.ack       = vt8500_irq_mask,
+	.mask      = vt8500_irq_mask,
+	.unmask    = vt8500_irq_unmask,
+	.set_type  = vt8500_irq_set_type,
+};
+
+void __init vt8500_init_irq(void)
+{
+	unsigned int i;
+
+	ic_regbase = ioremap(wmt_ic_base, SZ_64K);
+
+	if (ic_regbase) {
+		/* Enable rotating priority for IRQ */
+		writel((1 << 6), ic_regbase + 0x20);
+		writel(0, ic_regbase + 0x24);
+
+		for (i = 0; i < wmt_nr_irqs; i++) {
+			/* Disable all interrupts and route them to IRQ */
+			writeb(0x00, ic_regbase + VT8500_IC_DCTR + i);
+
+			set_irq_chip(i, &vt8500_irq_chip);
+			set_irq_handler(i, handle_level_irq);
+			set_irq_flags(i, IRQF_VALID);
+		}
+	} else {
+		printk(KERN_ERR "Unable to remap the Interrupt Controller registers, not enabling IRQs!\n");
+	}
+}
+
+void __init wm8505_init_irq(void)
+{
+	unsigned int i;
+
+	ic_regbase = ioremap(wmt_ic_base, SZ_64K);
+	sic_regbase = ioremap(wmt_sic_base, SZ_64K);
+
+	if (ic_regbase && sic_regbase) {
+		/* Enable rotating priority for IRQ */
+		writel((1 << 6), ic_regbase + 0x20);
+		writel(0, ic_regbase + 0x24);
+		writel((1 << 6), sic_regbase + 0x20);
+		writel(0, sic_regbase + 0x24);
+
+		for (i = 0; i < wmt_nr_irqs; i++) {
+			/* Disable all interrupts and route them to IRQ */
+			if (i < 64)
+				writeb(0x00, ic_regbase + VT8500_IC_DCTR + i);
+			else
+				writeb(0x00, sic_regbase + VT8500_IC_DCTR
+								+ i - 64);
+
+			set_irq_chip(i, &vt8500_irq_chip);
+			set_irq_handler(i, handle_level_irq);
+			set_irq_flags(i, IRQF_VALID);
+		}
+	} else {
+		printk(KERN_ERR "Unable to remap the Interrupt Controller registers, not enabling IRQs!\n");
+	}
+}
diff --git a/arch/arm/mach-vt8500/pwm.c b/arch/arm/mach-vt8500/pwm.c
new file mode 100644
index 0000000..8ad825e
--- /dev/null
+++ b/arch/arm/mach-vt8500/pwm.c
@@ -0,0 +1,265 @@
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
+#include <linux/delay.h>
+
+#include <asm/div64.h>
+
+#define VT8500_NR_PWMS 4
+
+static DEFINE_MUTEX(pwm_lock);
+static LIST_HEAD(pwm_list);
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
+#define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
+static inline void pwm_busy_wait(void __iomem *reg, u8 bitmask)
+{
+	int loops = msecs_to_loops(10);
+	while ((readb(reg) & bitmask) && --loops)
+		cpu_relax();
+
+	if (unlikely(!loops))
+		pr_warning("Waiting for status bits 0x%x to clear timed out\n",
+			   bitmask);
+}
+
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
+	c = (unsigned long long)pv * duty_ns;
+	do_div(c, period_ns);
+	dc = c;
+
+	pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 1));
+	writel(prescale, pwm->regbase + 0x4 + (pwm->pwm_id << 4));
+
+	pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 2));
+	writel(pv, pwm->regbase + 0x8 + (pwm->pwm_id << 4));
+
+	pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 3));
+	writel(dc, pwm->regbase + 0xc + (pwm->pwm_id << 4));
+
+	return 0;
+}
+EXPORT_SYMBOL(pwm_config);
+
+int pwm_enable(struct pwm_device *pwm)
+{
+	pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 0));
+	writel(5, pwm->regbase + (pwm->pwm_id << 4));
+	return 0;
+}
+EXPORT_SYMBOL(pwm_enable);
+
+void pwm_disable(struct pwm_device *pwm)
+{
+	pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 0));
+	writel(0, pwm->regbase + (pwm->pwm_id << 4));
+}
+EXPORT_SYMBOL(pwm_disable);
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
+		} else {
+			pwm = ERR_PTR(-EBUSY);
+		}
+	} else {
+		pwm = ERR_PTR(-ENOENT);
+	}
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
+	} else {
+		pr_warning("PWM device already freed\n");
+	}
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
+		pwms[i].regbase = pwms[0].regbase;
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
index 0000000..d5376c5
--- /dev/null
+++ b/arch/arm/mach-vt8500/timer.c
@@ -0,0 +1,155 @@
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
+#include <linux/delay.h>
+
+#include <asm/mach/time.h>
+
+#include "devices.h"
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
+#define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
+
+static void __iomem *regbase;
+
+static cycle_t vt8500_timer_read(struct clocksource *cs)
+{
+	int loops = msecs_to_loops(10);
+	writel(3, regbase + TIMER_CTRL_VAL);
+	while ((readl((regbase + TIMER_AS_VAL)) & TIMER_COUNT_R_ACTIVE)
+						&& --loops)
+		cpu_relax();
+	return readl(regbase + TIMER_COUNT_VAL);
+}
+
+struct clocksource clocksource = {
+	.name           = "vt8500_timer",
+	.rating         = 200,
+	.read           = vt8500_timer_read,
+	.mask           = CLOCKSOURCE_MASK(32),
+	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int vt8500_timer_set_next_event(unsigned long cycles,
+				    struct clock_event_device *evt)
+{
+	int loops = msecs_to_loops(10);
+	cycle_t alarm = clocksource.read(&clocksource) + cycles;
+	while ((readl(regbase + TIMER_AS_VAL) & TIMER_MATCH_W_ACTIVE)
+						&& --loops)
+		cpu_relax();
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
+	regbase = ioremap(wmt_pmc_base + VT8500_TIMER_OFFSET, 0x28);
+	if (!regbase)
+		printk(KERN_ERR "vt8500_timer_init: failed to map MMIO registers\n");
+
+	writel(1, regbase + TIMER_CTRL_VAL);
+	writel(0xf, regbase + TIMER_STATUS_VAL);
+	writel(~0, regbase + TIMER_MATCH_VAL);
+
+	if (clocksource_register_hz(&clocksource, VT8500_TIMER_HZ))
+		printk(KERN_ERR "vt8500_timer_init: clocksource_register failed for %s\n",
+					clocksource.name);
+
+	clockevents_calc_mult_shift(&clockevent, VT8500_TIMER_HZ, 4);
+
+	/* copy-pasted from mach-msm; no idea */
+	clockevent.max_delta_ns =
+		clockevent_delta2ns(0xf0000000, &clockevent);
+	clockevent.min_delta_ns = clockevent_delta2ns(4, &clockevent);
+	clockevent.cpumask = cpumask_of(0);
+
+	if (setup_irq(wmt_timer_irq, &irq))
+		printk(KERN_ERR "vt8500_timer_init: setup_irq failed for %s\n",
+					clockevent.name);
+	clockevents_register_device(&clockevent);
+}
+
+struct sys_timer vt8500_timer = {
+	.init = vt8500_timer_init
+};
diff --git a/arch/arm/mach-vt8500/wm8505_7in.c b/arch/arm/mach-vt8500/wm8505_7in.c
new file mode 100644
index 0000000..e73aadb
--- /dev/null
+++ b/arch/arm/mach-vt8500/wm8505_7in.c
@@ -0,0 +1,77 @@
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
+#include <linux/io.h>
+#include <linux/pm.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
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
+	void __iomem *gpio_mux_reg = ioremap(wmt_gpio_base + 0x200, 4);
+	if (gpio_mux_reg) {
+		writel(readl(gpio_mux_reg) | 0x80000000, gpio_mux_reg);
+		iounmap(gpio_mux_reg);
+	} else {
+		printk(KERN_ERR "Could not remap the GPIO mux register, display may not work properly!\n");
+	}
+#endif
+	pmc_hiber = ioremap(wmt_pmc_base + 0x12, 2);
+	if (pmc_hiber)
+		pm_power_off = &vt8500_power_off;
+	else
+		printk(KERN_ERR "PMC Hibernation register could not be remapped, not enabling power off!\n");
+
+	wm8505_set_resources();
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+	vt8500_gpio_init();
+}
+
+MACHINE_START(WM8505_7IN_NETBOOK, "WM8505 7-inch generic netbook")
+	.boot_params	= 0x00000100,
+	.reserve	= wm8505_reserve_mem,
+	.map_io		= wm8505_map_io,
+	.init_irq	= wm8505_init_irq,
+	.timer		= &vt8500_timer,
+	.init_machine	= wm8505_7in_init,
+MACHINE_END
-- 
1.7.3.4

