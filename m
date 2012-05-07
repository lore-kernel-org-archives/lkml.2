Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2EGHjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:39:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19951 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab2EGHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:39:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 May 2012 00:39:00 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        lrg@ti.com, linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1 1/4] regmap: add function for set/clear bits
Date: Mon,  7 May 2012 13:05:36 +0530
Message-Id: <1336376139-1048-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add regmap_set_bits() and regmap_clear_bits() for
setting/clearing bits.
Although this can be achieve by regmap_update_bits() but
having these functions gives good readability in driver
code which uses regmap apis.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/base/regmap/regmap.c |   32 ++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |   15 +++++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 8a25006..d0c8144 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -942,6 +942,38 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
 
 /**
+ * regmap_set_bits: Set bits of register.
+ *
+ * @map: Register map to update
+ * @reg: Register to update
+ * @bits: Bits to set
+ *
+ * Returns zero for success, a negative number on error.
+ */
+int regmap_set_bits(struct regmap *map, unsigned int reg, unsigned int bits)
+{
+	bool change;
+	return _regmap_update_bits(map, reg, bits, bits, &change);
+}
+EXPORT_SYMBOL_GPL(regmap_set_bits);
+
+/**
+ * regmap_clear_bits: Clear bits of register.
+ *
+ * @map: Register map to update
+ * @reg: Register to update
+ * @bits: Bits to clear
+ *
+ * Returns zero for success, a negative number on error.
+ */
+int regmap_clear_bits(struct regmap *map, unsigned int reg, unsigned int bits)
+{
+	bool change;
+	return _regmap_update_bits(map, reg, bits, 0, &change);
+}
+EXPORT_SYMBOL_GPL(regmap_clear_bits);
+
+/**
  * regmap_register_patch: Register and apply register updates to be applied
  *                        on device initialistion
  *
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index ae797b1..bc859b2 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -185,6 +185,8 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val,
 			     bool *change);
+int regmap_set_bits(struct regmap *map, unsigned int reg, unsigned int bits);
+int regmap_clear_bits(struct regmap *map, unsigned int reg, unsigned int bits);
 int regmap_get_val_bytes(struct regmap *map);
 
 int regcache_sync(struct regmap *map);
@@ -311,6 +313,19 @@ static inline int regmap_update_bits_check(struct regmap *map,
 	WARN_ONCE(1, "regmap API is disabled");
 	return -EINVAL;
 }
+static inline int regmap_set_bits(struct regmap *map,
+			unsigned int reg, unsigned int bits)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_clear_bits(struct regmap *map,
+			unsigned int reg, unsigned int bits)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
 
 static inline int regmap_get_val_bytes(struct regmap *map)
 {
-- 
1.7.1.1

