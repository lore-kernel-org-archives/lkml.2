Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1JLHPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:15:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63986 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1JLHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:15:53 -0400
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH] irq: Add EXPORT_SYMBOL to function of irq generic-chip
Date: Wed, 12 Oct 2011 16:16:50 +0900
Message-Id: <1318403810-21860-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although some functions of of irq generic-chip can be used,
since EXPORT_SYMBOL is not specified, it cannot use.
This is revised that EXPORT_SYMBOL can be added and referred
to in functions.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 kernel/irq/generic-chip.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index e38544d..8108811 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -27,6 +27,7 @@ static inline struct irq_chip_regs *cur_regs(struct irq_data *d)
 void irq_gc_noop(struct irq_data *d)
 {
 }
+EXPORT_SYMBOL(irq_gc_noop);
 
 /**
  * irq_gc_mask_disable_reg - Mask chip via disable register
@@ -45,6 +46,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 	gc->mask_cache &= ~mask;
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL(irq_gc_mask_disable_reg);
 
 /**
  * irq_gc_mask_set_mask_bit - Mask chip via setting bit in mask register
@@ -63,6 +65,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 	irq_reg_writel(gc->mask_cache, gc->reg_base + cur_regs(d)->mask);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL(irq_gc_mask_set_bit);
 
 /**
  * irq_gc_mask_set_mask_bit - Mask chip via clearing bit in mask register
@@ -81,6 +84,7 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 	irq_reg_writel(gc->mask_cache, gc->reg_base + cur_regs(d)->mask);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL(irq_gc_mask_clr_bit);
 
 /**
  * irq_gc_unmask_enable_reg - Unmask chip via enable register
@@ -99,6 +103,7 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
 	gc->mask_cache |= mask;
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL(irq_gc_unmask_enable_reg);
 
 /**
  * irq_gc_ack_set_bit - Ack pending interrupt via setting bit
@@ -113,6 +118,7 @@ void irq_gc_ack_set_bit(struct irq_data *d)
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL(irq_gc_ack_set_bit);
 
 /**
  * irq_gc_ack_clr_bit - Ack pending interrupt via clearing bit
@@ -127,6 +133,7 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL(irq_gc_ack_clr_bit);
 
 /**
  * irq_gc_mask_disable_reg_and_ack- Mask and ack pending interrupt
@@ -142,6 +149,7 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL(irq_gc_mask_disable_reg_and_ack);
 
 /**
  * irq_gc_eoi - EOI interrupt
@@ -156,6 +164,7 @@ void irq_gc_eoi(struct irq_data *d)
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->eoi);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL(irq_gc_eoi);
 
 /**
  * irq_gc_set_wake - Set/clr wake bit for an interrupt
@@ -181,6 +190,7 @@ int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 	irq_gc_unlock(gc);
 	return 0;
 }
+EXPORT_SYMBOL(irq_gc_set_wake);
 
 /**
  * irq_alloc_generic_chip - Allocate a generic chip and initialize it
@@ -211,6 +221,7 @@ irq_alloc_generic_chip(const char *name, int num_ct, unsigned int irq_base,
 	}
 	return gc;
 }
+EXPORT_SYMBOL(irq_alloc_generic_chip);
 
 /*
  * Separate lockdep class for interrupt chip which can nest irq_desc
@@ -258,6 +269,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 	}
 	gc->irq_cnt = i - gc->irq_base;
 }
+EXPORT_SYMBOL(irq_setup_generic_chip);
 
 /**
  * irq_setup_alt_chip - Switch to alternative chip
@@ -281,6 +293,7 @@ int irq_setup_alt_chip(struct irq_data *d, unsigned int type)
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL(irq_setup_alt_chip);
 
 /**
  * irq_remove_generic_chip - Remove a chip
@@ -311,6 +324,7 @@ void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 		irq_modify_status(i, clr, set);
 	}
 }
+EXPORT_SYMBOL(irq_remove_generic_chip);
 
 #ifdef CONFIG_PM
 static int irq_gc_suspend(void)
-- 
1.7.6.3

