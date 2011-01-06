Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1AFKm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:42:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab1AFKm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:42:57 -0500
Date: Thu, 6 Jan 2011 11:42:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq changes for v2.6.38
Message-ID: <20110106104246.GA26427@elte.hu>
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

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

 Thanks,

	Ingo

------------------>
Eric Dumazet (1):
      irq: Better struct irqaction layout


 include/linux/interrupt.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 79d0c4f..55e0d42 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -114,15 +114,15 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
 struct irqaction {
 	irq_handler_t handler;
 	unsigned long flags;
-	const char *name;
 	void *dev_id;
 	struct irqaction *next;
 	int irq;
-	struct proc_dir_entry *dir;
 	irq_handler_t thread_fn;
 	struct task_struct *thread;
 	unsigned long thread_flags;
-};
+	const char *name;
+	struct proc_dir_entry *dir;
+} ____cacheline_internodealigned_in_smp;
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
 
