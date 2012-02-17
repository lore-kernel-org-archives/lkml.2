Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2BQWug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:50:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52861 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389Ab2BQWuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:50:35 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Add stub regmap calls as a build crutch for infrastructure users
Date: Fri, 17 Feb 2012 14:50:24 -0800
Message-Id: <1329519024-14533-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make life easier for subsystems which build infrastructure on top of the
regmap API by providing stub definitions for most of the API so that users
can at least build even if the regmap API is not enabled without having to
add ifdefs if they don't want to.

These stubs are not expected to be useful and should never actually get
called, they just exist so that we can link so there are WARN_ONCE()s in
the stubs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regmap.h |  106 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 40ff568..df9ffcc 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -16,6 +16,8 @@
 #include <linux/device.h>
 #include <linux/list.h>
 
+#ifdef CONFIG_REGMAP
+
 struct module;
 struct i2c_client;
 struct spi_device;
@@ -213,4 +215,108 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *data);
 int regmap_irq_chip_get_base(struct regmap_irq_chip_data *data);
 
+#else
+
+/*
+ * These stubs should only ever be called by generic code which has
+ * regmap based facilities, if they ever get called at runtime
+ * something is going wrong and something probably needs to select
+ * REGMAP.
+ */
+
+static inline int regmap_write(struct regmap *map, unsigned int reg,
+			       unsigned int val)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_raw_write(struct regmap *map, unsigned int reg,
+				   const void *val, size_t val_len)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_bulk_write(struct regmap *map, unsigned int reg,
+				    const void *val, size_t val_count)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_read(struct regmap *map, unsigned int reg,
+			      unsigned int *val)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_raw_read(struct regmap *map, unsigned int reg,
+				  void *val, size_t val_len)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_bulk_read(struct regmap *map, unsigned int reg,
+				   void *val, size_t val_count)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_update_bits(struct regmap *map, unsigned int reg,
+				     unsigned int mask, unsigned int val)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_update_bits_check(struct regmap *map,
+					   unsigned int reg,
+					   unsigned int mask, unsigned int val,
+					   bool *change)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_get_val_bytes(struct regmap *map)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regcache_sync(struct regmap *map)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline void regcache_cache_only(struct regmap *map, bool enable)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+}
+
+static inline void regcache_cache_bypass(struct regmap *map, bool enable)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+}
+
+static inline void regcache_mark_dirty(struct regmap *map)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+}
+
+static inline int regmap_register_patch(struct regmap *map,
+					const struct reg_default *regs,
+					int num_regs)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+#endif
+
 #endif
-- 
1.7.9

