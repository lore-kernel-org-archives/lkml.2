Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab2JDRgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:36:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59428 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932393Ab2JDRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:36:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regmap: Make return code checks consistent
Date: Thu,  4 Oct 2012 18:36:15 +0100
Message-Id: <1349372177-18931-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349372177-18931-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1349372177-18931-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The range code was written to check for return codes less than zero as
errors but throughout the rest of the API return codes not equal to zero
are errors. Change all these checks to match the house style.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 4bb926c..baf9586 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -606,7 +606,7 @@ struct regmap *regmap_init(struct device *dev,
 	}
 
 	ret = regcache_init(map, config);
-	if (ret < 0)
+	if (ret != 0)
 		goto err_range;
 
 	regmap_debugfs_init(map, config->name);
@@ -803,7 +803,7 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 
 		map->work_buf = orig_work_buf;
 
-		if (ret < 0)
+		if (ret != 0)
 			return ret;
 	}
 
@@ -854,7 +854,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	if (range) {
 		ret = _regmap_select_page(map, &reg, range,
 					  val_len / map->format.val_bytes);
-		if (ret < 0)
+		if (ret != 0)
 			return ret;
 	}
 
@@ -930,7 +930,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 		range = _regmap_range_lookup(map, reg);
 		if (range) {
 			ret = _regmap_select_page(map, &reg, range, 1);
-			if (ret < 0)
+			if (ret != 0)
 				return ret;
 		}
 
@@ -1096,7 +1096,7 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	if (range) {
 		ret = _regmap_select_page(map, &reg, range,
 					  val_len / map->format.val_bytes);
-		if (ret < 0)
+		if (ret != 0)
 			return ret;
 	}
 
-- 
1.7.10.4

