Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1J0IAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:00:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42644 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1J0IAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:00:00 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <lrg@ti.com>, <b-cousson@ti.com>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@freescale.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Zeng Zhaoming <b32542@freescale.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH v3 3/4] regulator: pass additional of_node to regulator_register()
Date: Thu, 27 Oct 2011 13:26:24 +0530
Message-ID: <1319702185-16108-4-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319702185-16108-1-git-send-email-rnayak@ti.com>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With device tree support for regulators, its needed that the
regulator_dev->dev device has the right of_node attached.
To be able to do this add an additional parameter to the
regulator_register() api, wherein the dt-adapted driver can
then pass this additional info onto the regulator core.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Zeng Zhaoming <b32542@freescale.com>
Cc: Dan Carpenter <error27@gmail.com>
---
 drivers/regulator/88pm8607.c           |    2 +-
 drivers/regulator/aat2870-regulator.c  |    2 +-
 drivers/regulator/ab3100.c             |    2 +-
 drivers/regulator/ab8500.c             |    2 +-
 drivers/regulator/ad5398.c             |    2 +-
 drivers/regulator/bq24022.c            |    2 +-
 drivers/regulator/core.c               |    3 ++-
 drivers/regulator/da903x.c             |    2 +-
 drivers/regulator/db8500-prcmu.c       |    2 +-
 drivers/regulator/dummy.c              |    2 +-
 drivers/regulator/fixed.c              |    2 +-
 drivers/regulator/isl6271a-regulator.c |    2 +-
 drivers/regulator/lp3971.c             |    2 +-
 drivers/regulator/lp3972.c             |    2 +-
 drivers/regulator/max1586.c            |    2 +-
 drivers/regulator/max8649.c            |    2 +-
 drivers/regulator/max8660.c            |    2 +-
 drivers/regulator/max8925-regulator.c  |    2 +-
 drivers/regulator/max8952.c            |    2 +-
 drivers/regulator/max8997.c            |    2 +-
 drivers/regulator/max8998.c            |    2 +-
 drivers/regulator/mc13783-regulator.c  |    2 +-
 drivers/regulator/mc13892-regulator.c  |    2 +-
 drivers/regulator/pcap-regulator.c     |    2 +-
 drivers/regulator/pcf50633-regulator.c |    2 +-
 drivers/regulator/tps6105x-regulator.c |    3 ++-
 drivers/regulator/tps65023-regulator.c |    2 +-
 drivers/regulator/tps6507x-regulator.c |    2 +-
 drivers/regulator/tps6524x-regulator.c |    2 +-
 drivers/regulator/tps6586x-regulator.c |    2 +-
 drivers/regulator/tps65910-regulator.c |    2 +-
 drivers/regulator/tps65912-regulator.c |    2 +-
 drivers/regulator/twl-regulator.c      |    2 +-
 drivers/regulator/wm831x-dcdc.c        |    8 ++++----
 drivers/regulator/wm831x-isink.c       |    2 +-
 drivers/regulator/wm831x-ldo.c         |    6 +++---
 drivers/regulator/wm8350-regulator.c   |    2 +-
 drivers/regulator/wm8400-regulator.c   |    2 +-
 drivers/regulator/wm8994-regulator.c   |    2 +-
 include/linux/regulator/driver.h       |    2 +-
 sound/soc/codecs/sgtl5000.c            |    2 +-
 41 files changed, 48 insertions(+), 46 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index d63fddb..443f2df 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -426,7 +426,7 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 
 	/* replace driver_data with info */
 	info->regulator = regulator_register(&info->desc, &pdev->dev,
-					     pdata, info);
+					     pdata, info, NULL);
 	if (IS_ERR(info->regulator)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			info->desc.name);
diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index cd41045..5c49a7c 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -187,7 +187,7 @@ static int aat2870_regulator_probe(struct platform_device *pdev)
 	ri->pdev = pdev;
 
 	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdev->dev.platform_data, ri);
