Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0GIXhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:37:24 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59632 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669Ab0GIXhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:37:23 -0400
Message-Id: <20100709225817.140563299@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 18:57:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 10/20] Trace clock - build standalone
References: <20100709225727.312232266@efficios.com>
Content-Disposition: inline; filename=trace-clock-build-standalone.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  9 Jul 2010 22:58:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the trace clock without CONFIG_TRACING enabled is useful for the ring
buffer library sample client.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/Makefile            |    1 +
 kernel/trace/Kconfig       |    3 +++
 kernel/trace/trace_clock.c |    3 +++
 3 files changed, 7 insertions(+)

Index: linux.trees.git/kernel/trace/trace_clock.c
===================================================================
--- linux.trees.git.orig/kernel/trace/trace_clock.c	2010-06-28 08:15:25.000000000 -0400
+++ linux.trees.git/kernel/trace/trace_clock.c	2010-06-28 08:32:08.000000000 -0400
@@ -44,6 +44,7 @@ u64 notrace trace_clock_local(void)
 
 	return clock;
 }
+EXPORT_SYMBOL_GPL(trace_clock_local);
 
 /*
  * trace_clock(): 'inbetween' trace clock. Not completely serialized,
@@ -57,6 +58,7 @@ u64 notrace trace_clock(void)
 {
 	return local_clock();
 }
+EXPORT_SYMBOL_GPL(trace_clock);
 
 
 /*
@@ -113,3 +115,4 @@ u64 notrace trace_clock_global(void)
 
 	return now;
 }
+EXPORT_SYMBOL_GPL(trace_clock_global);
Index: linux.trees.git/kernel/trace/Kconfig
===================================================================
--- linux.trees.git.orig/kernel/trace/Kconfig	2010-06-28 08:15:25.000000000 -0400
+++ linux.trees.git/kernel/trace/Kconfig	2010-06-28 08:31:35.000000000 -0400
@@ -73,6 +73,9 @@ config RING_BUFFER_ALLOW_SWAP
 	 Allow the use of ring_buffer_swap_cpu.
 	 Adds a very slight overhead to tracing when enabled.
 
+config TRACE_CLOCK_STANDALONE
+	bool
+
 # All tracer options should select GENERIC_TRACER. For those options that are
 # enabled by all tracers (context switch and event tracer) they select TRACING.
 # This allows those options to appear when no other tracer is selected. But the
Index: linux.trees.git/kernel/Makefile
===================================================================
--- linux.trees.git.orig/kernel/Makefile	2010-06-28 08:15:25.000000000 -0400
+++ linux.trees.git/kernel/Makefile	2010-06-28 08:15:25.000000000 -0400
@@ -98,6 +98,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
+obj-$(CONFIG_TRACE_CLOCK_STANDALONE) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 obj-$(CONFIG_SLOW_WORK_DEBUG) += slow-work-debugfs.o

