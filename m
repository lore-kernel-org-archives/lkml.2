Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab1ISSEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:04:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38801 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756270Ab1ISSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:04:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] regmap: Allow drivers to control cache_only flag
Date: Mon, 19 Sep 2011 19:03:42 +0100
Message-Id: <1316455424-11173-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316455424-11173-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110919175948.GD540@opensource.wolfsonmicro.com>
 <1316455424-11173-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   18 ++++++++++++++++++
 include/linux/regmap.h         |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index e0a4a0d..7806941 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -238,6 +238,24 @@ int regcache_sync(struct regmap *map)
 }
 EXPORT_SYMBOL_GPL(regcache_sync);
 
+/**
+ * regcache_cache_only: Put a register map into cache only mode
+ *
+ * @map: map to configure
+ * @cache_only: flag if changes should be written to the hardware
+ *
+ * When a register map is marked as cache only writes to the register
+ * map API will only update the register cache, they will not cause
+ * any hardware changes.  This is useful for allowing portions of
+ * drivers to act as though the device were functioning as normal when
+ * it is disabled for power saving reasons.
+ */
+void regcache_cache_only(struct regmap *map, bool enable)
+{
+	map->cache_only = enable;
+}
+EXPORT_SYMBOL_GPL(regcache_cache_only);
+
 bool regcache_set_val(void *base, unsigned int idx,
 		      unsigned int val, unsigned int word_size)
 {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 63b3075..76ac255 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -141,4 +141,6 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val);
 
 int regcache_sync(struct regmap *map);
+void regcache_cache_only(struct regmap *map, bool enable);
+
 #endif
-- 
1.7.6.3