+				  pdev->dev.platform_data, ri, NULL);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "Failed to register regulator %s\n",
 			ri->desc.name);
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 585e494..042271a 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -634,7 +634,7 @@ static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 		rdev = regulator_register(&ab3100_regulator_desc[i],
 					  &pdev->dev,
 					  &plfdata->reg_constraints[i],
-					  reg);
+					  reg, NULL);
 
 		if (IS_ERR(rdev)) {
 			err = PTR_ERR(rdev);
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 02f3c23..8b13b0e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -821,7 +821,7 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 
 		/* register regulator with framework */
 		info->regulator = regulator_register(&info->desc, &pdev->dev,
-				&pdata->regulator[i], info);
+				&pdata->regulator[i], info, NULL);
 		if (IS_ERR(info->regulator)) {
 			err = PTR_ERR(info->regulator);
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index a4be416..483c809 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -233,7 +233,7 @@ static int __devinit ad5398_probe(struct i2c_client *client,
 	chip->current_mask = (chip->current_level - 1) << chip->current_offset;
 
 	chip->rdev = regulator_register(&ad5398_reg, &client->dev,
-					init_data, chip);
+					init_data, chip, NULL);
 	if (IS_ERR(chip->rdev)) {
 		ret = PTR_ERR(chip->rdev);
 		dev_err(&client->dev, "failed to register %s %s\n",
diff --git a/drivers/regulator/bq24022.c b/drivers/regulator/bq24022.c
index 068d488..dc4a8e6 100644
--- a/drivers/regulator/bq24022.c
+++ b/drivers/regulator/bq24022.c
@@ -106,7 +106,7 @@ static int __init bq24022_probe(struct platform_device *pdev)
 	ret = gpio_direction_output(pdata->gpio_nce, 1);
 
 	bq24022 = regulator_register(&bq24022_desc, &pdev->dev,
-				     pdata->init_data, pdata);
+				     pdata->init_data, pdata, NULL);
 	if (IS_ERR(bq24022)) {
 		dev_dbg(&pdev->dev, "couldn't register regulator\n");
 		ret = PTR_ERR(bq24022);
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d8e6a42..6edaaf0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2574,7 +2574,7 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
  */
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	struct device *dev, const struct regulator_init_data *init_data,
-	void *driver_data)
+	void *driver_data, struct device_node *of_node)
 {
 	static atomic_t regulator_no = ATOMIC_INIT(0);
 	struct regulator_dev *rdev;
@@ -2632,6 +2632,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 
 	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
+	rdev->dev.of_node = of_node;
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%d",
 		     atomic_inc_return(&regulator_no) - 1);
diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 362e082..f3064fe 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -536,7 +536,7 @@ static int __devinit da903x_regulator_probe(struct platform_device *pdev)
 		ri->desc.ops = &da9030_regulator_ldo1_15_ops;
 
 	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdev->dev.platform_data, ri);
