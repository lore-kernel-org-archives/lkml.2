Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2FNBig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:38:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63142 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2FNBif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:38:35 -0400
Message-ID: <1339637906.16332.0.camel@phoenix>
Subject: [PATCH] regulator: tps62360: Remove chip_id and voltage_base from
 struct tps62360_chip
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 14 Jun 2012 09:38:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chip_id is not used.
The voltage_base is not necessary, set base voltage to tps->desc.min_uV instead.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index e534269..ec3d0d5 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -65,10 +65,8 @@ struct tps62360_chip {
 	struct regulator_desc desc;
 	struct regulator_dev *rdev;
 	struct regmap *regmap;
-	int chip_id;
 	int vsel0_gpio;
 	int vsel1_gpio;
-	int voltage_base;
 	u8 voltage_reg_mask;
 	bool en_internal_pulldn;
 	bool en_discharge;
@@ -408,13 +406,13 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	switch (chip_id) {
 	case TPS62360:
 	case TPS62362:
-		tps->voltage_base = TPS62360_BASE_VOLTAGE;
+		tps->desc.min_uV = TPS62360_BASE_VOLTAGE;
 		tps->voltage_reg_mask = 0x3F;
 		tps->desc.n_voltages = TPS62360_N_VOLTAGES;
 		break;
 	case TPS62361:
 	case TPS62363:
-		tps->voltage_base = TPS62361_BASE_VOLTAGE;
+		tps->desc.min_uV = TPS62361_BASE_VOLTAGE;
 		tps->voltage_reg_mask = 0x7F;
 		tps->desc.n_voltages = TPS62361_N_VOLTAGES;
 		break;
@@ -427,7 +425,6 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	tps->desc.ops = &tps62360_dcdc_ops;
 	tps->desc.type = REGULATOR_VOLTAGE;
 	tps->desc.owner = THIS_MODULE;
-	tps->desc.min_uV = tps->voltage_base;
 	tps->desc.uV_step = 10000;
 
 	tps->regmap = devm_regmap_init_i2c(client, &tps62360_regmap_config);
-- 
1.7.9.5



