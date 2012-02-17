Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab2BQWVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:21:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37960 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389Ab2BQWVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:21:37 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Allow users to query the size of register values
Date: Fri, 17 Feb 2012 14:21:14 -0800
Message-Id: <1329517274-3106-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic infrastructure based on top of regmap may want to operate on
blocks of data and therefore find it useful to find the size of the
register values. Provide an accessor operation for this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   15 +++++++++++++++
 include/linux/regmap.h       |    1 +
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 4aa38ea..a871f14 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -869,6 +869,21 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_register_patch);
 
+/**
+ * regmap_get_val_bytes(): Report the size of a register value
+ *
+ * Report the size of a register value, mainly intended to for use by
+ * generic infrastructure built on top of regmap.
+ */
+int regmap_get_val_bytes(struct regmap *map)
+{
+	if (map->format.format_write)
+		return -EINVAL;
+
+	return map->format.val_bytes;
+}
+EXPORT_SYMBOL_GPL(regmap_get_val_bytes);
+
 static int __init regmap_initcall(void)
 {
 	regmap_debugfs_initcall();
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7cb21e8..40ff568 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -155,6 +155,7 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val,
 			     bool *change);
+int regmap_get_val_bytes(struct regmap *map);
 
 int regcache_sync(struct regmap *map);
 void regcache_cache_only(struct regmap *map, bool enable);
-- 
1.7.9

