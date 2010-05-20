Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab0ETUMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:12:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63497 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab0ETUMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:12:10 -0400
X-Authority-Analysis: v=1.1 cv=DB4JU8ZWelvwd5d0x20oybKyR86uyiSly0XbcMdosrc= c=1 sm=0 a=jOljwp8wn3oA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=t4mOimeOipRyIYD7-ykA:9 a=LAkGQQhj-2CmETDmaNwA:7 a=xBf6GO3f5f4ThTwDQPq3gtUIPCgA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFD] Future tracing/instrumentation directions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <1274366318.26328.2292.camel@gandalf.stny.rr.com>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
	 <20100520093131.GA30929@elte.hu>
	 <1274366318.26328.2292.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 20 May 2010 16:12:04 -0400
Message-ID: <1274386324.26328.2660.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 10:38 -0400, Steven Rostedt wrote:
> On Thu, 2010-05-20 at 11:31 +0200, Ingo Molnar wrote:

> # modprobe ring_buffer_benchmark producer_fifo=10
> # sleep 30
> # cat /debug/tracing/trace
> 
> 
>            <...>-2636  [003]   761.969850: ring_buffer_producer_thread: Starting ring buffer hammer
>            <...>-2636  [003]   771.910121: ring_buffer_producer_thread: End ring buffer hammer
>            <...>-2636  [003]   771.910172: ring_buffer_producer_thread: Running Consumer at nice: 19
>            <...>-2636  [003]   771.910172: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
>            <...>-2636  [003]   771.910173: ring_buffer_producer_thread: Time:     9965321 (usecs)
>            <...>-2636  [003]   771.910173: ring_buffer_producer_thread: Overruns: 0
>            <...>-2636  [003]   771.910174: ring_buffer_producer_thread: Read:     76580325  (by pages)
>            <...>-2636  [003]   771.910175: ring_buffer_producer_thread: Entries:  75
>            <...>-2636  [003]   771.910175: ring_buffer_producer_thread: Total:    76580400
>            <...>-2636  [003]   771.910175: ring_buffer_producer_thread: Missed:   0
>            <...>-2636  [003]   771.910176: ring_buffer_producer_thread: Hit:      76580400
>            <...>-2636  [003]   771.910176: ring_buffer_producer_thread: Entries per millisec: 7684
>            <...>-2636  [003]   771.910176: ring_buffer_producer_thread: 130 ns per entry
>            <...>-2636  [003]   771.910177: ring_buffer_producer_thread: Sleeping for 10 secs
> 
>            <...>-2636  [003]   781.884686: ring_buffer_producer_thread: Starting ring buffer hammer
>            <...>-2636  [003]   790.862392: ring_buffer_producer_thread: End ring buffer hammer
>            <...>-2636  [003]   790.897399: ring_buffer_producer_thread: Running Consumer at nice: 19
>            <...>-2636  [003]   790.897400: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
>            <...>-2636  [003]   790.897401: ring_buffer_producer_thread: Time:     9000321 (usecs)
>            <...>-2636  [003]   790.897401: ring_buffer_producer_thread: Overruns: 26581200
>            <...>-2636  [003]   790.897402: ring_buffer_producer_thread: Read:     6767200  (by events)
>            <...>-2636  [003]   790.897403: ring_buffer_producer_thread: Entries:  0
>            <...>-2636  [003]   790.897403: ring_buffer_producer_thread: Total:    33348400
>            <...>-2636  [003]   790.897403: ring_buffer_producer_thread: Missed:   0
>            <...>-2636  [003]   790.897404: ring_buffer_producer_thread: Hit:      33348400
>            <...>-2636  [003]   790.897404: ring_buffer_producer_thread: Entries per millisec: 3705
>            <...>-2636  [003]   790.897405: ring_buffer_producer_thread: 269 ns per entry
> 
> While having the reader read by pages (splice mode) a write takes 130ns
> per entry. Not that bad.
> 
> But when the reader is reading each event, (I'm assuming we get some
> cache line bouncing here, it is still lockless), a write takes 269ns.
> 
> Note, the reader is an aggressive reader. That is, it goes into a strong
> loop and just reads as fast as it can. Which would cause cache line
> bouncing.
> 
> When I disable the reader and just measure what a write takes:
> 
> # rmmod ring_buffer_benchmark
> # modprobe ring_buffer_benchmark disable_reader=1 producer_fifo=10
> # sleep 30
> # cat /debug/tracing/trace
> 
>            <...>-2649  [003]  1141.981639: ring_buffer_producer_thread: Starting ring buffer hammer
>            <...>-2649  [003]  1151.950840: ring_buffer_producer_thread: End ring buffer hammer
>            <...>-2649  [003]  1151.950841: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
>            <...>-2649  [003]  1151.950842: ring_buffer_producer_thread: Time:     9994238 (usecs)
>            <...>-2649  [003]  1151.950842: ring_buffer_producer_thread: Overruns: 90635670
>            <...>-2649  [003]  1151.950843: ring_buffer_producer_thread: Read:     (reader disabled)
>            <...>-2649  [003]  1151.950843: ring_buffer_producer_thread: Entries:  62480
>            <...>-2649  [003]  1151.950844: ring_buffer_producer_thread: Total:    90698150
>            <...>-2649  [003]  1151.950844: ring_buffer_producer_thread: Missed:   0
>            <...>-2649  [003]  1151.950844: ring_buffer_producer_thread: Hit:      90698150
>            <...>-2649  [003]  1151.950845: ring_buffer_producer_thread: Entries per millisec: 9075
>            <...>-2649  [003]  1151.950845: ring_buffer_producer_thread: 110 ns per entry
>            <...>-2649  [003]  1151.950846: ring_buffer_producer_thread: Sleeping for 10 secs
> 
> It takes just a 110ns.

