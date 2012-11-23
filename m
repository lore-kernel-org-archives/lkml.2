Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2KWQ1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:27:38 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:48692 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2KWQ1h convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 23 Nov 2012 11:27:37 -0500
Message-Id: <50AFB24002000078000AAE8A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 23 Nov 2012 16:28:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/perf_events: build fix
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least some older gcc versions dislike mixing constant and non-const
data in the same section ("... causes a section type confict"). Newer
gcc simply emits the section as writable (which isn't what we want, but
also is not a big problem as it gets discarded post-init anyway).

Also get the Knight's Corner definitions in sync.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/cpu/perf_event_knc.c |    4 ++--
 arch/x86/kernel/cpu/perf_event_p6.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- 3.7-rc6/arch/x86/kernel/cpu/perf_event_knc.c
+++ 3.7-rc6-x86-perf-initconst/arch/x86/kernel/cpu/perf_event_knc.c
@@ -17,7 +17,7 @@ static const u64 knc_perfmon_event_map[]
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
 };
 
-static __initconst u64 knc_hw_cache_event_ids
+static const u64 __initconst knc_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -284,7 +284,7 @@ static struct attribute *intel_knc_forma
 	NULL,
 };
 
-static __initconst struct x86_pmu knc_pmu = {
+static const struct x86_pmu knc_pmu __initconst = {
 	.name			= "knc",
 	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
--- 3.7-rc6/arch/x86/kernel/cpu/perf_event_p6.c
+++ 3.7-rc6-x86-perf-initconst/arch/x86/kernel/cpu/perf_event_p6.c
@@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[]
 
 };
 
-static __initconst u64 p6_hw_cache_event_ids
+static const u64 __initconst p6_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =



