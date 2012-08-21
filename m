Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab2HUK2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:28:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60354 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231Ab2HUK2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:28:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: irq: Allow users to retrieve the irq_domain
Date: Tue, 21 Aug 2012 11:28:09 +0100
Message-Id: <1345544889-7720-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for integration with other subsystems, especially MFD,
and provides an alternative API for users that request their own IRQs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |   19 +++++++++++++++++++
 include/linux/regmap.h           |    2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index bb5e103..78b833f 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -450,3 +450,22 @@ int regmap_irq_get_virq(struct regmap_irq_chip_data *data, int irq)
 	return irq_create_mapping(data->domain, irq);
 }
 EXPORT_SYMBOL_GPL(regmap_irq_get_virq);
+
+/**
+ * regmap_irq_get_domain(): Retrieve the irq_domain for the chip
+ *
+ * Useful for drivers to request their own IRQs and for integration
+ * with subsystems.  For ease of integration NULL is accepted as a
+ * domain, allowing devices to just call this even if no domain is
+ * allocated.
+ *
+ * @data: regmap_irq controller to operate on.
+ */
+struct irq_domain *regmap_irq_get_domain(struct regmap_irq_chip_data *data)
+{
+	if (data)
+		return data->domain;
+	else
+		return NULL;
+}
+EXPORT_SYMBOL_GPL(regmap_irq_get_domain);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 9c4c9c67..a0f76c1 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -19,6 +19,7 @@
 struct module;
 struct device;
 struct i2c_client;
+struct irq_domain;
 struct spi_device;
 struct regmap;
 struct regmap_range_cfg;
@@ -316,6 +317,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *data);
 int regmap_irq_chip_get_base(struct regmap_irq_chip_data *data);
 int regmap_irq_get_virq(struct regmap_irq_chip_data *data, int irq);
+struct irq_domain *regmap_irq_get_domain(struct regmap_irq_chip_data *data);
 
 #else
 
-- 
1.7.10.4

