Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2JQC4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:56:31 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49446 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2JQC42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:56:28 -0400
X-AuditID: b753bd60-932c5ba0000047ca-f7-507e1e590d7a
X-AuditID: b753bd60-932c5ba0000047ca-f7-507e1e590d7a
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH v2 -tip  1/4] tracing: change tracer's integer flags to bool
To: rostedt@goodmis.org
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Oct 2012 11:56:13 +0900
Message-ID: <20121017025612.2627.57415.stgit@falsita>
In-Reply-To: <20121017025608.2627.87497.stgit@falsita>
References: <20121017025608.2627.87497.stgit@falsita>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_max and use_max_tr in struct tracer are "int" variables and
used like flags. This is wasteful, so change the type to "bool".

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---

 kernel/trace/trace.h              |    4 ++--
 kernel/trace/trace_irqsoff.c      |   12 ++++++------
 kernel/trace/trace_sched_wakeup.c |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 593debe..0eb6a1a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -285,8 +285,8 @@ struct tracer {
 	int			(*set_flag)(u32 old_flags, u32 bit, int set);
 	struct tracer		*next;
 	struct tracer_flags	*flags;
-	int			print_max;
-	int			use_max_tr;
+	bool			print_max;
+	bool			use_max_tr;
 };
 
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index d98ee82..5c823c1 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -604,7 +604,7 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.reset		= irqsoff_tracer_reset,
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
-	.print_max	= 1,
+	.print_max	= true,
 	.print_header   = irqsoff_print_header,
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
@@ -614,7 +614,7 @@ static struct tracer irqsoff_tracer __read_mostly =
 #endif
 	.open           = irqsoff_trace_open,
 	.close          = irqsoff_trace_close,
-	.use_max_tr	= 1,
+	.use_max_tr	= true,
 };
 # define register_irqsoff(trace) register_tracer(&trace)
 #else
@@ -637,7 +637,7 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.reset		= irqsoff_tracer_reset,
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
-	.print_max	= 1,
+	.print_max	= true,
 	.print_header   = irqsoff_print_header,
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
@@ -647,7 +647,7 @@ static struct tracer preemptoff_tracer __read_mostly =
 #endif
 	.open		= irqsoff_trace_open,
 	.close		= irqsoff_trace_close,
-	.use_max_tr	= 1,
+	.use_max_tr	= true,
 };
 # define register_preemptoff(trace) register_tracer(&trace)
 #else
@@ -672,7 +672,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.reset		= irqsoff_tracer_reset,
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
-	.print_max	= 1,
+	.print_max	= true,
 	.print_header   = irqsoff_print_header,
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
@@ -682,7 +682,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 #endif
 	.open		= irqsoff_trace_open,
 	.close		= irqsoff_trace_close,
-	.use_max_tr	= 1,
+	.use_max_tr	= true,
 };
 
 # define register_preemptirqsoff(trace) register_tracer(&trace)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 02170c0..43f8abc 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -589,7 +589,7 @@ static struct tracer wakeup_tracer __read_mostly =
 	.reset		= wakeup_tracer_reset,
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
-	.print_max	= 1,
+	.print_max	= true,
 	.print_header	= wakeup_print_header,
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
@@ -599,7 +599,7 @@ static struct tracer wakeup_tracer __read_mostly =
 #endif
 	.open		= wakeup_trace_open,
 	.close		= wakeup_trace_close,
-	.use_max_tr	= 1,
+	.use_max_tr	= true,
 };
 
 static struct tracer wakeup_rt_tracer __read_mostly =
@@ -610,7 +610,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
 	.wait_pipe	= poll_wait_pipe,
-	.print_max	= 1,
+	.print_max	= true,
 	.print_header	= wakeup_print_header,
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
@@ -620,7 +620,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 #endif
 	.open		= wakeup_trace_open,
 	.close		= wakeup_trace_close,
-	.use_max_tr	= 1,
+	.use_max_tr	= true,
 };
 
 __init static int init_wakeup_tracer(void)

