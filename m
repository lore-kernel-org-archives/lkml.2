Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0JVN1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:27:44 -0400
Received: from www.tglx.de ([62.245.132.106]:41143 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab0JVN1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:27:43 -0400
Date: Fri, 22 Oct 2010 15:27:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Weinberger <richard@nod.at>
cc: peterz@infradead.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: User Mode Linux broken
In-Reply-To: <alpine.LFD.2.00.1010221309370.3345@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1010221526080.29540@localhost6.localdomain6>
References: <201010211315.26679.richard@nod.at> <201010212122.38437.richard@nod.at> <alpine.LFD.2.00.1010212143300.3467@localhost6.localdomain6> <201010212227.12919.richard@nod.at> <alpine.LFD.2.00.1010220900230.3467@localhost6.localdomain6>
 <ed248baebfad9b050f53a6832435a9a5@radon2.swed.at> <alpine.LFD.2.00.1010221309370.3345@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Thomas Gleixner wrote:
> On Fri, 22 Oct 2010, Richard Weinberger wrote:
> Well, nothing is supposed to call enable_irq() before an interrupt is
> installed with request_irq() or setup_irq().
> 
> Patch below should fix your problem.

Yuck. Missed the second instance. Updated patch below.

Thanks,
 
 	tglx
---
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index a746e30..97e204b 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -395,13 +395,11 @@ void __init init_IRQ(void)
 	irq_desc[TIMER_IRQ].action = NULL;
 	irq_desc[TIMER_IRQ].depth = 1;
 	irq_desc[TIMER_IRQ].chip = &SIGVTALRM_irq_type;
-	enable_irq(TIMER_IRQ);
 	for (i = 1; i < NR_IRQS; i++) {
 		irq_desc[i].status = IRQ_DISABLED;
 		irq_desc[i].action = NULL;
 		irq_desc[i].depth = 1;
 		irq_desc[i].chip = &normal_irq_type;
-		enable_irq(i);
 	}
 }
 
