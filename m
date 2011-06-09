Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab1FIV5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:57:53 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:35667 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754817Ab1FIV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:57:52 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Robert Rosengren <robert.rosengren@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3] mfd: ab8500-core MFD devices marked as initdata
Date: Thu, 9 Jun 2011 23:57:33 +0200
Message-ID: <1307656653-6258-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Rosengren <robert.rosengren@stericsson.com>

Internal MFD device structs are marked as __devinitdata since the kernel
will allocate memory for the same when calling mfd_add_devices.

Signed-off-by: Robert Rosengren <robert.rosengren@stericsson.com>
Reviewed-by: Mattias Wallin <mattias.wallin@stericsson.com>
Reviewed-by: Johan Palsson <johan.palsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index fc0c1af..1fc6be8 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -363,7 +363,7 @@ static void ab8500_irq_remove(struct ab8500 *ab8500)
 	}
 }
 
-static struct resource ab8500_gpio_resources[] = {
+static struct resource __devinitdata ab8500_gpio_resources[] = {
 	{
 		.name	= "GPIO_INT6",
 		.start	= AB8500_INT_GPIO6R,
@@ -372,7 +372,7 @@ static struct resource ab8500_gpio_resources[] = {
 	}
 };
 
-static struct resource ab8500_gpadc_resources[] = {
+static struct resource __devinitdata ab8500_gpadc_resources[] = {
 	{
 		.name	= "HW_CONV_END",
 		.start	= AB8500_INT_GP_HW_ADC_CONV_END,
@@ -387,7 +387,7 @@ static struct resource ab8500_gpadc_resources[] = {
 	},
 };
 
-static struct resource ab8500_rtc_resources[] = {
+static struct resource __devinitdata ab8500_rtc_resources[] = {
 	{
 		.name	= "60S",
 		.start	= AB8500_INT_RTC_60S,
@@ -402,7 +402,7 @@ static struct resource ab8500_rtc_resources[] = {
 	},
 };
 
-static struct resource ab8500_poweronkey_db_resources[] = {
+static struct resource __devinitdata ab8500_poweronkey_db_resources[] = {
 	{
 		.name	= "ONKEY_DBF",
 		.start	= AB8500_INT_PON_KEY1DB_F,
@@ -417,7 +417,7 @@ static struct resource ab8500_poweronkey_db_resources[] = {
 	},
 };
 
-static struct resource ab8500_bm_resources[] = {
+static struct resource __devinitdata ab8500_bm_resources[] = {
 	{
 		.name = "MAIN_EXT_CH_NOT_OK",
 		.start = AB8500_INT_MAIN_EXT_CH_NOT_OK,
@@ -534,7 +534,7 @@ static struct resource ab8500_bm_resources[] = {
 	},
 };
 
-static struct resource ab8500_debug_resources[] = {
+static struct resource __devinitdata ab8500_debug_resources[] = {
 	{
 		.name	= "IRQ_FIRST",
 		.start	= AB8500_INT_MAIN_EXT_CH_NOT_OK,
@@ -549,7 +549,7 @@ static struct resource ab8500_debug_resources[] = {
 	},
 };
 
-static struct resource ab8500_usb_resources[] = {
+static struct resource __devinitdata ab8500_usb_resources[] = {
 	{
 		.name = "ID_WAKEUP_R",
 		.start = AB8500_INT_ID_WAKEUP_R,
@@ -582,7 +582,7 @@ static struct resource ab8500_usb_resources[] = {
 	},
 };
 
-static struct resource ab8500_temp_resources[] = {
+static struct resource __devinitdata ab8500_temp_resources[] = {
 	{
 		.name  = "AB8500_TEMP_WARM",
 		.start = AB8500_INT_TEMP_WARM,
@@ -591,7 +591,7 @@ static struct resource ab8500_temp_resources[] = {
 	},
 };
 
-static struct mfd_cell ab8500_devs[] = {
+static struct mfd_cell __devinitdata ab8500_devs[] = {
 #ifdef CONFIG_DEBUG_FS
 	{
 		.name = "ab8500-debug",
-- 
1.7.3.2

