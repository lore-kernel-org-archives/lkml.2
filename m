Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2DTNJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:09:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:44765 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124557.581762105@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Richard Kuo <rkuo@codeaurora.org>
Subject: [patch 11/18] hexagon: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=hexagon-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/Kconfig      |    1 +
 arch/hexagon/kernel/smp.c |   11 ++---------
 2 files changed, 3 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/hexagon/Kconfig
===================================================================
--- linux-2.6.orig/arch/hexagon/Kconfig
+++ linux-2.6/arch/hexagon/Kconfig
@@ -27,6 +27,7 @@ config HEXAGON
 	select HAVE_ARCH_TRACEHOOK
 	select NO_IOPORT
 	select GENERIC_IOMAP
+	select GENERIC_SMP_IDLE_THREAD
 	# mostly generic routines, with some accelerated ones
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
Index: linux-2.6/arch/hexagon/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/hexagon/kernel/smp.c
+++ linux-2.6/arch/hexagon/kernel/smp.c
@@ -190,18 +190,11 @@ void __cpuinit start_secondary(void)
  * maintains control until "cpu_online(cpu)" is set.
  */
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
-	struct task_struct *idle;
-	struct thread_info *thread;
+	struct thread_info *thread = (struct thread_info *)idle->stack;
 	void *stack_start;
 
-	/*  Create new init task for the CPU  */
-	idle = fork_idle(cpu);
-	if (IS_ERR(idle))
-		panic(KERN_ERR "fork_idle failed\n");
-
-	thread = (struct thread_info *)idle->stack;
 	thread->cpu = cpu;
 
 	/*  Boot to the head.  */


