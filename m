Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2JEIU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:20:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58095 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab2JEIUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:20:24 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/28] leds-lp5521/5523: use lp55xx common unregister sysfs
 function
Thread-Topic: [PATCH 17/28] leds-lp5521/5523: use lp55xx common unregister
 sysfs function
Thread-Index: Ac2i0jwO4nEKDsa3S+GQg+dQV6dw5Q==
Date: Fri, 5 Oct 2012 08:20:10 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641767DB@DQHE02.ent.ti.com>
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

 While loading the driver, lp55xx common device attributes are registered.
 On removing the driver, the attributes should be unregistered.
 Old sysfs function is removed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   10 ++--------
 drivers/leds/leds-lp5523.c |    9 +--------
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index a5aae05..786b539 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -452,13 +452,6 @@ static const struct attribute_group lp5521_group = {
 	.attrs = lp5521_attributes,
 };
 
-static void lp5521_unregister_sysfs(struct i2c_client *client)
-{
-	struct device *dev = &client->dev;
-
-	sysfs_remove_group(&dev->kobj, &lp5521_group);
-}
-
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5521_cfg = {
 	.max_channel  = LP5521_MAX_LEDS,
@@ -541,7 +534,8 @@ static int __devexit lp5521_remove(struct i2c_client *client)
 	struct lp55xx_chip *chip = led->chip;
 
 	lp5521_stop_engine(chip);
-	lp5521_unregister_sysfs(client);
+
+	lp55xx_unregister_sysfs(chip);
 
 	for (i = 0; i < old_chip->num_leds; i++) {
 		led_classdev_unregister(&old_chip->leds[i].cdev);
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index c54785c..c9229fc 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -503,13 +503,6 @@ static const struct attribute_group lp5523_group = {
 	.attrs = lp5523_attributes,
 };
 
-static void lp5523_unregister_sysfs(struct i2c_client *client)
-{
-	struct device *dev = &client->dev;
-
-	sysfs_remove_group(&dev->kobj, &lp5523_group);
-}
-
 /*--------------------------------------------------------------*/
 /*			Probe, Attach, Remove			*/
 /*--------------------------------------------------------------*/
@@ -597,7 +590,7 @@ static int lp5523_remove(struct i2c_client *client)
 
 	lp5523_stop_engine(chip);
 
-	lp5523_unregister_sysfs(client);
+	lp55xx_unregister_sysfs(chip);
 
 	for (i = 0; i < old_chip->num_leds; i++) {
 		led_classdev_unregister(&old_chip->leds[i].cdev);
-- 
1.7.9.5


Best Regards,
Milo


