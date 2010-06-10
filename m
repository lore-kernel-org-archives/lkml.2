Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab0FJLKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:10:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39152 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab0FJLKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:42 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: tglx@linutronix.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/23] IRQ: Move alloc_desk_mask variables inside ifdef
Message-Id: <20100610111037.E0C8FB1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


They are only useful with CONFIG_CPUMASK_OFFSTACK

Avoids hundreds of warnings with a gcc 4.6 -Wall build.

Cc: tglx@linutronix.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/irq.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35-rc2-gcc/include/linux/irq.h
===================================================================
--- linux-2.6.35-rc2-gcc.orig/include/linux/irq.h
+++ linux-2.6.35-rc2-gcc/include/linux/irq.h
@@ -439,12 +439,12 @@ extern int set_irq_msi(unsigned int irq,
 static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
 							bool boot)
 {
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	gfp_t gfp = GFP_ATOMIC;
 
 	if (boot)
 		gfp = GFP_NOWAIT;
 
-#ifdef CONFIG_CPUMASK_OFFSTACK
 	if (!alloc_cpumask_var_node(&desc->affinity, gfp, node))
 		return false;
 
