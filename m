Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1GAMpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:45:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab1GAMpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:45:04 -0400
Date: Fri, 1 Jul 2011 14:44:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 00/16 v2] [GIT PULL] tracing: various fixes
Message-ID: <20110701124455.GD12605@elte.hu>
References: <20110615134841.767565350@goodmis.org>
 <20110616140050.GA4822@elte.hu>
 <1309290496.26417.16.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309290496.26417.16.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2011-06-16 at 16:00 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Ingo,
> > > 
> > > I went through the patches and addressed your comments. I fixed the line
> > > break issues (no need to have the original author resubmit for whitespace
> > > clean ups), and I fixed the change logs that had the whacky tags caused
> > > by my script.
> > > 
> > > I replaced the one patch by Vaibhav that added the ioctl with the original
> > > patch he sent that adds the free_buffer file to do the same thing. I also
> > > added a patch to make it optional whether or not freeing the buffer disables
> > > tracing.
> > > 
> > > Please pull the latest tip/perf/core-2 tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > tip/perf/core-2
> > > 
> > > Head SHA1: 1fd8df2c3970c9e7e4e262354154ee39e58bdd7c
> > > 
> > > 
> > > Jiri Olsa (5):
> > >       tracing, function_graph: Remove dependency of abstime and duration fields on latency
> > >       tracing, function_graph: Merge overhead and duration display functions
> > >       tracing, function: Fix trace header to follow context-info option
> > >       tracing, function_graph: Remove lock-depth from latency trace
> > >       tracing, function_graph: Add context-info support for function_graph tracer
> > > 
> > > Masami Hiramatsu (3):
> > >       x86: Swap save_stack_trace_regs parameters
> > >       stack_trace: Add weak save_stack_trace_regs()
> > >       tracing/kprobes: Fix kprobe-tracer to support stack trace
> > > 
> > > Paul McQuade (2):
> > >       ftrace: Fixed an include coding style issue
> > >       async: Fixed an include coding style issue
> > > 
> > > Peter Huewe (1):
> > >       tracing: Convert to kstrtoul_from_user
> > > 
> > > Steven Rostedt (1):
> > >       tracing: Add disable_on_free option
> > > 
> > > Vaibhav Nagarnaik (4):
> > >       tracing: Schedule a delayed work to call wakeup()
> > >       tracing: Use NUMA allocation for per-cpu ring buffer pages
> > >       tracing: Add a proc file to stop tracing and free buffer
> > >       ring-buffer: Set __GFP_NORETRY flag for ring buffer allocating process
> > > 
> > > ----
> > >  arch/x86/kernel/stacktrace.c         |    2 +-
> > >  arch/x86/mm/kmemcheck/error.c        |    2 +-
> > >  include/linux/ftrace_event.h         |    4 +
> > >  include/linux/ring_buffer.h          |    2 +-
> > >  include/linux/stacktrace.h           |    4 +-
> > >  kernel/async.c                       |   12 +-
> > >  kernel/stacktrace.c                  |   12 ++-
> > >  kernel/trace/ftrace.c                |   20 +---
> > >  kernel/trace/ring_buffer.c           |   66 +++++----
> > >  kernel/trace/ring_buffer_benchmark.c |    2 +-
> > >  kernel/trace/trace.c                 |  242 ++++++++++++++++++---------------
> > >  kernel/trace/trace.h                 |   10 ++
> > >  kernel/trace/trace_events.c          |   26 +---
> > >  kernel/trace/trace_functions_graph.c |  223 +++++++++++++++----------------
> > >  kernel/trace/trace_irqsoff.c         |    4 +-
> > >  kernel/trace/trace_kprobe.c          |    6 +-
> > >  kernel/trace/trace_sched_wakeup.c    |    4 +-
> > >  kernel/trace/trace_stack.c           |   13 +--
> > >  18 files changed, 333 insertions(+), 321 deletions(-)
> > 
> > Pulled, thanks a lot Steve!
> > 
> 
> Hi Ingo,
> 
> Was there an issue with this pull request? I don't see it in tip. I 
> was about to add a fix for Thomas and noticed that this pull wasn't 
> in.

Hm, the problem appears to be that your tip/perf/core-2 branch is on 
0ef5bf1cd3bd - which does not match the bits you advertised in:

    Head SHA1: 1fd8df2c3970c9e7e4e262354154ee39e58bdd7c

Thanks,

	Ingo
