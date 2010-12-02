Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab0LBOLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:11:23 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:45047 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab0LBOLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:11:22 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] MFD: ab8500-core ioresources irq for subdrivers added
Date: Thu, 2 Dec 2010 15:11:15 +0100
Message-ID: <1291299075-11629-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ioresources used by subdrivers to
retrieve their interrupt.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-core.c |  212 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 205 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index e464e94..68ef958 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -397,13 +397,195 @@ static struct resource ab8500_poweronkey_db_resources[] = {
 	},
 };
 
+static struct resource ab8500_bm_resources[] = {
+	{
+		.name = "MAIN_EXT_CH_NOT_OK",
+		.start = AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.end = AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BATT_OVV",
+		.start = AB8500_INT_BATT_OVV,
+		.end = AB8500_INT_BATT_OVV,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "MAIN_CH_UNPLUG_DET",
+		.start = AB8500_INT_MAIN_CH_UNPLUG_DET,
+		.end = AB8500_INT_MAIN_CH_UNPLUG_DET,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "MAIN_CHARGE_PLUG_DET",
+		.start = AB8500_INT_MAIN_CH_PLUG_DET,
+		.end = AB8500_INT_MAIN_CH_PLUG_DET,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_DET_F",
+		.start = AB8500_INT_VBUS_DET_F,
+		.end = AB8500_INT_VBUS_DET_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_DET_R",
+		.start = AB8500_INT_VBUS_DET_R,
+		.end = AB8500_INT_VBUS_DET_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BAT_CTRL_INDB",
+		.start = AB8500_INT_BAT_CTRL_INDB,
+		.end = AB8500_INT_BAT_CTRL_INDB,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "CH_WD_EXP",
+		.start = AB8500_INT_CH_WD_EXP,
+		.end = AB8500_INT_CH_WD_EXP,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_OVV",
+		.start = AB8500_INT_VBUS_OVV,
+		.end = AB8500_INT_VBUS_OVV,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "NCONV_ACCU",
+		.start = AB8500_INT_CCN_CONV_ACC,
+		.end = AB8500_INT_CCN_CONV_ACC,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "LOW_BAT_F",
+		.start = AB8500_INT_LOW_BAT_F,
+		.end = AB8500_INT_LOW_BAT_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "LOW_BAT_R",
+		.start = AB8500_INT_LOW_BAT_R,
+		.end = AB8500_INT_LOW_BAT_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BTEMP_LOW",
+		.start = AB8500_INT_BTEMP_LOW,
+		.end = AB8500_INT_BTEMP_LOW,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BTEMP_HIGH",
+		.start = AB8500_INT_BTEMP_HIGH,
+		.end = AB8500_INT_BTEMP_HIGH,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CHARGER_NOT_OKR",
+		.start = AB8500_INT_USB_CHARGER_NOT_OK,
+		.end = AB8500_INT_USB_CHARGER_NOT_OK,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CHARGE_DET_DONE",
+		.start = AB8500_INT_USB_CHG_DET_DONE,
+		.end = AB8500_INT_USB_CHG_DET_DONE,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CH_TH_PROT_R",
+		.start = AB8500_INT_USB_CH_TH_PROT_R,
+		.end = AB8500_INT_USB_CH_TH_PROT_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "MAIN_CH_TH_PROT_R",
+		.start = AB8500_INT_MAIN_CH_TH_PROT_R,
+		.end = AB8500_INT_MAIN_CH_TH_PROT_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CHARGER_NOT_OKF",
+		.start = AB8500_INT_USB_CHARGER_NOT_OKF,
+		.end = AB8500_INT_USB_CHARGER_NOT_OKF,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource ab8500_debug_resources[] = {
+	{
+		.name	= "IRQ_FIRST",
+		.start	= AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.end	= AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "IRQ_LAST",
+		.start	= AB8500_INT_USB_LINK_STATUS,
+		.end	= AB8500_INT_USB_LINK_STATUS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource ab8500_usb_resources[] = {
+	{
+		.name = "ID_WAKEUP_R",
+		.start = AB8500_INT_ID_WAKEUP_R,
+		.end = AB8500_INT_ID_WAKEUP_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "ID_WAKEUP_F",
+		.start = AB8500_INT_ID_WAKEUP_F,
+		.end = AB8500_INT_ID_WAKEUP_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_DET_F",
+		.start = AB8500_INT_VBUS_DET_F,
+		.end = AB8500_INT_VBUS_DET_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_DET_R",
+		.start = AB8500_INT_VBUS_DET_R,
+		.end = AB8500_INT_VBUS_DET_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_LINK_STATUS",
+		.start = AB8500_INT_USB_LINK_STATUS,
+		.end = AB8500_INT_USB_LINK_STATUS,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource ab8500_temp_resources[] = {
+	{
+		.name  = "AB8500_TEMP_WARM",
+		.start = AB8500_INT_TEMP_WARM,
+		.end   = AB8500_INT_TEMP_WARM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
 static struct mfd_cell ab8500_devs[] = {
 #ifdef CONFIG_DEBUG_FS
 	{
 		.name = "ab8500-debug",
+		.num_resources = ARRAY_SIZE(ab8500_debug_resources),
+		.resources = ab8500_debug_resources,
 	},
 #endif
 	{
+		.name = "ab8500-sysctrl",
+	},
+	{
+		.name = "ab8500-regulator",
+	},
+	{
 		.name = "ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
 		.resources = ab8500_gpadc_resources,
@@ -414,6 +596,22 @@ static struct mfd_cell ab8500_devs[] = {
 		.resources = ab8500_rtc_resources,
 	},
 	{
+		.name = "ab8500-bm",
+		.num_resources = ARRAY_SIZE(ab8500_bm_resources),
+		.resources = ab8500_bm_resources,
+	},
+	{ .name = "ab8500-codec", },
+	{
+		.name = "ab8500-usb",
+		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
+		.resources = ab8500_usb_resources,
+	},
+	{
+		.name = "ab8500-poweron-key",
+		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
+		.resources = ab8500_poweronkey_db_resources,
+	},
+	{
 		.name = "ab8500-pwm",
 		.id = 1,
 	},
@@ -425,14 +623,14 @@ static struct mfd_cell ab8500_devs[] = {
 		.name = "ab8500-pwm",
 		.id = 3,
 	},
-	{ .name = "ab8500-charger", },
-	{ .name = "ab8500-audio", },
-	{ .name = "ab8500-usb", },
-	{ .name = "ab8500-regulator", },
+	{ .name = "ab8500-leds", },
 	{
-		.name = "ab8500-poweron-key",
-		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
-		.resources = ab8500_poweronkey_db_resources,
+		.name = "ab8500-denc",
+	},
+	{
+		.name = "ab8500-temp",
+		.num_resources = ARRAY_SIZE(ab8500_temp_resources),
+		.resources = ab8500_temp_resources,
 	},
 };
 
-- 
1.7.2.2

