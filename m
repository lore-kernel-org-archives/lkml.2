Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0F2Im5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:42:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60776 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab0F2Imz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:42:55 -0400
Date: Tue, 29 Jun 2010 10:42:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/9] [GI PULL][2.6.36] tracing: various updates
Message-ID: <20100629084231.GC22344@elte.hu>
References: <20100629030836.222433712@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629030836.222433712@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I pushed some of these to you before, but you wanted to wait
> till after the merge window to pull them.
> 
> The last patch is the full fix for the perf kprobe regression. But
> since it was too big of a change for the -rc release we did
> a quick fix. This reverts that change back to the true fix for
> 2.6.36.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Chase Douglas (1):
>       tracing/function-graph: Use correct string size for snprintf
> 
> Li Zefan (7):
>       tracing: Use a global field list for all syscall exit events
>       tracing: Don't allocate common fields for every trace events
>       tracing: Convert some timer events to DEFINE_EVENT
>       tracing: Convert more sched events to DEFINE_EVENT
>       tracing: Remove test of NULL define_fields callback
>       tracing: Remove redundant raw_init callbacks
>       tracing: Remove open-coded __trace_add_event_call()
> 
> Steven Rostedt (1):
>       tracing: Use class->reg() for all registering of events
> 
> ----
>  include/linux/ftrace_event.h         |    3 +
>  include/linux/syscalls.h             |    2 -
>  include/trace/events/sched.h         |   32 +----
>  include/trace/events/timer.h         |   80 ++++------
>  include/trace/ftrace.h               |    2 +
>  include/trace/syscall.h              |    1 -
>  kernel/trace/trace.h                 |    2 +
>  kernel/trace/trace_event_perf.c      |   19 +--
>  kernel/trace/trace_events.c          |  264 +++++++++++++++++-----------------
>  kernel/trace/trace_events_filter.c   |   27 ++--
>  kernel/trace/trace_export.c          |    8 +-
>  kernel/trace/trace_functions_graph.c |    3 +-
>  kernel/trace/trace_kprobe.c          |   10 +--
>  kernel/trace/trace_syscalls.c        |    7 +-
>  14 files changed, 203 insertions(+), 257 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
