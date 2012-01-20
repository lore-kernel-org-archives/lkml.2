Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2ATBuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:50:55 -0500
Received: from mail2.nsc.com ([12.238.8.132]:52767 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755325Ab2ATBuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:50:54 -0500
X-WSS-ID: 0LY2QGP-0A-FF1-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Thu, 19 Jan 2012 17:50:25 -0800
Subject: [PATCH 5/7] leds-lm3530: replace 'i2c_client' with
 'led_classdev'
Thread-Topic: [PATCH 5/7] leds-lm3530: replace 'i2c_client' with
 'led_classdev'
Thread-Index: AczXFeD/IVI/swmRQEeq7C0EMZQ8sA==
Message-ID: <B567DBAB974C0544994013492B949F8E3812C6D0D1@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630617E51LS9810001-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get members of lm3530_data, use 'struct led_classdev' rather than
'struct i2c_client'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 0a42207..89b667b 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -290,11 +290,10 @@ static ssize_t lm3530_mode_get(struct device *dev,
 static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 				   *attr, const char *buf, size_t size)
 {
-	int err;
-	struct i2c_client *client = container_of(
-					dev->parent, struct i2c_client, dev);
-	struct lm3530_data *drvdata = i2c_get_clientdata(client);
-	int mode;
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3530_data *drvdata =
+	    container_of(led_cdev, struct lm3530_data, led_dev);
+	int mode, err;
 
 	mode = lm3530_get_mode_from_str(buf);
 	if (mode < 0) {
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated

