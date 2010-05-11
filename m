Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab0EKUO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:14:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43595 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0EKUOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:14:54 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=5sH3s8HGSoAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=-QAX7fqwHxs1iD0xHTYA:9 a=oxYwB29kg5CcHwT__LEA:7 a=mkP7VyLuk5dhtMVc12DwFgY5yrIA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 00/10] [GIT PULL] tracing: Lowering the footprint of
 TRACE_EVENTs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100511182022.826921702@goodmis.org>
References: <20100511182022.826921702@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 11 May 2010 16:14:51 -0400
Message-ID: <1273608891.27703.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 14:20 -0400, Steven Rostedt wrote:
> [ Final version! ]
> 
> Ingo,

> 
> Please pull the latest tip/tracing/core tree, which can be found at:

Ingo,

Hold on, this breaks a few places on a allyesconfig. I missed some
places that use the register_trace_* and this changes the API.

I'll have another patch set later tonight.

-- Steve

> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Mathieu Desnoyers (1):
>       tracepoints: Add check trace callback type
> 
> Steven Rostedt (9):
>       tracing: Create class struct for events
>       tracing: Let tracepoints have data passed to tracepoint callbacks
>       tracing: Remove per event trace registering
>       tracing: Move fields from event to class structure
>       tracing: Move raw_init from events to class
>       tracing: Allow events to share their print functions
>       tracing: Move print functions into event class
>       tracing: Remove duplicate id information in event structure
>       tracing: Combine event filter_active and enable into single flags field
> 
> ----
>  include/linux/ftrace_event.h                   |   73 ++++++--
>  include/linux/syscalls.h                       |   57 ++----
>  include/linux/tracepoint.h                     |   98 ++++++++---
>  include/trace/ftrace.h                         |  233 +++++++++---------------
>  include/trace/syscall.h                        |   10 +-
>  kernel/trace/blktrace.c                        |  138 ++++++++------
>  kernel/trace/ftrace.c                          |    7 +-
>  kernel/trace/kmemtrace.c                       |   70 +++++---
>  kernel/trace/trace.c                           |    9 +-
>  kernel/trace/trace.h                           |    5 +-
>  kernel/trace/trace_event_perf.c                |   17 ++-
>  kernel/trace/trace_events.c                    |  131 +++++++++-----
>  kernel/trace/trace_events_filter.c             |   28 ++--
>  kernel/trace/trace_export.c                    |   16 +-
>  kernel/trace/trace_functions_graph.c           |   13 +-
>  kernel/trace/trace_kprobe.c                    |  104 +++++++----
>  kernel/trace/trace_output.c                    |  137 ++++++++++-----
>  kernel/trace/trace_output.h                    |    2 +-
>  kernel/trace/trace_sched_switch.c              |   23 ++-
>  kernel/trace/trace_sched_wakeup.c              |   27 ++--
>  kernel/trace/trace_syscalls.c                  |  137 ++++++++++++---
>  kernel/trace/trace_workqueue.c                 |   26 ++-
>  kernel/tracepoint.c                            |   91 +++++----
>  samples/tracepoints/tp-samples-trace.h         |    4 +-
>  samples/tracepoints/tracepoint-probe-sample.c  |   13 +-
>  samples/tracepoints/tracepoint-probe-sample2.c |    7 +-
>  26 files changed, 879 insertions(+), 597 deletions(-)