I checked out latest tip/perf/core with commit:

commit dfacc4d6c98b89609250269f518c1f54c30454ef
Merge: f869097 85cb68b
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu May 20 14:38:55 2010 +0200

    Merge branch 'perf/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing into perf/core

This seems to include the latest optimizations from Peter.

I decided to modify the trace/kernel/ring_buffer_benchmark.c to
benchmark the perf ring buffer. I spent an hour or so trying to get it
to work but since the perf ring buffer is so coupled with perf, I gave
up in trying to test it directly. It requires a reader, and it has no
good way to set up a buffer and read it from the kernel.

So instead, I figured I would test perf and ftrace with TRACE_EVENT().

Here's what I did, and my changes are at the bottom of this email as a
patch too.

I created a function within the kernel proper (since the benchmark is a
module) called ring_buffer_benchmark_caller(). All this does is call:

trace_rb_benchmark(raw_smp_processor_id());

Where trace_rb_benchmark is created with TRACE_EVENT() (as shown in the
patch below).

I modified the ring buffer benchmark to take a "trace_event" parameter
where instead of testing the ring buffer itself, it would just time the
calling of "ring_buffer_benchmark_caller()", which includes the trace
event.

This is nice way to see the difference between perf and ftrace since
this is the code that they both use.

Note, I noticed that the ring buffer slowed down since 2.6.34. Probably
to do with the "lost events" recording that I added. But it went from
110ns to 153ns in the normal benchmark (not this one).

Anyway, the benchmark would pause until the tracepoint was activated, as
the tracepoint would enable rb_start_bench. When the tracepoint is
called the first time, the benchmark would begin.

Here's what I did:

# modprobe ring_buffer_benchmark producer_fifo=10 trace_event=1
# perf record -e rb_bench:rb_benchmark -c1 -a sleep 30
# cat /debug/tracing/trace

