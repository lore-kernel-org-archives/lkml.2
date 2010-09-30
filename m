Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0I3XQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:16:39 -0400
Received: from www.tglx.de ([62.245.132.106]:52494 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab0I3XQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:16:03 -0400
Message-Id: <20100930221739.760167780@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 13/47] powerpc: Use ARCH_IRQ_INIT_FLAGS
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline;
	filename=powerpc-use-generic-default-init-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the ARCH_IRQ_INIT_FLAGS instead of fixing it up in a loop.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/include/asm/hw_irq.h |    2 ++
 arch/powerpc/kernel/irq.c         |   15 ---------------
 2 files changed, 2 insertions(+), 15 deletions(-)

Index: linux-2.6-tip/arch/powerpc/include/asm/hw_irq.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/hw_irq.h
+++ linux-2.6-tip/arch/powerpc/include/asm/hw_irq.h
@@ -124,6 +124,8 @@ static inline int irqs_disabled_flags(un
 
 #endif /* CONFIG_PPC64 */
 
+#define ARCH_IRQ_INIT_FLAGS	IRQ_NOREQUEST
+
 /*
  * interrupt-retrigger: should we handle this via lost interrupts and IPIs
  * or should we not care like we do now ? --BenH.
Index: linux-2.6-tip/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6-tip/arch/powerpc/kernel/irq.c
@@ -1072,21 +1072,6 @@ void irq_free_virt(unsigned int virq, un
 
 int arch_early_irq_init(void)
 {
-	struct irq_desc *desc;
-	int i;
-
-	for (i = 0; i < NR_IRQS; i++) {
-		desc = irq_to_desc(i);
-		if (desc)
-			desc->status |= IRQ_NOREQUEST;
-	}
-
-	return 0;
-}
-
-int arch_init_chip_data(struct irq_desc *desc, int node)
-{
-	desc->status |= IRQ_NOREQUEST;
 	return 0;
 }
 


