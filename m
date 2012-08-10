Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2HJBir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:38:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51114 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2HJBiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:38:46 -0400
Message-ID: <1344562719.2996.7.camel@phoenix>
Subject: [PATCH 6/6] regulator: mc13xxx: Remove get_voltage implementation
 for single voltage regulators
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Date: Fri, 10 Aug 2012 09:38:39 +0800
In-Reply-To: <1344562353.2996.1.camel@phoenix>
References: <1344562353.2996.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not required after commit f7df20ec
"regulator: core: Use list_voltage() to read single voltage regulators"

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13783-regulator.c      |    1 -
 drivers/regulator/mc13892-regulator.c      |    1 -
 drivers/regulator/mc13xxx-regulator-core.c |   11 -----------
 drivers/regulator/mc13xxx.h                |    1 -
 4 files changed, 14 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 2587ea1..4977b19 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -324,7 +324,6 @@ static struct regulator_ops mc13783_gpo_regulator_ops = {
 	.is_enabled = mc13783_gpo_regulator_is_enabled,
 	.list_voltage = regulator_list_voltage_table,
 	.set_voltage = mc13xxx_fixed_regulator_set_voltage,
-	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
 };
 
 static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 09265f0..1fa6381 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -390,7 +390,6 @@ static struct regulator_ops mc13892_gpo_regulator_ops = {
 	.is_enabled = mc13892_gpo_regulator_is_enabled,
 	.list_voltage = regulator_list_voltage_table,
 	.set_voltage = mc13xxx_fixed_regulator_set_voltage,
-	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
 };
 
 static int mc13892_sw_regulator_get_voltage_sel(struct regulator_dev *rdev)
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 8151889..88cbb83 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -152,23 +152,12 @@ int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
 }
 EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_set_voltage);
 
-int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev)
-{
-	int id = rdev_get_id(rdev);
-
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
-
-	return rdev->desc->volt_table[0];
-}
-EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_get_voltage);
-
 struct regulator_ops mc13xxx_fixed_regulator_ops = {
 	.enable = mc13xxx_regulator_enable,
 	.disable = mc13xxx_regulator_disable,
 	.is_enabled = mc13xxx_regulator_is_enabled,
 	.list_voltage = regulator_list_voltage_table,
 	.set_voltage = mc13xxx_fixed_regulator_set_voltage,
-	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
 };
 EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_ops);
 
diff --git a/drivers/regulator/mc13xxx.h b/drivers/regulator/mc13xxx.h
index eaff551..06c8903 100644
--- a/drivers/regulator/mc13xxx.h
+++ b/drivers/regulator/mc13xxx.h
@@ -34,7 +34,6 @@ struct mc13xxx_regulator_priv {
 
 extern int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector);
-extern int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev);
 
 #ifdef CONFIG_OF
 extern int mc13xxx_get_num_regulators_dt(struct platform_device *pdev);
-- 
1.7.9.5



