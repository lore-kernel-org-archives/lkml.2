Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab2FSGUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:20:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54204 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2FSGUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:20:08 -0400
Message-ID: <1340086797.9329.1.camel@phoenix>
Subject: [PATCH] regulator: mc13xxx: Remove mc13xxx_sw_regulator_is_enabled
 function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 19 Jun 2012 14:19:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If .is_enabled callback is not implemented, regulator core assumes that the
regulator is always on. Thus we don't need mc13xxx_sw_regulator_is_enabled
function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13892-regulator.c      |    1 -
 drivers/regulator/mc13xxx-regulator-core.c |    6 ------
 drivers/regulator/mc13xxx.h                |    1 -
 3 files changed, 8 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 6329723..b388b74 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -469,7 +469,6 @@ err:
 }
 
 static struct regulator_ops mc13892_sw_regulator_ops = {
-	.is_enabled = mc13xxx_sw_regulator_is_enabled,
 	.list_voltage = regulator_list_voltage_table,
 	.set_voltage_sel = mc13892_sw_regulator_set_voltage_sel,
 	.get_voltage = mc13892_sw_regulator_get_voltage,
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 8a6b050..d6eda28 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -170,12 +170,6 @@ struct regulator_ops mc13xxx_fixed_regulator_ops = {
 };
 EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_ops);
 
-int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev)
-{
-	return 1;
-}
-EXPORT_SYMBOL_GPL(mc13xxx_sw_regulator_is_enabled);
-
 #ifdef CONFIG_OF
 int __devinit mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 {
diff --git a/drivers/regulator/mc13xxx.h b/drivers/regulator/mc13xxx.h
index 9a8f72c..8343a25 100644
--- a/drivers/regulator/mc13xxx.h
+++ b/drivers/regulator/mc13xxx.h
@@ -33,7 +33,6 @@ struct mc13xxx_regulator_priv {
 };
 
 extern int mc13xxx_sw_regulator(struct regulator_dev *rdev);
-extern int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev);
 extern int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector);
 extern int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev);
-- 
1.7.9.5



