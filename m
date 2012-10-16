Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2JPHaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:30:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33842 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab2JPHaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:30:02 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-c8-507d0cf9f6e0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 08/17] backlight: jornada720: fix checkpatch error and warning
Date: Tue, 16 Oct 2012 16:30:00 +0900
Message-id: <007901cdab70$0d7c28e0$28747aa0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAInLw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd2fPLUBBvPma1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M5r1vGQu2yVYc6lzK1MB4X7yLkZNDQsBE4tmXT+wQtpjEhXvr
	2boYuTiEBKYzSlxpfMoEkhASmM0kMemIOojNJqAm8eXLYbAGEYEIieYZs5i7GDk4mAV8JDbP
	0oQot5VYPeMtWAmngJ3ExtcHWUBsYQE/iTUXV4DFWQRUJWbsuggW5wWqb93VzgxhC0r8mHwP
	LM4soCWxfudxJghbXmLzmrdgqyQE1CUe/dWFuMBIYuGtf4wQJSIS+168Y5zAKDQLyaRZSCbN
	QjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCg/iZ9A7GVQ0WhxgFOBiVeHgz
	nGsChFgTy4orcw8xSnAwK4nwekwECvGmJFZWpRblxxeV5qQWH2KU5mBREudt9kgJEBJITyxJ
	zU5NLUgtgskycXBKNTC6xXy01Ptfu3DXc4+P23hbF7IvXn3VNbv/AZObkcpCDsYnu1NDpkt4
	JkpPq75bV/PIPFD87t3P9fWWfn+uv7x4yvLS788ndt6IP33t6ZGfPdu5+lyqI+IF7bcKBLNt
	cZpx9eWWPfec05enub4zdljh+SN5j/uSG9abXW70fzlh+ZzJeUHut6slSizFGYmGWsxFxYkA
	LFbFdF4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch error and warning as below:

WARNING: line over 80 characters
ERROR: return is not a function, parentheses are not required

Also, long comments are fixed for the preferred style.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/jornada720_bl.c  |   34 ++++++++++++++++++-----------
 drivers/video/backlight/jornada720_lcd.c |    3 +-
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 16f593b..c23801c 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -48,7 +48,7 @@ static int jornada_bl_get_brightness(struct backlight_device *bd)
 
 	jornada_ssp_end();
 
-	return (BL_MAX_BRIGHT - ret);
+	return BL_MAX_BRIGHT - ret;
 }
 
 static int jornada_bl_update_status(struct backlight_device *bd)
@@ -58,7 +58,8 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 	jornada_ssp_start();
 
 	/* If backlight is off then really turn it off */
-	if ((bd->props.power != FB_BLANK_UNBLANK) || (bd->props.fb_blank != FB_BLANK_UNBLANK)) {
+	if ((bd->props.power != FB_BLANK_UNBLANK) ||
+		(bd->props.fb_blank != FB_BLANK_UNBLANK)) {
 		ret = jornada_ssp_byte(BRIGHTNESSOFF);
 		if (ret != TXDUMMY) {
 			pr_info("brightness off timeout\n");
@@ -77,18 +78,23 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 			goto out;
 		}
 
-		/* at this point we expect that the mcu has accepted
-		   our command and is waiting for our new value
-		   please note that maximum brightness is 255,
-		   but due to physical layout it is equal to 0, so we simply
-		   invert the value (MAX VALUE - NEW VALUE). */
-		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness) != TXDUMMY) {
+		/*
+		 * at this point we expect that the mcu has accepted
+		 * our command and is waiting for our new value
+		 * please note that maximum brightness is 255,
+		 * but due to physical layout it is equal to 0, so we simply
+		 * invert the value (MAX VALUE - NEW VALUE).
+		 */
+		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness)
+			!= TXDUMMY) {
 			pr_err("set brightness failed\n");
 			ret = -ETIMEDOUT;
 		}
 
-		/* If infact we get an TXDUMMY as output we are happy and dont
-		   make any further comments about it */
+		/*
+		 * If infact we get an TXDUMMY as output we are happy and dont
+		 * make any further comments about it
+		 */
 out:
 	jornada_ssp_end();
 
@@ -121,9 +127,11 @@ static int jornada_bl_probe(struct platform_device *pdev)
 
 	bd->props.power = FB_BLANK_UNBLANK;
 	bd->props.brightness = BL_DEF_BRIGHT;
-	/* note. make sure max brightness is set otherwise
-	   you will get seemingly non-related errors when
-	   trying to change brightness */
+	/*
+	 * note. make sure max brightness is set otherwise
+	 * you will get seemingly non-related errors when
+	 * trying to change brightness
+	 */
 	jornada_bl_update_status(bd);
 
 	platform_set_drvdata(pdev, bd);
diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index 635b305..4b412cb 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -101,7 +101,8 @@ static int jornada_lcd_probe(struct platform_device *pdev)
 	struct lcd_device *lcd_device;
 	int ret;
 
-	lcd_device = lcd_device_register(S1D_DEVICENAME, &pdev->dev, NULL, &jornada_lcd_props);
+	lcd_device = lcd_device_register(S1D_DEVICENAME, &pdev->dev, NULL,
+					&jornada_lcd_props);
 
 	if (IS_ERR(lcd_device)) {
 		ret = PTR_ERR(lcd_device);
-- 
1.7.1


