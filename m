Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0I3XQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:16:04 -0400
Received: from www.tglx.de ([62.245.132.106]:52487 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab0I3XP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:15:59 -0400
Message-Id: <20100930221739.661942830@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:38 -0000
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
Subject: [patch 12/47] arm: Use ARCH_IRQ_INIT_FLAGS
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=arm-use-genirq-default-init-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the ARCH_IRQ_INIT_FLAGS instead of fixing it up in a loop.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/include/asm/hw_irq.h |    2 ++
 arch/arm/kernel/irq.c         |    4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/arch/arm/include/asm/hw_irq.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/hw_irq.h
+++ linux-2.6-tip/arch/arm/include/asm/hw_irq.h
@@ -24,4 +24,6 @@ void set_irq_flags(unsigned int irq, uns
 #define IRQF_PROBE	(1 << 1)
 #define IRQF_NOAUTOEN	(1 << 2)
 
+#define ARCH_IRQ_INIT_FLAGS	(IRQ_NOREQUEST | IRQ_NOPROBE)
+
 #endif
Index: linux-2.6-tip/arch/arm/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/kernel/irq.c
+++ linux-2.6-tip/arch/arm/kernel/irq.c
@@ -151,10 +151,8 @@ void __init init_IRQ(void)
 	struct irq_desc *desc;
 	int irq;
 
-	for (irq = 0; irq < nr_irqs; irq++) {
+	for (irq = 0; irq < nr_irqs; irq++)
 		desc = irq_to_desc_alloc_node(irq, 0);
-		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-	}
 
 	init_arch_irq();
 }


