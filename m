Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0F2DKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:10:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0F2DKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:10:45 -0400
X-Authority-Analysis: v=1.1 cv=4GK1Slht3WUdSXXcSOu+TCe3GQnvEFDsQSvVHKX2gdo= c=1 sm=0 a=4Y6OtaccAHEA:10 a=hO-oPbc3tlwA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=RFCLwlB7kcZ11mCqTjYA:9 a=YT_W6jwjr1QNnl6R_RoA:7 a=cEZIwdn0rlut9cXDYW8FYLx6V28A:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100629030836.222433712@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 28 Jun 2010 23:08:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/9] [GI PULL][2.6.36] tracing: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I pushed some of these to you before, but you wanted to wait
till after the merge window to pull them.

The last patch is the full fix for the perf kprobe regression. But
since it was too big of a change for the -rc release we did
a quick fix. This reverts that change back to the true fix for
2.6.36.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Chase Douglas (1):
      tracing/function-graph: Use correct string size for snprintf

Li Zefan (7):
      tracing: Use a global field list for all syscall exit events
      tracing: Don't allocate common fields for every trace events
      tracing: Convert some timer events to DEFINE_EVENT
      tracing: Convert more sched events to DEFINE_EVENT
      tracing: Remove test of NULL define_fields callback
      tracing: Remove redundant raw_init callbacks
      tracing: Remove open-coded __trace_add_event_call()

Steven Rostedt (1):
      tracing: Use class->reg() for all registering of events

----
 include/linux/ftrace_event.h         |    3 +
 include/linux/syscalls.h             |    2 -
 include/trace/events/sched.h         |   32 +----
 include/trace/events/timer.h         |   80 ++++------
 include/trace/ftrace.h               |    2 +
 include/trace/syscall.h              |    1 -
 kernel/trace/trace.h                 |    2 +
 kernel/trace/trace_event_perf.c      |   19 +--
 kernel/trace/trace_events.c          |  264 +++++++++++++++++-----------------
 kernel/trace/trace_events_filter.c   |   27 ++--
 kernel/trace/trace_export.c          |    8 +-
 kernel/trace/trace_functions_graph.c |    3 +-
 kernel/trace/trace_kprobe.c          |   10 +--
 kernel/trace/trace_syscalls.c        |    7 +-
 14 files changed, 203 insertions(+), 257 deletions(-)
