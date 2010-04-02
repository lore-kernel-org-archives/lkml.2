Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0DBTKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:10:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:38667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab0DBTKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:10:32 -0400
Date: Fri, 2 Apr 2010 19:10:00 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, sfr@canb.auug.org.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, sfr@canb.auug.org.au,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Fix __initconst vs const
Message-ID: <tip-caaa8be3b6707cb9664e573a28b00f845ce9f32e@git.kernel.org>
Git-Commit-ID: caaa8be3b6707cb9664e573a28b00f845ce9f32e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:10:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  caaa8be3b6707cb9664e573a28b00f845ce9f32e
Gitweb:     http://git.kernel.org/tip/caaa8be3b6707cb9664e573a28b00f845ce9f32e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 29 Mar 2010 13:09:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:52:05 +0200

perf, x86: Fix __initconst vs const

All variables that have __initconst should also be const.

Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_amd.c   |    4 ++--
 arch/x86/kernel/cpu/perf_event_intel.c |   12 ++++++------
 arch/x86/kernel/cpu/perf_event_p4.c    |    4 ++--
 arch/x86/kernel/cpu/perf_event_p6.c    |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index bbd7339..611df11 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -2,7 +2,7 @@
 
 static DEFINE_RAW_SPINLOCK(amd_nb_lock);
 
-static __initconst u64 amd_hw_cache_event_ids
+static __initconst const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -368,7 +368,7 @@ static void amd_pmu_cpu_dead(int cpu)
 	raw_spin_unlock(&amd_nb_lock);
 }
 
-static __initconst struct x86_pmu amd_pmu = {
+static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 30bf10c..1957e3f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -88,7 +88,7 @@ static u64 intel_pmu_event_map(int hw_event)
 	return intel_perfmon_event_map[hw_event];
 }
 
-static __initconst u64 westmere_hw_cache_event_ids
+static __initconst const u64 westmere_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -179,7 +179,7 @@ static __initconst u64 westmere_hw_cache_event_ids
  },
 };
 
-static __initconst u64 nehalem_hw_cache_event_ids
+static __initconst const u64 nehalem_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -270,7 +270,7 @@ static __initconst u64 nehalem_hw_cache_event_ids
  },
 };
 
-static __initconst u64 core2_hw_cache_event_ids
+static __initconst const u64 core2_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -361,7 +361,7 @@ static __initconst u64 core2_hw_cache_event_ids
  },
 };
 
-static __initconst u64 atom_hw_cache_event_ids
+static __initconst const u64 atom_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -782,7 +782,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
-static __initconst struct x86_pmu core_pmu = {
+static __initconst const struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
@@ -820,7 +820,7 @@ static void intel_pmu_cpu_dying(int cpu)
 	fini_debug_store_on_cpu(cpu);
 }
 
-static __initconst struct x86_pmu intel_pmu = {
+static __initconst const struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
 	.disable_all		= intel_pmu_disable_all,
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index acd237d..15367cc 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -287,7 +287,7 @@ static struct p4_event_bind p4_event_bind_map[] = {
 	p4_config_pack_cccr(cache_event					| \
 			    P4_CCCR_ESEL(P4_OPCODE_ESEL(P4_OPCODE(event))))
 
-static __initconst u64 p4_hw_cache_event_ids
+static __initconst const u64 p4_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -780,7 +780,7 @@ done:
 	return num ? -ENOSPC : 0;
 }
 
-static __initconst struct x86_pmu p4_pmu = {
+static __initconst const struct x86_pmu p4_pmu = {
 	.name			= "Netburst P4/Xeon",
 	.handle_irq		= p4_pmu_handle_irq,
 	.disable_all		= p4_pmu_disable_all,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 9123e8e..34ba07b 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -84,7 +84,7 @@ static void p6_pmu_enable_event(struct perf_event *event)
 	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
 }
 
-static __initconst struct x86_pmu p6_pmu = {
+static __initconst const struct x86_pmu p6_pmu = {
 	.name			= "p6",
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= p6_pmu_disable_all,
