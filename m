Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab0EGSos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:44:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:46596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969Ab0EGSom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:44:42 -0400
Date: Fri, 7 May 2010 18:43:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Remove PEBS SAMPLE_RAW support
Message-ID: <tip-1e9a6d8d44cb6dcd2799b36ceb23007e6a423bfe@git.kernel.org>
Git-Commit-ID: 1e9a6d8d44cb6dcd2799b36ceb23007e6a423bfe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:43:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e9a6d8d44cb6dcd2799b36ceb23007e6a423bfe
Gitweb:     http://git.kernel.org/tip/1e9a6d8d44cb6dcd2799b36ceb23007e6a423bfe
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 4 May 2010 16:30:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:31:01 +0200

perf, x86: Remove PEBS SAMPLE_RAW support

Its broken, we really should get PERF_SAMPLE_REGS sorted.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ec8b2e1..080b9b0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -459,7 +459,6 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	struct perf_event *event = cpuc->events[0]; /* PMC0 only */
 	struct pebs_record_core *at, *top;
 	struct perf_sample_data data;
-	struct perf_raw_record raw;
 	struct pt_regs regs;
 	int n;
 
@@ -499,12 +498,6 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
 
-	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
-		raw.size = x86_pmu.pebs_record_size;
-		raw.data = at;
-		data.raw = &raw;
-	}
-
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
 	 * does not contain a full regs set, specifically it seems to
@@ -536,7 +529,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	struct pebs_record_nhm *at, *top;
 	struct perf_sample_data data;
 	struct perf_event *event = NULL;
-	struct perf_raw_record raw;
 	struct pt_regs regs;
 	u64 status = 0;
 	int bit, n;
@@ -585,12 +577,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 		perf_sample_data_init(&data, 0);
 		data.period = event->hw.last_period;
 
-		if (event->attr.sample_type & PERF_SAMPLE_RAW) {
-			raw.size = x86_pmu.pebs_record_size;
-			raw.data = at;
-			data.raw = &raw;
-		}
-
 		/*
 		 * See the comment in intel_pmu_drain_pebs_core()
 		 */
