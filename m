Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2BHKFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:05:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61138 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2BHKFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:05:51 -0500
From: Geunsik Lim <geunsik.lim@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: sched_switch plugin is deprecated.
Date: Wed,  8 Feb 2012 19:05:36 +0900
Message-Id: <1328695537-15081-1-git-send-email-geunsik.lim@gmail.com>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

Actually, sched_switch function tracer is merged into wakeup/wakeup_rt
Update 'mini-HOWTO' for ftrace(Kernel function tracer).
If we want to trace "sched:sched_switch" to trace sched_switch func,
We may utilize event option.(e.g: trace-cmd list -e | grep sched)
This patch is based on Linux-3.3.rc2-SMP-PREEMPT

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 kernel/trace/trace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3f1bc5..10d5503 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2764,12 +2764,12 @@ static const char readme_msg[] =
 	"tracing mini-HOWTO:\n\n"
 	"# mount -t debugfs nodev /sys/kernel/debug\n\n"
 	"# cat /sys/kernel/debug/tracing/available_tracers\n"
-	"wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop\n\n"
+	"wakeup wakeup_rt preemptirqsoff preemptoff irqsoff function nop\n\n"
 	"# cat /sys/kernel/debug/tracing/current_tracer\n"
 	"nop\n"
-	"# echo sched_switch > /sys/kernel/debug/tracing/current_tracer\n"
+	"# echo wakeup > /sys/kernel/debug/tracing/current_tracer\n"
 	"# cat /sys/kernel/debug/tracing/current_tracer\n"
-	"sched_switch\n"
+	"wakeup\n"
 	"# cat /sys/kernel/debug/tracing/trace_options\n"
 	"noprint-parent nosym-offset nosym-addr noverbose\n"
 	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
-- 
1.7.8.1

