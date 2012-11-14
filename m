Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab2KNLQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:16:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58810 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab2KNLQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:16:12 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] backlight: pandora_bl: Change TWL4030_MODULE_PWM0 to TWL_MODULE_PWM
Date: Wed, 14 Nov 2012 12:16:01 +0100
Message-ID: <1352891761-29561-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TWL_MODULE_PWM is defined as:
#define TWL_MODULE_PWM		TWL4030_MODULE_PWM0

Use the common module ID define here which will facilitate the upcoming
twl-core cleanup.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/video/backlight/pandora_bl.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/pandora_bl.c b/drivers/video/backlight/pandora_bl.c
index 4ec3074..633b0a2 100644
--- a/drivers/video/backlight/pandora_bl.c
+++ b/drivers/video/backlight/pandora_bl.c
@@ -71,8 +71,7 @@ static int pandora_backlight_update_status(struct backlight_device *bl)
 		 * set PWM duty cycle to max. TPS61161 seems to use this
 		 * to calibrate it's PWM sensitivity when it starts.
 		 */
-		twl_i2c_write_u8(TWL4030_MODULE_PWM0, MAX_VALUE,
-					TWL_PWM0_OFF);
+		twl_i2c_write_u8(TWL_MODULE_PWM, MAX_VALUE, TWL_PWM0_OFF);
 
 		/* first enable clock, then PWM0 out */
 		twl_i2c_read_u8(TWL4030_MODULE_INTBR, &r, TWL_INTBR_GPBR1);
@@ -90,8 +89,7 @@ static int pandora_backlight_update_status(struct backlight_device *bl)
 		usleep_range(2000, 10000);
 	}
 
-	twl_i2c_write_u8(TWL4030_MODULE_PWM0, MIN_VALUE + brightness,
-				TWL_PWM0_OFF);
+	twl_i2c_write_u8(TWL_MODULE_PWM, MIN_VALUE + brightness, TWL_PWM0_OFF);
 
 done:
 	if (brightness != 0)
@@ -132,7 +130,7 @@ static int pandora_backlight_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bl);
 
 	/* 64 cycle period, ON position 0 */
-	twl_i2c_write_u8(TWL4030_MODULE_PWM0, 0x80, TWL_PWM0_ON);
+	twl_i2c_write_u8(TWL_MODULE_PWM, 0x80, TWL_PWM0_ON);
 
 	bl->props.state |= PANDORABL_WAS_OFF;
 	bl->props.brightness = MAX_USER_VALUE;
-- 
1.8.0

