Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049Ab1JEQvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:51:03 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:40647 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935004Ab1JEQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:51:01 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] mfd/db8500-prcmu: rename init function
Date: Wed, 5 Oct 2011 18:50:47 +0200
Message-ID: <1317833447-714-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This renames the PRCMU clock force initialization function
to have a less generic name.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Patch made on Samuel Ortiz' request as a review comment on
"mfd/db8500-prcmu: initialize DB8500 PRCMU regs"
---
 drivers/mfd/db8500-prcmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 91a5e8c..98da431 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2154,7 +2154,7 @@ void __init db8500_prcmu_early_init(void)
 	}
 }
 
-static void __init init_prcm_registers(void)
+static void __init db8500_prcmu_init_clkforce(void)
 {
 	u32 val;
 
@@ -2412,7 +2412,7 @@ static int __init db8500_prcmu_probe(struct platform_device *pdev)
 	if (ux500_is_svp())
 		return -ENODEV;
 
-	init_prcm_registers();
+	db8500_prcmu_init_clkforce();
 
 	/* Clean up the mailbox interrupts after pre-kernel code. */
 	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);
-- 
1.7.3.2

