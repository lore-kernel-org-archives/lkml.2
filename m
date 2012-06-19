Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2FSJNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:13:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37218 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2FSJNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:13:19 -0400
Message-ID: <1340097193.28289.2.camel@phoenix>
Subject: [PATCH RFT 2/3] regulator: tps65023: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 19 Jun 2012 17:13:13 +0800
In-Reply-To: <1340097138.28289.1.camel@phoenix>
References: <1340097138.28289.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 332cbc5..eacff95 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -155,7 +155,7 @@ struct tps_driver_data {
 	u8 core_regulator;
 };
 
-static int tps65023_dcdc_get_voltage(struct regulator_dev *dev)
+static int tps65023_dcdc_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int ret;
@@ -169,9 +169,9 @@ static int tps65023_dcdc_get_voltage(struct regulator_dev *dev)
 		if (ret != 0)
 			return ret;
 		data &= (tps->info[dcdc]->table_len - 1);
-		return tps->info[dcdc]->table[data];
+		return data;
 	} else
-		return tps->info[dcdc]->table[0];
+		return 0;
 }
 
 static int tps65023_dcdc_set_voltage_sel(struct regulator_dev *dev,
@@ -198,7 +198,7 @@ out:
 	return ret;
 }
 
-static int tps65023_ldo_get_voltage(struct regulator_dev *dev)
+static int tps65023_ldo_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int data, ldo = rdev_get_id(dev);
@@ -213,7 +213,7 @@ static int tps65023_ldo_get_voltage(struct regulator_dev *dev)
 
 	data >>= (TPS65023_LDO_CTRL_LDOx_SHIFT(ldo - TPS65023_LDO_1));
 	data &= (tps->info[ldo]->table_len - 1);
-	return tps->info[ldo]->table[data];
+	return data;
 }
 
 static int tps65023_ldo_set_voltage_sel(struct regulator_dev *dev,
@@ -232,7 +232,7 @@ static struct regulator_ops tps65023_dcdc_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-	.get_voltage = tps65023_dcdc_get_voltage,
+	.get_voltage_sel = tps65023_dcdc_get_voltage_sel,
 	.set_voltage_sel = tps65023_dcdc_set_voltage_sel,
 	.list_voltage = regulator_list_voltage_table,
 };
@@ -242,7 +242,7 @@ static struct regulator_ops tps65023_ldo_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-	.get_voltage = tps65023_ldo_get_voltage,
+	.get_voltage_sel = tps65023_ldo_get_voltage_sel,
 	.set_voltage_sel = tps65023_ldo_set_voltage_sel,
 	.list_voltage = regulator_list_voltage_table,
 };
-- 
1.7.9.5



