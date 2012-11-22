Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab2KVUGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:06:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60408 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2KVUGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:06:35 -0500
Message-ID: <1353573044.18426.1.camel@phoenix>
Subject: [PATCH] regulator: tps80031: Trivial cleanups
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Nov 2012 16:30:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below cleanups:

- Fix typo in comment
- Fix showing wrong register in dev_err
- Remove unnecessary rinfo variable
- Add TPS80032 to MODULE_DESCRIPTION

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps80031-regulator.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index 127d175..6d5f203 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -1,7 +1,7 @@
 /*
  * tps80031-regulator.c -- TI TPS80031 regulator driver.
  *
- * Regulator driver for TITPS80031/TPS80032 Fully Integrated Power
+ * Regulator driver for TI TPS80031/TPS80032 Fully Integrated Power
  * Management with Power Path and Battery Charger.
  *
  * Copyright (c) 2012, NVIDIA Corporation.
@@ -311,7 +311,7 @@ static int tps80031_vbus_is_enabled(struct regulator_dev *rdev)
 				TPS80031_CHARGERUSB_CTRL3, &ctrl3);
 	if (ret < 0) {
 		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
-			TPS80031_CHARGERUSB_CTRL1, ret);
+			TPS80031_CHARGERUSB_CTRL3, ret);
 		return ret;
 	}
 	if ((ctrl1 & OPA_MODE_EN) && (ctrl3 & BOOST_HW_PWR_EN))
@@ -679,7 +679,6 @@ static int tps80031_regulator_probe(struct platform_device *pdev)
 {
 	struct tps80031_platform_data *pdata;
 	struct tps80031_regulator_platform_data *tps_pdata;
-	struct tps80031_regulator_info *rinfo;
 	struct tps80031_regulator *ri;
 	struct tps80031_regulator *pmic;
 	struct regulator_dev *rdev;
@@ -703,9 +702,8 @@ static int tps80031_regulator_probe(struct platform_device *pdev)
 
 	for (num = 0; num < TPS80031_REGULATOR_MAX; ++num) {
 		tps_pdata = pdata->regulator_pdata[num];
-		rinfo = &tps80031_rinfo[num];
 		ri = &pmic[num];
-		ri->rinfo = rinfo;
+		ri->rinfo = &tps80031_rinfo[num];
 		ri->dev = &pdev->dev;
 
 		check_smps_mode_mult(pdev->dev.parent, ri);
@@ -788,6 +786,6 @@ static void __exit tps80031_regulator_exit(void)
 module_exit(tps80031_regulator_exit);
 
 MODULE_ALIAS("platform:tps80031-regulator");
-MODULE_DESCRIPTION("Regulator Driver for TI TPS80031 PMIC");
+MODULE_DESCRIPTION("Regulator Driver for TI TPS80031/TPS80032 PMIC");
 MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
 MODULE_LICENSE("GPL v2");
-- 
1.7.9.5



