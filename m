Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2JEIW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:22:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47690 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2JEIW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:22:26 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/28] leds-lp5521/5523: use lp55xx common deinit device
 function
Thread-Topic: [PATCH 19/28] leds-lp5521/5523: use lp55xx common deinit
 device function
Thread-Index: Ac2i0n82tizrU0iCSXC5jJ/e8jx0vA==
Date: Fri, 5 Oct 2012 08:22:02 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176806@DQHE02.ent.ti.com>
Accept-Language: en-US
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

 Use lp55xx common function to release the device.
 Unnecessary old code lines are removed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    6 +-----
 drivers/leds/leds-lp5523.c |    6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 8aa4a90..67d492c 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -528,7 +528,6 @@ err_init:
 
 static int __devexit lp5521_remove(struct i2c_client *client)
 {
-	struct lp5521_chip *old_chip = i2c_get_clientdata(client);
 	struct lp55xx_led *led = i2c_get_clientdata(client);
 	struct lp55xx_chip *chip = led->chip;
 
@@ -536,11 +535,8 @@ static int __devexit lp5521_remove(struct i2c_client *client)
 
 	lp55xx_unregister_sysfs(chip);
 	lp55xx_unregister_leds(led, chip);
+	lp55xx_deinit_device(chip);
 
-	if (old_chip->pdata->enable)
-		old_chip->pdata->enable(0);
-	if (old_chip->pdata->release_resources)
-		old_chip->pdata->release_resources();
 	return 0;
 }
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index b029a09..5c4f6df 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -583,7 +583,6 @@ err_init:
 
 static int lp5523_remove(struct i2c_client *client)
 {
-	struct lp5523_chip *old_chip = i2c_get_clientdata(client);
 	struct lp55xx_led *led = i2c_get_clientdata(client);
 	struct lp55xx_chip *chip = led->chip;
 
@@ -591,11 +590,8 @@ static int lp5523_remove(struct i2c_client *client)
 
 	lp55xx_unregister_sysfs(chip);
 	lp55xx_unregister_leds(led, chip);
+	lp55xx_deinit_device(chip);
 
-	if (old_chip->pdata->enable)
-		old_chip->pdata->enable(0);
-	if (old_chip->pdata->release_resources)
-		old_chip->pdata->release_resources();
 	return 0;
 }
 
-- 
1.7.9.5


Best Regards,
Milo


