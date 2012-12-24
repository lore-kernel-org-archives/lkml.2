Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab2LXQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:16:56 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:35581 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2LXQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:16:54 -0500
Message-ID: <1356365803.17063.0.camel@phoenix>
Subject: [PATCH 1/2] mfd: max77686: Init max77686->dev before using it
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Dec 2012 00:16:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code uses max77686->dev in the dev_err call before setting it to
&i2c->dev. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/max77686.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index f6878f8..4d73963 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -93,15 +93,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	if (max77686 == NULL)
 		return -ENOMEM;
 
-	max77686->regmap = regmap_init_i2c(i2c, &max77686_regmap_config);
-	if (IS_ERR(max77686->regmap)) {
-		ret = PTR_ERR(max77686->regmap);
-		dev_err(max77686->dev, "Failed to allocate register map: %d\n",
-				ret);
-		kfree(max77686);
-		return ret;
-	}
-
 	i2c_set_clientdata(i2c, max77686);
 	max77686->dev = &i2c->dev;
 	max77686->i2c = i2c;
@@ -111,6 +102,15 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	max77686->irq_gpio = pdata->irq_gpio;
 	max77686->irq = i2c->irq;
 
+	max77686->regmap = regmap_init_i2c(i2c, &max77686_regmap_config);
+	if (IS_ERR(max77686->regmap)) {
+		ret = PTR_ERR(max77686->regmap);
+		dev_err(max77686->dev, "Failed to allocate register map: %d\n",
+				ret);
+		kfree(max77686);
+		return ret;
+	}
+
 	if (regmap_read(max77686->regmap,
 			 MAX77686_REG_DEVICE_ID, &data) < 0) {
 		dev_err(max77686->dev,
-- 
1.7.9.5



