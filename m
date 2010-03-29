Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0C2MZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:25:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0C2MZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:25:22 -0400
Message-Id: <20100329122138.791549336@chello.nl>
User-Agent: quilt/0.47-1
Date: Mon, 29 Mar 2010 14:20:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] perf, x86: fix __initconst vs const
References: <20100329122021.765109681@chello.nl>
Content-Disposition: inline; filename=perf-initconst.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All variables that have __initconst should also be const.

Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event_amd.c   |    4 ++--
 arch/x86/kernel/cpu/perf_event_intel.c |   12 ++++++------
 arch/x86/kernel/cpu/perf_event_p4.c    |    4 ++--
 arch/x86/kernel/cpu/perf_event_p6.c    |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
@@ -2,7 +2,7 @@
 
 static DEFINE_RAW_SPINLOCK(amd_nb_lock);
 
-static __initconst u64 amd_hw_cache_event_ids
+static __initconst const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -371,7 +371,7 @@ static void amd_pmu_cpu_dead(int cpu)
 	raw_spin_unlock(&amd_nb_lock);
 }
 
-static __initconst struct x86_pmu amd_pmu = {
+static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -88,7 +88,7 @@ static u64 intel_pmu_event_map(int hw_ev
 	return intel_perfmon_event_map[hw_event];
 }
 
-static __initconst u64 westmere_hw_cache_event_ids
+static __initconst const u64 westmere_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -179,7 +179,7 @@ static __initconst u64 westmere_hw_cache
  },
 };
 
-static __initconst u64 nehalem_hw_cache_event_ids
+static __initconst const u64 nehalem_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -270,7 +270,7 @@ static __initconst u64 nehalem_hw_cache_
  },
 };
 
-static __initconst u64 core2_hw_cache_event_ids
+static __initconst const u64 core2_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -361,7 +361,7 @@ static __initconst u64 core2_hw_cache_ev
  },
 };
 
-static __initconst u64 atom_hw_cache_event_ids
+static __initconst const u64 atom_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -776,7 +776,7 @@ intel_get_event_constraints(struct cpu_h
 	return x86_get_event_constraints(cpuc, event);
 }
 
-static __initconst struct x86_pmu core_pmu = {
+static __initconst const struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
@@ -815,7 +815,7 @@ static void intel_pmu_cpu_dying(int cpu)
 	fini_debug_store_on_cpu(cpu);
 }
 
-static __initconst struct x86_pmu intel_pmu = {
+static __initconst const struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
 	.disable_all		= intel_pmu_disable_all,
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
@@ -287,7 +287,7 @@ static struct p4_event_bind p4_event_bin
 	p4_config_pack_cccr(cache_event					| \
 			    P4_CCCR_ESEL(P4_OPCODE_ESEL(P4_OPCODE(event))))
 
-static __initconst u64 p4_hw_cache_event_ids
+static __initconst const u64 p4_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -775,7 +775,7 @@ done:
 	return num ? -ENOSPC : 0;
 }
 
-static __initconst struct x86_pmu p4_pmu = {
+static __initconst const struct x86_pmu p4_pmu = {
 	.name			= "Netburst P4/Xeon",
 	.handle_irq		= p4_pmu_handle_irq,
 	.disable_all		= p4_pmu_disable_all,
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p6.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p6.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_p6.c
@@ -102,7 +102,7 @@ static void p6_pmu_enable_event(struct p
 	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
 }
 
-static __initconst struct x86_pmu p6_pmu = {
+static __initconst const struct x86_pmu p6_pmu = {
 	.name			= "p6",
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= p6_pmu_disable_all,


