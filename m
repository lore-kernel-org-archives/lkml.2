Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1BFL60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 06:58:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab1BFL6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 06:58:25 -0500
Date: Sun, 6 Feb 2011 12:58:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fixes
Message-ID: <20110206115814.GA28084@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (2):
      genirq: Add missing status flags to modification mask
      m32r: Fixup last __do_IRQ leftover


 arch/m32r/kernel/irq.c |    2 +-
 include/linux/irq.h    |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index f745c12..76eaf38 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -80,7 +80,7 @@ asmlinkage unsigned int do_IRQ(int irq, struct pt_regs *regs)
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	/* FIXME M32R */
 #endif
-	__do_IRQ(irq);
+	generic_handle_irq(irq);
 	irq_exit();
 	set_irq_regs(old_regs);
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index abde252..80fcb53 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -74,7 +74,8 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
-	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL)
+	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
+	 IRQ_PER_CPU)
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
