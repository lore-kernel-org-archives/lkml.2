Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab2DTHah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:30:37 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:54576 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800Ab2DTHaf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:30:35 -0400
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 20 Apr 2012 09:28:46 +0200
Subject: RE: [PATCH 1/2] leds-lm3530: comment correction about the range of
 brightness
Thread-Topic: [PATCH 1/2] leds-lm3530: comment correction about the range of
 brightness
Thread-Index: Ac0d91aE61uKSG1fTRa0ziODJqgpzAAz8gZw
Message-ID: <2E48302EED53D048A7BA72B0A307FB511FB8D43B52@EXDCVYMBSTM005.EQ1STM.local>
References: <DD6B9D658496A2488636C8C75B9C0CB601CD3224@EXMAIL04.scwf.nsc.com>
In-Reply-To: <DD6B9D658496A2488636C8C75B9C0CB601CD3224@EXMAIL04.scwf.nsc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I feel driver should take care of range provided by hardware by 
scaling the value provided by user, instead of limiting the max 
brightness to user.

For .e.g. here it can be something like this -
                err = i2c_smbus_write_byte_data(drvdata->client,
                                LM3530_BRT_CTRL_REG, brt_val / 2);

I am not sure if application really use/check max brightness in before 
calculating/setting new brightness values.

-----Original Message-----
From: Kim, Milo [mailto:Milo.Kim@ti.com] 
Sent: Thursday, April 19, 2012 12:11 PM
To: Andrew Morton
Cc: Shreshtha Kumar SAHU; linus.walleij@linaro.org; Richard Purdie; linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] leds-lm3530: comment correction about the range of brightness

max brightness is 127, so the range of brt_val should be from 0 to 127

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 include/linux/led-lm3530.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/led-lm3530.h b/include/linux/led-lm3530.h
index eeae6e7..4b13347 100644
--- a/include/linux/led-lm3530.h
+++ b/include/linux/led-lm3530.h
@@ -92,7 +92,7 @@ struct lm3530_pwm_data {
  * @als2_resistor_sel: internal resistance from ALS2 input to ground
  * @als_vmin: als input voltage calibrated for max brightness in mV
  * @als_vmax: als input voltage calibrated for min brightness in mV
- * @brt_val: brightness value (0-255)
+ * @brt_val: brightness value (0-127)
  * @pwm_data: PWM control functions (only valid when the mode is PWM)
  */
 struct lm3530_platform_data {
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim


