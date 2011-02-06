Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab1BFVqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:46:22 -0500
Received: from www.tglx.de ([62.245.132.106]:45935 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab1BFVp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:45:58 -0500
Message-Id: <20110206214534.566824121@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:45:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 2/7] mn10300: Remove unused mn10300_intc_* functions
References: <20110206214441.438777646@linutronix.de>
Content-Disposition: inline; filename=mn10300-remove-unused-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/include/asm/intctl-regs.h |    5 -----
 arch/mn10300/kernel/irq.c              |   25 -------------------------
 2 files changed, 30 deletions(-)

Index: linux-next/arch/mn10300/include/asm/intctl-regs.h
===================================================================
--- linux-next.orig/arch/mn10300/include/asm/intctl-regs.h
+++ linux-next/arch/mn10300/include/asm/intctl-regs.h
@@ -60,11 +60,6 @@
 
 #ifndef __ASSEMBLY__
 extern void set_intr_level(int irq, u16 level);
-extern void mn10300_intc_set_level(unsigned int irq, unsigned int level);
-extern void mn10300_intc_clear(unsigned int irq);
-extern void mn10300_intc_set(unsigned int irq);
-extern void mn10300_intc_enable(unsigned int irq);
-extern void mn10300_intc_disable(unsigned int irq);
 extern void mn10300_set_lateack_irq_type(int irq);
 #endif
 
Index: linux-next/arch/mn10300/kernel/irq.c
===================================================================
--- linux-next.orig/arch/mn10300/kernel/irq.c
+++ linux-next/arch/mn10300/kernel/irq.c
@@ -252,31 +252,6 @@ void set_intr_level(int irq, u16 level)
 	__mask_and_set_icr(irq, GxICR_ENABLE, level);
 }
 
-void mn10300_intc_set_level(unsigned int irq, unsigned int level)
-{
-	set_intr_level(irq, NUM2GxICR_LEVEL(level) & GxICR_LEVEL);
-}
-
-void mn10300_intc_clear(unsigned int irq)
-{
-	__mask_and_set_icr(irq, GxICR_LEVEL | GxICR_ENABLE, GxICR_DETECT);
-}
-
-void mn10300_intc_set(unsigned int irq)
-{
-	__mask_and_set_icr(irq, 0, GxICR_REQUEST | GxICR_DETECT);
-}
-
-void mn10300_intc_enable(unsigned int irq)
-{
-	mn10300_cpupic_unmask(irq);
-}
-
-void mn10300_intc_disable(unsigned int irq)
-{
-	mn10300_cpupic_mask(irq);
-}
-
 /*
  * mark an interrupt to be ACK'd after interrupt handlers have been run rather
  * than before


