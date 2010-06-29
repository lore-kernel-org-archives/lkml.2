Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0F2CCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:02:06 -0400
Received: from ozlabs.org ([203.10.76.45]:44611 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab0F2CCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:02:04 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH] sched: fix spelling of sibling
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Tue, 29 Jun 2010 12:02:01 +1000
Message-ID: <15249.1277776921@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No logic changes, only spelling.

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/kernel/process.c |    2 +-
 include/linux/topology.h      |    2 +-
 kernel/sched_fair.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-tip/arch/powerpc/kernel/process.c
===================================================================
--- linux-tip.orig/arch/powerpc/kernel/process.c
+++ linux-tip/arch/powerpc/kernel/process.c
@@ -1270,7 +1270,7 @@ unsigned long randomize_et_dyn(unsigned 
 }
 
 #ifdef CONFIG_SMP
-int arch_sd_sibiling_asym_packing(void)
+int arch_sd_sibling_asym_packing(void)
 {
 	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
 		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
Index: linux-tip/include/linux/topology.h
===================================================================
--- linux-tip.orig/include/linux/topology.h
+++ linux-tip/include/linux/topology.h
@@ -103,7 +103,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
-				| arch_sd_sibiling_asym_packing()	\
+				| arch_sd_sibling_asym_packing()	\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
Index: linux-tip/kernel/sched_fair.c
===================================================================
--- linux-tip.orig/kernel/sched_fair.c
+++ linux-tip/kernel/sched_fair.c
@@ -2567,7 +2567,7 @@ static inline void update_sd_lb_stats(st
 	} while (sg != sd->groups);
 }
 
-int __weak arch_sd_sibiling_asym_packing(void)
+int __weak arch_sd_sibling_asym_packing(void)
 {
        return 0*SD_ASYM_PACKING;
 }
