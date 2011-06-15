Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1FONzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:55:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab1FONwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:52:37 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=mT52HMQrpFwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=9zVdl7l8AJRjW2FqS_IA:9 a=Vc3hcS-xj-Igtsdc1FMA:7 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110615134841.767565350@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Jun 2011 09:48:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 00/16 v2] [GIT PULL] tracing: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I went through the patches and addressed your comments. I fixed the line
break issues (no need to have the original author resubmit for whitespace
clean ups), and I fixed the change logs that had the whacky tags caused
by my script.

I replaced the one patch by Vaibhav that added the ioctl with the original
patch he sent that adds the free_buffer file to do the same thing. I also
added a patch to make it optional whether or not freeing the buffer disables
tracing.

Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core-2

Head SHA1: 1fd8df2c3970c9e7e4e262354154ee39e58bdd7c


Jiri Olsa (5):
      tracing, function_graph: Remove dependency of abstime and duration fields on latency
      tracing, function_graph: Merge overhead and duration display functions
      tracing, function: Fix trace header to follow context-info option
      tracing, function_graph: Remove lock-depth from latency trace
      tracing, function_graph: Add context-info support for function_graph tracer

Masami Hiramatsu (3):
      x86: Swap save_stack_trace_regs parameters
      stack_trace: Add weak save_stack_trace_regs()
      tracing/kprobes: Fix kprobe-tracer to support stack trace

Paul McQuade (2):
      ftrace: Fixed an include coding style issue
      async: Fixed an include coding style issue

Peter Huewe (1):
      tracing: Convert to kstrtoul_from_user

Steven Rostedt (1):
      tracing: Add disable_on_free option

Vaibhav Nagarnaik (4):
      tracing: Schedule a delayed work to call wakeup()
      tracing: Use NUMA allocation for per-cpu ring buffer pages
      tracing: Add a proc file to stop tracing and free buffer
      ring-buffer: Set __GFP_NORETRY flag for ring buffer allocating process

----
 arch/x86/kernel/stacktrace.c         |    2 +-
 arch/x86/mm/kmemcheck/error.c        |    2 +-
 include/linux/ftrace_event.h         |    4 +
 include/linux/ring_buffer.h          |    2 +-
 include/linux/stacktrace.h           |    4 +-
 kernel/async.c                       |   12 +-
 kernel/stacktrace.c                  |   12 ++-
 kernel/trace/ftrace.c                |   20 +---
 kernel/trace/ring_buffer.c           |   66 +++++----
 kernel/trace/ring_buffer_benchmark.c |    2 +-
 kernel/trace/trace.c                 |  242 ++++++++++++++++++---------------
 kernel/trace/trace.h                 |   10 ++
 kernel/trace/trace_events.c          |   26 +---
 kernel/trace/trace_functions_graph.c |  223 +++++++++++++++----------------
 kernel/trace/trace_irqsoff.c         |    4 +-
 kernel/trace/trace_kprobe.c          |    6 +-
 kernel/trace/trace_sched_wakeup.c    |    4 +-
 kernel/trace/trace_stack.c           |   13 +--
 18 files changed, 333 insertions(+), 321 deletions(-)
