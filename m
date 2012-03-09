Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2CICWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:22:30 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46455 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2CICW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:22:28 -0500
Message-ID: <1331259740.6239.4.camel@phoenix>
Subject: [PATCH] regulator: Rename set_voltage_sel callback function name to
 *_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Fri, 09 Mar 2012 10:22:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change improves readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |   16 +++++++++-------
 drivers/regulator/tps65912-regulator.c |   12 ++++++------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 8de2835..b6edcf6 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -684,8 +684,8 @@ static int tps65911_get_voltage(struct regulator_dev *dev)
 	return (LDO_MIN_VOLT + value * step_mv) * 1000;
 }
 
-static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
-				unsigned selector)
+static int tps65910_set_voltage_dcdc_sel(struct regulator_dev *dev,
+					 unsigned selector)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int id = rdev_get_id(dev), vsel;
@@ -722,7 +722,8 @@ static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
 	return 0;
 }
 
-static int tps65910_set_voltage(struct regulator_dev *dev, unsigned selector)
+static int tps65910_set_voltage_sel(struct regulator_dev *dev,
+				    unsigned selector)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int reg, id = rdev_get_id(dev);
@@ -748,7 +749,8 @@ static int tps65910_set_voltage(struct regulator_dev *dev, unsigned selector)
 	return -EINVAL;
 }
 
-static int tps65911_set_voltage(struct regulator_dev *dev, unsigned selector)
+static int tps65911_set_voltage_sel(struct regulator_dev *dev,
+				    unsigned selector)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int reg, id = rdev_get_id(dev);
@@ -866,7 +868,7 @@ static struct regulator_ops tps65910_ops_dcdc = {
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65910_get_voltage_dcdc,
-	.set_voltage_sel	= tps65910_set_voltage_dcdc,
+	.set_voltage_sel	= tps65910_set_voltage_dcdc_sel,
 	.list_voltage		= tps65910_list_voltage_dcdc,
 };
 
@@ -887,7 +889,7 @@ static struct regulator_ops tps65910_ops = {
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65910_get_voltage,
-	.set_voltage_sel	= tps65910_set_voltage,
+	.set_voltage_sel	= tps65910_set_voltage_sel,
 	.list_voltage		= tps65910_list_voltage,
 };
 
@@ -898,7 +900,7 @@ static struct regulator_ops tps65911_ops = {
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65911_get_voltage,
-	.set_voltage_sel	= tps65911_set_voltage,
+	.set_voltage_sel	= tps65911_set_voltage_sel,
 	.list_voltage		= tps65911_list_voltage,
 };
 
diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index a654602..3ab1722 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -558,8 +558,8 @@ static int tps65912_get_voltage_dcdc(struct regulator_dev *dev)
 	return tps65912_list_voltage_dcdc(dev, vsel);
 }
 
-static int tps65912_set_voltage_dcdc(struct regulator_dev *dev,
-						unsigned selector)
+static int tps65912_set_voltage_dcdc_sel(struct regulator_dev *dev,
+					 unsigned selector)
 {
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	struct tps65912 *mfd = pmic->mfd;
@@ -588,8 +588,8 @@ static int tps65912_get_voltage_ldo(struct regulator_dev *dev)
 	return tps65912_vsel_to_uv_ldo(vsel);
 }
 
-static int tps65912_set_voltage_ldo(struct regulator_dev *dev,
-						unsigned selector)
+static int tps65912_set_voltage_ldo_sel(struct regulator_dev *dev,
+					unsigned selector)
 {
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	struct tps65912 *mfd = pmic->mfd;
@@ -620,7 +620,7 @@ static struct regulator_ops tps65912_ops_dcdc = {
 	.set_mode = tps65912_set_mode,
 	.get_mode = tps65912_get_mode,
 	.get_voltage = tps65912_get_voltage_dcdc,
-	.set_voltage_sel = tps65912_set_voltage_dcdc,
+	.set_voltage_sel = tps65912_set_voltage_dcdc_sel,
 	.list_voltage = tps65912_list_voltage_dcdc,
 };
 
@@ -630,7 +630,7 @@ static struct regulator_ops tps65912_ops_ldo = {
 	.enable = tps65912_reg_enable,
 	.disable = tps65912_reg_disable,
 	.get_voltage = tps65912_get_voltage_ldo,
-	.set_voltage_sel = tps65912_set_voltage_ldo,
+	.set_voltage_sel = tps65912_set_voltage_ldo_sel,
 	.list_voltage = tps65912_list_voltage_ldo,
 };
 
-- 
1.7.5.4



