Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1E3Oop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:44:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43888 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab1E3Oon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:44:43 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3/4] ARM: mxc: migrate mach-imx gpio driver to gpio-mxc
Date: Mon, 30 May 2011 22:52:18 +0800
Message-Id: <1306767139-24763-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It migrates mx1/mx21/mx25/mx27/mx31/mx35 gpio driver to
drivers/gpio/gpio-mxc.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/mach-imx/mm-imx1.c                   |    9 -----
 arch/arm/mach-imx/mm-imx21.c                  |   11 ------
 arch/arm/mach-imx/mm-imx25.c                  |    9 -----
 arch/arm/mach-imx/mm-imx27.c                  |   11 ------
 arch/arm/mach-imx/mm-imx31.c                  |    8 ----
 arch/arm/mach-imx/mm-imx35.c                  |    8 ----
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c |   44 +++++++++++++++++++++++++
 7 files changed, 44 insertions(+), 56 deletions(-)

diff --git a/arch/arm/mach-imx/mm-imx1.c b/arch/arm/mach-imx/mm-imx1.c
index 2e482ba..621ee4c 100644
--- a/arch/arm/mach-imx/mm-imx1.c
+++ b/arch/arm/mach-imx/mm-imx1.c
@@ -23,7 +23,6 @@
 
 #include <mach/common.h>
 #include <mach/hardware.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 #include <mach/iomux-v1.h>
 
@@ -44,15 +43,7 @@ void __init imx1_init_early(void)
 			MX1_NUM_GPIO_PORT);
 }
 
-static struct mxc_gpio_port imx1_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 0, 1, MX1_GPIO_INT_PORTA),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 1, 2, MX1_GPIO_INT_PORTB),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 2, 3, MX1_GPIO_INT_PORTC),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 3, 4, MX1_GPIO_INT_PORTD),
-};
-
 void __init mx1_init_irq(void)
 {
 	mxc_init_irq(MX1_IO_ADDRESS(MX1_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx1_gpio_ports,	ARRAY_SIZE(imx1_gpio_ports));
 }
diff --git a/arch/arm/mach-imx/mm-imx21.c b/arch/arm/mach-imx/mm-imx21.c
index 7a0c500..a00ffe1 100644
--- a/arch/arm/mach-imx/mm-imx21.c
+++ b/arch/arm/mach-imx/mm-imx21.c
@@ -24,7 +24,6 @@
 #include <mach/common.h>
 #include <asm/pgtable.h>
 #include <asm/mach/map.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 #include <mach/iomux-v1.h>
 
@@ -70,17 +69,7 @@ void __init imx21_init_early(void)
 			MX21_NUM_GPIO_PORT);
 }
 
-static struct mxc_gpio_port imx21_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX21, 0, 1, MX21_INT_GPIO),
-	DEFINE_IMX_GPIO_PORT(MX21, 1, 2),
-	DEFINE_IMX_GPIO_PORT(MX21, 2, 3),
-	DEFINE_IMX_GPIO_PORT(MX21, 3, 4),
-	DEFINE_IMX_GPIO_PORT(MX21, 4, 5),
-	DEFINE_IMX_GPIO_PORT(MX21, 5, 6),
-};
-
 void __init mx21_init_irq(void)
 {
 	mxc_init_irq(MX21_IO_ADDRESS(MX21_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx21_gpio_ports,	ARRAY_SIZE(imx21_gpio_ports));
 }
diff --git a/arch/arm/mach-imx/mm-imx25.c b/arch/arm/mach-imx/mm-imx25.c
index 02f7b5c..3866c88 100644
--- a/arch/arm/mach-imx/mm-imx25.c
+++ b/arch/arm/mach-imx/mm-imx25.c
@@ -27,7 +27,6 @@
 #include <mach/hardware.h>
 #include <mach/mx25.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 /*
@@ -57,16 +56,8 @@ void __init imx25_init_early(void)
 	mxc_arch_reset_init(MX25_IO_ADDRESS(MX25_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx25_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 0, 1, MX25_INT_GPIO1),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 1, 2, MX25_INT_GPIO2),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 2, 3, MX25_INT_GPIO3),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 3, 4, MX25_INT_GPIO4),
-};
-
 void __init mx25_init_irq(void)
 {
 	mxc_init_irq(MX25_IO_ADDRESS(MX25_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx25_gpio_ports,	ARRAY_SIZE(imx25_gpio_ports));
 }
 
diff --git a/arch/arm/mach-imx/mm-imx27.c b/arch/arm/mach-imx/mm-imx27.c
index a6761a3..b98eb7a 100644
--- a/arch/arm/mach-imx/mm-imx27.c
+++ b/arch/arm/mach-imx/mm-imx27.c
@@ -24,7 +24,6 @@
 #include <mach/common.h>
 #include <asm/pgtable.h>
 #include <asm/mach/map.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 #include <mach/iomux-v1.h>
 
@@ -70,17 +69,7 @@ void __init imx27_init_early(void)
 			MX27_NUM_GPIO_PORT);
 }
 
