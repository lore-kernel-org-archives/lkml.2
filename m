Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1DKOfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:35:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:54392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1DKOfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:35:00 -0400
Date: Mon, 11 Apr 2011 14:34:01 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-c4a8849af939082052d8117f9ea3e170a99ff232@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122941.820460566@chello.nl>
References: <20110407122941.820460566@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Remove obsolete arch_ prefixes
Git-Commit-ID: c4a8849af939082052d8117f9ea3e170a99ff232
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:34:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4a8849af939082052d8117f9ea3e170a99ff232
Gitweb:     http://git.kernel.org/tip/c4a8849af939082052d8117f9ea3e170a99ff232
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:16 +0200

sched: Remove obsolete arch_ prefixes

Non weak static functions clearly are not arch specific, so remove the
arch_ prefix.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122941.820460566@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4801363..d3e183c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -231,7 +231,7 @@ static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
 #endif
 
 /*
- * sched_domains_mutex serializes calls to arch_init_sched_domains,
+ * sched_domains_mutex serializes calls to init_sched_domains,
  * detach_destroy_domains and partition_sched_domains.
  */
 static DEFINE_MUTEX(sched_domains_mutex);
@@ -7670,7 +7670,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms)
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
  */
-static int arch_init_sched_domains(const struct cpumask *cpu_map)
+static int init_sched_domains(const struct cpumask *cpu_map)
 {
 	int err;
 
@@ -7687,7 +7687,7 @@ static int arch_init_sched_domains(const struct cpumask *cpu_map)
 	return err;
 }
 
-static void arch_destroy_sched_domains(const struct cpumask *cpu_map,
+static void destroy_sched_domains(const struct cpumask *cpu_map,
 				       struct cpumask *tmpmask)
 {
 	free_sched_groups(cpu_map, tmpmask);
@@ -7706,7 +7706,7 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
 	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
-	arch_destroy_sched_domains(cpu_map, to_cpumask(tmpmask));
+	destroy_sched_domains(cpu_map, to_cpumask(tmpmask));
 }
 
 /* handle null as "default" */
@@ -7815,7 +7815,7 @@ match2:
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-static void arch_reinit_sched_domains(void)
+static void reinit_sched_domains(void)
 {
 	get_online_cpus();
 
@@ -7848,7 +7848,7 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 	else
 		sched_mc_power_savings = level;
 
-	arch_reinit_sched_domains();
+	reinit_sched_domains();
 
 	return count;
 }
@@ -7974,7 +7974,7 @@ void __init sched_init_smp(void)
 #endif
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
-	arch_init_sched_domains(cpu_active_mask);
+	init_sched_domains(cpu_active_mask);
 	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
 	if (cpumask_empty(non_isolated_cpus))
 		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
