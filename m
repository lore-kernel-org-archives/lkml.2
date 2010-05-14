Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab0ENT3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:29:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab0ENT3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:29:16 -0400
X-Authority-Analysis: v=1.1 cv=QBaIlYAip0cLYvdi/Wu3On4+kilSXYulM+a9j4asJ0c= c=1 sm=0 a=rYPub9TUlLcA:10 a=1CvaPgNKC-EA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=3RiVMex5rkPO_lcfevoA:9 a=zzmn2xwpqLWshUrEZlYA:7 a=ofRwMP-Oj1yGKrpzWnoMgcLqQWoA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100514192246.079025623@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 May 2010 15:22:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 00/13 v3] [GIT PULL] tracing: shrinking trace events and updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

As you have found that there were conflicts with these patches and
the code in sched/core (the removal of the rq from the trace points)

I merged your sched/core branch into mine and applied the patches
on top, fixing the conflicts.

I added Frederic Weisbecker and Masami Hiramatsu acks.

I also tested this on my PPC64 box with PERF_EVENTS disabled and found
a compile bug. I fixed that too.

I also added a patch to document the use case of flags (filter_active)
and event_mutex. Since that variable is read without the mutex held,
but this is currently the case with filter_active as it stands today.
The code is made so it will not cause any problems but Mathieu
wanted it documented. I did so in the last patch.

Please pull the latest tip/tracing/core-4 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-4


Li Zefan (1):
      tracing: Fix function declarations if !CONFIG_STACKTRACE

Mathieu Desnoyers (1):
      tracepoints: Add check trace callback type

Steven Rostedt (11):
      tracing: Create class struct for events
      tracing: Let tracepoints have data passed to tracepoint callbacks
      tracing: Remove per event trace registering
      tracing: Move fields from event to class structure
      tracing: Move raw_init from events to class
      tracing: Allow events to share their print functions
      tracing: Move print functions into event class
      tracing: Remove duplicate id information in event structure
      tracing: Combine event filter_active and enable into single flags field
      ring-buffer: Add cached pages when freeing reader page
      tracing: Comment the use of event_mutex with trace event flags

----
 include/linux/ftrace_event.h                   |   80 +++++++--
 include/linux/syscalls.h                       |   57 ++----
 include/linux/tracepoint.h                     |   98 ++++++++---
 include/trace/ftrace.h                         |  237 +++++++++---------------
 include/trace/syscall.h                        |   10 +-
 kernel/trace/blktrace.c                        |  138 ++++++++------
 kernel/trace/ftrace.c                          |    7 +-
 kernel/trace/kmemtrace.c                       |   70 +++++---
 kernel/trace/ring_buffer.c                     |   52 +++++-
 kernel/trace/trace.c                           |    9 +-
 kernel/trace/trace.h                           |    9 +-
 kernel/trace/trace_branch.c                    |    8 +-
 kernel/trace/trace_event_perf.c                |   17 ++-
 kernel/trace/trace_events.c                    |  139 +++++++++-----
 kernel/trace/trace_events_filter.c             |   28 ++--
 kernel/trace/trace_export.c                    |   16 +-
 kernel/trace/trace_functions_graph.c           |   13 +-
 kernel/trace/trace_kprobe.c                    |  104 +++++++----
 kernel/trace/trace_output.c                    |  137 +++++++++-----
 kernel/trace/trace_output.h                    |    2 +-
 kernel/trace/trace_sched_switch.c              |   20 +-
 kernel/trace/trace_sched_wakeup.c              |   28 ++--
 kernel/trace/trace_syscalls.c                  |  137 ++++++++++++---
 kernel/trace/trace_workqueue.c                 |   26 ++-
 kernel/tracepoint.c                            |   91 +++++----
 net/core/drop_monitor.c                        |   12 +-
 samples/tracepoints/tp-samples-trace.h         |    4 +-
 samples/tracepoints/tracepoint-probe-sample.c  |   13 +-
 samples/tracepoints/tracepoint-probe-sample2.c |    7 +-
 29 files changed, 951 insertions(+), 618 deletions(-)
