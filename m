Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1LCVoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 16:44:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40302 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab1LCVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 16:44:04 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert WM8400 to devm_kzalloc()
Date: Sat,  3 Dec 2011 21:43:04 +0000
Message-Id: <1322948584-27913-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8400-core.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 62b4626..2204893 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -344,7 +344,7 @@ static int wm8400_i2c_probe(struct i2c_client *i2c,
 	struct wm8400 *wm8400;
 	int ret;
 
-	wm8400 = kzalloc(sizeof(struct wm8400), GFP_KERNEL);
+	wm8400 = devm_kzalloc(&i2c->dev, sizeof(struct wm8400), GFP_KERNEL);
 	if (wm8400 == NULL) {
 		ret = -ENOMEM;
 		goto err;
@@ -353,7 +353,7 @@ static int wm8400_i2c_probe(struct i2c_client *i2c,
 	wm8400->regmap = regmap_init_i2c(i2c, &wm8400_regmap_config);
 	if (IS_ERR(wm8400->regmap)) {
 		ret = PTR_ERR(wm8400->regmap);
-		goto struct_err;
+		goto err;
 	}
 
 	wm8400->dev = &i2c->dev;
@@ -367,8 +367,6 @@ static int wm8400_i2c_probe(struct i2c_client *i2c,
 
 map_err:
 	regmap_exit(wm8400->regmap);
-struct_err:
-	kfree(wm8400);
 err:
 	return ret;
 }
@@ -379,7 +377,6 @@ static int wm8400_i2c_remove(struct i2c_client *i2c)
 
 	wm8400_release(wm8400);
 	regmap_exit(wm8400->regmap);
-	kfree(wm8400);
 
 	return 0;
 }
-- 
1.7.7.3

