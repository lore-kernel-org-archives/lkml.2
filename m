Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab1E3Ooc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:44:32 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61439 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab1E3Oo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:44:29 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 2/4] ARM: mxc: migrate mach-mx5 gpio driver to gpio-mxc
Date: Mon, 30 May 2011 22:52:17 +0800
Message-Id: <1306767139-24763-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It adds platform device for drivers/gpio/gpio-mxc, and migrates
mx50/mx51/mx53 gpio driver to gpio-mxc.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/mach-mx5/devices.c                     |   64 ---------------------
 arch/arm/mach-mx5/mm-mx50.c                     |   11 ----
 arch/arm/mach-mx5/mm.c                          |    6 --
 arch/arm/plat-mxc/devices.c                     |   11 ++++
 arch/arm/plat-mxc/devices/Makefile              |    1 +
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c   |   69 +++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/devices-common.h |    2 +
 7 files changed, 83 insertions(+), 81 deletions(-)
 create mode 100644 arch/arm/plat-mxc/devices/platform-gpio-mxc.c

diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
index 153ada5..371ca8c 100644
--- a/arch/arm/mach-mx5/devices.c
+++ b/arch/arm/mach-mx5/devices.c
@@ -12,7 +12,6 @@
 
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <linux/gpio.h>
 #include <mach/hardware.h>
 #include <mach/imx-uart.h>
 #include <mach/irqs.h>
