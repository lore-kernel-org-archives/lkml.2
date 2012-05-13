Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab2EMKcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 06:32:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53780 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980Ab2EMKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 06:32:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Pass back the allocated regmap IRQ controller data
Date: Sun, 13 May 2012 11:31:09 +0100
Message-Id: <1336905069-1249-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's needed for freeing and for obtaining the IRQ base later on.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 1befaa7..f4e6dcf 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -192,6 +192,8 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	if (!d)
 		return -ENOMEM;
 
+	*data = d;
+
 	d->status_buf = kzalloc(sizeof(unsigned int) * chip->num_regs,
 				GFP_KERNEL);
 	if (!d->status_buf)
-- 
1.7.10

