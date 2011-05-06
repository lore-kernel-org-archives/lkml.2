Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1EFHlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:41:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:52882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab1EFHlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:41:15 -0400
Date: Fri, 6 May 2011 07:40:49 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Message-ID: <tip-e04d1b23f9706186187dcb0be1a752e48dcc540b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1304666042-17577-1-git-send-email-ming.m.lin@intel.com>
References: <1304666042-17577-1-git-send-email-ming.m.lin@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events, x86: Add SandyBridge stalled-cycles-frontend/backend events
Git-Commit-ID: e04d1b23f9706186187dcb0be1a752e48dcc540b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 May 2011 07:40:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e04d1b23f9706186187dcb0be1a752e48dcc540b
Gitweb:     http://git.kernel.org/tip/e04d1b23f9706186187dcb0be1a752e48dcc540b
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 6 May 2011 07:14:02 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 May 2011 09:37:03 +0200

perf events, x86: Add SandyBridge stalled-cycles-frontend/backend events

Extend the Intel SandyBridge PMU driver with definitions
for generic front-end and back-end stall events.

( As commit 3011203 "perf events, x86: Add Westmere stalled-cycles-frontend/backend
  events" says, these are only approximations. )

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1304666042-17577-1-git-send-email-ming.m.lin@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e61539b..7cf2ec5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1474,6 +1474,12 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+
+		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
+		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x18001b1;
+
 		pr_cont("SandyBridge events, ");
 		break;
 
