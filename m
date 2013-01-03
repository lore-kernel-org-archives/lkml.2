Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3ACG2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:28:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39028 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab3ACG2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:28:23 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds-lp8788: fix a parent device in _probe()
Thread-Topic: [PATCH] leds-lp8788: fix a parent device in _probe()
Thread-Index: Ac3pe4D79wleqFBrT6amHZaZ/1xv8w==
Date: Thu, 3 Jan 2013 06:28:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E10FBC@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The lp8788-keyled is a platform driver of lp8788-mfd.
 The platform device is allocated when mfd_add_devices() is called
 in lp8788-mfd.
 On the other hand, 'lp->dev' is the i2c client device.

 Therefore, this 'platform_device' is a proper parent device in case of
 resource managed mem alloc, registering led device and device kernel messages.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp8788.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-lp8788.c b/drivers/leds/leds-lp8788.c
index 4353942..7c2cb38 100644
--- a/drivers/leds/leds-lp8788.c
+++ b/drivers/leds/leds-lp8788.c
@@ -130,9 +130,10 @@ static int lp8788_led_probe(struct platform_device *pdev)
 	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
 	struct lp8788_led_platform_data *led_pdata;
 	struct lp8788_led *led;
+	struct device *dev = &pdev->dev;
 	int ret;
 
-	led = devm_kzalloc(lp->dev, sizeof(struct lp8788_led), GFP_KERNEL);
+	led = devm_kzalloc(dev, sizeof(struct lp8788_led), GFP_KERNEL);
 	if (!led)
 		return -ENOMEM;
 
@@ -154,13 +155,13 @@ static int lp8788_led_probe(struct platform_device *pdev)
 
 	ret = lp8788_led_init_device(led, led_pdata);
 	if (ret) {
-		dev_err(lp->dev, "led init device err: %d\n", ret);
+		dev_err(dev, "led init device err: %d\n", ret);
 		return ret;
 	}
 
-	ret = led_classdev_register(lp->dev, &led->led_dev);
+	ret = led_classdev_register(dev, &led->led_dev);
 	if (ret) {
-		dev_err(lp->dev, "led register err: %d\n", ret);
+		dev_err(dev, "led register err: %d\n", ret);
 		return ret;
 	}
 
-- 
1.7.9.5


Best Regards,
Milo


