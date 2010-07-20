Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab0GTEqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:46:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46814 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab0GTEqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:46:52 -0400
Date: Tue, 20 Jul 2010 14:46:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the workqueues tree with the tip tree
Message-Id: <20100720144643.970abee5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
include/linux/workqueue.h between commit
a25909a4d4a29e272f953e12595bf2f04a292dbd ("lockdep: Add an
in_workqueue_context() lockdep-based test function") from the tip tree
and commit a0a1a5fd4fb15ec61117c759fe9f5c16c53d9e9c ("workqueue:
reimplement workqueue freeze using max_active") from the workqueues tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/workqueue.h
index d0f7c81,d74a529..0000000
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@@ -298,7 -394,10 +394,14 @@@ static inline long work_on_cpu(unsigne
  long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
  #endif /* CONFIG_SMP */
  
 +#ifdef CONFIG_LOCKDEP
 +int in_workqueue_context(struct workqueue_struct *wq);
 +#endif
++
+ #ifdef CONFIG_FREEZER
+ extern void freeze_workqueues_begin(void);
+ extern bool freeze_workqueues_busy(void);
+ extern void thaw_workqueues(void);
+ #endif /* CONFIG_FREEZER */
+ 
  #endif
