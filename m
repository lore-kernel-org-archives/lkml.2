Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1FBNrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:47:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48441 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754157Ab1FBNrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:47:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] genirq: Fix missing parenthesises in generic-chip
Date: Thu,  2 Jun 2011 14:46:27 +0100
Message-Id: <1307022387-12822-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless I'm very much missing something these tests are intended to check
if bit zero is set, rather than checking if msk is entirely zero (in which
case the logic would be very confusing. I haven't actually observed any
runtime issues so this may be a misreading of the code on my part.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 kernel/irq/generic-chip.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 31a9db7..7872a5d 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -232,7 +232,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
@@ -287,7 +287,7 @@ void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 	raw_spin_unlock(&gc_lock);
 
 	for (; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		/* Remove handler first. That will mask the irq line */
-- 
1.7.5.3

