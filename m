Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0GIIkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:40:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:52237 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab0GIIkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:40:12 -0400
Message-Id: <20100709083247.634986208@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 09 Jul 2010 10:21:18 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/13] perf, x86: Fix Nehalem PMU quirk
References: <20100709082117.631541128@chello.nl>
Content-Disposition: inline; filename=perf-x86-fix-nehalem-quirk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea was to run all three counters, which means we need to
program 7 into the enable mask, not 3 (which is two bits).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -504,7 +504,7 @@ static void intel_pmu_nhm_enable_all(int
 		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
 		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
 
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
+		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
 		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
 
 		for (i = 0; i < 3; i++) {


