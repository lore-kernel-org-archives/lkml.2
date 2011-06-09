Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1FIR3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:29:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46085 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1FIR3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:29:12 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=hqgLC0vJG1YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=BsXpPUFP6QU5Lt3JaBUA:9 a=6HHXDmYqISTgbg_c3KEA:7 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110609172744.333794089@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:27:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/15] [GIT PULL] tracing: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Most of these are updates for tracing with one exception:

The patch by Paul McQuade that updates async, which I told Arjan
that I would be fine in pulling.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core

Head SHA1: 2560176dcb6d776115ef5615dac4f566fb8de129


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

Vaibhav Nagarnaik (4):
      tracing: Schedule a delayed work to call wakeup()
      tracing: Use NUMA allocation for per-cpu ring buffer pages
      tracing: Add a free on close control mechanism for buffer_size_kb
      ring-buffer: Set __GFP_NORETRY flag for ring buffer allocating process

----
 arch/x86/kernel/stacktrace.c         |    2 +-
 arch/x86/mm/kmemcheck/error.c        |    2 +-
 include/linux/ftrace.h               |    3 +
 include/linux/ftrace_event.h         |    4 +
 include/linux/ring_buffer.h          |    2 +-
 include/linux/stacktrace.h           |    4 +-
 kernel/async.c                       |   12 +-
 kernel/stacktrace.c                  |   13 ++-
 kernel/trace/ftrace.c                |   20 +--
 kernel/trace/ring_buffer.c           |   68 +++++----
 kernel/trace/ring_buffer_benchmark.c |    2 +-
 kernel/trace/trace.c                 |  272 ++++++++++++++++++++--------------
 kernel/trace/trace.h                 |    9 +
 kernel/trace/trace_events.c          |   26 +---
 kernel/trace/trace_functions_graph.c |  223 ++++++++++++++--------------
 kernel/trace/trace_irqsoff.c         |    4 +-
 kernel/trace/trace_kprobe.c          |    6 +-
 kernel/trace/trace_sched_wakeup.c    |    4 +-
 kernel/trace/trace_stack.c           |   13 +--
 19 files changed, 369 insertions(+), 320 deletions(-)
