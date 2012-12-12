Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2LLOBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:01:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44374 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab2LLOBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:01:12 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/33] leds-lp55xx: replace name of data structure
Thread-Topic: [PATCH 08/33] leds-lp55xx: replace name of data structure
Thread-Index: Ac3YcSHq2Muv6/k7TQ6wtDoWY5Wasw==
Date: Wed, 12 Dec 2012 14:01:08 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAE8@DQHE02.ent.ti.com>
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

 Change name of chip data structure and platform data.
 This patch is a preceding step for cleaning up lp5521/5523 probe and remove.
 These data will be replaced with new lp55xx common data structures
 in next patch.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   36 ++++++++++++++++++------------------
 drivers/leds/leds-lp5523.c |   38 +++++++++++++++++++-------------------
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 56ea946..2e646e1 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -872,35 +872,35 @@ static void lp5521_unregister_leds(struct lp5521_chip *chip)
 static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct lp5521_chip		*chip;
-	struct lp5521_platform_data	*pdata;
+	struct lp5521_chip		*old_chip;
+	struct lp5521_platform_data	*old_pdata;
 	int ret;
 
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
 
-	ret = lp5521_init_device(chip);
+	ret = lp5521_init_device(old_chip);
 	if (ret)
 		goto err_init;
 
 	dev_info(&client->dev, "%s programmable led chip found\n", id->name);
 
-	ret = lp5521_register_leds(chip);
+	ret = lp5521_register_leds(old_chip);
 	if (ret)
 		goto fail2;
 
@@ -911,23 +911,23 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	}
 	return ret;
 fail2:
-	lp5521_unregister_leds(chip);
+	lp5521_unregister_leds(old_chip);
 fail1:
-	lp5521_deinit_device(chip);
+	lp5521_deinit_device(old_chip);
 err_init:
 	return ret;
 }
 
 static int __devexit lp5521_remove(struct i2c_client *client)
 {
-	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	struct lp5521_chip *old_chip = i2c_get_clientdata(client);
 
-	lp5521_run_led_pattern(PATTERN_OFF, chip);
+	lp5521_run_led_pattern(PATTERN_OFF, old_chip);
 	lp5521_unregister_sysfs(client);
 
-	lp5521_unregister_leds(chip);
+	lp5521_unregister_leds(old_chip);
 
-	lp5521_deinit_device(chip);
+	lp5521_deinit_device(old_chip);
 	return 0;
 }
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index a6521ea..270dfbe 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -1010,44 +1010,44 @@ static void lp5523_deinit_device(struct lp5523_chip *chip)
 static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct lp5523_chip		*chip;
-	struct lp5523_platform_data	*pdata;
+	struct lp5523_chip		*old_chip;
+	struct lp5523_platform_data	*old_pdata;
 	int ret, i;
 
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
 
-	ret = lp5523_init_device(chip);
+	ret = lp5523_init_device(old_chip);
 	if (ret)
 		goto err_init;
 
 	dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
 
 	/* Initialize engines */
-	for (i = 0; i < ARRAY_SIZE(chip->engines); i++) {
-		ret = lp5523_init_engine(&chip->engines[i], i + 1);
+	for (i = 0; i < ARRAY_SIZE(old_chip->engines); i++) {
+		ret = lp5523_init_engine(&old_chip->engines[i], i + 1);
 		if (ret) {
 			dev_err(&client->dev, "error initializing engine\n");
 			goto fail1;
 		}
 	}
 
-	ret = lp5523_register_leds(chip, id->name);
+	ret = lp5523_register_leds(old_chip, id->name);
 	if (ret)
 		goto fail2;
 
@@ -1058,25 +1058,25 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	}
 	return ret;
 fail2:
-	lp5523_unregister_leds(chip);
+	lp5523_unregister_leds(old_chip);
 fail1:
-	lp5523_deinit_device(chip);
+	lp5523_deinit_device(old_chip);
 err_init:
 	return ret;
 }
 
 static int lp5523_remove(struct i2c_client *client)
 {
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	struct lp5523_chip *old_chip = i2c_get_clientdata(client);
 
 	/* Disable engine mode */
 	lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
 
 	lp5523_unregister_sysfs(client);
 
-	lp5523_unregister_leds(chip);
+	lp5523_unregister_leds(old_chip);
 
-	lp5523_deinit_device(chip);
+	lp5523_deinit_device(old_chip);
 	return 0;
 }
 
-- 
1.7.9.5


Best Regards,
Milo


