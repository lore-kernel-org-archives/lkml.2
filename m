Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab1LEQMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:12:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50443 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932447Ab1LEQMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:12:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: ashish.jangam@kpitcummins.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Add irq_base accessor to regmap_irq
Date: Mon,  5 Dec 2011 16:10:48 +0000
Message-Id: <1323101448-4125-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows devices to discover their own interrupt without having to remember
it themselves.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |   13 +++++++++++++
 include/linux/regmap.h           |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 6b8a74c..428836f 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -287,3 +287,16 @@ void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *d)
 	kfree(d);
 }
 EXPORT_SYMBOL_GPL(regmap_del_irq_chip);
+
+/**
+ * regmap_irq_chip_get_base(): Retrieve interrupt base for a regmap IRQ chip
+ *
+ * Useful for drivers to request their own IRQs.
+ *
+ * @data: regmap_irq controller to operate on.
+ */
+int regmap_irq_chip_get_base(struct regmap_irq_chip_data *data)
+{
+	return data->irq_base;
+}
+EXPORT_SYMBOL_GPL(regmap_irq_chip_get_base);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index cfce3a3..eb93921 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -195,5 +195,6 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 			int irq_base, struct regmap_irq_chip *chip,
 			struct regmap_irq_chip_data **data);
 void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *data);
+int regmap_irq_chip_get_base(struct regmap_irq_chip_data *data);
 
 #endif
-- 
1.7.7.3

