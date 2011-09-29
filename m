Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1I2Jks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:40:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56964 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760Ab1I2JjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:39:17 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/8] regmap: Use the lockless _regmap_write() for syncing
Date: Thu, 29 Sep 2011 10:39:08 +0100
Message-Id: <1317289153-21123-3-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-indexed.c |    4 ++--
 drivers/base/regmap/regcache-lzo.c     |    2 +-
 drivers/base/regmap/regcache-rbtree.c  |    2 +-
 drivers/base/regmap/regcache.c         |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regcache-indexed.c b/drivers/base/regmap/regcache-indexed.c
index 268497a..2e10bb1 100644
--- a/drivers/base/regmap/regcache-indexed.c
+++ b/drivers/base/regmap/regcache-indexed.c
@@ -45,8 +45,8 @@ static int regcache_indexed_sync(struct regmap *map)
 	int ret;
 
 	for (i = 0; i < map->num_reg_defaults; i++) {
-		ret = regmap_write(map, map->reg_defaults[i].reg,
-				   map->reg_defaults[i].def);
+		ret = _regmap_write(map, map->reg_defaults[i].reg,
+				    map->reg_defaults[i].def);
 		if (ret < 0)
 			return ret;
 		dev_dbg(map->dev, "Synced register %#x, value %#x\n",
diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 9079cb5..ad6af92 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -339,7 +339,7 @@ static int regcache_lzo_sync(struct regmap *map)
 		if (ret)
 			return ret;
 		map->cache_bypass = 1;
-		ret = regmap_write(map, i, val);
+		ret = _regmap_write(map, i, val);
 		map->cache_bypass = 0;
 		if (ret)
 			return ret;
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index de32ced..40f23dd 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -327,7 +327,7 @@ static int regcache_rbtree_sync(struct regmap *map)
 			if (val == def)
 				continue;
 			map->cache_bypass = 1;
-			ret = regmap_write(map, regtmp, val);
+			ret = _regmap_write(map, regtmp, val);
 			map->cache_bypass = 0;
 			if (ret)
 				return ret;
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index f46e247..b6efde7 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -242,7 +242,7 @@ int regcache_sync(struct regmap *map)
 			if (ret < 0)
 				goto out;
 			map->cache_bypass = 1;
-			ret = regmap_write(map, i, val);
+			ret = _regmap_write(map, i, val);
 			map->cache_bypass = 0;
 			if (ret < 0)
 				goto out;
-- 
1.7.6.4

