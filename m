Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab0JWO7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 10:59:32 -0400
Received: from www.tglx.de ([62.245.132.106]:41022 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab0JWO7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 10:59:31 -0400
Date: Sat, 23 Oct 2010 16:56:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] softirq updates for 2.6.37
Message-ID: <alpine.LFD.2.00.1010231643300.2516@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest softirq-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git softirq-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      softirqs: Make wakeup_softirqd static


 include/linux/interrupt.h |    1 -
 kernel/softirq.c          |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a0384a4..0a9141e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -410,7 +410,6 @@ extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
-extern void wakeup_softirqd(void);
 
 /* This is the worklist that queues up per-cpu softirq work.
  *
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 07b4f1b..80f6e3b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -67,7 +67,7 @@ char *softirq_to_name[NR_SOFTIRQS] = {
  * to the pending events, so lets the scheduler to balance
  * the softirq load for us.
  */
-void wakeup_softirqd(void)
+static void wakeup_softirqd(void)
 {
 	/* Interrupts are disabled: no need to stop preemption */
 	struct task_struct *tsk = __get_cpu_var(ksoftirqd);
