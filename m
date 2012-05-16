Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab2EPEu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 00:50:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46440 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2EPEu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 00:50:57 -0400
Message-ID: <1337143847.3876.1.camel@phoenix>
Subject: [PATCH] regulator: max8952: Use devm_kzalloc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Date: Wed, 16 May 2012 12:50:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 62ae140..910c9b2 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -181,7 +181,8 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
 		return -EIO;
 
-	max8952 = kzalloc(sizeof(struct max8952_data), GFP_KERNEL);
+	max8952 = devm_kzalloc(&client->dev, sizeof(struct max8952_data),
+			       GFP_KERNEL);
 	if (!max8952)
 		return -ENOMEM;
 
@@ -198,7 +199,7 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 	if (IS_ERR(max8952->rdev)) {
 		ret = PTR_ERR(max8952->rdev);
 		dev_err(max8952->dev, "regulator init failed (%d)\n", ret);
-		goto err_reg;
+		return ret;
 	}
 
 	max8952->en = !!(pdata->reg_data.constraints.boot_on);
@@ -295,10 +296,6 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, max8952);
 
 	return 0;
-
-err_reg:
-	kfree(max8952);
-	return ret;
 }
 
 static int __devexit max8952_pmic_remove(struct i2c_client *client)
@@ -312,8 +309,6 @@ static int __devexit max8952_pmic_remove(struct i2c_client *client)
 	gpio_free(pdata->gpio_vid0);
 	gpio_free(pdata->gpio_vid1);
 	gpio_free(pdata->gpio_en);
-
-	kfree(max8952);
 	return 0;
 }
 
-- 
1.7.5.4



