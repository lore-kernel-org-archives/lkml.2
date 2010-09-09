Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab0IITql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:46:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:40662 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab0IITqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:46:40 -0400
Date: Thu, 9 Sep 2010 19:46:12 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100831082843.953617555@de.ibm.com>
References: <20100831082843.953617555@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Merge cpu_to_core_group functions
Message-ID: <tip-f269893c575167447cc9f6d1867e639fb5b6f0c5@git.kernel.org>
Git-Commit-ID: f269893c575167447cc9f6d1867e639fb5b6f0c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:46:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f269893c575167447cc9f6d1867e639fb5b6f0c5
Gitweb:     http://git.kernel.org/tip/f269893c575167447cc9f6d1867e639fb5b6f0c5
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Tue, 31 Aug 2010 10:28:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:41:18 +0200

sched: Merge cpu_to_core_group functions

Merge and simplify the two cpu_to_core_group variants so that the
resulting function follows the same pattern like cpu_to_phys_group.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100831082843.953617555@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8eef8e5..1a0c084 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6552,31 +6552,23 @@ cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
 #ifdef CONFIG_SCHED_MC
 static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
-#endif /* CONFIG_SCHED_MC */
 
-#if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
 static int
 cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
-
+#ifdef CONFIG_SCHED_SMT
 	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
 	group = cpumask_first(mask);
+#else
+	group = cpu;
+#endif
 	if (sg)
 		*sg = &per_cpu(sched_group_core, group).sg;
 	return group;
 }
-#elif defined(CONFIG_SCHED_MC)
-static int
-cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *unused)
-{
-	if (sg)
-		*sg = &per_cpu(sched_group_core, cpu).sg;
-	return cpu;
-}
-#endif
+#endif /* CONFIG_SCHED_MC */
 
 static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
