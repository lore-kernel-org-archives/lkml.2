Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1I1Kpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:45:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50444 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab1I1Kn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:43:58 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/7] regmap: Implement regcache_cache_bypass helper function
Date: Wed, 28 Sep 2011 11:43:46 +0100
Message-Id: <1317206627-6673-6-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we've got a function so users can enable/disable the
cache bypass option.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   19 +++++++++++++++++++
 include/linux/regmap.h         |    1 +
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 8900897..a3f466c 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -288,6 +288,25 @@ void regcache_cache_only(struct regmap *map, bool enable)
 }
 EXPORT_SYMBOL_GPL(regcache_cache_only);
 
+/**
+ * regcache_cache_bypass: Put a register map into cache bypass mode
+ *
+ * @map: map to configure
+ * @cache_only: flag if changes should not be written to the hardware
+ *
+ * When a register map is marked with the cache bypass option, writes
+ * to the register map API will only update the hardware and not the
+ * the cache directly.  This is useful when syncing the cache back to
+ * the hardware.
+ */
+void regcache_cache_bypass(struct regmap *map, bool enable)
+{
+	mutex_lock(&map->sync_lock);
+	map->cache_bypass = enable;
+	mutex_unlock(&map->sync_lock);
+}
+EXPORT_SYMBOL_GPL(regcache_cache_bypass);
+
 bool regcache_set_val(void *base, unsigned int idx,
 		      unsigned int val, unsigned int word_size)
 {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 76ac255..3daac2d 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -142,5 +142,6 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 
 int regcache_sync(struct regmap *map);
 void regcache_cache_only(struct regmap *map, bool enable);
+void regcache_cache_bypass(struct regmap *map, bool enable);
 
 #endif
-- 
1.7.6.4

