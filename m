Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab1KPO3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:29:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:58489 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab1KPO3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:29:22 -0500
Date: Wed, 16 Nov 2011 15:29:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] irq fixes for 3.2
Message-ID: <alpine.LFD.2.02.1111161526490.4902@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

Thanks,

	tglx

------------------>
Edward Donovan (1):
      genirq: Fix irqfixup, irqpoll regression


 kernel/irq/spurious.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index aa57d5d..b5f4742 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -115,7 +115,7 @@ static int misrouted_irq(int irq)
 	struct irq_desc *desc;
 	int i, ok = 0;
 
-	if (atomic_inc_return(&irq_poll_active) == 1)
+	if (atomic_inc_return(&irq_poll_active) != 1)
 		goto out;
 
 	irq_poll_cpu = smp_processor_id();
