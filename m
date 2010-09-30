Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab0I3XSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:18:21 -0400
Received: from www.tglx.de ([62.245.132.106]:53031 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab0I3XSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:18:12 -0400
Message-Id: <20100930221742.320643472@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:17:54 -0000
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
Subject: [patch 39/47] genirq: Remove arch_init_chip_data()
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-arch_init_chip_data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function should have not been there in the first place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    3 ---
 kernel/irq/irqdesc.c      |    2 --
 kernel/softirq.c          |    5 -----
 3 files changed, 10 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -641,11 +641,8 @@ static inline void init_irq_proc(void)
 struct seq_file;
 int show_interrupts(struct seq_file *p, void *v);
 
-struct irq_desc;
-
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
-extern int arch_init_chip_data(struct irq_desc *desc, int node);
 
 #endif
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -196,8 +196,6 @@ static int alloc_descs(unsigned int star
 		desc = alloc_desc(start + i, node);
 		if (!desc)
 			goto err;
-		/* temporary until I fixed x86 madness */
-		arch_init_chip_data(desc, node);
 		raw_spin_lock_irqsave(&sparse_irq_lock, flags);
 		irq_insert_desc(start + i, desc);
 		raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
Index: linux-2.6-tip/kernel/softirq.c
===================================================================
--- linux-2.6-tip.orig/kernel/softirq.c
+++ linux-2.6-tip/kernel/softirq.c
@@ -895,8 +895,3 @@ int __init __weak arch_early_irq_init(vo
 {
 	return 0;
 }
-
-int __weak arch_init_chip_data(struct irq_desc *desc, int node)
-{
-	return 0;
-}


