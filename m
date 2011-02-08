Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1BHWSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:18:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab1BHWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:22 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=HxXhnmNh8jIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=hJuKa39hO4uFmV2_r8UA:9 a=jlikheOgo2c3pb4zVawA:7 a=N2-TojdU-UEFUbBUb6WBTlw8bCIA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221721.132033349@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/10] tracing: Remove obsolete sched_switch tracer
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Remove-obsolete-sched_switch-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The trace events sched_switch and sched_wakeup do the same thing
as the stand alone sched_switch tracer does. It is no longer needed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt    |  110 -------------------------------------
 kernel/trace/trace_sched_switch.c |   48 ----------------
 2 files changed, 0 insertions(+), 158 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 557c1ed..65eddb7 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -202,10 +202,6 @@ Here is the list of current tracers that may be configured.
 	to draw a graph of function calls similar to C code
 	source.
 
-  "sched_switch"
-
-	Traces the context switches and wakeups between tasks.
-
   "irqsoff"
 
 	Traces the areas that disable interrupts and saves
@@ -273,39 +269,6 @@ format, the function name that was traced "path_put" and the
 parent function that called this function "path_walk". The
 timestamp is the time at which the function was entered.
 
-The sched_switch tracer also includes tracing of task wakeups
-and context switches.
-
-     ksoftirqd/1-7     [01]  1453.070013:      7:115:R   +  2916:115:S
-     ksoftirqd/1-7     [01]  1453.070013:      7:115:R   +    10:115:S
-     ksoftirqd/1-7     [01]  1453.070013:      7:115:R ==>    10:115:R
-        events/1-10    [01]  1453.070013:     10:115:S ==>  2916:115:R
-     kondemand/1-2916  [01]  1453.070013:   2916:115:S ==>     7:115:R
-     ksoftirqd/1-7     [01]  1453.070013:      7:115:S ==>     0:140:R
-
-Wake ups are represented by a "+" and the context switches are
-shown as "==>".  The format is:
-
- Context switches:
-
-       Previous task              Next Task
-
-  <pid>:<prio>:<state>  ==>  <pid>:<prio>:<state>
-
- Wake ups:
-
-       Current task               Task waking up
-
-  <pid>:<prio>:<state>    +  <pid>:<prio>:<state>
-
-The prio is the internal kernel priority, which is the inverse
-of the priority that is usually displayed by user-space tools.
-Zero represents the highest priority (99). Prio 100 starts the
-"nice" priorities with 100 being equal to nice -20 and 139 being
-nice 19. The prio "140" is reserved for the idle task which is
-the lowest priority thread (pid 0).
-
-
 Latency trace format
 --------------------
 
@@ -491,79 +454,6 @@ x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
                    latencies, as described in "Latency
                    trace format".
 
-sched_switch
-------------
-
-This tracer simply records schedule switches. Here is an example
-of how to use it.
-
- # echo sched_switch > current_tracer
- # echo 1 > tracing_enabled
- # sleep 1
- # echo 0 > tracing_enabled
- # cat trace
-
-# tracer: sched_switch
-#
-#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
-#              | |      |          |         |
-            bash-3997  [01]   240.132281:   3997:120:R   +  4055:120:R
-            bash-3997  [01]   240.132284:   3997:120:R ==>  4055:120:R
-           sleep-4055  [01]   240.132371:   4055:120:S ==>  3997:120:R
-            bash-3997  [01]   240.132454:   3997:120:R   +  4055:120:S
-            bash-3997  [01]   240.132457:   3997:120:R ==>  4055:120:R
-           sleep-4055  [01]   240.132460:   4055:120:D ==>  3997:120:R
-            bash-3997  [01]   240.132463:   3997:120:R   +  4055:120:D
-            bash-3997  [01]   240.132465:   3997:120:R ==>  4055:120:R
-          <idle>-0     [00]   240.132589:      0:140:R   +     4:115:S
-          <idle>-0     [00]   240.132591:      0:140:R ==>     4:115:R
-     ksoftirqd/0-4     [00]   240.132595:      4:115:S ==>     0:140:R
-          <idle>-0     [00]   240.132598:      0:140:R   +     4:115:S
-          <idle>-0     [00]   240.132599:      0:140:R ==>     4:115:R
-     ksoftirqd/0-4     [00]   240.132603:      4:115:S ==>     0:140:R
-           sleep-4055  [01]   240.133058:   4055:120:S ==>  3997:120:R
- [...]
-
-
-As we have discussed previously about this format, the header
-shows the name of the trace and points to the options. The
-"FUNCTION" is a misnomer since here it represents the wake ups
-and context switches.
-
-The sched_switch file only lists the wake ups (represented with
-'+') and context switches ('==>') with the previous task or
-current task first followed by the next task or task waking up.
-The format for both of these is PID:KERNEL-PRIO:TASK-STATE.
-Remember that the KERNEL-PRIO is the inverse of the actual
-priority with zero (0) being the highest priority and the nice
-values starting at 100 (nice -20). Below is a quick chart to map
-the kernel priority to user land priorities.
-
-   Kernel Space                     User Space
- ===============================================================
-   0(high) to  98(low)     user RT priority 99(high) to 1(low)
-                           with SCHED_RR or SCHED_FIFO
- ---------------------------------------------------------------
-  99                       sched_priority is not used in scheduling
-                           decisions(it must be specified as 0)
- ---------------------------------------------------------------
- 100(high) to 139(low)     user nice -20(high) to 19(low)
- ---------------------------------------------------------------
- 140                       idle task priority
- ---------------------------------------------------------------
-
-The task states are:
-
- R - running : wants to run, may not actually be running
- S - sleep   : process is waiting to be woken up (handles signals)
- D - disk sleep (uninterruptible sleep) : process must be woken up
-					(ignores signals)
- T - stopped : process suspended
- t - traced  : process is being traced (with something like gdb)
- Z - zombie  : process waiting to be cleaned up
- X - unknown
-
-
 ftrace_enabled
 --------------
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 8f758d0..7e62c0a 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -247,51 +247,3 @@ void tracing_sched_switch_assign_trace(struct trace_array *tr)
 	ctx_trace = tr;
 }
 
-static void stop_sched_trace(struct trace_array *tr)
-{
-	tracing_stop_sched_switch_record();
-}
-
-static int sched_switch_trace_init(struct trace_array *tr)
-{
-	ctx_trace = tr;
-	tracing_reset_online_cpus(tr);
-	tracing_start_sched_switch_record();
-	return 0;
-}
-
-static void sched_switch_trace_reset(struct trace_array *tr)
-{
-	if (sched_ref)
-		stop_sched_trace(tr);
-}
-
-static void sched_switch_trace_start(struct trace_array *tr)
-{
-	sched_stopped = 0;
-}
-
-static void sched_switch_trace_stop(struct trace_array *tr)
-{
-	sched_stopped = 1;
-}
-
-static struct tracer sched_switch_trace __read_mostly =
-{
-	.name		= "sched_switch",
-	.init		= sched_switch_trace_init,
-	.reset		= sched_switch_trace_reset,
-	.start		= sched_switch_trace_start,
-	.stop		= sched_switch_trace_stop,
-	.wait_pipe	= poll_wait_pipe,
-#ifdef CONFIG_FTRACE_SELFTEST
-	.selftest    = trace_selftest_startup_sched_switch,
-#endif
-};
-
-__init static int init_sched_switch_trace(void)
-{
-	return register_tracer(&sched_switch_trace);
-}
-device_initcall(init_sched_switch_trace);
-
-- 
1.7.2.3


