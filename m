Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab2DYCGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:06:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35294 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2DYCGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:06:44 -0400
Message-ID: <1335319600.30909.8.camel@phoenix>
Subject: [PATCH 4/5] mfd: tps65217: Convert to devm_regmap_init_i2c()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, AnilKumar Ch <anilkumar@ti.com>
Date: Wed, 25 Apr 2012 10:06:40 +0800
In-Reply-To: <1335319315.30909.2.camel@phoenix>
References: <1335319315.30909.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65217.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index f7d854e..c064c0a 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -150,7 +150,7 @@ static int __devinit tps65217_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	tps->pdata = pdata;
-	tps->regmap = regmap_init_i2c(client, &tps65217_regmap_config);
+	tps->regmap = devm_regmap_init_i2c(client, &tps65217_regmap_config);
 	if (IS_ERR(tps->regmap)) {
 		ret = PTR_ERR(tps->regmap);
 		dev_err(tps->dev, "Failed to allocate register map: %d\n",
@@ -163,9 +163,9 @@ static int __devinit tps65217_probe(struct i2c_client *client,
 
 	ret = tps65217_reg_read(tps, TPS65217_REG_CHIPID, &version);
 	if (ret < 0) {
-		dev_err(tps->dev, "Failed to read revision"
-					" register: %d\n", ret);
-		goto err_regmap;
+		dev_err(tps->dev, "Failed to read revision register: %d\n",
+			ret);
+		return ret;
 	}
 
 	dev_info(tps->dev, "TPS65217 ID %#x version 1.%d\n",
@@ -190,11 +190,6 @@ static int __devinit tps65217_probe(struct i2c_client *client,
 	}
 
 	return 0;
-
-err_regmap:
-	regmap_exit(tps->regmap);
-
-	return ret;
 }
 
 static int __devexit tps65217_remove(struct i2c_client *client)
@@ -205,8 +200,6 @@ static int __devexit tps65217_remove(struct i2c_client *client)
 	for (i = 0; i < TPS65217_NUM_REGULATOR; i++)
 		platform_device_unregister(tps->regulator_pdev[i]);
 
-	regmap_exit(tps->regmap);
-
 	return 0;
 }
 
-- 
1.7.5.4



