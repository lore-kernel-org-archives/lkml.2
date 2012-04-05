Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2DEEJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 00:09:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39000 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2DEEJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 00:09:05 -0400
Message-ID: <1333598938.10597.10.camel@phoenix>
Subject: [PATCH] regulator: da9052: Remove unneeded devm_kfree calls
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Thu, 05 Apr 2012 12:08:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 7eb7293..83e489f 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -406,7 +406,6 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 	struct da9052_regulator *regulator;
 	struct da9052 *da9052;
 	struct da9052_pdata *pdata;
-	int ret;
 
 	regulator = devm_kzalloc(&pdev->dev, sizeof(struct da9052_regulator),
 				 GFP_KERNEL);
@@ -421,8 +420,7 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 					      pdev->id);
 	if (regulator->info == NULL) {
 		dev_err(&pdev->dev, "invalid regulator ID specified\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 	regulator->rdev = regulator_register(&regulator->info->reg_desc,
 					     &pdev->dev,
@@ -431,16 +429,12 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 	if (IS_ERR(regulator->rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			regulator->info->reg_desc.name);
-		ret = PTR_ERR(regulator->rdev);
-		goto err;
+		return PTR_ERR(regulator->rdev);
 	}
 
 	platform_set_drvdata(pdev, regulator);
 
 	return 0;
-err:
-	devm_kfree(&pdev->dev, regulator);
-	return ret;
 }
 
 static int __devexit da9052_regulator_remove(struct platform_device *pdev)
@@ -448,8 +442,6 @@ static int __devexit da9052_regulator_remove(struct platform_device *pdev)
 	struct da9052_regulator *regulator = platform_get_drvdata(pdev);
 
 	regulator_unregister(regulator->rdev);
-	devm_kfree(&pdev->dev, regulator);
-
 	return 0;
 }
 
-- 
1.7.5.4



