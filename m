Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2JEIK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:10:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47143 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2JEIKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:10:47 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/28] leds-lp55xx: change variable names before probe()
 cleanup
Thread-Topic: [PATCH 02/28] leds-lp55xx: change variable names before
 probe() cleanup
Thread-Index: Ac2i0ONiytI5s35RROSpjXa858jxVw==
Date: Fri, 5 Oct 2012 08:10:31 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176702@DQHE02.ent.ti.com>
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

 Adding prefix old_ for variables for avoiding compile error with
 new lp55xx structure.
 This patch is preceding step for changing _probe().
 Adding prefix old_ will be removed after _probe() cleanup.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   70 ++++++++++++++++++++---------------------
 drivers/leds/leds-lp5523.c |   74 ++++++++++++++++++++++----------------------
 2 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 2064aef..992984b 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -739,39 +739,39 @@ static int __devinit lp5521_init_led(struct lp5521_led *led,
 static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct lp5521_chip		*chip;
-	struct lp5521_platform_data	*pdata;
-	int ret, i, led;
+	struct lp5521_chip		*old_chip;
+	struct lp5521_platform_data	*old_pdata;
+	int ret, i, old_led;
 	u8 buf;
 
-	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
-	if (!chip)
+	old_chip = devm_kzalloc(&client->dev, sizeof(*old_chip), GFP_KERNEL);
+	if (!old_chip)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, chip);
-	chip->client = client;
+	i2c_set_clientdata(client, old_chip);
+	old_chip->client = client;
 
-	pdata = client->dev.platform_data;
+	old_pdata = client->dev.platform_data;
 
