Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2AaHeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:34:12 -0500
Received: from mail2.nsc.com ([12.238.8.132]:55753 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752848Ab2AaHeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:34:08 -0500
X-WSS-ID: 0LYNJOR-0A-MML-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jan 2012 23:33:53 -0800
Subject: [PATCH v3 4/6] leds-lm3530: replace i2c_client with
 led_classdev
Thread-Topic: [PATCH v3 4/6] leds-lm3530: replace i2c_client with
 led_classdev
Thread-Index: Aczf6q6Xg2OeLX5nSSyDBf7yueXiWQ==
Message-ID: <B567DBAB974C0544994013492B949F8E3812DEC934@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633946EE1LS10038289-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get members of lm3530_data, use 'struct led_classdev' rather than
'struct i2c_client'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/leds/leds-lm3530.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index b2fd545..fdb3988 100644
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