Here's the results:

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-22836 [001]  2804.849264: : wait to start
           <...>-22836 [001]  2816.419909: : starting
           <...>-22836 [001]  2816.419911: : Starting ring buffer hammer
           <...>-22836 [002]  2826.056105: : End ring buffer hammer
           <...>-22836 [002]  2826.056108: : Running Producer at SCHED_FIFO 10
           <...>-22836 [002]  2826.056109: : Time:     9660458 (usecs)
           <...>-22836 [002]  2826.056110: : Overruns: 0
           <...>-22836 [002]  2826.056110: : Read:     (reader disabled)
           <...>-22836 [002]  2826.056111: : Entries:  0
           <...>-22836 [002]  2826.056111: : Total:    0
           <...>-22836 [002]  2826.056112: : Missed:   0
           <...>-22836 [002]  2826.056112: : Hit:      14637150
           <...>-22836 [002]  2826.056113: : Entries per millisec: 1515
           <...>-22836 [002]  2826.056113: : 660 ns per entry
           <...>-22836 [002]  2826.056114: : Sleeping for 10 secs
           <...>-22836 [002]  2836.030464: : wait to start
           <...>-22836 [002]  2836.030465: : starting
           <...>-22836 [002]  2836.030465: : Starting ring buffer hammer
           <...>-22836 [001]  2845.008379: : End ring buffer hammer
           <...>-22836 [001]  2845.008383: : Running Producer at SCHED_FIFO 10
           <...>-22836 [001]  2845.008384: : Time:     9000518 (usecs)
           <...>-22836 [001]  2845.008384: : Overruns: 0
           <...>-22836 [001]  2845.008384: : Read:     (reader disabled)
           <...>-22836 [001]  2845.008385: : Entries:  0
           <...>-22836 [001]  2845.008385: : Total:    0
           <...>-22836 [001]  2845.008386: : Missed:   0
           <...>-22836 [001]  2845.008387: : Hit:      13642200
           <...>-22836 [001]  2845.008387: : Entries per millisec: 1515
           <...>-22836 [001]  2845.008388: : 660 ns per entry

Writing an event in perf took 660ns each.


To do the same for ftrace, I first had to set a filter. This is because
the events for ftrace write to the same place the ring buffer benchmark
is writing its output, and I would have to search through thousands of
called events to see the output. But since filtering is actually
expensive, it should still give us a basic idea.

# modprobe ring_buffer_benchmark producer_fifo=10 trace_event=1
# echo mydata == 10 > /debug/tracing/events/rb_bench/rb_benchmark/filter
# echo 1 > /debug/tracing/events/rb_bench/rb_benchmark/enable
# cat /debug/tracing/trace

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
     rb_producer-22849 [000]  3015.236994: ring_buffer_producer_thread: wait to start
     rb_producer-22849 [000]  3032.193995: ring_buffer_producer_thread: starting
     rb_producer-22849 [000]  3032.193996: ring_buffer_producer_thread: Starting ring buffer hammer
     rb_producer-22849 [000]  3041.513072: ring_buffer_producer_thread: End ring buffer hammer
     rb_producer-22849 [000]  3041.513073: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
     rb_producer-22849 [000]  3041.513074: ring_buffer_producer_thread: Time:     9342579 (usecs)
     rb_producer-22849 [000]  3041.513074: ring_buffer_producer_thread: Overruns: 0
     rb_producer-22849 [000]  3041.513075: ring_buffer_producer_thread: Read:     (reader disabled)
     rb_producer-22849 [000]  3041.513075: ring_buffer_producer_thread: Entries:  0
     rb_producer-22849 [000]  3041.513076: ring_buffer_producer_thread: Total:    0
     rb_producer-22849 [000]  3041.513076: ring_buffer_producer_thread: Missed:   0
     rb_producer-22849 [000]  3041.513077: ring_buffer_producer_thread: Hit:      51588000
     rb_producer-22849 [000]  3041.513077: ring_buffer_producer_thread: Entries per millisec: 5522
     rb_producer-22849 [000]  3041.513078: ring_buffer_producer_thread: 181 ns per entry
     rb_producer-22849 [000]  3041.513078: ring_buffer_producer_thread: Sleeping for 10 secs
     rb_producer-22849 [000]  3051.487356: ring_buffer_producer_thread: wait to start
     rb_producer-22849 [000]  3051.487356: ring_buffer_producer_thread: starting
     rb_producer-22849 [000]  3051.487357: ring_buffer_producer_thread: Starting ring buffer hammer
     rb_producer-22849 [000]  3060.465270: ring_buffer_producer_thread: End ring buffer hammer
     rb_producer-22849 [000]  3060.465271: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
     rb_producer-22849 [000]  3060.465272: ring_buffer_producer_thread: Time:     9000562 (usecs)
     rb_producer-22849 [000]  3060.465272: ring_buffer_producer_thread: Overruns: 0
     rb_producer-22849 [000]  3060.465272: ring_buffer_producer_thread: Read:     (reader disabled)
     rb_producer-22849 [000]  3060.465273: ring_buffer_producer_thread: Entries:  0
     rb_producer-22849 [000]  3060.465273: ring_buffer_producer_thread: Total:    0
     rb_producer-22849 [000]  3060.465274: ring_buffer_producer_thread: Missed:   0
     rb_producer-22849 [000]  3060.465274: ring_buffer_producer_thread: Hit:      49675400
     rb_producer-22849 [000]  3060.465275: ring_buffer_producer_thread: Entries per millisec: 5519
     rb_producer-22849 [000]  3060.465275: ring_buffer_producer_thread: 181 ns per entry

