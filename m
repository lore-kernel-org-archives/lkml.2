Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2A3V34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:29:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35527 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753560Ab2A3V3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:29:49 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] mfd: wm8400: Convert to devm_regmap_init_i2c()
Date: Mon, 30 Jan 2012 21:29:46 +0000
Message-Id: <1327958986-16115-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
In-Reply-To: <1327958986-16115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1327958986-16115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

OK to take this via regmap, it's another new feature?

 drivers/mfd/wm8400-core.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 2204893..237764a 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -350,7 +350,7 @@ static int wm8400_i2c_probe(struct i2c_client *i2c,
 		goto err;
 	}
 
-	wm8400->regmap = regmap_init_i2c(i2c, &wm8400_regmap_config);
+	wm8400->regmap = devm_regmap_init_i2c(i2c, &wm8400_regmap_config);
 	if (IS_ERR(wm8400->regmap)) {
 		ret = PTR_ERR(wm8400->regmap);
 		goto err;
@@ -361,12 +361,10 @@ static int wm8400_i2c_probe(struct i2c_client *i2c,
 
 	ret = wm8400_init(wm8400, i2c->dev.platform_data);
 	if (ret != 0)
-		goto map_err;
+		goto err;
 
 	return 0;
 
-map_err:
-	regmap_exit(wm8400->regmap);
 err:
 	return ret;
 }
@@ -376,7 +374,6 @@ static int wm8400_i2c_remove(struct i2c_client *i2c)
 	struct wm8400 *wm8400 = i2c_get_clientdata(i2c);
 
 	wm8400_release(wm8400);
-	regmap_exit(wm8400->regmap);
 
 	return 0;
 }
-- 
1.7.9.rc1

