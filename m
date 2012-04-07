Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2DGPbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 11:31:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2DGPbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 11:31:50 -0400
Message-ID: <1333812704.6390.5.camel@phoenix>
Subject: [PATCH 3/3] regulator: tps65023: Use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Sat, 07 Apr 2012 23:31:44 +0800
In-Reply-To: <1333812508.6390.1.camel@phoenix>
References: <1333812508.6390.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 5c9a900..694386f 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -393,16 +393,16 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 	if (!init_data)
 		return -EIO;
 
-	tps = kzalloc(sizeof(*tps), GFP_KERNEL);
+	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
 	if (!tps)
 		return -ENOMEM;
 
-	tps->regmap = regmap_init_i2c(client, &tps65023_regmap_config);
+	tps->regmap = devm_regmap_init_i2c(client, &tps65023_regmap_config);
 	if (IS_ERR(tps->regmap)) {
 		error = PTR_ERR(tps->regmap);
 		dev_err(&client->dev, "Failed to allocate register map: %d\n",
 			error);
-		goto fail_alloc;
+		return error;
 	}
 
 	/* common for all regulators */
@@ -445,10 +445,6 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
  fail:
 	while (--i >= 0)
 		regulator_unregister(tps->rdev[i]);
-
-	regmap_exit(tps->regmap);
- fail_alloc:
-	kfree(tps);
 	return error;
 }
 
@@ -459,10 +455,6 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
 
 	for (i = 0; i < TPS65023_NUM_REGULATOR; i++)
 		regulator_unregister(tps->rdev[i]);
-
-	regmap_exit(tps->regmap);
-	kfree(tps);
-
 	return 0;
 }
 
-- 
1.7.5.4