Note, enabling an event in ftrace enables the comm line record, which
shows the "rb_producer".


Here we see each event took 181ns as called by TRACE_EVENT() and then
discarded.

But since I'm discarding the events this may be giving ftrace an unfair
advantage. Thus, I modified the ring buffer benchmark code as follows:

#undef trace_printk
#define trace_printk(fmt, args...) printk(fmt, ##args)

This makes the ring buffer benchmark write to the console instead of the
ring buffer, and lets me run without filtering.

# modprobe ring_buffer_benchmark producer_fifo=10 trace_event=1
# echo 0 > /debug/tracing/events/rb_bench/rb_benchmark/filter
# echo 1 > /debug/tracing/events/rb_bench/rb_benchmark/enable

I got this:

wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9972749 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      57079200
Entries per millisec: 5723
174 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9972786 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      57086350
Entries per millisec: 5724
174 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9972772 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      57058250
Entries per millisec: 5721
174 ns per entry
Sleeping for 10 secs

The non-filtering case (the one that actually records) was 174ns per event.


Here's the patch:

-- Steve

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index ffb1a5b..3b559d3 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -21,10 +21,12 @@ endif
 #
 obj-y += trace_clock.o
 
+CFLAGS_ring_buffer_bm_event.o += -I$(src)
+
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
-
+obj-y += ring_buffer_bm_event.o
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_stat.o
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 302f8a6..9d5cdb1 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -4,12 +4,23 @@
  * Copyright (C) 2009 Steven Rostedt <srostedt@redhat.com>
  */
 #include <linux/ring_buffer.h>
+#include <linux/ftrace_event.h>
 #include <linux/completion.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/time.h>
 #include <asm/local.h>
 
