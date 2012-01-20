Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2ATBwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:52:44 -0500
Received: from mail2.nsc.com ([12.238.8.132]:36255 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755593Ab2ATBwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:52:43 -0500
X-WSS-ID: 0LY2QJR-0A-FFX-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Thu, 19 Jan 2012 17:52:29 -0800
Subject: [PATCH 7/7] leds-lm3530: enhanced arithmetic operation
Thread-Topic: [PATCH 7/7] leds-lm3530: enhanced arithmetic operation
Thread-Index: AczXFir5mEEvIv5FQBeNkj9FUSGZ5w==
Message-ID: <B567DBAB974C0544994013492B949F8E3812C6D0D7@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6306175F1LS9810048-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use shift operation rather than 'divide-by-2'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 51c1f6c..e0b1ba8 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -249,12 +249,12 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 
 		/* set the brightness in brightness control register*/
 		err = i2c_smbus_write_byte_data(drvdata->client,
-				LM3530_BRT_CTRL_REG, brt_val / 2);
+				LM3530_BRT_CTRL_REG, brt_val >> 1);
 		if (err)
 			dev_err(&drvdata->client->dev,
 				"Unable to set brightness: %d\n", err);
 		else
-			drvdata->brightness = brt_val / 2;
+			drvdata->brightness = brt_val >> 1;
 
 		if (brt_val == 0 && !pdata->is_vin_always_on) {
 			err = regulator_disable(drvdata->regulator);
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated


