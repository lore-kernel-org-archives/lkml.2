Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0I3XS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:18:58 -0400
Received: from www.tglx.de ([62.245.132.106]:43628 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012Ab0I3XSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:18:53 -0400
Message-Id: <20100930221743.113364752@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:18:32 -0000
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
Subject: [patch 47/47] genirq: Remove the old sparse irq allocator function
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-craplocator.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last user is gone. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h  |    2 --
 kernel/irq/irqdesc.c |    9 ---------
 2 files changed, 11 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -261,8 +261,6 @@ struct irq_desc {
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif
 
-extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
-
 int irq_alloc_descs(unsigned int irq, unsigned int from, unsigned int cnt, int node);
 
 static inline int irq_alloc_desc(int node)
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -192,15 +192,6 @@ err:
 	return -ENOMEM;
 }
 
-struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
-{
-	int res = irq_alloc_descs(irq, irq, 1, node);
-
-	if (res == -EEXIST || res == irq)
-		return irq_to_desc(irq);
-	return NULL;
-}
-
 int __init early_irq_init(void)
 {
 	int i, initcnt, node = first_online_node;


