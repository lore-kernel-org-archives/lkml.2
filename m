Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab0JIAq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:46:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44524 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759981Ab0JIAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:46:26 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/7] perf: New helper function for pmu name
Date: Sat,  9 Oct 2010 01:46:17 +0100
Message-Id: <a72a7968f5e3f64a26875457a7451b34f896f5ae.1286584677.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce perf_pmu_name() helper function that returns the name of the
pmu. This gives us a generic way to get the name of a pmu regardless of
how an architecture identifies it internally.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 arch/sh/kernel/perf_event.c |    9 +++++++++
 include/linux/perf_event.h  |    1 +
 kernel/perf_event.c         |    5 +++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 2cb9ad5..55fe89b 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -59,6 +59,15 @@ static inline int sh_pmu_initialized(void)
 	return !!sh_pmu;
 }
 
+const char *perf_pmu_name(void)
+{
+	if (!sh_pmu)
+		return NULL;
+
+	return sh_pmu->name;
+}
+EXPORT_SYMBOL_GPL(perf_pmu_name);
+
 int perf_num_counters(void)
 {
 	if (!sh_pmu)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1a02192..33f08da 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -850,6 +850,7 @@ extern int perf_max_events;
 extern const struct pmu *hw_perf_event_init(struct perf_event *event);
 
 extern int perf_num_counters(void);
+extern const char *perf_pmu_name(void);
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
 extern void perf_event_task_tick(struct task_struct *task);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index db5b560..fc51268 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -85,6 +85,11 @@ void __weak hw_perf_enable(void)		{ barrier(); }
 
 void __weak perf_event_print_debug(void)	{ }
 
+extern __weak const char *perf_pmu_name(void)
+{
+	return "pmu";
+}
+
 static DEFINE_PER_CPU(int, perf_disable_count);
 
 void perf_disable(void)
-- 
1.7.1

