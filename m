Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab2B1GYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 01:24:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61133 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2B1GYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 01:24:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.130.138 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330410235.4654.1.camel@phoenix>
Subject: [PATCH] mfd: s5m-core: return proper error if regmap_init_i2c fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 28 Feb 2012 14:23:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove a redundant semicolon from return statement.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/s5m-core.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/s5m-core.c b/drivers/mfd/s5m-core.c
index 578e12e..48949d9 100644
--- a/drivers/mfd/s5m-core.c
+++ b/drivers/mfd/s5m-core.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(s5m_reg_read);
 
 int s5m_bulk_read(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
 {
-	return regmap_bulk_read(s5m87xx->regmap, reg, buf, count);;
+	return regmap_bulk_read(s5m87xx->regmap, reg, buf, count);
 }
 EXPORT_SYMBOL_GPL(s5m_bulk_read);
 
@@ -94,8 +94,7 @@ static int s5m87xx_i2c_probe(struct i2c_client *i2c,
 {
 	struct s5m_platform_data *pdata = i2c->dev.platform_data;
 	struct s5m87xx_dev *s5m87xx;
-	int ret = 0;
-	int error;
+	int ret;
 
 	s5m87xx = devm_kzalloc(&i2c->dev, sizeof(struct s5m87xx_dev),
 				GFP_KERNEL);
@@ -117,9 +116,9 @@ static int s5m87xx_i2c_probe(struct i2c_client *i2c,
 
 	s5m87xx->regmap = regmap_init_i2c(i2c, &s5m_regmap_config);
 	if (IS_ERR(s5m87xx->regmap)) {
-		error = PTR_ERR(s5m87xx->regmap);
+		ret = PTR_ERR(s5m87xx->regmap);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
-			error);
+			ret);
 		goto err;
 	}
 
-- 
1.7.5.4



