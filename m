Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2JIKXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:23:09 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17865 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab2JIKXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:23:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 09 Oct 2012 03:20:48 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <sameo@linux.intel.com>, <vbyravarasu@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/4] regulator: tps65090: rename driver name and regulator name
Date: Tue, 9 Oct 2012 15:19:00 +0530
Message-ID: <1349776142-6409-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
References: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the names proper and more appropriate:
Rename the driver name from tps65090-regulator to tps65090-pmic.
Rename the regulators from TPS65090_ID_* to TPS65090_REGULATOR_*

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1: 
Make this as patch2 from older patch1.

 drivers/regulator/tps65090-regulator.c |   16 ++++++++--------
 include/linux/mfd/tps65090.h           |   24 ++++++++++++------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 5f7f931..584a185 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -41,7 +41,7 @@ static struct regulator_ops tps65090_ops = {
 {							\
 	.name = "TPS65090_RAILS"#_id,			\
 	.supply_name = _sname,				\
-	.id = TPS65090_ID_##_id,			\
+	.id = TPS65090_REGULATOR_##_id,			\
 	.ops = &_ops,					\
 	.enable_reg = _en_reg,				\
 	.enable_mask = BIT(0),				\
@@ -65,9 +65,9 @@ static struct regulator_desc tps65090_regulator_desc[] = {
 static inline bool is_dcdc(int id)
 {
 	switch (id) {
-	case TPS65090_ID_DCDC1:
-	case TPS65090_ID_DCDC2:
-	case TPS65090_ID_DCDC3:
+	case TPS65090_REGULATOR_DCDC1:
+	case TPS65090_REGULATOR_DCDC2:
+	case TPS65090_REGULATOR_DCDC3:
 		return true;
 	default:
 		return false;
@@ -133,14 +133,14 @@ static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	pmic = devm_kzalloc(&pdev->dev, TPS65090_ID_MAX * sizeof(*pmic),
+	pmic = devm_kzalloc(&pdev->dev, TPS65090_REGULATOR_MAX * sizeof(*pmic),
 			GFP_KERNEL);
 	if (!pmic) {
 		dev_err(&pdev->dev, "mem alloc for pmic failed\n");
 		return -ENOMEM;
 	}
 
-	for (num = 0; num < TPS65090_ID_MAX; num++) {
+	for (num = 0; num < TPS65090_REGULATOR_MAX; num++) {
 		tps_pdata = tps65090_pdata->reg_pdata[num];
 
 		ri = &pmic[num];
@@ -196,7 +196,7 @@ static int __devexit tps65090_regulator_remove(struct platform_device *pdev)
 	struct tps65090_regulator *ri;
 	int num;
 
-	for (num = 0; num < TPS65090_ID_MAX; ++num) {
+	for (num = 0; num < TPS65090_REGULATOR_MAX; ++num) {
 		ri = &pmic[num];
 		regulator_unregister(ri->rdev);
 	}
@@ -205,7 +205,7 @@ static int __devexit tps65090_regulator_remove(struct platform_device *pdev)
 
 static struct platform_driver tps65090_regulator_driver = {
 	.driver	= {
-		.name	= "tps65090-regulator",
+		.name	= "tps65090-pmic",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= tps65090_regulator_probe,
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index d06c633..958bf15 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -26,19 +26,19 @@
 
 /* TPS65090 Regulator ID */
 enum {
-	TPS65090_ID_DCDC1,
-	TPS65090_ID_DCDC2,
-	TPS65090_ID_DCDC3,
-	TPS65090_ID_FET1,
-	TPS65090_ID_FET2,
-	TPS65090_ID_FET3,
-	TPS65090_ID_FET4,
-	TPS65090_ID_FET5,
-	TPS65090_ID_FET6,
-	TPS65090_ID_FET7,
+	TPS65090_REGULATOR_DCDC1,
+	TPS65090_REGULATOR_DCDC2,
+	TPS65090_REGULATOR_DCDC3,
+	TPS65090_REGULATOR_FET1,
+	TPS65090_REGULATOR_FET2,
+	TPS65090_REGULATOR_FET3,
+	TPS65090_REGULATOR_FET4,
+	TPS65090_REGULATOR_FET5,
+	TPS65090_REGULATOR_FET6,
+	TPS65090_REGULATOR_FET7,
 
 	/* Last entry for maximum ID */
-	TPS65090_ID_MAX,
+	TPS65090_REGULATOR_MAX,
 };
 
 struct tps65090 {
@@ -72,7 +72,7 @@ struct tps65090_platform_data {
 	int irq_base;
 	int num_subdevs;
 	struct tps65090_subdev_info *subdevs;
-	struct tps65090_regulator_plat_data *reg_pdata[TPS65090_ID_MAX];
+	struct tps65090_regulator_plat_data *reg_pdata[TPS65090_REGULATOR_MAX];
 };
 
 /*
-- 
1.7.1.1

