Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2I0Bdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:33:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:48573 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab2I0Bd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,492,1344236400"; 
   d="scan'208";a="197692038"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: eranian@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86: Fix typo in uncore_pmu_to_box
Date: Thu, 27 Sep 2012 09:33:26 +0800
Message-Id: <1348709606-2759-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

the variable box should not be declared as static

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index db917ec..99d96a4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1950,7 +1950,7 @@ struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cp
 static struct intel_uncore_box *
 uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
 {
-	static struct intel_uncore_box *box;
+	struct intel_uncore_box *box;
 
 	box = *per_cpu_ptr(pmu->box, cpu);
 	if (box)
-- 
1.7.11.4

