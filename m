Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab0FBLju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:39:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab0FBLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:38:53 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 08/11] OMAP2: Devkit8000: Using the REGULATOR_SUPPLY macro
Date: Wed,  2 Jun 2010 13:37:48 +0200
Message-Id: <1275478671-24563-9-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275478671-24563-1-git-send-email-weber@corscience.de>
References: <1275478671-24563-1-git-send-email-weber@corscience.de>
X-Provags-ID: V01U2FsdGVkX19eXwjVUk8qY0voQWCodabfYrAoGqvyUdHtPrK
 r5dKYx+HObfnSOan/QV8o537H9MIXfjZNx9wuyJN4uJ4DSPXJb
 cOv3eA72YKsFtYqwwhmLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing supplies with the REGULATOR_SUPPLY macro.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |   33 ++++++++++++-------------------
 1 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 095dc7a..3da88c8 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -158,14 +158,13 @@ static void devkit8000_panel_disable_dvi(struct omap_dss_device *dssdev)
 		gpio_set_value(dssdev->reset_gpio, 0);
 }
 
-static struct regulator_consumer_supply devkit8000_vmmc1_supply = {
-	.supply			= "vmmc",
-};
+static struct regulator_consumer_supply devkit8000_vmmc1_supply =
+	REGULATOR_SUPPLY("vmmc", "mmci-omap-hs.0");
+
 
 /* ads7846 on SPI */
-static struct regulator_consumer_supply devkit8000_vio_supplies[] = {
-	REGULATOR_SUPPLY("vcc", "spi2.0")
-};
+static struct regulator_consumer_supply devkit8000_vio_supply =
+	REGULATOR_SUPPLY("vcc", "spi2.0");
 
 static struct omap_dss_device devkit8000_lcd_device = {
 	.name                   = "lcd",
@@ -214,10 +213,8 @@ static struct platform_device devkit8000_dss_device = {
 	},
 };
 
-static struct regulator_consumer_supply devkit8000_vdda_dac_supply = {
-	.supply = "vdda_dac",
-	.dev	= &devkit8000_dss_device.dev,
-};
+static struct regulator_consumer_supply devkit8000_vdda_dac_supply =
+	REGULATOR_SUPPLY("vdda_dac", "omapdss");
 
 static int board_keymap[] = {
 	KEY(0, 0, KEY_1),
@@ -294,12 +291,8 @@ static struct twl4030_gpio_platform_data devkit8000_gpio_data = {
 	.setup		= devkit8000_twl_gpio_setup,
 };
 
-static struct regulator_consumer_supply devkit8000_vpll1_supplies[] = {
-	{
-	.supply		= "vdds_dsi",
-	.dev		= &devkit8000_dss_device.dev,
-	}
-};
+static struct regulator_consumer_supply devkit8000_vpll1_supply =
+	REGULATOR_SUPPLY("vdds_dsi", "omapdss");
 
 /* VMMC1 for MMC1 pins CMD, CLK, DAT0..DAT3 (20 mA, plus card == max 220 mA) */
 static struct regulator_init_data devkit8000_vmmc1 = {
@@ -340,8 +333,8 @@ static struct regulator_init_data devkit8000_vpll1 = {
 		.valid_ops_mask		= REGULATOR_CHANGE_MODE
 					| REGULATOR_CHANGE_STATUS,
 	},
-	.num_consumer_supplies	= ARRAY_SIZE(devkit8000_vpll1_supplies),
-	.consumer_supplies	= devkit8000_vpll1_supplies,
+	.num_consumer_supplies	= 1,
+	.consumer_supplies	= &devkit8000_vpll1_supply,
 };
 
 /* VAUX4 for ads7846 and nubs */
@@ -355,8 +348,8 @@ static struct regulator_init_data devkit8000_vio = {
 		.valid_ops_mask         = REGULATOR_CHANGE_MODE
 			| REGULATOR_CHANGE_STATUS,
 	},
-	.num_consumer_supplies  = ARRAY_SIZE(devkit8000_vio_supplies),
-	.consumer_supplies      = devkit8000_vio_supplies,
+	.num_consumer_supplies  = 1,
+	.consumer_supplies      = &devkit8000_vio_supply,
 };
 
 static struct twl4030_usb_data devkit8000_usb_data = {
-- 
1.7.1

