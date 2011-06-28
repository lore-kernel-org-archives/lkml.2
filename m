Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1F1TsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:48:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1F1TsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:48:19 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=d-8w2qbBBTkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=RCX_K2eM31QDpUA67AkA:9 a=1_isnZN5hSK4UoIEI2MA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 00/16 v2] [GIT PULL] tracing: various fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
In-Reply-To: <20110616140050.GA4822@elte.hu>
References: <20110615134841.767565350@goodmis.org>
	 <20110616140050.GA4822@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 28 Jun 2011 15:48:16 -0400
Message-ID: <1309290496.26417.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 16:00 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > I went through the patches and addressed your comments. I fixed the line
> > break issues (no need to have the original author resubmit for whitespace
> > clean ups), and I fixed the change logs that had the whacky tags caused
> > by my script.
> > 
> > I replaced the one patch by Vaibhav that added the ioctl with the original
> > patch he sent that adds the free_buffer file to do the same thing. I also
> > added a patch to make it optional whether or not freeing the buffer disables
> > tracing.
> > 
> > Please pull the latest tip/perf/core-2 tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/perf/core-2
> > 
> > Head SHA1: 1fd8df2c3970c9e7e4e262354154ee39e58bdd7c
> > 
> > 
> > Jiri Olsa (5):
> >       tracing, function_graph: Remove dependency of abstime and duration fields on latency
> >       tracing, function_graph: Merge overhead and duration display functions
> >       tracing, function: Fix trace header to follow context-info option
> >       tracing, function_graph: Remove lock-depth from latency trace
> >       tracing, function_graph: Add context-info support for function_graph tracer
> > 
> > Masami Hiramatsu (3):
> >       x86: Swap save_stack_trace_regs parameters
> >       stack_trace: Add weak save_stack_trace_regs()
> >       tracing/kprobes: Fix kprobe-tracer to support stack trace
> > 
> > Paul McQuade (2):
> >       ftrace: Fixed an include coding style issue
> >       async: Fixed an include coding style issue
> > 
> > Peter Huewe (1):
> >       tracing: Convert to kstrtoul_from_user
> > 
> > Steven Rostedt (1):
> >       tracing: Add disable_on_free option
> > 
> > Vaibhav Nagarnaik (4):
> >       tracing: Schedule a delayed work to call wakeup()
> >       tracing: Use NUMA allocation for per-cpu ring buffer pages
> >       tracing: Add a proc file to stop tracing and free buffer
> >       ring-buffer: Set __GFP_NORETRY flag for ring buffer allocating process
> > 
> > ----
> >  arch/x86/kernel/stacktrace.c         |    2 +-
> >  arch/x86/mm/kmemcheck/error.c        |    2 +-
> >  include/linux/ftrace_event.h         |    4 +
> >  include/linux/ring_buffer.h          |    2 +-
> >  include/linux/stacktrace.h           |    4 +-
> >  kernel/async.c                       |   12 +-
> >  kernel/stacktrace.c                  |   12 ++-
> >  kernel/trace/ftrace.c                |   20 +---
> >  kernel/trace/ring_buffer.c           |   66 +++++----
> >  kernel/trace/ring_buffer_benchmark.c |    2 +-
> >  kernel/trace/trace.c                 |  242 ++++++++++++++++++---------------
> >  kernel/trace/trace.h                 |   10 ++
> >  kernel/trace/trace_events.c          |   26 +---
> >  kernel/trace/trace_functions_graph.c |  223 +++++++++++++++----------------
> >  kernel/trace/trace_irqsoff.c         |    4 +-
> >  kernel/trace/trace_kprobe.c          |    6 +-
> >  kernel/trace/trace_sched_wakeup.c    |    4 +-
> >  kernel/trace/trace_stack.c           |   13 +--
> >  18 files changed, 333 insertions(+), 321 deletions(-)
> 
> Pulled, thanks a lot Steve!
> 

Hi Ingo,

Was there an issue with this pull request? I don't see it in tip. I was
about to add a fix for Thomas and noticed that this pull wasn't in.

Thanks,

-- Steve


