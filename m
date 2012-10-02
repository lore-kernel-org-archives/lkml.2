Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2JBI04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:26:56 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37716 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab2JBI0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:26:54 -0400
X-Greylist: delayed 830 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2012 04:26:53 EDT
X-AuditID: b753bd60-97251ba000002f78-1a-506aa54b15c2
X-AuditID: b753bd60-97251ba000002f78-1a-506aa54b15c2
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH -tip  1/4] tracing: change tracer's integer flags to bool
To: linux-kernel@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Oct 2012 17:27:10 +0900
Message-ID: <20121002082710.9807.86393.stgit@falsita>
In-Reply-To: <20121002081309.8661.37629.stgit@falsita>
References: <20121002081309.8661.37629.stgit@falsita>
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

