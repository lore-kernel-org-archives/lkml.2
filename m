Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab0ESH6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:58:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:45644 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0ESH6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:58:04 -0400
Date: Wed, 19 May 2010 07:57:24 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, gorcunov@openvz.org, rostedt@goodmis.org,
       peterz@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100518212439.167259349@openvz.org>
References: <20100518212439.167259349@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: P4_pmu_schedule_events -- use smp_processor_id instead of raw_
Message-ID: <tip-9d36dfcf219e2ba1f1d169a7f92dcf2cbd4e05f0@git.kernel.org>
Git-Commit-ID: 9d36dfcf219e2ba1f1d169a7f92dcf2cbd4e05f0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 07:57:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d36dfcf219e2ba1f1d169a7f92dcf2cbd4e05f0
Gitweb:     http://git.kernel.org/tip/9d36dfcf219e2ba1f1d169a7f92dcf2cbd4e05f0
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 19 May 2010 01:19:18 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 May 2010 09:41:05 +0200

perf, x86: P4_pmu_schedule_events -- use smp_processor_id instead of raw_

This snippet somehow escaped the commit:

 | commit 137351e0feeb9f25d99488ee1afc1c79f5499a9a
 | Author: Cyrill Gorcunov <gorcunov@openvz.org>
 | Date:   Sat May 8 15:25:52 2010 +0400
 |
 |    x86, perf: P4 PMU -- protect sensible procedures from preemption

so bring it eventually back. It helps to catch
preemption issue (if there will be, rule of thumb --
don't use raw_ if you can).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100518212439.167259349@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 5f8e36d..ae85d69 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -763,7 +763,7 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 {
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long escr_mask[BITS_TO_LONGS(P4_ESCR_MSR_TABLE_SIZE)];
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 	struct hw_perf_event *hwc;
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
