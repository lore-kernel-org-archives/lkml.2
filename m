Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0I3XPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:15:50 -0400
Received: from www.tglx.de ([62.245.132.106]:52437 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab0I3XPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:15:48 -0400
Message-Id: <20100930221739.463064808@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:24 -0000
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
Subject: [patch 10/47] genirq: Remove export of kstat_irqs_cpu
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-export-of-kstat_irqs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The statistics accessor is only used by proc/stats and
show_interrupts(). Both are compiled in.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdesc.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -269,4 +269,3 @@ unsigned int kstat_irqs_cpu(unsigned int
 	struct irq_desc *desc = irq_to_desc(irq);
 	return desc ? desc->kstat_irqs[cpu] : 0;
 }
-EXPORT_SYMBOL(kstat_irqs_cpu);


