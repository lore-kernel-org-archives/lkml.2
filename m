Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2DGPaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 11:30:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61238 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2DGPaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 11:30:02 -0400
Message-ID: <1333812596.6390.3.camel@phoenix>
Subject: [PATCH 2/3] regulator: tps62360: Convert to devm_regmap_init_i2c()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 07 Apr 2012 23:29:56 +0800
In-Reply-To: <1333812508.6390.1.camel@phoenix>
References: <1333812508.6390.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index aa57632..e55219b 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -319,7 +319,7 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	tps->desc.ops = &tps62360_dcdc_ops;
 	tps->desc.type = REGULATOR_VOLTAGE;
 	tps->desc.owner = THIS_MODULE;
-	tps->regmap = regmap_init_i2c(client, &tps62360_regmap_config);
+	tps->regmap = devm_regmap_init_i2c(client, &tps62360_regmap_config);
 	if (IS_ERR(tps->regmap)) {
 		ret = PTR_ERR(tps->regmap);
 		dev_err(&client->dev, "%s() Err: Failed to allocate register"
@@ -404,7 +404,6 @@ err_gpio1:
 	if (gpio_is_valid(tps->vsel0_gpio))
 		gpio_free(tps->vsel0_gpio);
 err_gpio0:
-	regmap_exit(tps->regmap);
 	return ret;
 }
 
@@ -425,7 +424,6 @@ static int __devexit tps62360_remove(struct i2c_client *client)
 		gpio_free(tps->vsel0_gpio);
 
 	regulator_unregister(tps->rdev);
-	regmap_exit(tps->regmap);
 	return 0;
 }
 
-- 
1.7.5.4