-static struct mxc_gpio_port imx27_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX27, 0, 1, MX27_INT_GPIO),
-	DEFINE_IMX_GPIO_PORT(MX27, 1, 2),
-	DEFINE_IMX_GPIO_PORT(MX27, 2, 3),
-	DEFINE_IMX_GPIO_PORT(MX27, 3, 4),
-	DEFINE_IMX_GPIO_PORT(MX27, 4, 5),
-	DEFINE_IMX_GPIO_PORT(MX27, 5, 6),
-};
-
 void __init mx27_init_irq(void)
 {
 	mxc_init_irq(MX27_IO_ADDRESS(MX27_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx27_gpio_ports,	ARRAY_SIZE(imx27_gpio_ports));
 }
diff --git a/arch/arm/mach-imx/mm-imx31.c b/arch/arm/mach-imx/mm-imx31.c
index 86b9b45..afcca7b 100644
--- a/arch/arm/mach-imx/mm-imx31.c
+++ b/arch/arm/mach-imx/mm-imx31.c
@@ -26,7 +26,6 @@
 #include <mach/common.h>
 #include <mach/hardware.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 static struct map_desc mx31_io_desc[] __initdata = {
@@ -53,14 +52,7 @@ void __init imx31_init_early(void)
 	mxc_arch_reset_init(MX31_IO_ADDRESS(MX31_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx31_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX31, 0, 1, MX31_INT_GPIO1),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX31, 1, 2, MX31_INT_GPIO2),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX31, 2, 3, MX31_INT_GPIO3),
-};
-
 void __init mx31_init_irq(void)
 {
 	mxc_init_irq(MX31_IO_ADDRESS(MX31_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx31_gpio_ports,	ARRAY_SIZE(imx31_gpio_ports));
 }
diff --git a/arch/arm/mach-imx/mm-imx35.c b/arch/arm/mach-imx/mm-imx35.c
index c880e6d..ac9d031 100644
--- a/arch/arm/mach-imx/mm-imx35.c
+++ b/arch/arm/mach-imx/mm-imx35.c
@@ -27,7 +27,6 @@
 #include <mach/common.h>
 #include <mach/hardware.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 static struct map_desc mx35_io_desc[] __initdata = {
@@ -50,14 +49,7 @@ void __init imx35_init_early(void)
 	mxc_arch_reset_init(MX35_IO_ADDRESS(MX35_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx35_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX35, 0, 1, MX35_INT_GPIO1),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX35, 1, 2, MX35_INT_GPIO2),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX35, 2, 3, MX35_INT_GPIO3),
-};
-
 void __init mx35_init_irq(void)
 {
 	mxc_init_irq(MX35_IO_ADDRESS(MX35_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx35_gpio_ports,	ARRAY_SIZE(imx35_gpio_ports));
 }
diff --git a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
index 3b10da0..07fee19 100644
--- a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
+++ b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
@@ -38,6 +38,50 @@ static struct platform_device *__init mxc_add_gpio(int id,
 
 static int __init mxc_add_mxc_gpio(void)
 {
+	if (cpu_is_mx1()) {
+		mxc_add_gpio(0, MX1_GPIO1_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTA, 0);
+		mxc_add_gpio(1, MX1_GPIO2_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTB, 0);
+		mxc_add_gpio(2, MX1_GPIO3_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTC, 0);
+		mxc_add_gpio(3, MX1_GPIO4_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTD, 0);
+	}
+
+	if (cpu_is_mx21()) {
+		mxc_add_gpio(0, MX21_GPIO1_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+		mxc_add_gpio(1, MX21_GPIO2_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+		mxc_add_gpio(2, MX21_GPIO3_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+		mxc_add_gpio(3, MX21_GPIO4_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+		mxc_add_gpio(4, MX21_GPIO5_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+		mxc_add_gpio(5, MX21_GPIO6_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	}
+
+	if (cpu_is_mx25()) {
+		mxc_add_gpio(0, MX25_GPIO1_BASE_ADDR, SZ_16K, MX25_INT_GPIO1, 0);
+		mxc_add_gpio(1, MX25_GPIO2_BASE_ADDR, SZ_16K, MX25_INT_GPIO2, 0);
+		mxc_add_gpio(2, MX25_GPIO3_BASE_ADDR, SZ_16K, MX25_INT_GPIO3, 0);
+		mxc_add_gpio(3, MX25_GPIO4_BASE_ADDR, SZ_16K, MX25_INT_GPIO4, 0);
+	}
+
+	if (cpu_is_mx27()) {
+		mxc_add_gpio(0, MX27_GPIO1_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+		mxc_add_gpio(1, MX27_GPIO2_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+		mxc_add_gpio(2, MX27_GPIO3_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+		mxc_add_gpio(3, MX27_GPIO4_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+		mxc_add_gpio(4, MX27_GPIO5_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+		mxc_add_gpio(5, MX27_GPIO6_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	}
+
+	if (cpu_is_mx31()) {
+		mxc_add_gpio(0, MX31_GPIO1_BASE_ADDR, SZ_16K, MX31_INT_GPIO1, 0);
+		mxc_add_gpio(1, MX31_GPIO2_BASE_ADDR, SZ_16K, MX31_INT_GPIO2, 0);
+		mxc_add_gpio(2, MX31_GPIO3_BASE_ADDR, SZ_16K, MX31_INT_GPIO3, 0);
+	}
+
+	if (cpu_is_mx35()) {
+		mxc_add_gpio(0, MX35_GPIO1_BASE_ADDR, SZ_16K, MX35_INT_GPIO1, 0);
+		mxc_add_gpio(1, MX35_GPIO2_BASE_ADDR, SZ_16K, MX35_INT_GPIO2, 0);
+		mxc_add_gpio(2, MX35_GPIO3_BASE_ADDR, SZ_16K, MX35_INT_GPIO3, 0);
+	}
+
 	if (cpu_is_mx50()) {
 		mxc_add_gpio(0, MX50_GPIO1_BASE_ADDR, SZ_16K, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH);
 		mxc_add_gpio(1, MX50_GPIO2_BASE_ADDR, SZ_16K, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH);
-- 
1.7.4.1