+				  pdev->dev.platform_data, ri, NULL);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index 2bb8f45..f88b13d 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -485,7 +485,7 @@ static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 
 		/* register with the regulator framework */
 		info->rdev = regulator_register(&info->desc, &pdev->dev,
-				init_data, info);
+				init_data, info, NULL);
 		if (IS_ERR(info->rdev)) {
 			err = PTR_ERR(info->rdev);
 			dev_err(&pdev->dev, "failed to register %s: err %i\n",
diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
index f6ef669..910583f 100644
--- a/drivers/regulator/dummy.c
+++ b/drivers/regulator/dummy.c
@@ -41,7 +41,7 @@ static int __devinit dummy_regulator_probe(struct platform_device *pdev)
 	int ret;
 
 	dummy_regulator_rdev = regulator_register(&dummy_desc, NULL,
-						  &dummy_initdata, NULL);
+						  &dummy_initdata, NULL, NULL);
 	if (IS_ERR(dummy_regulator_rdev)) {
 		ret = PTR_ERR(dummy_regulator_rdev);
 		pr_err("Failed to register regulator: %d\n", ret);
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 9851b42..bc78cc4 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -225,7 +225,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	}
 
 	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
-					  config->init_data, drvdata);
+					  config->init_data, drvdata, NULL);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index e4b3592..c1a456c 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -170,7 +170,7 @@ static int __devinit isl6271a_probe(struct i2c_client *i2c,
 
 	for (i = 0; i < 3; i++) {
 		pmic->rdev[i] = regulator_register(&isl_rd[i], &i2c->dev,
-						init_data, pmic);
+						init_data, pmic, NULL);
 		if (IS_ERR(pmic->rdev[i])) {
 			dev_err(&i2c->dev, "failed to register %s\n", id->name);
 			err = PTR_ERR(pmic->rdev[i]);
diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 0f22ef1..42b1a30 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -450,7 +450,7 @@ static int __devinit setup_regulators(struct lp3971 *lp3971,
 	for (i = 0; i < pdata->num_regulators; i++) {
 		struct lp3971_regulator_subdev *reg = &pdata->regulators[i];
 		lp3971->rdev[i] = regulator_register(&regulators[reg->id],
-					lp3971->dev, reg->initdata, lp3971);
+				lp3971->dev, reg->initdata, lp3971, NULL);
 
 		if (IS_ERR(lp3971->rdev[i])) {
 			err = PTR_ERR(lp3971->rdev[i]);
diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 6aa1b50..939e7f4 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -554,7 +554,7 @@ static int __devinit setup_regulators(struct lp3972 *lp3972,
 	for (i = 0; i < pdata->num_regulators; i++) {
 		struct lp3972_regulator_subdev *reg = &pdata->regulators[i];
 		lp3972->rdev[i] = regulator_register(&regulators[reg->id],
-					lp3972->dev, reg->initdata, lp3972);
+				lp3972->dev, reg->initdata, lp3972, NULL);
 
 		if (IS_ERR(lp3972->rdev[i])) {
 			err = PTR_ERR(lp3972->rdev[i]);
diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 3f49512..40e7a4d 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -214,7 +214,7 @@ static int __devinit max1586_pmic_probe(struct i2c_client *client,
 		}
 		rdev[i] = regulator_register(&max1586_reg[id], &client->dev,
 					     pdata->subdevs[i].platform_data,
-					     max1586);
+					     max1586, NULL);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(&client->dev, "failed to register %s\n",
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 30eb9e5..14d6d28 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -347,7 +347,7 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	}
 
 	info->regulator = regulator_register(&dcdc_desc, &client->dev,
-					     pdata->regulator, info);
+					     pdata->regulator, info, NULL);
 	if (IS_ERR(info->regulator)) {
 		dev_err(info->dev, "failed to register regulator %s\n",
 			dcdc_desc.name);
diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 33f5d9a..a838e66 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -449,7 +449,7 @@ static int __devinit max8660_probe(struct i2c_client *client,
 
 		rdev[i] = regulator_register(&max8660_reg[id], &client->dev,
 					     pdata->subdevs[i].platform_data,
-					     max8660);
+					     max8660, NULL);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(&client->dev, "failed to register %s\n",
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index e4dbd66..dd5fae9 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -265,7 +265,7 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 	ri->chip = chip;
 
 	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdata->regulator[pdev->id], ri);
+				  pdata->regulator[pdev->id], ri, NULL);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 486ed81..c4bfd4d 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -211,7 +211,7 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 	mutex_init(&max8952->mutex);
 
 	max8952->rdev = regulator_register(&regulator, max8952->dev,
-			&pdata->reg_data, max8952);
+			&pdata->reg_data, max8952, NULL);
 
 	if (IS_ERR(max8952->rdev)) {
 		ret = PTR_ERR(max8952->rdev);
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index ad6628c..f701ca5 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1145,7 +1145,7 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 			regulators[id].n_voltages = 16;
 
 		rdev[i] = regulator_register(&regulators[id], max8997->dev,
-				pdata->regulators[i].initdata, max8997);
+				pdata->regulators[i].initdata, max8997, NULL);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(max8997->dev, "regulator init failed for %d\n",
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 41a1495..2d38c24 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -847,7 +847,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 			regulators[index].n_voltages = count;
 		}
 		rdev[i] = regulator_register(&regulators[index], max8998->dev,
-				pdata->regulators[i].initdata, max8998);
+				pdata->regulators[i].initdata, max8998, NULL);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(max8998->dev, "regulator init failed\n");
diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 730f43a..8d5822b 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -356,7 +356,7 @@ static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 		init_data = &pdata->regulators[i];
 		priv->regulators[i] = regulator_register(
 				&mc13783_regulators[init_data->id].desc,
-				&pdev->dev, init_data->init_data, priv);
+				&pdev->dev, init_data->init_data, priv, NULL);
 
 		if (IS_ERR(priv->regulators[i])) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 3285d41..9d82b5c 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -572,7 +572,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 		init_data = &pdata->regulators[i];
 		priv->regulators[i] = regulator_register(
 			&mc13892_regulators[init_data->id].desc,
-			&pdev->dev, init_data->init_data, priv);
+			&pdev->dev, init_data->init_data, priv, NULL);
 
 		if (IS_ERR(priv->regulators[i])) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index 31f6e11..a5aab1b 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -277,7 +277,7 @@ static int __devinit pcap_regulator_probe(struct platform_device *pdev)
 	void *pcap = dev_get_drvdata(pdev->dev.parent);
 
 	rdev = regulator_register(&pcap_regulators[pdev->id], &pdev->dev,
-				pdev->dev.platform_data, pcap);
+				pdev->dev.platform_data, pcap, NULL);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 69a11d9..1d1c310 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -320,7 +320,7 @@ static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
 	pcf = dev_to_pcf50633(pdev->dev.parent);
 
 	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-				  pdev->dev.platform_data, pcf);
