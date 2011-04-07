Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1DGEep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 00:34:45 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:46637 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1DGEeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 00:34:44 -0400
X-ASG-Debug-ID: 1302150884-082c227c0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: haojian.zhuang@gmail.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 1/1] mfd: fix build warning on 88pm860x
Subject: [PATCH 1/1] mfd: fix build warning on 88pm860x
Date: Thu,  7 Apr 2011 12:30:41 +0800
X-ASG-Orig-Subj: [PATCH 1/1] mfd: fix build warning on 88pm860x
Message-Id: <1302150641-2580-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2011040701>
References: <2011040701>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1302150884
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.devinit.text+0x6c4): Section mismatch in reference
from the function device_onkey_init() to the (unknown reference)
.init.data:(unknown)
The function __devinit device_onkey_init() references a (unknown reference)
 __initdata (unknown).
If (unknown) is only used by device_onkey_init then annotate (unknown)
with a matching annotation.

It's caused by using __initdata on mfd cell resources. Replace __initdata
with __devinitdata.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/88pm860x-core.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 63d1c54..5d8885a 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -21,13 +21,13 @@
 
 #define INT_STATUS_NUM			3
 
-static struct resource bk_resources[] __initdata = {
+static struct resource bk_resources[] __devinitdata = {
 	{PM8606_BACKLIGHT1, PM8606_BACKLIGHT1, "backlight-0", IORESOURCE_IO,},
 	{PM8606_BACKLIGHT2, PM8606_BACKLIGHT2, "backlight-1", IORESOURCE_IO,},
 	{PM8606_BACKLIGHT3, PM8606_BACKLIGHT3, "backlight-2", IORESOURCE_IO,},
 };
 
-static struct resource led_resources[] __initdata = {
+static struct resource led_resources[] __devinitdata = {
 	{PM8606_LED1_RED,   PM8606_LED1_RED,   "led0-red",   IORESOURCE_IO,},
 	{PM8606_LED1_GREEN, PM8606_LED1_GREEN, "led0-green", IORESOURCE_IO,},
 	{PM8606_LED1_BLUE,  PM8606_LED1_BLUE,  "led0-blue",  IORESOURCE_IO,},
@@ -36,7 +36,7 @@ static struct resource led_resources[] __initdata = {
 	{PM8606_LED2_BLUE,  PM8606_LED2_BLUE,  "led1-blue",  IORESOURCE_IO,},
 };
 
-static struct resource regulator_resources[] __initdata = {
+static struct resource regulator_resources[] __devinitdata = {
 	{PM8607_ID_BUCK1, PM8607_ID_BUCK1, "buck-1", IORESOURCE_IO,},
 	{PM8607_ID_BUCK2, PM8607_ID_BUCK2, "buck-2", IORESOURCE_IO,},
 	{PM8607_ID_BUCK3, PM8607_ID_BUCK3, "buck-3", IORESOURCE_IO,},
@@ -57,19 +57,19 @@ static struct resource regulator_resources[] __initdata = {
 	{PM8607_ID_LDO15, PM8607_ID_LDO15, "ldo-15", IORESOURCE_IO,},
 };
 
-static struct resource rtc_resources[] __initdata = {
+static struct resource rtc_resources[] __devinitdata = {
 	{PM8607_IRQ_RTC, PM8607_IRQ_RTC, "rtc", IORESOURCE_IRQ,},
 };
 
-static struct resource touch_resources[] __initdata = {
+static struct resource touch_resources[] __devinitdata = {
 	{PM8607_IRQ_PEN, PM8607_IRQ_PEN, "touch", IORESOURCE_IRQ,},
 };
 
-static struct resource onkey_resources[] __initdata = {
+static struct resource onkey_resources[] __devinitdata = {
 	{PM8607_IRQ_ONKEY, PM8607_IRQ_ONKEY, "onkey", IORESOURCE_IRQ,},
 };
 
-static struct resource codec_resources[] __initdata = {
+static struct resource codec_resources[] __devinitdata = {
 	/* Headset microphone insertion or removal */
 	{PM8607_IRQ_MICIN,   PM8607_IRQ_MICIN,   "micin",   IORESOURCE_IRQ,},
 	/* Hook-switch press or release */
@@ -80,12 +80,12 @@ static struct resource codec_resources[] __initdata = {
 	{PM8607_IRQ_AUDIO_SHORT, PM8607_IRQ_AUDIO_SHORT, "audio-short", IORESOURCE_IRQ,},
 };
 
-static struct resource battery_resources[] __initdata = {
+static struct resource battery_resources[] __devinitdata = {
 	{PM8607_IRQ_CC,  PM8607_IRQ_CC,  "columb counter", IORESOURCE_IRQ,},
 	{PM8607_IRQ_BAT, PM8607_IRQ_BAT, "battery",        IORESOURCE_IRQ,},
 };
 
-static struct resource charger_resources[] __initdata = {
+static struct resource charger_resources[] __devinitdata = {
 	{PM8607_IRQ_CHG,  PM8607_IRQ_CHG,  "charger detect",  IORESOURCE_IRQ,},
 	{PM8607_IRQ_CHG_DONE,  PM8607_IRQ_CHG_DONE,  "charging done",       IORESOURCE_IRQ,},
 	{PM8607_IRQ_CHG_FAULT, PM8607_IRQ_CHG_FAULT, "charging timeout",    IORESOURCE_IRQ,},
@@ -94,13 +94,13 @@ static struct resource charger_resources[] __initdata = {
 	{PM8607_IRQ_VCHG, PM8607_IRQ_VCHG, "vchg voltage",    IORESOURCE_IRQ,},
 };
 
-static struct mfd_cell bk_devs[] __initdata = {
+static struct mfd_cell bk_devs[] __devinitdata = {
 	{"88pm860x-backlight", 0,},
 	{"88pm860x-backlight", 1,},
 	{"88pm860x-backlight", 2,},
 };
 
-static struct mfd_cell led_devs[] __initdata = {
+static struct mfd_cell led_devs[] __devinitdata = {
 	{"88pm860x-led", 0,},
 	{"88pm860x-led", 1,},
 	{"88pm860x-led", 2,},
@@ -109,7 +109,7 @@ static struct mfd_cell led_devs[] __initdata = {
 	{"88pm860x-led", 5,},
 };
 
-static struct mfd_cell regulator_devs[] __initdata = {
+static struct mfd_cell regulator_devs[] __devinitdata = {
 	{"88pm860x-regulator", 0,},
 	{"88pm860x-regulator", 1,},
 	{"88pm860x-regulator", 2,},
@@ -130,23 +130,23 @@ static struct mfd_cell regulator_devs[] __initdata = {
 	{"88pm860x-regulator", 17,},
 };
 
-static struct mfd_cell rtc_devs[] __initdata = {
+static struct mfd_cell rtc_devs[] __devinitdata = {
 	{"88pm860x-rtc", -1,},
 };
 
-static struct mfd_cell touch_devs[] __initdata = {
+static struct mfd_cell touch_devs[] __devinitdata = {
 	{"88pm860x-touch", -1,},
 };
 
-static struct mfd_cell onkey_devs[] __initdata = {
+static struct mfd_cell onkey_devs[] __devinitdata = {
 	{"88pm860x-onkey", -1,},
 };
 
-static struct mfd_cell codec_devs[] __initdata = {
+static struct mfd_cell codec_devs[] __devinitdata = {
 	{"88pm860x-codec", -1,},
 };
 
-static struct mfd_cell power_devs[] = {
+static struct mfd_cell power_devs[] __devinitdata = {
 	{"88pm860x-battery", -1,},
 	{"88pm860x-charger", -1,},
 };
-- 
1.5.6.5

