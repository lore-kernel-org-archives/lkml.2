Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237Ab2FENaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:30:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56420 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932429Ab2FENaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:30:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Don't try to map non-existant IRQs
Date: Tue,  5 Jun 2012 14:30:06 +0100
Message-Id: <1338903006-24379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the driver supplied an empty entry in the array of IRQs then return
an error rather than trying to do the mapping. This is intended for use
with handling chip variants and similar situations.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index c190229..8e94e0e 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -346,6 +346,10 @@ EXPORT_SYMBOL_GPL(regmap_irq_chip_get_base);
  */
 int regmap_irq_get_virq(struct regmap_irq_chip_data *data, int irq)
 {
+	/* Handle holes in the IRQ list */
+	if (!data->chip->irqs[irq].mask)
+		return -EINVAL;
+
 	return irq_create_mapping(data->domain, irq);
 }
 EXPORT_SYMBOL_GPL(regmap_irq_get_virq);
-- 
1.7.10

