Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab0GQLZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 07:25:10 -0400
Received: from mail.df.lth.se ([194.47.250.12]:45091 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755726Ab0GQLZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 07:25:05 -0400
From: Linus Walleij <triad@df.lth.se>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Linus Walleij <triad@df.lth.se>
Subject: [PATCH 2/2] ARM: add character LCD platform data for RealView and Versatile
Date: Sat, 17 Jul 2010 13:23:16 +0200
Message-Id: <1279365796-18727-1-git-send-email-triad@df.lth.se>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds some platform data for the character LCD found in the
RealView and Versatile reference designs from ARM.

Signed-off-by: Linus Walleij <triad@df.lth.se>
---
 arch/arm/mach-realview/realview_eb.c     |   21 +++++++++++++++++++++
 arch/arm/mach-realview/realview_pb1176.c |   21 +++++++++++++++++++++
 arch/arm/mach-versatile/core.c           |   16 ++++++++++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-realview/realview_eb.c b/arch/arm/mach-realview/realview_eb.c
index b5f4d09..2df6ae8 100644
--- a/arch/arm/mach-realview/realview_eb.c
+++ b/arch/arm/mach-realview/realview_eb.c
@@ -330,6 +330,26 @@ static struct platform_device pmu_device = {
 	.resource		= pmu_resources,
 };
 
+static struct resource char_lcd_resources[] = {
+	{
+		.start = REALVIEW_CHAR_LCD_BASE,
+		.end   = (REALVIEW_CHAR_LCD_BASE + SZ_4K - 1),
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start	= IRQ_EB_CHARLCD,
+		.end	= IRQ_EB_CHARLCD,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device char_lcd_device = {
+	.name		=	"arm-charlcd",
+	.id		=	-1,
+	.num_resources	=	ARRAY_SIZE(char_lcd_resources),
+	.resource	=	char_lcd_resources,
+};
+
 static void __init gic_init_irq(void)
 {
 	if (core_tile_eb11mp() || core_tile_a9mp()) {
@@ -448,6 +468,7 @@ static void __init realview_eb_init(void)
 
 	realview_flash_register(&realview_eb_flash_resource, 1);
 	platform_device_register(&realview_i2c_device);
+	platform_device_register(&char_lcd_device);
 	eth_device_register();
 	realview_usb_register(realview_eb_isp1761_resources);
 
diff --git a/arch/arm/mach-realview/realview_pb1176.c b/arch/arm/mach-realview/realview_pb1176.c
index 93aa1b1..ba490bb 100644
--- a/arch/arm/mach-realview/realview_pb1176.c
+++ b/arch/arm/mach-realview/realview_pb1176.c
@@ -280,6 +280,26 @@ static struct platform_device pmu_device = {
 	.resource		= &pmu_resource,
 };
 
+static struct resource char_lcd_resources[] = {
+	{
+		.start = REALVIEW_CHAR_LCD_BASE,
+		.end   = (REALVIEW_CHAR_LCD_BASE + SZ_4K - 1),
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start	= IRQ_PB1176_CHARLCD,
+		.end	= IRQ_PB1176_CHARLCD,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device char_lcd_device = {
+	.name		=	"arm-charlcd",
+	.id		=	-1,
+	.num_resources	=	ARRAY_SIZE(char_lcd_resources),
+	.resource	=	char_lcd_resources,
+};
+
 static void __init gic_init_irq(void)
 {
 	/* ARM1176 DevChip GIC, primary */
@@ -342,6 +362,7 @@ static void __init realview_pb1176_init(void)
 	platform_device_register(&realview_i2c_device);
 	realview_usb_register(realview_pb1176_isp1761_resources);
 	platform_device_register(&pmu_device);
+	platform_device_register(&char_lcd_device);
 
 	for (i = 0; i < ARRAY_SIZE(amba_devs); i++) {
 		struct amba_device *d = amba_devs[i];
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index f3a0e07..6ccd261 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -355,6 +355,21 @@ static struct mmci_platform_data mmc0_plat_data = {
 	.gpio_cd	= -1,
 };
 
+static struct resource char_lcd_resources[] = {
+	{
+		.start = VERSATILE_CHAR_LCD_BASE,
+		.end   = (VERSATILE_CHAR_LCD_BASE + SZ_4K - 1),
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device char_lcd_device = {
+	.name           =       "arm-charlcd",
+	.id             =       -1,
+	.num_resources  =       ARRAY_SIZE(char_lcd_resources),
+	.resource       =       char_lcd_resources,
+};
+
 /*
  * Clock handling
  */
@@ -853,6 +868,7 @@ void __init versatile_init(void)
 	platform_device_register(&versatile_flash_device);
 	platform_device_register(&versatile_i2c_device);
 	platform_device_register(&smc91x_device);
+	platform_device_register(&char_lcd_device);
 
 	for (i = 0; i < ARRAY_SIZE(amba_devs); i++) {
 		struct amba_device *d = amba_devs[i];
-- 
1.7.1

