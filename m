Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965134Ab1C3VYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:24:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:37491 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965113Ab1C3VJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278831"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tglx@linutronix.de, James.Bottomley@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [216/275] fix per-cpu flag problem in the cpu affinity checkers
Message-Id: <20110330210741.2309D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 9804c9eaeacfe78651052c5ddff31099f60ef78c upstream.

The CHECK_IRQ_PER_CPU is wrong, it should be checking
irq_to_desc(irq)->status not just irq.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/parisc/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.35.y.orig/arch/parisc/kernel/irq.c	2011-03-29 22:50:31.235459182 -0700
+++ linux-2.6.35.y/arch/parisc/kernel/irq.c	2011-03-29 23:03:02.750229799 -0700
@@ -117,7 +117,7 @@
 	int cpu_dest;
 
 	/* timer and ipi have to always be received on all CPUs */
-	if (CHECK_IRQ_PER_CPU(irq)) {
+	if (CHECK_IRQ_PER_CPU(irq_to_desc(irq)->status)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
 		cpumask_setall(irq_desc[irq].affinity);
