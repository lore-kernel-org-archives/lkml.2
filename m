Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab2AaHd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:33:59 -0500
Received: from mail2.nsc.com ([12.238.8.132]:55688 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752709Ab2AaHd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:33:57 -0500
X-WSS-ID: 0LYNJOG-0A-MMD-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jan 2012 23:33:44 -0800
Subject: [PATCH v3 3/6] leds-lm3530: add lm3530_mode_get() in the
 dev_attr
Thread-Topic: [PATCH v3 3/6] leds-lm3530: add lm3530_mode_get() in the
 dev_attr
Thread-Index: Aczf6qmBv4QKpm0ATDm/dz4QS7ZaEw==
Message-ID: <B567DBAB974C0544994013492B949F8E3812DEC933@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633946D01LS10038281-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get information about brightness control mode, lm3530_mode_get() is added.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/leds/leds-lm3530.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 963a1db..b2fd545 100644
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




