Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab2FGW33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:29:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:61540 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab2FGW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:29:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="149712376"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, eranian@google.com, mingo@elte.hu,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support
Date: Thu,  7 Jun 2012 15:29:16 -0700
Message-Id: <1339108157-30021-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Very similar to Sandy Bridge, but there is no PEBS problem.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 166546e..1249c56 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1698,6 +1698,7 @@ __init int intel_pmu_init(void)
 	union cpuid10_ebx ebx;
 	unsigned int unused;
 	int version;
+	char *name;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -1839,9 +1840,15 @@ __init int intel_pmu_init(void)
 		pr_cont("Westmere events, ");
 		break;
 
+	case 58: /* IvyBridge */
+		name = "Ivy";
+		goto snb_ivb_common;
+
 	case 42: /* SandyBridge */
 		x86_add_quirk(intel_sandybridge_quirk);
 	case 45: /* SandyBridge, "Romely-EP" */
+		name = "Sandy";
+	snb_ivb_common:
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -1861,7 +1868,7 @@ __init int intel_pmu_init(void)
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
 			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
 
-		pr_cont("SandyBridge events, ");
+		pr_cont("%sBridge events, ", name);
 		break;
 
 	default:
-- 
1.7.7.6

