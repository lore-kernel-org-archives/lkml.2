Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2EMLu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 07:50:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48133 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744Ab2EMLu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 07:50:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Dynamicallly allocate a regmap_irq range if no base is specified
Date: Sun, 13 May 2012 12:50:21 +0100
Message-Id: <1336909821-18711-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids drivers having to implement the logic and will make it easier
to add irq_domain support.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 0d233cc..f9724af 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -195,6 +195,10 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 			return -EINVAL;
 	}
 
+	/* Ask for a dynamic range if none is specified */
+	if (!irq_base)
+		irq_base = -1;
+
 	irq_base = irq_alloc_descs(irq_base, 0, chip->num_irqs, 0);
 	if (irq_base < 0) {
 		dev_warn(map->dev, "Failed to allocate IRQs: %d\n",
-- 
1.7.10

