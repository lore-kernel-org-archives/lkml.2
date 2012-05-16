Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965535Ab2EPFRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:17:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27326 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965132Ab2EPFRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:17:01 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-4a-4fb3384bdb13
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Kristoffer Ericson'" <kristoffer.ericson@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH v2 5/7] backlight: jornada720: use pr_err/info instead of printk
Date: Wed, 16 May 2012 14:16:59 +0900
Message-id: <002601cd3323$1ebbf9c0$5c33ed40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zImxKO9q4db+7S8SyAPR98GQG5gAAJN3w
Content-language: ko
x-cr-hashedpuzzle: AFmq DvR9 HORr KduU L1Ct OAuK PDUz Q7VO RNrV TKI/ W6IW fwGn
 gkMN gtbX iVzV
 lk5I;5;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBrAHIAaQBzAHQAbwBmAGYAZQByAC4AZQByAGkAYwBzAG8AbgBAAGcAbQBhAGkAbAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHIAcAB1AHIAZABpAGUAQAByAHAAcwB5AHMALgBuAGUAdAA=;Sosha1_v1;7;{3F0B8DA3-BBC9-4E3B-837C-2B3D1872C503};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 16 May 2012 05:16:53
 GMT;WwBQAEEAVABDAEgAIAB2ADIAIAA1AC8ANwBdACAAYgBhAGMAawBsAGkAZwBoAHQAOgAgAGoAbwByAG4AYQBkAGEANwAyADAAOgAgAHUAcwBlACAAcAByAF8AZQByAHIALwBpAG4AZgBvACAAaQBuAHMAdABlAGEAZAAgAG8AZgAgAHAAcgBpAG4AdABrAA==
x-cr-puzzleid: {3F0B8DA3-BBC9-4E3B-837C-2B3D1872C503}
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_err/info instead of printk to allow dynamic debugging.
The pr_fmt prefix for pr_ macros is used. It also fixes checkpatch
warnings as below:

WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/jornada720_bl.c  |   14 ++++++++------
 drivers/video/backlight/jornada720_lcd.c |    8 +++++---
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 2f8af5d..bcaa7b5 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) "jornada720_bl: " fmt
+
 #include <linux/backlight.h>
 #include <linux/device.h>
 #include <linux/fb.h>
@@ -38,7 +40,7 @@ static int jornada_bl_get_brightness(struct backlight_device *bd)
 	ret = jornada_ssp_byte(GETBRIGHTNESS);
 
 	if (jornada_ssp_byte(GETBRIGHTNESS) != TXDUMMY) {
-		printk(KERN_ERR "bl : get brightness timeout\n");
+		pr_err("get brightness timeout\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	} else /* exchange txdummy for value */
@@ -59,7 +61,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 	if ((bd->props.power != FB_BLANK_UNBLANK) || (bd->props.fb_blank != FB_BLANK_UNBLANK)) {
 		ret = jornada_ssp_byte(BRIGHTNESSOFF);
 		if (ret != TXDUMMY) {
-			printk(KERN_INFO "bl : brightness off timeout\n");
+			pr_info("brightness off timeout\n");
 			/* turn off backlight */
 			PPSR &= ~PPC_LDD1;
 			PPDR |= PPC_LDD1;
@@ -70,7 +72,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 
 		/* send command to our mcu */
 		if (jornada_ssp_byte(SETBRIGHTNESS) != TXDUMMY) {
-			printk(KERN_INFO "bl : failed to set brightness\n");
+			pr_info("failed to set brightness\n");
 			ret = -ETIMEDOUT;
 			goto out;
 		}
@@ -81,7 +83,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 		   but due to physical layout it is equal to 0, so we simply
 		   invert the value (MAX VALUE - NEW VALUE). */
 		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness) != TXDUMMY) {
-			printk(KERN_ERR "bl : set brightness failed\n");
+			pr_err("set brightness failed\n");
 			ret = -ETIMEDOUT;
 		}
 
@@ -113,7 +115,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
-		printk(KERN_ERR "bl : failed to register device, err=%x\n", ret);
+		pr_err("failed to register device, err=%x\n", ret);
 		return ret;
 	}
 
@@ -125,7 +127,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	jornada_bl_update_status(bd);
 
 	platform_set_drvdata(pdev, bd);
-	printk(KERN_INFO "HP Jornada 700 series backlight driver\n");
+	pr_info("HP Jornada 700 series backlight driver\n");
 
 	return 0;
 }
diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index 22d231a..a7782cd 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) "jornada720_lcd: " fmt
+
 #include <linux/device.h>
 #include <linux/fb.h>
 #include <linux/kernel.h>
@@ -44,7 +46,7 @@ static int jornada_lcd_get_contrast(struct lcd_device *dev)
 	jornada_ssp_start();
 
 	if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
-		printk(KERN_ERR "lcd: get contrast failed\n");
+		pr_err("get contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	} else {
@@ -65,7 +67,7 @@ static int jornada_lcd_set_contrast(struct lcd_device *dev, int value)
 
 	/* push the new value */
 	if (jornada_ssp_byte(value) != TXDUMMY) {
-		printk(KERN_ERR "lcd : set contrast failed\n");
+		pr_err("set contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	}
@@ -103,7 +105,7 @@ static int jornada_lcd_probe(struct platform_device *pdev)
 
 	if (IS_ERR(lcd_device)) {
 		ret = PTR_ERR(lcd_device);
-		printk(KERN_ERR "lcd : failed to register device\n");
+		pr_err("failed to register device\n");
 		return ret;
 	}
 
-- 
1.7.1


