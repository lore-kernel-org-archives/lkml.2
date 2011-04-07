Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1DGMoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:44:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:48153 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1DGMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:52 -0400
Message-Id: <20110407122942.553814623@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:56 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 15/23] sched: Remove some dead code
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo13.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    6 ------
 kernel/sched.c        |   16 ----------------
 2 files changed, 22 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -881,9 +881,6 @@ struct sched_group {
 	 * NOTE: this field is variable length. (Allocated dynamically
 	 * by attaching extra space to the end of the structure,
 	 * depending on how many CPUs the kernel has booted up with)
-	 *
-	 * It is also be embedded into static data structures at build
-	 * time. (See 'struct static_sched_group' in kernel/sched.c)
 	 */
 	unsigned long cpumask[0];
 };
@@ -992,9 +989,6 @@ struct sched_domain {
 	 * NOTE: this field is variable length. (Allocated dynamically
 	 * by attaching extra space to the end of the structure,
 	 * depending on how many CPUs the kernel has booted up with)
-	 *
-	 * It is also be embedded into static data structures at build
-	 * time. (See 'struct static_sched_domain' in kernel/sched.c)
 	 */
 	unsigned long span[0];
 };
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6793,22 +6793,6 @@ static void sched_domain_node_span(int n
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
-/*
- * The cpus mask in sched_group and sched_domain hangs off the end.
- *
- * ( See the the comments in include/linux/sched.h:struct sched_group
- *   and struct sched_domain. )
- */
-struct static_sched_group {
-	struct sched_group sg;
-	DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
-};
-
-struct static_sched_domain {
-	struct sched_domain sd;
-	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
-};
-
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;


