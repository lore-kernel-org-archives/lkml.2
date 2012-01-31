Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab2AaHdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:33:50 -0500
Received: from mail2.nsc.com ([12.238.8.132]:55663 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752482Ab2AaHds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:33:48 -0500
X-WSS-ID: 0LYNJO7-0A-MM7-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jan 2012 23:33:28 -0800
Subject: [PATCH v3 2/6] leds-lm3530: add 'name' in lm3530_platform_data
Thread-Topic: [PATCH v3 2/6] leds-lm3530: add 'name' in
 lm3530_platform_data
Thread-Index: Aczf6p+dJTb7+I07QsqVEsP5pnJewQ==
Message-ID: <B567DBAB974C0544994013492B949F8E3812DEC931@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633946C01LS10038277-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The led device name can be configurable.
For the compatibility, the name is set to default value(LM3530_LED_DEV)
when 'name' is not defined.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/leds/leds-lm3530.c |    2 +-
 include/linux/led-lm3530.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 3135734..963a1db 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -341,7 +341,7 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 	drvdata->pdata = pdata;
 	drvdata->brightness = LED_OFF;
 	drvdata->enable = false;
-	drvdata->led_dev.name = LM3530_LED_DEV;
+	drvdata->led_dev.name = pdata->name ? pdata->name : LM3530_LED_DEV;
 	drvdata->led_dev.brightness_set = lm3530_brightness_set;
 
 	i2c_set_clientdata(client, drvdata);
diff --git a/include/linux/led-lm3530.h b/include/linux/led-lm3530.h
index 5534d1e..513e9c3 100644
--- a/include/linux/led-lm3530.h
+++ b/include/linux/led-lm3530.h
@@ -91,6 +91,7 @@ struct lm3530_pwm_data {
  * @als1_resistor_sel: internal resistance from ALS1 input to ground
  * @als2_resistor_sel: internal resistance from ALS2 input to ground
  * @brt_val: brightness value (0-255)
+ * @name: led device name
  * @pwm_data: PWM control functions. only valid when the mode is PWM.
  */
 struct lm3530_platform_data {
@@ -110,6 +111,7 @@ struct lm3530_platform_data {
 
 	u8 brt_val;
 
+	const char *name;
 	struct lm3530_pwm_data pwm_data;
 };
 
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




