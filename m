Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775Ab2FDPPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:15:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:41936 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab2FDPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:15:32 -0400
Date: Mon, 4 Jun 2012 17:15:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] smp updates for 3.5
Message-ID: <alpine.LFD.2.02.1206041714170.3086@ionos>
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

please pull the latest smp-hotplug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git smp-hotplug-for-linus


Thanks,

	tglx

------------------>
Srivatsa S. Bhat (2):
      smpboot, idle: Optimize calls to smp_processor_id() in idle_threads_init()
      smpboot, idle: Fix comment mismatch over idle_threads_init()


 kernel/smpboot.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index e1a797e..98f60c5 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -31,6 +31,12 @@ void __init idle_thread_set_boot_cpu(void)
 	per_cpu(idle_threads, smp_processor_id()) = current;
 }
 
+/**
+ * idle_init - Initialize the idle thread for a cpu
+ * @cpu:	The cpu for which the idle thread should be initialized
+ *
+ * Creates the thread if it does not exist.
+ */
 static inline void idle_init(unsigned int cpu)
 {
 	struct task_struct *tsk = per_cpu(idle_threads, cpu);
@@ -45,17 +51,16 @@ static inline void idle_init(unsigned int cpu)
 }
 
 /**
- * idle_thread_init - Initialize the idle thread for a cpu
- * @cpu:	The cpu for which the idle thread should be initialized
- *
- * Creates the thread if it does not exist.
+ * idle_threads_init - Initialize idle threads for all cpus
  */
 void __init idle_threads_init(void)
 {
-	unsigned int cpu;
+	unsigned int cpu, boot_cpu;
+
+	boot_cpu = smp_processor_id();
 
 	for_each_possible_cpu(cpu) {
-		if (cpu != smp_processor_id())
+		if (cpu != boot_cpu)
 			idle_init(cpu);
 	}
 }
