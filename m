Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2GED71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:59:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2GED7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:59:23 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 2/6] mfd: max77686: Apply irq_mask_cur before handling interrupts.
Date: Thu,  5 Jul 2012 09:28:21 +0530
Message-Id: <1341460705-10868-2-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
References: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to TRM, though we mask the interrupts in interrupt-mask register,
interrupt source-register still provide the status of the masked interrupts.
So we should apply irq_mask_cur to read interrupt source-register value before
handling.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/mfd/max77686-irq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/max77686-irq.c b/drivers/mfd/max77686-irq.c
index 09e593a..0758fac 100644
--- a/drivers/mfd/max77686-irq.c
+++ b/drivers/mfd/max77686-irq.c
@@ -208,6 +208,9 @@ static irqreturn_t max77686_irq_thread(int irq, void *data)
 
 	}
 
+	for (i = 0; i < MAX77686_IRQ_GROUP_NR; i++)
+		irq_reg[i] &= ~max77686->irq_masks_cur[i];
+
 	for (i = 0; i < MAX77686_IRQ_NR; i++) {
 		if (irq_reg[max77686_irqs[i].group] & max77686_irqs[i].mask) {
 			cur_irq = irq_find_mapping(max77686->irq_domain, i);
-- 
1.7.0.4

