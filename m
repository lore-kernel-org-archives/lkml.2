Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab0FJLPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:15:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39160 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab0FJLKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:43 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: peterz@infradead.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [6/23] perf: Fix set but unused variables in perf
Message-Id: <20100610111042.02956B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just dead code I believe

Cc: peterz@infradead.org
Cc: mingo@elte.hu

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/perf_event.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6.35-rc2-gcc/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.35-rc2-gcc/arch/x86/kernel/cpu/perf_event.c
@@ -953,12 +953,9 @@ static void x86_pmu_enable_event(struct
 static int x86_pmu_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc;
 	int assign[X86_PMC_IDX_MAX];
 	int n, n0, ret;
 
-	hwc = &event->hw;
-
 	n0 = cpuc->n_events;
 	n = collect_events(cpuc, event, false);
 	if (n < 0)
@@ -1122,7 +1119,6 @@ static int x86_pmu_handle_irq(struct pt_
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
 	struct perf_event *event;
-	struct hw_perf_event *hwc;
 	int idx, handled = 0;
 	u64 val;
 
@@ -1135,7 +1131,6 @@ static int x86_pmu_handle_irq(struct pt_
 			continue;
 
 		event = cpuc->events[idx];
-		hwc = &event->hw;
 
 		val = x86_perf_event_update(event);
 		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
