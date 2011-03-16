Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1CPN6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:58:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:35876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab1CPN6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:58:11 -0400
Date: Wed, 16 Mar 2011 13:57:48 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1299684089-22835-3-git-send-email-ming.m.lin@intel.com>
References: <1299684089-22835-3-git-send-email-ming.m.lin@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Use INTEL_*_CONSTRAINT() for all PEBS event constraints
Message-ID: <tip-7d5d02dadd43db7f829775e404e82019c5d5586f@git.kernel.org>
Git-Commit-ID: 7d5d02dadd43db7f829775e404e82019c5d5586f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:57:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d5d02dadd43db7f829775e404e82019c5d5586f
Gitweb:     http://git.kernel.org/tip/7d5d02dadd43db7f829775e404e82019c5d5586f
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Wed, 9 Mar 2011 23:21:29 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:04:12 +0100

perf, x86: Use INTEL_*_CONSTRAINT() for all PEBS event constraints

PEBS_EVENT_CONSTRAINT() is just a duplicate of INTEL_UEVENT_CONSTRAINT().
Remove it and use INTEL_UEVENT_CONSTRAINT() instead.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1299684089-22835-3-git-send-email-ming.m.lin@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c          |    2 -
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   95 ++++++++++++++---------------
 2 files changed, 47 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2660418..e8dbe17 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -178,8 +178,6 @@ struct cpu_hw_events {
  */
 #define INTEL_UEVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
-#define PEBS_EVENT_CONSTRAINT(c, n)	\
-	INTEL_UEVENT_CONSTRAINT(c, n)
 
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b72687f..bab491b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -362,70 +362,69 @@ static int intel_pmu_drain_bts_buffer(void)
  * PEBS
  */
 static struct event_constraint intel_core2_pebs_event_constraints[] = {
-	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
-	PEBS_EVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),  /* MEM_LOAD_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	INTEL_UEVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
+	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
+	INTEL_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_atom_pebs_event_constraints[] = {
-	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),  /* MEM_LOAD_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_nehalem_pebs_event_constraints[] = {
-	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),  /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),  /* MEM_UNCORE_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INST_RETIRED.ANY */
-	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),  /* FP_ASSIST.* */
+	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INST_RETIRED.ANY */
+	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
+	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_westmere_pebs_event_constraints[] = {
-	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),  /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),  /* MEM_UNCORE_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INSTR_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
-
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),  /* BR_MISP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),  /* FP_ASSIST.* */
+	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INSTR_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_snb_pebs_events[] = {
-	PEBS_EVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-	PEBS_EVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-	PEBS_EVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),  /* BR_MISP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),  /* MEM_TRANS_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_LOADS */
-	PEBS_EVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_STORES */
-	PEBS_EVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOP_RETIRED.LOCK_LOADS */
-	PEBS_EVENT_CONSTRAINT(0x22d0, 0xf), /* MEM_UOP_RETIRED.LOCK_STORES */
-	PEBS_EVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_LOADS */
-	PEBS_EVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_STORES */
-	PEBS_EVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOP_RETIRED.ANY_LOADS */
-	PEBS_EVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOP_RETIRED.ANY_STORES */
-	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),  /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),  /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
+	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOP_RETIRED.LOCK_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x22d0, 0xf), /* MEM_UOP_RETIRED.LOCK_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOP_RETIRED.ANY_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOP_RETIRED.ANY_STORES */
+	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
 	EVENT_CONSTRAINT_END
 };
 
