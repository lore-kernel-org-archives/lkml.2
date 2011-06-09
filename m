Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1FIV6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:58:08 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:39817 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756529Ab1FIV6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:58:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3] mfd: update ab8500 subdevice list
Date: Thu, 9 Jun 2011 23:57:45 +0200
Message-ID: <1307656665-6631-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This synchronize the subdevice entries for the AB8500 MFD driver
with the latest development of subdrivers for things like battery
charging and temperature monitoring.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |  215 ++++++++++++++++++++++++++++++++++----------
 1 files changed, 166 insertions(+), 49 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 1fc6be8..387705e 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -417,20 +417,47 @@ static struct resource __devinitdata ab8500_poweronkey_db_resources[] = {
 	},
 };
 
-static struct resource __devinitdata ab8500_bm_resources[] = {
+static struct resource __devinitdata ab8500_av_acc_detect_resources[] = {
 	{
-		.name = "MAIN_EXT_CH_NOT_OK",
-		.start = AB8500_INT_MAIN_EXT_CH_NOT_OK,
-		.end = AB8500_INT_MAIN_EXT_CH_NOT_OK,
-		.flags = IORESOURCE_IRQ,
+	       .name = "ACC_DETECT_1DB_F",
+	       .start = AB8500_INT_ACC_DETECT_1DB_F,
+	       .end = AB8500_INT_ACC_DETECT_1DB_F,
+	       .flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "BATT_OVV",
-		.start = AB8500_INT_BATT_OVV,
-		.end = AB8500_INT_BATT_OVV,
-		.flags = IORESOURCE_IRQ,
+	       .name = "ACC_DETECT_1DB_R",
+	       .start = AB8500_INT_ACC_DETECT_1DB_R,
+	       .end = AB8500_INT_ACC_DETECT_1DB_R,
+	       .flags = IORESOURCE_IRQ,
+	},
+	{
+	       .name = "ACC_DETECT_21DB_F",
+	       .start = AB8500_INT_ACC_DETECT_21DB_F,
+	       .end = AB8500_INT_ACC_DETECT_21DB_F,
+	       .flags = IORESOURCE_IRQ,
+	},
+	{
+	       .name = "ACC_DETECT_21DB_R",
+	       .start = AB8500_INT_ACC_DETECT_21DB_R,
+	       .end = AB8500_INT_ACC_DETECT_21DB_R,
+	       .flags = IORESOURCE_IRQ,
+	},
+	{
+	       .name = "ACC_DETECT_22DB_F",
+	       .start = AB8500_INT_ACC_DETECT_22DB_F,
+	       .end = AB8500_INT_ACC_DETECT_22DB_F,
+	       .flags = IORESOURCE_IRQ,
 	},
 	{
+	       .name = "ACC_DETECT_22DB_R",
+	       .start = AB8500_INT_ACC_DETECT_22DB_R,
+	       .end = AB8500_INT_ACC_DETECT_22DB_R,
+	       .flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource __devinitdata ab8500_charger_resources[] = {
+	{
 		.name = "MAIN_CH_UNPLUG_DET",
 		.start = AB8500_INT_MAIN_CH_UNPLUG_DET,
 		.end = AB8500_INT_MAIN_CH_UNPLUG_DET,
@@ -443,27 +470,27 @@ static struct resource __devinitdata ab8500_bm_resources[] = {
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "VBUS_DET_F",
-		.start = AB8500_INT_VBUS_DET_F,
-		.end = AB8500_INT_VBUS_DET_F,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
 		.name = "VBUS_DET_R",
 		.start = AB8500_INT_VBUS_DET_R,
 		.end = AB8500_INT_VBUS_DET_R,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "BAT_CTRL_INDB",
-		.start = AB8500_INT_BAT_CTRL_INDB,
-		.end = AB8500_INT_BAT_CTRL_INDB,
+		.name = "VBUS_DET_F",
+		.start = AB8500_INT_VBUS_DET_F,
+		.end = AB8500_INT_VBUS_DET_F,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "CH_WD_EXP",
-		.start = AB8500_INT_CH_WD_EXP,
-		.end = AB8500_INT_CH_WD_EXP,
+		.name = "USB_LINK_STATUS",
+		.start = AB8500_INT_USB_LINK_STATUS,
+		.end = AB8500_INT_USB_LINK_STATUS,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CHARGE_DET_DONE",
+		.start = AB8500_INT_USB_CHG_DET_DONE,
+		.end = AB8500_INT_USB_CHG_DET_DONE,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
@@ -473,21 +500,60 @@ static struct resource __devinitdata ab8500_bm_resources[] = {
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "NCONV_ACCU",
-		.start = AB8500_INT_CCN_CONV_ACC,
-		.end = AB8500_INT_CCN_CONV_ACC,
+		.name = "USB_CH_TH_PROT_R",
+		.start = AB8500_INT_USB_CH_TH_PROT_R,
+		.end = AB8500_INT_USB_CH_TH_PROT_R,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "LOW_BAT_F",
-		.start = AB8500_INT_LOW_BAT_F,
-		.end = AB8500_INT_LOW_BAT_F,
+		.name = "USB_CH_TH_PROT_F",
+		.start = AB8500_INT_USB_CH_TH_PROT_F,
+		.end = AB8500_INT_USB_CH_TH_PROT_F,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "LOW_BAT_R",
-		.start = AB8500_INT_LOW_BAT_R,
-		.end = AB8500_INT_LOW_BAT_R,
+		.name = "MAIN_EXT_CH_NOT_OK",
+		.start = AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.end = AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "MAIN_CH_TH_PROT_R",
+		.start = AB8500_INT_MAIN_CH_TH_PROT_R,
+		.end = AB8500_INT_MAIN_CH_TH_PROT_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "MAIN_CH_TH_PROT_F",
+		.start = AB8500_INT_MAIN_CH_TH_PROT_F,
+		.end = AB8500_INT_MAIN_CH_TH_PROT_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CHARGER_NOT_OKR",
+		.start = AB8500_INT_USB_CHARGER_NOT_OK,
+		.end = AB8500_INT_USB_CHARGER_NOT_OK,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CHARGER_NOT_OKF",
+		.start = AB8500_INT_USB_CHARGER_NOT_OKF,
+		.end = AB8500_INT_USB_CHARGER_NOT_OKF,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "CH_WD_EXP",
+		.start = AB8500_INT_CH_WD_EXP,
+		.end = AB8500_INT_CH_WD_EXP,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource __devinitdata ab8500_btemp_resources[] = {
+	{
+		.name = "BAT_CTRL_INDB",
+		.start = AB8500_INT_BAT_CTRL_INDB,
+		.end = AB8500_INT_BAT_CTRL_INDB,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
@@ -503,37 +569,54 @@ static struct resource __devinitdata ab8500_bm_resources[] = {
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "USB_CHARGER_NOT_OKR",
-		.start = AB8500_INT_USB_CHARGER_NOT_OK,
-		.end = AB8500_INT_USB_CHARGER_NOT_OK,
+		.name = "BTEMP_LOW_MEDIUM",
+		.start = AB8500_INT_BTEMP_LOW_MEDIUM,
+		.end = AB8500_INT_BTEMP_LOW_MEDIUM,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "USB_CHARGE_DET_DONE",
-		.start = AB8500_INT_USB_CHG_DET_DONE,
-		.end = AB8500_INT_USB_CHG_DET_DONE,
+		.name = "BTEMP_MEDIUM_HIGH",
+		.start = AB8500_INT_BTEMP_MEDIUM_HIGH,
+		.end = AB8500_INT_BTEMP_MEDIUM_HIGH,
 		.flags = IORESOURCE_IRQ,
 	},
+};
+
+static struct resource __devinitdata ab8500_fg_resources[] = {
 	{
-		.name = "USB_CH_TH_PROT_R",
-		.start = AB8500_INT_USB_CH_TH_PROT_R,
-		.end = AB8500_INT_USB_CH_TH_PROT_R,
+		.name = "NCONV_ACCU",
+		.start = AB8500_INT_CCN_CONV_ACC,
+		.end = AB8500_INT_CCN_CONV_ACC,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "MAIN_CH_TH_PROT_R",
-		.start = AB8500_INT_MAIN_CH_TH_PROT_R,
-		.end = AB8500_INT_MAIN_CH_TH_PROT_R,
+		.name = "BATT_OVV",
+		.start = AB8500_INT_BATT_OVV,
+		.end = AB8500_INT_BATT_OVV,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "USB_CHARGER_NOT_OKF",
-		.start = AB8500_INT_USB_CHARGER_NOT_OKF,
-		.end = AB8500_INT_USB_CHARGER_NOT_OKF,
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
+		.name = "CC_INT_CALIB",
+		.start = AB8500_INT_CC_INT_CALIB,
+		.end = AB8500_INT_CC_INT_CALIB,
 		.flags = IORESOURCE_IRQ,
 	},
 };
 
+static struct resource __devinitdata ab8500_chargalg_resources[] = {};
+
 static struct resource __devinitdata ab8500_debug_resources[] = {
 	{
 		.name	= "IRQ_FIRST",
@@ -580,6 +663,18 @@ static struct resource __devinitdata ab8500_usb_resources[] = {
 		.end = AB8500_INT_USB_LINK_STATUS,
 		.flags = IORESOURCE_IRQ,
 	},
+	{
+		.name = "USB_ADP_PROBE_PLUG",
+		.start = AB8500_INT_ADP_PROBE_PLUG,
+		.end = AB8500_INT_ADP_PROBE_PLUG,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_ADP_PROBE_UNPLUG",
+		.start = AB8500_INT_ADP_PROBE_UNPLUG,
+		.end = AB8500_INT_ADP_PROBE_UNPLUG,
+		.flags = IORESOURCE_IRQ,
+	},
 };
 
 static struct resource __devinitdata ab8500_temp_resources[] = {
@@ -621,11 +716,33 @@ static struct mfd_cell __devinitdata ab8500_devs[] = {
 		.resources = ab8500_rtc_resources,
 	},
 	{
-		.name = "ab8500-bm",
-		.num_resources = ARRAY_SIZE(ab8500_bm_resources),
-		.resources = ab8500_bm_resources,
+		.name = "ab8500-charger",
+		.num_resources = ARRAY_SIZE(ab8500_charger_resources),
+		.resources = ab8500_charger_resources,
+	},
+	{
+		.name = "ab8500-btemp",
+		.num_resources = ARRAY_SIZE(ab8500_btemp_resources),
+		.resources = ab8500_btemp_resources,
+	},
+	{
+		.name = "ab8500-fg",
+		.num_resources = ARRAY_SIZE(ab8500_fg_resources),
+		.resources = ab8500_fg_resources,
+	},
+	{
+		.name = "ab8500-chargalg",
+		.num_resources = ARRAY_SIZE(ab8500_chargalg_resources),
+		.resources = ab8500_chargalg_resources,
+	},
+	{
+		.name = "ab8500-acc-det",
+		.num_resources = ARRAY_SIZE(ab8500_av_acc_detect_resources),
+		.resources = ab8500_av_acc_detect_resources,
+	},
+	{
+		.name = "ab8500-codec",
 	},
-	{ .name = "ab8500-codec", },
 	{
 		.name = "ab8500-usb",
 		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
-- 
1.7.3.2

