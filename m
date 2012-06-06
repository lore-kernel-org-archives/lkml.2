Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2FFQAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:00:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab2FFQAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:00:47 -0400
Date: Wed, 6 Jun 2012 09:00:25 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-8440ccb43fc0ecffcf1acee0273d766e6a8cd51d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1338884803.28282.153.camel@twins>
References: <1338884803.28282.153.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Update SNB PEBS constraints
Git-Commit-ID: 8440ccb43fc0ecffcf1acee0273d766e6a8cd51d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:00:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8440ccb43fc0ecffcf1acee0273d766e6a8cd51d
Gitweb:     http://git.kernel.org/tip/8440ccb43fc0ecffcf1acee0273d766e6a8cd51d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 5 Jun 2012 10:26:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 16:59:52 +0200

perf/x86: Update SNB PEBS constraints

Afaict there's no need to (incompletely) iterate the
MEM_UOPS_RETIRED.* umask state.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1338884803.28282.153.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 5a3edc2..35e2192 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -400,14 +400,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOP_RETIRED.LOCK_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x22d0, 0xf), /* MEM_UOP_RETIRED.LOCK_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOP_RETIRED.ANY_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOP_RETIRED.ANY_STORES */
+	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
