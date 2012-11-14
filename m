Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2KNGoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:44:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2KNGn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:43:58 -0500
Date: Tue, 13 Nov 2012 22:43:44 -0800
From: tip-bot for Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Message-ID: <tip-f43c738bfa8608424610e4fc1aef4d4644e2ce11@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, hiraku.toyooka.gu@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hiraku.toyooka.gu@hitachi.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20121002082710.9807.86393.stgit@falsita>
References: <20121002082710.9807.86393.stgit@falsita>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Change tracer's integer flags to bool
Git-Commit-ID: f43c738bfa8608424610e4fc1aef4d4644e2ce11
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:43:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f43c738bfa8608424610e4fc1aef4d4644e2ce11
Gitweb:     http://git.kernel.org/tip/f43c738bfa8608424610e4fc1aef4d4644e2ce11
Author:     Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
AuthorDate: Tue, 2 Oct 2012 17:27:10 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 31 Oct 2012 16:45:25 -0400

tracing: Change tracer's integer flags to bool

print_max and use_max_tr in struct tracer are "int" variables and
used like flags. This is wasteful, so change the type to "bool".

Link: http://lkml.kernel.org/r/20121002082710.9807.86393.stgit@falsita

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h              |    4 ++--
 kernel/trace/trace_irqsoff.c      |   12 ++++++------
 kernel/trace/trace_sched_wakeup.c |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c15f528..c56a233 100644
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
index 11edebd..5ffce7b 100644
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
index 2f6af78..bc64fc1 100644
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
