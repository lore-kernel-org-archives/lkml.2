Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0JSRL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:11:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab0JSRLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:11:24 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=orbmIEd6FBIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=_KI8FHBTBClVQMh1aQoA:9 a=70W1dQL4S0VoNjgMiWRA4FC5pMoA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 13:11:22 -0400
Message-ID: <1287508282.16971.386.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (1):
      tracing: Fix compile issue for trace_sched_wakeup.c

----
 kernel/trace/trace_sched_wakeup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)
---------------------------
commit 7e40798f406fe73f9bac496a390daabd8768a8f7
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Oct 19 10:56:19 2010 -0400

    tracing: Fix compile issue for trace_sched_wakeup.c
    
    The function start_func_tracer() was incorrectly added in the
     #ifdef CONFIG_FUNCTION_TRACER condition, but is still used even
    when function tracing is not enabled.
    
    The calls to register_ftrace_function() and register_ftrace_graph()
    become nops (and their arguments are even ignored), thus there is
    no reason to hide start_func_tracer() when function tracing is
    not enabled.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 31689d2..7319559 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -130,6 +130,7 @@ static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = wakeup_tracer_call,
 };
+#endif /* CONFIG_FUNCTION_TRACER */
 
 static int start_func_tracer(int graph)
 {
@@ -159,8 +160,6 @@ static void stop_func_tracer(int graph)
 		unregister_ftrace_graph();
 }
 
-#endif /* CONFIG_FUNCTION_TRACER */
-
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
 {