@@ -119,66 +118,3 @@ struct platform_device mxc_usbh2_device = {
 		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
-
-static struct mxc_gpio_port mxc_gpio_ports[] = {
-	{
-		.chip.label = "gpio-0",
-		.base = MX51_IO_ADDRESS(MX51_GPIO1_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO1_LOW,
-		.irq_high = MX51_MXC_INT_GPIO1_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START
-	},
-	{
-		.chip.label = "gpio-1",
-		.base = MX51_IO_ADDRESS(MX51_GPIO2_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO2_LOW,
-		.irq_high = MX51_MXC_INT_GPIO2_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 1
-	},
-	{
-		.chip.label = "gpio-2",
-		.base = MX51_IO_ADDRESS(MX51_GPIO3_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO3_LOW,
-		.irq_high = MX51_MXC_INT_GPIO3_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 2
-	},
-	{
-		.chip.label = "gpio-3",
-		.base = MX51_IO_ADDRESS(MX51_GPIO4_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO4_LOW,
-		.irq_high = MX51_MXC_INT_GPIO4_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3
-	},
-	{
-		.chip.label = "gpio-4",
-		.base = MX53_IO_ADDRESS(MX53_GPIO5_BASE_ADDR),
-		.irq = MX53_INT_GPIO5_LOW,
-		.irq_high = MX53_INT_GPIO5_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 4
-	},
-	{
-		.chip.label = "gpio-5",
-		.base = MX53_IO_ADDRESS(MX53_GPIO6_BASE_ADDR),
-		.irq = MX53_INT_GPIO6_LOW,
-		.irq_high = MX53_INT_GPIO6_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 5
-	},
-	{
-		.chip.label = "gpio-6",
-		.base = MX53_IO_ADDRESS(MX53_GPIO7_BASE_ADDR),
-		.irq = MX53_INT_GPIO7_LOW,
-		.irq_high = MX53_INT_GPIO7_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 6
-	},
-};
-
-int __init imx51_register_gpios(void)
-{
-	return mxc_gpio_init(mxc_gpio_ports, 4);
-}
-
-int __init imx53_register_gpios(void)
-{
-	return mxc_gpio_init(mxc_gpio_ports, ARRAY_SIZE(mxc_gpio_ports));
-}
-
diff --git a/arch/arm/mach-mx5/mm-mx50.c b/arch/arm/mach-mx5/mm-mx50.c
index b9c363b..e1377ca 100644
--- a/arch/arm/mach-mx5/mm-mx50.c
+++ b/arch/arm/mach-mx5/mm-mx50.c
@@ -26,7 +26,6 @@
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 /*
@@ -56,17 +55,7 @@ void __init imx50_init_early(void)
 	mxc_arch_reset_init(MX50_IO_ADDRESS(MX50_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx50_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 0, 1, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 1, 2, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 2, 3, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 3, 4, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 4, 5, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 5, 6, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-};
-
 void __init mx50_init_irq(void)
 {
 	tzic_init_irq(MX50_IO_ADDRESS(MX50_TZIC_BASE_ADDR));
-	mxc_gpio_init(imx50_gpio_ports,	ARRAY_SIZE(imx50_gpio_ports));
 }
diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
index ff55730..ccc6ceb 100644
--- a/arch/arm/mach-mx5/mm.c
+++ b/arch/arm/mach-mx5/mm.c
@@ -69,8 +69,6 @@ void __init imx53_init_early(void)
 	mxc_arch_reset_init(MX53_IO_ADDRESS(MX53_WDOG1_BASE_ADDR));
 }
 
-int imx51_register_gpios(void);
-
 void __init mx51_init_irq(void)
 {
 	unsigned long tzic_addr;
@@ -86,11 +84,8 @@ void __init mx51_init_irq(void)
 		panic("unable to map TZIC interrupt controller\n");
 
 	tzic_init_irq(tzic_virt);
-	imx51_register_gpios();
 }
 
-int imx53_register_gpios(void);
-
 void __init mx53_init_irq(void)
 {
 	unsigned long tzic_addr;
@@ -103,5 +98,4 @@ void __init mx53_init_irq(void)
 		panic("unable to map TZIC interrupt controller\n");
 
 	tzic_init_irq(tzic_virt);
-	imx53_register_gpios();
 }
diff --git a/arch/arm/plat-mxc/devices.c b/arch/arm/plat-mxc/devices.c
index eee1b60..fb166b2 100644
--- a/arch/arm/plat-mxc/devices.c
+++ b/arch/arm/plat-mxc/devices.c
@@ -89,3 +89,14 @@ err:
 
 	return pdev;
 }
+
+struct device mxc_aips_bus = {
+	.init_name	= "mxc_aips",
+	.parent		= &platform_bus,
+};
+
+static int __init mxc_device_init(void)
+{
+	return device_register(&mxc_aips_bus);
+}
+core_initcall(mxc_device_init);
diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
index ad2922a..b41bf97 100644
--- a/arch/arm/plat-mxc/devices/Makefile
+++ b/arch/arm/plat-mxc/devices/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_FEC) += platform-fec.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_FLEXCAN) += platform-flexcan.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_FSL_USB2_UDC) += platform-fsl-usb2-udc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_GPIO_KEYS) += platform-gpio_keys.o
+obj-y += platform-gpio-mxc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX21_HCD) += platform-imx21-hcd.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX2_WDT) += platform-imx2-wdt.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMXDI_RTC) += platform-imxdi_rtc.o
diff --git a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
new file mode 100644
index 0000000..3b10da0
--- /dev/null
+++ b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright 2011 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2011 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#include <linux/compiler.h>
+#include <linux/err.h>
+#include <linux/init.h>
+
+#include <mach/hardware.h>
+#include <mach/devices-common.h>
+
+static struct platform_device *__init mxc_add_gpio(int id,
+	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high)
+{
+	struct resource res[] = {
+		{
+			.start = iobase,
+			.end = iobase + iosize - 1,
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = irq,
+			.end = irq,
+			.flags = IORESOURCE_IRQ,
+		}, {
+			.start = irq_high,
+			.end = irq_high,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+
+	return platform_device_register_resndata(&mxc_aips_bus,
+			"gpio-mxc", id, res, ARRAY_SIZE(res), NULL, 0);
+}
+
+static int __init mxc_add_mxc_gpio(void)
+{
+	if (cpu_is_mx50()) {
+		mxc_add_gpio(0, MX50_GPIO1_BASE_ADDR, SZ_16K, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH);
+		mxc_add_gpio(1, MX50_GPIO2_BASE_ADDR, SZ_16K, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH);
+		mxc_add_gpio(2, MX50_GPIO3_BASE_ADDR, SZ_16K, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH);
+		mxc_add_gpio(3, MX50_GPIO4_BASE_ADDR, SZ_16K, MX50_INT_GPIO4_LOW, MX50_INT_GPIO4_HIGH);
+		mxc_add_gpio(4, MX50_GPIO5_BASE_ADDR, SZ_16K, MX50_INT_GPIO5_LOW, MX50_INT_GPIO5_HIGH);
+		mxc_add_gpio(5, MX50_GPIO6_BASE_ADDR, SZ_16K, MX50_INT_GPIO6_LOW, MX50_INT_GPIO6_HIGH);
+	}
+
+	if (cpu_is_mx51()) {
+		mxc_add_gpio(0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
+		mxc_add_gpio(1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
+		mxc_add_gpio(2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
+		mxc_add_gpio(3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
+	}
+
+	if (cpu_is_mx53()) {
+		mxc_add_gpio(0, MX53_GPIO1_BASE_ADDR, SZ_16K, MX53_INT_GPIO1_LOW, MX53_INT_GPIO1_HIGH);
+		mxc_add_gpio(1, MX53_GPIO2_BASE_ADDR, SZ_16K, MX53_INT_GPIO2_LOW, MX53_INT_GPIO2_HIGH);
+		mxc_add_gpio(2, MX53_GPIO3_BASE_ADDR, SZ_16K, MX53_INT_GPIO3_LOW, MX53_INT_GPIO3_HIGH);
+		mxc_add_gpio(3, MX53_GPIO4_BASE_ADDR, SZ_16K, MX53_INT_GPIO4_LOW, MX53_INT_GPIO4_HIGH);
+		mxc_add_gpio(4, MX53_GPIO5_BASE_ADDR, SZ_16K, MX53_INT_GPIO5_LOW, MX53_INT_GPIO5_HIGH);
+		mxc_add_gpio(5, MX53_GPIO6_BASE_ADDR, SZ_16K, MX53_INT_GPIO6_LOW, MX53_INT_GPIO6_HIGH);
+		mxc_add_gpio(6, MX53_GPIO7_BASE_ADDR, SZ_16K, MX53_INT_GPIO7_LOW, MX53_INT_GPIO7_HIGH);
+	}
+
+	return 0;
+}
+postcore_initcall(mxc_add_mxc_gpio);
diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
index fa84773..03f6266 100644
--- a/arch/arm/plat-mxc/include/mach/devices-common.h
+++ b/arch/arm/plat-mxc/include/mach/devices-common.h
@@ -10,6 +10,8 @@
 #include <linux/platform_device.h>
 #include <linux/init.h>
 
+extern struct device mxc_aips_bus;
+
 struct platform_device *imx_add_platform_device_dmamask(
 		const char *name, int id,
 		const struct resource *res, unsigned int num_resources,
-- 
1.7.4.1