+#include "ring_buffer_bm_event.h"
+
+/* Write the strings directly into the buffers. */
+#undef trace_printk
+#define trace_printk(fmt, args...)					\
+do {									\
+	__trace_printk_check_format(fmt, ##args);			\
+	__trace_printk(_THIS_IP_, fmt, ##args);				\
+} while (0)
+
 struct rb_page {
 	u64		ts;
 	local_t		commit;
@@ -32,6 +43,10 @@ static struct task_struct *producer;
 static struct task_struct *consumer;
 static unsigned long read;
 
+static int trace_event;
+module_param(trace_event, uint, 0644);
+MODULE_PARM_DESC(trace_event, "record a trace event");
+
 static int disable_reader;
 module_param(disable_reader, uint, 0644);
 MODULE_PARM_DESC(disable_reader, "only run producer");
@@ -211,6 +226,50 @@ static void ring_buffer_consumer(void)
 	complete(&read_done);
 }
 
+static inline int ring_buffer_write_trace_event(void)
+{
+	ring_buffer_benchmark_caller();
+	return 0;
+}
+
+static inline int ring_buffer_write_rb_event(void)
+{
+	struct ring_buffer_event *event;
+	int *entry;
+
+	event = ring_buffer_lock_reserve(buffer, 10);
+	if (!event)
+		return -1;
+
+	entry = ring_buffer_event_data(event);
+	*entry = smp_processor_id();
+	ring_buffer_unlock_commit(buffer, event);
+
+	return 0;
+}
+
+static inline int ring_buffer_write_event(void)
+{
+	if (trace_event)
+		return ring_buffer_write_trace_event();
+	else
+		return ring_buffer_write_rb_event();
+}
+
+static int wait_to_start(void)
+{
+	while (!rb_start_bench) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_stop())
+			break;
+		schedule_timeout(HZ/10);
+		ring_buffer_benchmark_caller();
+	}
+	__set_current_state(TASK_RUNNING);
+
+	return kthread_should_stop();
+}
+
 static void ring_buffer_producer(void)
 {
 	struct timeval start_tv;
@@ -223,6 +282,13 @@ static void ring_buffer_producer(void)
 	unsigned long avg;
 	int cnt = 0;
 
+	if (trace_event) {
+		trace_printk("wait to start\n");
+		if (wait_to_start())
+			return;
+		trace_printk("starting\n");
+	}
+
 	/*
 	 * Hammer the buffer for 10 secs (this may
 	 * make the system stall)
@@ -230,20 +296,13 @@ static void ring_buffer_producer(void)
 	trace_printk("Starting ring buffer hammer\n");
 	do_gettimeofday(&start_tv);
 	do {
-		struct ring_buffer_event *event;
-		int *entry;
 		int i;
 
 		for (i = 0; i < write_iteration; i++) {
-			event = ring_buffer_lock_reserve(buffer, 10);
-			if (!event) {
+			if (ring_buffer_write_event() < 0)
 				missed++;
-			} else {
+			else
 				hit++;
-				entry = ring_buffer_event_data(event);
-				*entry = smp_processor_id();
-				ring_buffer_unlock_commit(buffer, event);
-			}
 		}
 		do_gettimeofday(&end_tv);
 
@@ -425,6 +484,12 @@ static int __init ring_buffer_benchmark_init(void)
 	if (!buffer)
 		return -ENOMEM;
 
+	/* The reader is userspace */
+	if (trace_event) {
+		disable_reader = 1;
+		rb_start_bench = 0;
+	}
+
 	if (!disable_reader) {
 		consumer = kthread_create(ring_buffer_consumer_thread,
 					  NULL, "rb_consumer");
diff --git a/kernel/trace/ring_buffer_bm_event.c b/kernel/trace/ring_buffer_bm_event.c
new file mode 100644
index 0000000..862e80c
--- /dev/null
+++ b/kernel/trace/ring_buffer_bm_event.c
@@ -0,0 +1,13 @@
+#include <linux/module.h>
+
+#define CREATE_TRACE_POINTS
+#include "ring_buffer_bm_event.h"
+
+int rb_start_bench;
+EXPORT_SYMBOL(rb_start_bench);
+
+void ring_buffer_benchmark_caller(void)
+{
+	trace_rb_benchmark(raw_smp_processor_id());
+}
+EXPORT_SYMBOL(ring_buffer_benchmark_caller);
diff --git a/kernel/trace/ring_buffer_bm_event.h b/kernel/trace/ring_buffer_bm_event.h
new file mode 100644
index 0000000..a167c6d
--- /dev/null
+++ b/kernel/trace/ring_buffer_bm_event.h
@@ -0,0 +1,38 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rb_bench
+
+#if !defined(_TRACE_RB_BENCHMARK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RB_BENCHMARK_H
+
+#include <linux/tracepoint.h>
+
+extern int rb_start_bench;
+void ring_buffer_benchmark_caller(void);
+
+TRACE_EVENT(rb_benchmark,
+
+	TP_PROTO(int mydata),
+
+	TP_ARGS(mydata),
+
+	TP_STRUCT__entry(
+		__field(	int,	mydata			)
+	),
+
+	TP_fast_assign(
+		rb_start_bench = 1;
+		__entry->mydata = mydata;
+	),
+
+	TP_printk("data=%d", __entry->mydata)
+);
+
+#endif /* _TRACE_RB_BENCHMARK_H */
+
+#undef TRACE_INCLUDE_FILE
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE ring_buffer_bm_event
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>