-	if (!pdata) {
+	if (!old_pdata) {
 		dev_err(&client->dev, "no platform data\n");
 		return -EINVAL;
 	}
 
-	mutex_init(&chip->lock);
+	mutex_init(&old_chip->lock);
 
-	chip->pdata   = pdata;
+	old_chip->pdata   = old_pdata;
 
-	if (pdata->setup_resources) {
-		ret = pdata->setup_resources();
+	if (old_pdata->setup_resources) {
+		ret = old_pdata->setup_resources();
 		if (ret < 0)
 			return ret;
 	}
 
-	if (pdata->enable) {
-		pdata->enable(0);
+	if (old_pdata->enable) {
+		old_pdata->enable(0);
 		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
-		pdata->enable(1);
+		old_pdata->enable(1);
 		usleep_range(1000, 2000); /* 500us abs min. */
 	}
 
@@ -810,30 +810,30 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	}
 
 	/* Initialize leds */
-	chip->num_channels = pdata->num_channels;
-	chip->num_leds = 0;
-	led = 0;
-	for (i = 0; i < pdata->num_channels; i++) {
+	old_chip->num_channels = old_pdata->num_channels;
+	old_chip->num_leds = 0;
+	old_led = 0;
+	for (i = 0; i < old_pdata->num_channels; i++) {
 		/* Do not initialize channels that are not connected */
-		if (pdata->led_config[i].led_current == 0)
+		if (old_pdata->led_config[i].led_current == 0)
 			continue;
 
-		ret = lp5521_init_led(&chip->leds[led], client, i, pdata);
+		ret = lp5521_init_led(&old_chip->leds[old_led], client, i, old_pdata);
 		if (ret) {
 			dev_err(&client->dev, "error initializing leds\n");
 			goto fail2;
 		}
-		chip->num_leds++;
+		old_chip->num_leds++;
 
-		chip->leds[led].id = led;
+		old_chip->leds[old_led].id = old_led;
 		/* Set initial LED current */
-		lp5521_set_led_current(chip, led,
-				chip->leds[led].led_current);
+		lp5521_set_led_current(old_chip, old_led,
+				old_chip->leds[old_led].led_current);
 
-		INIT_WORK(&(chip->leds[led].brightness_work),
+		INIT_WORK(&(old_chip->leds[old_led].brightness_work),
 			lp5521_led_brightness_work);
 
-		led++;
+		old_led++;
 	}
 
 	ret = lp5521_register_sysfs(client);
@@ -843,15 +843,15 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	}
 	return ret;
 fail2:
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		cancel_work_sync(&chip->leds[i].brightness_work);
+	for (i = 0; i < old_chip->num_leds; i++) {
+		led_classdev_unregister(&old_chip->leds[i].cdev);
+		cancel_work_sync(&old_chip->leds[i].brightness_work);
 	}
 fail1:
-	if (pdata->enable)
-		pdata->enable(0);
-	if (pdata->release_resources)
-		pdata->release_resources();
+	if (old_pdata->enable)
+		old_pdata->enable(0);
+	if (old_pdata->release_resources)
+		old_pdata->release_resources();
 	return ret;
 }
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 97994ff..75fc7d5 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -885,38 +885,38 @@ static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
 static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct lp5523_chip		*chip;
-	struct lp5523_platform_data	*pdata;
-	int ret, i, led;
+	struct lp5523_chip		*old_chip;
+	struct lp5523_platform_data	*old_pdata;
+	int ret, i, old_led;
 
-	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
-	if (!chip)
+	old_chip = devm_kzalloc(&client->dev, sizeof(*old_chip), GFP_KERNEL);
+	if (!old_chip)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, chip);
-	chip->client = client;
+	i2c_set_clientdata(client, old_chip);
+	old_chip->client = client;
 
-	pdata = client->dev.platform_data;
+	old_pdata = client->dev.platform_data;
 
-	if (!pdata) {
+	if (!old_pdata) {
 		dev_err(&client->dev, "no platform data\n");
 		return -EINVAL;
 	}
 
-	mutex_init(&chip->lock);
+	mutex_init(&old_chip->lock);
 
-	chip->pdata   = pdata;
+	old_chip->pdata   = old_pdata;
 
-	if (pdata->setup_resources) {
-		ret = pdata->setup_resources();
+	if (old_pdata->setup_resources) {
+		ret = old_pdata->setup_resources();
 		if (ret < 0)
 			return ret;
 	}
 
-	if (pdata->enable) {
-		pdata->enable(0);
+	if (old_pdata->enable) {
+		old_pdata->enable(0);
 		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
-		pdata->enable(1);
+		old_pdata->enable(1);
 		usleep_range(1000, 2000); /* 500us abs min. */
 	}
 
@@ -932,8 +932,8 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
 
 	/* Initialize engines */
-	for (i = 0; i < ARRAY_SIZE(chip->engines); i++) {
-		ret = lp5523_init_engine(&chip->engines[i], i + 1);
+	for (i = 0; i < ARRAY_SIZE(old_chip->engines); i++) {
+		ret = lp5523_init_engine(&old_chip->engines[i], i + 1);
 		if (ret) {
 			dev_err(&client->dev, "error initializing engine\n");
 			goto fail1;
@@ -946,32 +946,32 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	}
 
 	/* Initialize leds */
-	chip->num_channels = pdata->num_channels;
-	chip->num_leds = 0;
-	led = 0;
-	for (i = 0; i < pdata->num_channels; i++) {
+	old_chip->num_channels = old_pdata->num_channels;
+	old_chip->num_leds = 0;
+	old_led = 0;
+	for (i = 0; i < old_pdata->num_channels; i++) {
 		/* Do not initialize channels that are not connected */
-		if (pdata->led_config[i].led_current == 0)
+		if (old_pdata->led_config[i].led_current == 0)
 			continue;
 
-		INIT_WORK(&chip->leds[led].brightness_work,
+		INIT_WORK(&old_chip->leds[old_led].brightness_work,
 			lp5523_led_brightness_work);
 
-		ret = lp5523_init_led(&chip->leds[led], &client->dev, i, pdata,
+		ret = lp5523_init_led(&old_chip->leds[old_led], &client->dev, i, old_pdata,
 				id->name);
 		if (ret) {
 			dev_err(&client->dev, "error initializing leds\n");
 			goto fail2;
 		}
-		chip->num_leds++;
+		old_chip->num_leds++;
 
-		chip->leds[led].id = led;
+		old_chip->leds[old_led].id = old_led;
 		/* Set LED current */
 		lp5523_write(client,
-			  LP5523_REG_LED_CURRENT_BASE + chip->leds[led].chan_nr,
-			  chip->leds[led].led_current);
+			  LP5523_REG_LED_CURRENT_BASE + old_chip->leds[old_led].chan_nr,
+			  old_chip->leds[old_led].led_current);
 
-		led++;
+		old_led++;
 	}
 
 	ret = lp5523_register_sysfs(client);
@@ -981,15 +981,15 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	}
 	return ret;
 fail2:
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		flush_work(&chip->leds[i].brightness_work);
+	for (i = 0; i < old_chip->num_leds; i++) {
+		led_classdev_unregister(&old_chip->leds[i].cdev);
+		flush_work(&old_chip->leds[i].brightness_work);
 	}
 fail1:
-	if (pdata->enable)
-		pdata->enable(0);
-	if (pdata->release_resources)
-		pdata->release_resources();
+	if (old_pdata->enable)
+		old_pdata->enable(0);
+	if (old_pdata->release_resources)
+		old_pdata->release_resources();
 	return ret;
 }
 
-- 
1.7.9.5


Best Regards,
Milo


