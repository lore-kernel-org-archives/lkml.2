Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab1GUGdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 02:33:12 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:45462 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1GUGdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 02:33:12 -0400
From: jhbird.choi@samsung.com
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] genirq: fix wrong bit operation
Date: Thu, 21 Jul 2011 15:29:14 +0900
Message-Id: <1311229754-6003-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 kernel/irq/generic-chip.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 3a2cab4..e38544d 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -246,7 +246,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
@@ -301,7 +301,7 @@ void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 	raw_spin_unlock(&gc_lock);
 
 	for (; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		/* Remove handler first. That will mask the irq line */
-- 
1.7.0

