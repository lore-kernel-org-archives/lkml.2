Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab0EMWMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:12:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0EMWMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:12:49 -0400
X-Authority-Analysis: v=1.1 cv=PaD2Wv+9xJqXNP3J8apim3QBTBpXOuB+BaCFQon6buA= c=1 sm=0 a=QabcpGej5EAA:10 a=1CvaPgNKC-EA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=QUNvyC2rmemlsQ2Qs2gA:9 a=yoLJCItoOeU_qv0ZaXUA:7 a=sJ4SX9f5sXpMO5qnejQcG1oiMQEA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100513221004.765293881@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 May 2010 18:10:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/12 v2] [GIT PULL] tracing: shrinking trace events and updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I combined the last two pushes and rebased it to core-2.

I removed the sched patch until Carsten updates it with something
you approve, as well as the mmiotrace patch until Pekka gives
me an ack.

I also added a patch that caches pages in the ring buffer to speed
up the splice implementation.

Thanks,

-- Steve

Please pull the latest tip/tracing/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-2


Li Zefan (1):
      tracing: Fix function declarations if !CONFIG_STACKTRACE

Mathieu Desnoyers (1):
      tracepoints: Add check trace callback type

Steven Rostedt (10):
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

----
 include/linux/ftrace_event.h                   |   73 ++++++--
 include/linux/syscalls.h                       |   57 ++----
 include/linux/tracepoint.h                     |   98 ++++++++---
 include/trace/ftrace.h                         |  237 +++++++++---------------
 include/trace/syscall.h                        |   10 +-
 kernel/trace/blktrace.c                        |  138 ++++++++------
 kernel/trace/ftrace.c                          |    7 +-
 kernel/trace/kmemtrace.c                       |   70 +++++---
 kernel/trace/ring_buffer.c                     |   41 ++++-
 kernel/trace/trace.c                           |    9 +-
 kernel/trace/trace.h                           |    9 +-
 kernel/trace/trace_branch.c                    |    8 +-
 kernel/trace/trace_event_perf.c                |   17 ++-
 kernel/trace/trace_events.c                    |  137 +++++++++-----
 kernel/trace/trace_events_filter.c             |   28 ++--
 kernel/trace/trace_export.c                    |   16 +-
 kernel/trace/trace_functions_graph.c           |   13 +-
 kernel/trace/trace_kprobe.c                    |  104 +++++++----
 kernel/trace/trace_output.c                    |  137 +++++++++-----
 kernel/trace/trace_output.h                    |    2 +-
 kernel/trace/trace_sched_switch.c              |   23 ++-
 kernel/trace/trace_sched_wakeup.c              |   27 ++--
 kernel/trace/trace_syscalls.c                  |  137 ++++++++++++---
 kernel/trace/trace_workqueue.c                 |   26 ++-
 kernel/tracepoint.c                            |   91 +++++----
 net/core/drop_monitor.c                        |   12 +-
 samples/tracepoints/tp-samples-trace.h         |    4 +-
 samples/tracepoints/tracepoint-probe-sample.c  |   13 +-
 samples/tracepoints/tracepoint-probe-sample2.c |    7 +-
 29 files changed, 933 insertions(+), 618 deletions(-)
