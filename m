Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab2GDCTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:19:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59769 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab2GDCTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:19:52 -0400
Message-ID: <1341368386.10587.5.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: gpio-regulator: Set enable enable_time
 in regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 04 Jul 2012 10:19:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/gpio-regulator.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 242851a..3ed8d15 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -39,7 +39,6 @@ struct gpio_regulator_data {
 	int enable_gpio;
 	bool enable_high;
 	bool is_enabled;
-	unsigned startup_delay;
 
 	struct gpio *gpios;
 	int nr_gpios;
@@ -81,13 +80,6 @@ static int gpio_regulator_disable(struct regulator_dev *dev)
 	return 0;
 }
 
-static int gpio_regulator_enable_time(struct regulator_dev *dev)
-{
-	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
-
-	return data->startup_delay;
-}
-
 static int gpio_regulator_get_value(struct regulator_dev *dev)
 {
 	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
@@ -156,7 +148,6 @@ static struct regulator_ops gpio_regulator_voltage_ops = {
 	.is_enabled = gpio_regulator_is_enabled,
 	.enable = gpio_regulator_enable,
 	.disable = gpio_regulator_disable,
-	.enable_time = gpio_regulator_enable_time,
 	.get_voltage = gpio_regulator_get_value,
 	.set_voltage = gpio_regulator_set_voltage,
 	.list_voltage = gpio_regulator_list_voltage,
@@ -166,7 +157,6 @@ static struct regulator_ops gpio_regulator_current_ops = {
 	.is_enabled = gpio_regulator_is_enabled,
 	.enable = gpio_regulator_enable,
 	.disable = gpio_regulator_disable,
-	.enable_time = gpio_regulator_enable_time,
 	.get_current_limit = gpio_regulator_get_value,
 	.set_current_limit = gpio_regulator_set_current_limit,
 };
@@ -213,6 +203,7 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 	drvdata->nr_states = config->nr_states;
 
 	drvdata->desc.owner = THIS_MODULE;
+	drvdata->desc.enable_time = config->startup_delay;
 
 	/* handle regulator type*/
 	switch (config->type) {
@@ -233,7 +224,6 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 	}
 
 	drvdata->enable_gpio = config->enable_gpio;
-	drvdata->startup_delay = config->startup_delay;
 
 	if (gpio_is_valid(config->enable_gpio)) {
 		drvdata->enable_high = config->enable_high;
-- 
1.7.9.5