+				  pdev->dev.platform_data, pcf, NULL);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index 1011873..d9278da 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -151,7 +151,8 @@ static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
 	/* Register regulator with framework */
 	tps6105x->regulator = regulator_register(&tps6105x_regulator_desc,
 					     &tps6105x->client->dev,
-					     pdata->regulator_data, tps6105x);
+					     pdata->regulator_data, tps6105x,
+					     NULL);
 	if (IS_ERR(tps6105x->regulator)) {
 		ret = PTR_ERR(tps6105x->regulator);
 		dev_err(&tps6105x->client->dev,
diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 701a590..a7a1910 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -461,7 +461,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 		/* Register the regulators */
 		rdev = regulator_register(&tps->desc[i], &client->dev,
-					  init_data, tps);
+					  init_data, tps, NULL);
 		if (IS_ERR(rdev)) {
 			dev_err(&client->dev, "failed to register %s\n",
 				id->name);
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index bfffabc..0f86e56 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -605,7 +605,7 @@ int tps6507x_pmic_probe(struct platform_device *pdev)
 		tps->desc[i].owner = THIS_MODULE;
 
 		rdev = regulator_register(&tps->desc[i],
-					tps6507x_dev->dev, init_data, tps);
+					tps6507x_dev->dev, init_data, tps, NULL);
 		if (IS_ERR(rdev)) {
 			dev_err(tps6507x_dev->dev,
 				"failed to register %s regulator\n",
diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 9166aa0..70b7b1f 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -651,7 +651,7 @@ static int __devinit pmic_probe(struct spi_device *spi)
 			hw->desc[i].n_voltages = 1;
 
 		hw->rdev[i] = regulator_register(&hw->desc[i], dev,
-						 init_data, hw);
+						 init_data, hw, NULL);
 		if (IS_ERR(hw->rdev[i])) {
 			ret = PTR_ERR(hw->rdev[i]);
 			hw->rdev[i] = NULL;
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index bb04a75..6a35c3a 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -365,7 +365,7 @@ static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
 		return err;
 
 	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdev->dev.platform_data, ri);
+				  pdev->dev.platform_data, ri, NULL);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 66d2d60..eaea9b4 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -963,7 +963,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		pmic->desc[i].owner = THIS_MODULE;
 
 		rdev = regulator_register(&pmic->desc[i],
-				tps65910->dev, reg_data, pmic);
+				tps65910->dev, reg_data, pmic, NULL);
 		if (IS_ERR(rdev)) {
 			dev_err(tps65910->dev,
 				"failed to register %s regulator\n",
diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 3a9313e..0318f4b 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -729,7 +729,7 @@ static __devinit int tps65912_probe(struct platform_device *pdev)
 		pmic->desc[i].owner = THIS_MODULE;
 		range = tps65912_get_range(pmic, i);
 		rdev = regulator_register(&pmic->desc[i],
-					tps65912->dev, reg_data, pmic);
+					tps65912->dev, reg_data, pmic, NULL);
 		if (IS_ERR(rdev)) {
 			dev_err(tps65912->dev,
 				"failed to register %s regulator\n",
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index ee8747f..9a2e07a 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1070,7 +1070,7 @@ static int __devinit twlreg_probe(struct platform_device *pdev)
 		break;
 	}
 
-	rdev = regulator_register(&info->desc, &pdev->dev, initdata, info);
+	rdev = regulator_register(&info->desc, &pdev->dev, initdata, info, NULL);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "can't register %s, %ld\n",
 				info->desc.name, PTR_ERR(rdev));
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index bd3531d..7558a96 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -553,7 +553,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 		wm831x_buckv_dvs_init(dcdc, pdata->dcdc[id]->driver_data);
 
 	dcdc->regulator = regulator_register(&dcdc->desc, &pdev->dev,
-					     pdata->dcdc[id], dcdc);
+					     pdata->dcdc[id], dcdc, NULL);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
@@ -747,7 +747,7 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 	dcdc->desc.owner = THIS_MODULE;
 
 	dcdc->regulator = regulator_register(&dcdc->desc, &pdev->dev,
-					     pdata->dcdc[id], dcdc);
+					     pdata->dcdc[id], dcdc, NULL);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
@@ -874,7 +874,7 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 	dcdc->desc.owner = THIS_MODULE;
 
 	dcdc->regulator = regulator_register(&dcdc->desc, &pdev->dev,
-					     pdata->dcdc[id], dcdc);
+					     pdata->dcdc[id], dcdc, NULL);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
@@ -973,7 +973,7 @@ static __devinit int wm831x_epe_probe(struct platform_device *pdev)
 	dcdc->desc.owner = THIS_MODULE;
 
 	dcdc->regulator = regulator_register(&dcdc->desc, &pdev->dev,
-					     pdata->epe[id], dcdc);
+					     pdata->epe[id], dcdc, NULL);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register EPE%d: %d\n",
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 01f27c7..d3ad3f5 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -189,7 +189,7 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 	isink->desc.owner = THIS_MODULE;
 
 	isink->regulator = regulator_register(&isink->desc, &pdev->dev,
-					     pdata->isink[id], isink);
+					     pdata->isink[id], isink, NULL);
 	if (IS_ERR(isink->regulator)) {
 		ret = PTR_ERR(isink->regulator);
 		dev_err(wm831x->dev, "Failed to register ISINK%d: %d\n",
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 6709710..5e96a23 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -351,7 +351,7 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	ldo->desc.owner = THIS_MODULE;
 
 	ldo->regulator = regulator_register(&ldo->desc, &pdev->dev,
-					     pdata->ldo[id], ldo);
+					     pdata->ldo[id], ldo, NULL);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
@@ -621,7 +621,7 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 	ldo->desc.owner = THIS_MODULE;
 
 	ldo->regulator = regulator_register(&ldo->desc, &pdev->dev,
-					     pdata->ldo[id], ldo);
+					     pdata->ldo[id], ldo, NULL);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
@@ -818,7 +818,7 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	ldo->desc.owner = THIS_MODULE;
 
 	ldo->regulator = regulator_register(&ldo->desc, &pdev->dev,
-					     pdata->ldo[id], ldo);
+					     pdata->ldo[id], ldo, NULL);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 1bcb22c..6894009 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1428,7 +1428,7 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
 	/* register regulator */
 	rdev = regulator_register(&wm8350_reg[pdev->id], &pdev->dev,
 				  pdev->dev.platform_data,
-				  dev_get_drvdata(&pdev->dev));
+				  dev_get_drvdata(&pdev->dev), NULL);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register %s\n",
 			wm8350_reg[pdev->id].name);
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 0f12c70..f468f8a 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -325,7 +325,7 @@ static int __devinit wm8400_regulator_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 
 	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-				  pdev->dev.platform_data, wm8400);
+				  pdev->dev.platform_data, wm8400, NULL);
 
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 1a6a690..8ee546f 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -256,7 +256,7 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 		ldo->is_enabled = true;
 
 	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &pdev->dev,
-					     pdata->ldo[id].init_data, ldo);
+					     pdata->ldo[id].init_data, ldo, NULL);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm8994->dev, "Failed to register LDO%d: %d\n",
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 1a80bc7..461eb90 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -208,7 +208,7 @@ struct regulator_dev {
 
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	struct device *dev, const struct regulator_init_data *init_data,
-	void *driver_data);
+	void *driver_data, struct device_node *of_node);
 void regulator_unregister(struct regulator_dev *rdev);
 
 int regulator_notifier_call_chain(struct regulator_dev *rdev,
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 7e4066e..62fd409 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -832,7 +832,7 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
 	ldo->voltage = voltage;
 
 	ldo->dev = regulator_register(&ldo->desc, codec->dev,
-					  init_data, ldo);
+					  init_data, ldo, NULL);
 	if (IS_ERR(ldo->dev)) {
 		int ret = PTR_ERR(ldo->dev);
 
-- 
1.7.1

