Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab2EaUDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:03:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33087 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933251Ab2EaUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:03:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Constify regmap_irq_chip
Date: Thu, 31 May 2012 21:03:09 +0100
Message-Id: <1338494589-8830-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should never be modifying it and it lets drivers declare it const.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |    6 +++---
 include/linux/regmap.h           |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 4fac4b9..c190229 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -24,7 +24,7 @@ struct regmap_irq_chip_data {
 	struct mutex lock;
 
 	struct regmap *map;
-	struct regmap_irq_chip *chip;
+	const struct regmap_irq_chip *chip;
 
 	int irq_base;
 	struct irq_domain *domain;
@@ -103,7 +103,7 @@ static struct irq_chip regmap_irq_chip = {
 static irqreturn_t regmap_irq_thread(int irq, void *d)
 {
 	struct regmap_irq_chip_data *data = d;
-	struct regmap_irq_chip *chip = data->chip;
+	const struct regmap_irq_chip *chip = data->chip;
 	struct regmap *map = data->map;
 	int ret, i;
 	bool handled = false;
@@ -195,7 +195,7 @@ static struct irq_domain_ops regmap_domain_ops = {
  * register values used by the IRQ controller over suspend and resume.
  */
 int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
-			int irq_base, struct regmap_irq_chip *chip,
+			int irq_base, const struct regmap_irq_chip *chip,
 			struct regmap_irq_chip_data **data)
 {
 	struct regmap_irq_chip_data *d;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 56af22e..390a5ed 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -243,7 +243,7 @@ struct regmap_irq_chip {
 struct regmap_irq_chip_data;
 
 int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
-			int irq_base, struct regmap_irq_chip *chip,
+			int irq_base, const struct regmap_irq_chip *chip,
 			struct regmap_irq_chip_data **data);
 void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *data);
 int regmap_irq_chip_get_base(struct regmap_irq_chip_data *data);
-- 
1.7.10

