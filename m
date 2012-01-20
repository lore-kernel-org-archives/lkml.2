Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2ATBti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:49:38 -0500
Received: from mail2.nsc.com ([12.238.8.132]:52659 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755325Ab2ATBth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:49:37 -0500
X-WSS-ID: 0LY2QEM-0A-FEN-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Thu, 19 Jan 2012 17:49:25 -0800
Subject: [PATCH 4/7] leds-lm3530: add 'lm3530_mode_get()' in the lm3530
 device attribute
Thread-Topic: [PATCH 4/7] leds-lm3530: add 'lm3530_mode_get()' in the
 lm3530 device attribute
Thread-Index: AczXFb0awj5rU2NWTZyzBVK6p9EmMg==
Message-ID: <B567DBAB974C0544994013492B949F8E3812C6D0D0@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630617941LS9809981-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get information about brightness control mode, lm3530_mode_get() is added.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index ba2bb7e..0a42207 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -275,6 +275,17 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 	}
 }
 
+static ssize_t lm3530_mode_get(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3530_data *drvdata =
+	    container_of(led_cdev, struct lm3530_data, led_dev);
+	enum lm3530_mode m = drvdata->mode;
+
+	return sprintf(buf, "%s\n", mode_map[m].mode);
+}
 
 static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 				   *attr, const char *buf, size_t size)
@@ -302,7 +313,7 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 	return sizeof(drvdata->mode);
 }
 
-static DEVICE_ATTR(mode, 0644, NULL, lm3530_mode_set);
+static DEVICE_ATTR(mode, 0644, lm3530_mode_get, lm3530_mode_set);
 
 static int __devinit lm3530_probe(struct i2c_client *client,
 			   const struct i2c_device_id *id)
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated

