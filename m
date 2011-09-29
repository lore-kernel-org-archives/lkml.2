Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1I2JnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:43:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54045 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469Ab1I2JnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:43:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Fix lock used for regcache_cache_only()
Date: Thu, 29 Sep 2011 10:43:08 +0100
Message-Id: <1317289388-3723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 744ed145..4dfab41 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -273,9 +273,9 @@ EXPORT_SYMBOL_GPL(regcache_sync);
  */
 void regcache_cache_only(struct regmap *map, bool enable)
 {
-	mutex_lock(&map->sync_lock);
+	mutex_lock(&map->lock);
 	map->cache_only = enable;
-	mutex_unlock(&map->sync_lock);
+	mutex_unlock(&map->lock);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_only);
 
-- 
1.7.6.3

