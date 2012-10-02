Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2JBX4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:56:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:19881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab2JBXs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:48:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="229791137"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/31] perf, x86: Support PERF_SAMPLE_ADDR on Haswell
Date: Tue,  2 Oct 2012 16:48:27 -0700
Message-Id: <1349221731-15665-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Haswell supplies the address for every PEBS memory event, so always fill it in
when the user requested it.  It will be 0 when not useful (no memory access)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 5d3d6be..8c893ce 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -637,6 +637,10 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		data.raw = &raw;
 	}
 
+	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
+		x86_pmu.intel_cap.pebs_format >= 2)
+		data.addr = ((struct pebs_record_v2 *)pebs)->nhm.dla;
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.7.7.6

