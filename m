Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886Ab2EQNW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:22:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45538 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760607Ab2EQNW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:22:57 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Fix typo in IRQ register striding
Date: Thu, 17 May 2012 14:22:52 +0100
Message-Id: <1337260972-1830-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 502cbdb..4fac4b9 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -116,7 +116,7 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 	 * doing a write per register.
 	 */
 	for (i = 0; i < data->chip->num_regs; i++) {
-		ret = regmap_read(map, chip->mask_base + (i * map->reg_stride
+		ret = regmap_read(map, chip->status_base + (i * map->reg_stride
 				   * data->irq_reg_stride),
 				   &data->status_buf[i]);
 
-- 
1.7.10

