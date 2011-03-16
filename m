Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1CPN6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:58:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:35857 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab1CPN55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:57:57 -0400
Date: Wed, 16 Mar 2011 13:57:27 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1299684089-22835-2-git-send-email-ming.m.lin@intel.com>
References: <1299684089-22835-2-git-send-email-ming.m.lin@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Clean up SandyBridge PEBS events
Message-ID: <tip-eefaaac46470d105f58cff93c8176cfadc75b857@git.kernel.org>
Git-Commit-ID: eefaaac46470d105f58cff93c8176cfadc75b857
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:57:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eefaaac46470d105f58cff93c8176cfadc75b857
Gitweb:     http://git.kernel.org/tip/eefaaac46470d105f58cff93c8176cfadc75b857
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Wed, 9 Mar 2011 23:21:28 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:04:12 +0100

perf, x86: Clean up SandyBridge PEBS events

Use INTEL_EVENT_CONSTRAINT() for the events where all umasks support PEBS.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1299684089-22835-2-git-send-email-ming.m.lin@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   27 +++++----------------------
 1 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b95c66a..b72687f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -412,20 +412,9 @@ static struct event_constraint intel_snb_pebs_events[] = {
 	PEBS_EVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	PEBS_EVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
 	PEBS_EVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-	PEBS_EVENT_CONSTRAINT(0x01c4, 0xf), /* BR_INST_RETIRED.CONDITIONAL */
-	PEBS_EVENT_CONSTRAINT(0x02c4, 0xf), /* BR_INST_RETIRED.NEAR_CALL */
-	PEBS_EVENT_CONSTRAINT(0x04c4, 0xf), /* BR_INST_RETIRED.ALL_BRANCHES */
-	PEBS_EVENT_CONSTRAINT(0x08c4, 0xf), /* BR_INST_RETIRED.NEAR_RETURN */
-	PEBS_EVENT_CONSTRAINT(0x10c4, 0xf), /* BR_INST_RETIRED.NOT_TAKEN */
-	PEBS_EVENT_CONSTRAINT(0x20c4, 0xf), /* BR_INST_RETIRED.NEAR_TAKEN */
-	PEBS_EVENT_CONSTRAINT(0x40c4, 0xf), /* BR_INST_RETIRED.FAR_BRANCH */
-	PEBS_EVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
-	PEBS_EVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
-	PEBS_EVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
-	PEBS_EVENT_CONSTRAINT(0x10c5, 0xf), /* BR_MISP_RETIRED.NOT_TAKEN */
-	PEBS_EVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.TAKEN */
-	PEBS_EVENT_CONSTRAINT(0x01cd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
-	PEBS_EVENT_CONSTRAINT(0x02cd, 0x8), /* MEM_TRANS_RETIRED.PRECISE_STORE */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),  /* BR_MISP_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),  /* MEM_TRANS_RETIRED.* */
 	PEBS_EVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_LOADS */
 	PEBS_EVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_STORES */
 	PEBS_EVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOP_RETIRED.LOCK_LOADS */
@@ -434,14 +423,8 @@ static struct event_constraint intel_snb_pebs_events[] = {
 	PEBS_EVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_STORES */
 	PEBS_EVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOP_RETIRED.ANY_LOADS */
 	PEBS_EVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOP_RETIRED.ANY_STORES */
-	PEBS_EVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
-	PEBS_EVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
-	PEBS_EVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.LLC_HIT */
-	PEBS_EVENT_CONSTRAINT(0x40d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
-	PEBS_EVENT_CONSTRAINT(0x01d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
-	PEBS_EVENT_CONSTRAINT(0x02d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
-	PEBS_EVENT_CONSTRAINT(0x04d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HITM */
-	PEBS_EVENT_CONSTRAINT(0x08d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_NONE */
+	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),  /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),  /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
 	PEBS_EVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
 	EVENT_CONSTRAINT_END
 };
