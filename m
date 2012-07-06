Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2GFLOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:14:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59503 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab2GFLOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:14:41 -0400
Message-ID: <1341573272.6611.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: aat2870: Convert to
 regulator_list_voltage_table
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 19:14:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/aat2870-regulator.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 06776ca..6644e83 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -33,8 +33,6 @@ struct aat2870_regulator {
 	struct aat2870_data *aat2870;
 	struct regulator_desc desc;
 
-	const int *voltages; /* uV */
-
 	int min_uV;
 	int max_uV;
 
@@ -47,14 +45,6 @@ struct aat2870_regulator {
 	u8 voltage_mask;
 };
 
-static int aat2870_ldo_list_voltage(struct regulator_dev *rdev,
-				    unsigned selector)
-{
-	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
-
-	return ri->voltages[selector];
-}
-
 static int aat2870_ldo_set_voltage_sel(struct regulator_dev *rdev,
 				       unsigned selector)
 {
@@ -111,7 +101,7 @@ static int aat2870_ldo_is_enabled(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops aat2870_ldo_ops = {
-	.list_voltage = aat2870_ldo_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.set_voltage_sel = aat2870_ldo_set_voltage_sel,
 	.get_voltage_sel = aat2870_ldo_get_voltage_sel,
 	.enable = aat2870_ldo_enable,
@@ -119,7 +109,7 @@ static struct regulator_ops aat2870_ldo_ops = {
 	.is_enabled = aat2870_ldo_is_enabled,
 };
 
-static const int aat2870_ldo_voltages[] = {
+static const unsigned int aat2870_ldo_voltages[] = {
 	1200000, 1300000, 1500000, 1600000,
 	1800000, 2000000, 2200000, 2500000,
 	2600000, 2700000, 2800000, 2900000,
@@ -132,11 +122,11 @@ static const int aat2870_ldo_voltages[] = {
 			.name = #ids,			\
 			.id = AAT2870_ID_##ids,		\
 			.n_voltages = ARRAY_SIZE(aat2870_ldo_voltages),	\
+			.volt_table = aat2870_ldo_voltages, \
 			.ops = &aat2870_ldo_ops,	\
 			.type = REGULATOR_VOLTAGE,	\
 			.owner = THIS_MODULE,		\
 		},					\
-		.voltages = aat2870_ldo_voltages,	\
 		.min_uV = 1200000,			\
 		.max_uV = 3300000,			\
 	}
-- 
1.7.9.5



