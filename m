Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2GED7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:59:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45409 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2GED7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:59:12 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 1/6] mfd: max77686: Use pmic regmap to read pmic interrupt register.
Date: Thu,  5 Jul 2012 09:28:20 +0530
Message-Id: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PMIC's regmap should be used to read pmic interrupt registers.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/mfd/max77686-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/max77686-irq.c b/drivers/mfd/max77686-irq.c
index fc10122..09e593a 100644
--- a/drivers/mfd/max77686-irq.c
+++ b/drivers/mfd/max77686-irq.c
@@ -180,7 +180,7 @@ static irqreturn_t max77686_irq_thread(int irq, void *data)
 		pr_info("%s: irq_src=0x%x\n", __func__, irq_src);
 
 	if (irq_src == MAX77686_IRQSRC_PMIC) {
-		ret = regmap_bulk_read(max77686->rtc_regmap,
+		ret = regmap_bulk_read(max77686->regmap,
 					 MAX77686_REG_INT1, irq_reg, 2);
 		if (ret < 0) {
 			dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
-- 
1.7.0.4

