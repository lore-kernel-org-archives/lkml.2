Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2AZSdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:33:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58266 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab2AZSc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:32:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Reset device debugfs when reinitialising the cache
Date: Thu, 26 Jan 2012 18:32:55 +0000
Message-Id: <1327602775-8873-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the data exposed via debugfs is for or from the cache so reset
all the debugfs configuration to make sure everything is up to date with
the latest configuration, especially if we're changing cache type.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a5b27fb..80507d5 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -278,6 +278,7 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 	mutex_lock(&map->lock);
 
 	regcache_exit(map);
+	regmap_debugfs_exit(map);
 
 	map->max_register = config->max_register;
 	map->writeable_reg = config->writeable_reg;
@@ -289,6 +290,8 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 	map->cache_bypass = false;
 	map->cache_only = false;
 
+	regmap_debugfs_init(map);
+
 	ret = regcache_init(map, config);
 
 	mutex_unlock(&map->lock);
-- 
1.7.9.rc1

