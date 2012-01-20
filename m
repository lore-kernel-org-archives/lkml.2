Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2ATNqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:46:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37329 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab2ATNqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:46:24 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Reset cache status when reinitialsing the cache
Date: Fri, 20 Jan 2012 13:46:21 +0000
Message-Id: <1327067181-15246-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we reinitialise the cache make sure that we reset the cache access
flags, ensuring that the reinitialised cache is in the default state
which is what callers would and do expect given the function name.

This is particularly likely to cause issues in systems where there was no
cache previously as those systems have cache bypass enabled, as for the
wm8994 driver where this was noticed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e9c2ac0..80129c0 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -286,6 +286,9 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 	map->precious_reg = config->precious_reg;
 	map->cache_type = config->cache_type;
 
+	map->cache_bypass = false;
+	map->cache_only = false;
+
 	ret = regcache_init(map, config);
 
 	mutex_unlock(&map->lock);
-- 
1.7.7.3

