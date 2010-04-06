Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0DFTof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:44:35 -0400
Received: from www.tglx.de ([62.245.132.106]:53167 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab0DFTo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:44:29 -0400
Date: Tue, 6 Apr 2010 21:44:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [GIT Pull] generic irq updates for 2.6.34
Message-ID: <alpine.LFD.2.00.1004062143020.32352@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cLinus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      genirq: Force MSI irq handlers to run with interrupts disabled


 kernel/irq/manage.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 398fda1..704e488 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -757,6 +757,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
 
+		/*
+		 * Force MSI interrupts to run with interrupts
+		 * disabled. The multi vector cards can cause stack
+		 * overflows due to nested interrupts when enough of
+		 * them are directed to a core and fire at the same
+		 * time.
+		 */
+		if (desc->msi_desc)
+			new->flags |= IRQF_DISABLED;
+
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
