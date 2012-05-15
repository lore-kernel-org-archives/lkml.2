Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab2EOHzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:55:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8728 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab2EOHzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:55:44 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-2d-4fb20bf8846c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Kristoffer Ericson'" <kristoffer.ericson@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 5/7] backlight: jornada720: use pr_err/info instead of printk
Date: Tue, 15 May 2012 16:55:36 +0900
Message-id: <001001cd3270$1d000940$57001bc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0ycBzqP/iibFj1S1eixWGXtE1pKQ==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_err/info instead of printk to allow dynamic debugging.
It also fixes checkpatch warnings as below:

WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/jornada720_bl.c  |   12 ++++++------
 drivers/video/backlight/jornada720_lcd.c |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 2f8af5d..a3c5c0e 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -38,7 +38,7 @@ static int jornada_bl_get_brightness(struct backlight_device *bd)
 	ret = jornada_ssp_byte(GETBRIGHTNESS);
 
 	if (jornada_ssp_byte(GETBRIGHTNESS) != TXDUMMY) {
-		printk(KERN_ERR "bl : get brightness timeout\n");
+		pr_err("bl : get brightness timeout\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	} else /* exchange txdummy for value */
@@ -59,7 +59,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 	if ((bd->props.power != FB_BLANK_UNBLANK) || (bd->props.fb_blank != FB_BLANK_UNBLANK)) {
 		ret = jornada_ssp_byte(BRIGHTNESSOFF);
 		if (ret != TXDUMMY) {
-			printk(KERN_INFO "bl : brightness off timeout\n");
+			pr_info("bl : brightness off timeout\n");
 			/* turn off backlight */
 			PPSR &= ~PPC_LDD1;
 			PPDR |= PPC_LDD1;
@@ -70,7 +70,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 
 		/* send command to our mcu */
 		if (jornada_ssp_byte(SETBRIGHTNESS) != TXDUMMY) {
-			printk(KERN_INFO "bl : failed to set brightness\n");
+			pr_info("bl : failed to set brightness\n");
 			ret = -ETIMEDOUT;
 			goto out;
 		}
@@ -81,7 +81,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 		   but due to physical layout it is equal to 0, so we simply
 		   invert the value (MAX VALUE - NEW VALUE). */
 		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness) != TXDUMMY) {
-			printk(KERN_ERR "bl : set brightness failed\n");
+			pr_err("bl : set brightness failed\n");
 			ret = -ETIMEDOUT;
 		}
 
@@ -113,7 +113,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
-		printk(KERN_ERR "bl : failed to register device, err=%x\n", ret);
+		pr_err("bl : failed to register device, err=%x\n", ret);
 		return ret;
 	}
 
@@ -125,7 +125,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	jornada_bl_update_status(bd);
 
 	platform_set_drvdata(pdev, bd);
-	printk(KERN_INFO "HP Jornada 700 series backlight driver\n");
+	pr_info("HP Jornada 700 series backlight driver\n");
 
 	return 0;
 }
diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index 22d231a..b8f2115 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -44,7 +44,7 @@ static int jornada_lcd_get_contrast(struct lcd_device *dev)
 	jornada_ssp_start();
 
 	if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
-		printk(KERN_ERR "lcd: get contrast failed\n");
+		pr_err("lcd: get contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	} else {
@@ -65,7 +65,7 @@ static int jornada_lcd_set_contrast(struct lcd_device *dev, int value)
 
 	/* push the new value */
 	if (jornada_ssp_byte(value) != TXDUMMY) {
-		printk(KERN_ERR "lcd : set contrast failed\n");
+		pr_err("lcd : set contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	}
@@ -103,7 +103,7 @@ static int jornada_lcd_probe(struct platform_device *pdev)
 
 	if (IS_ERR(lcd_device)) {
 		ret = PTR_ERR(lcd_device);
-		printk(KERN_ERR "lcd : failed to register device\n");
+		pr_err("lcd : failed to register device\n");
 		return ret;
 	}
 
-- 
1.7.1


