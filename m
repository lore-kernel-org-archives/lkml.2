Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2JGP4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:56:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8879 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab2JGPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:55:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 07 Oct 2012 08:55:56 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <vbyravarasu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/5] mfd: tps65090: move register access APIs to header
Date: Sun, 7 Oct 2012 20:52:19 +0530
Message-ID: <1349623340-21807-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
References: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since tps65090 register is accessed via regmap, moving
the register access APIs to header and making it as inline.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65090.c       |   34 ----------------------------------
 include/linux/mfd/tps65090.h |   39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 3cfc9dc..355a077 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -25,7 +25,6 @@
 #include <linux/i2c.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps65090.h>
-#include <linux/regmap.h>
 #include <linux/err.h>
 
 #define NUM_INT_REG 2
@@ -78,39 +77,6 @@ static struct mfd_cell tps65090s[] = {
 	},
 };
 
-int tps65090_write(struct device *dev, int reg, uint8_t val)
-{
-	struct tps65090 *tps = dev_get_drvdata(dev);
-	return regmap_write(tps->rmap, reg, val);
-}
-EXPORT_SYMBOL_GPL(tps65090_write);
-
-int tps65090_read(struct device *dev, int reg, uint8_t *val)
-{
-	struct tps65090 *tps = dev_get_drvdata(dev);
-	unsigned int temp_val;
-	int ret;
-	ret = regmap_read(tps->rmap, reg, &temp_val);
-	if (!ret)
-		*val = temp_val;
-	return ret;
-}
-EXPORT_SYMBOL_GPL(tps65090_read);
-
-int tps65090_set_bits(struct device *dev, int reg, uint8_t bit_num)
-{
-	struct tps65090 *tps = dev_get_drvdata(dev);
-	return regmap_update_bits(tps->rmap, reg, BIT(bit_num), ~0u);
-}
-EXPORT_SYMBOL_GPL(tps65090_set_bits);
-
-int tps65090_clr_bits(struct device *dev, int reg, uint8_t bit_num)
-{
-	struct tps65090 *tps = dev_get_drvdata(dev);
-	return regmap_update_bits(tps->rmap, reg, BIT(bit_num), 0u);
-}
-EXPORT_SYMBOL_GPL(tps65090_clr_bits);
-
 static void tps65090_irq_lock(struct irq_data *data)
 {
 	struct tps65090 *tps65090 = irq_data_get_irq_chip_data(data);
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 6c57622..1a5f916 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -23,6 +23,7 @@
 #define __LINUX_MFD_TPS65090_H
 
 #include <linux/irq.h>
+#include <linux/regmap.h>
 
 struct tps65090 {
 	struct device		*dev;
@@ -40,9 +41,39 @@ struct tps65090_platform_data {
  * NOTE: the functions below are not intended for use outside
  * of the TPS65090 sub-device drivers
  */
-extern int tps65090_write(struct device *dev, int reg, uint8_t val);
-extern int tps65090_read(struct device *dev, int reg, uint8_t *val);
-extern int tps65090_set_bits(struct device *dev, int reg, uint8_t bit_num);
-extern int tps65090_clr_bits(struct device *dev, int reg, uint8_t bit_num);
+static inline int tps65090_write(struct device *dev, int reg, uint8_t val)
+{
+	struct tps65090 *tps = dev_get_drvdata(dev);
+
+	return regmap_write(tps->rmap, reg, val);
+}
+
+static inline int tps65090_read(struct device *dev, int reg, uint8_t *val)
+{
+	struct tps65090 *tps = dev_get_drvdata(dev);
+	unsigned int temp_val;
+	int ret;
+
+	ret = regmap_read(tps->rmap, reg, &temp_val);
+	if (!ret)
+		*val = temp_val;
+	return ret;
+}
+
+static inline int tps65090_set_bits(struct device *dev, int reg,
+		uint8_t bit_num)
+{
+	struct tps65090 *tps = dev_get_drvdata(dev);
+
+	return regmap_update_bits(tps->rmap, reg, BIT(bit_num), ~0u);
+}
+
+static inline int tps65090_clr_bits(struct device *dev, int reg,
+		uint8_t bit_num)
+{
+	struct tps65090 *tps = dev_get_drvdata(dev);
+
+	return regmap_update_bits(tps->rmap, reg, BIT(bit_num), 0u);
+}
 
 #endif /*__LINUX_MFD_TPS65090_H */
-- 
1.7.1.1

