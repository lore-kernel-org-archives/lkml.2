Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab2DYCCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:02:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62374 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab2DYCCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:02:04 -0400
Message-ID: <1335319315.30909.2.camel@phoenix>
Subject: [PATCH 1/5] mfd: rc5t583: Convert to devm_regmap_init_i2c()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Wed, 25 Apr 2012 10:01:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/rc5t583.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index 1cb4c35..cdc1df7 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -268,7 +268,7 @@ static int __devinit rc5t583_i2c_probe(struct i2c_client *i2c,
 	rc5t583->dev = &i2c->dev;
 	i2c_set_clientdata(i2c, rc5t583);
 
-	rc5t583->regmap = regmap_init_i2c(i2c, &rc5t583_regmap_config);
+	rc5t583->regmap = devm_regmap_init_i2c(i2c, &rc5t583_regmap_config);
 	if (IS_ERR(rc5t583->regmap)) {
 		ret = PTR_ERR(rc5t583->regmap);
 		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
@@ -277,7 +277,7 @@ static int __devinit rc5t583_i2c_probe(struct i2c_client *i2c,
 
 	ret = rc5t583_clear_ext_power_req(rc5t583, pdata);
 	if (ret < 0)
-		goto err_irq_init;
+		return ret;
 
 	if (i2c->irq) {
 		ret = rc5t583_irq_init(rc5t583, i2c->irq, pdata->irq_base);
@@ -300,8 +300,6 @@ static int __devinit rc5t583_i2c_probe(struct i2c_client *i2c,
 err_add_devs:
 	if (irq_init_success)
 		rc5t583_irq_exit(rc5t583);
-err_irq_init:
-	regmap_exit(rc5t583->regmap);
 	return ret;
 }
 
@@ -311,7 +309,6 @@ static int  __devexit rc5t583_i2c_remove(struct i2c_client *i2c)
 
 	mfd_remove_devices(rc5t583->dev);
 	rc5t583_irq_exit(rc5t583);
-	regmap_exit(rc5t583->regmap);
 	return 0;
 }
 
-- 
1.7.5.4



