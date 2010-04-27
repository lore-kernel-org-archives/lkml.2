Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab0D0GzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 02:55:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0D0GzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 02:55:08 -0400
Date: Tue, 27 Apr 2010 08:54:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 4/4] tracing: graph output support for
 preemptirqsoff/preemptoff tracers
Message-ID: <20100427065451.GA1912@jolsa.lab.eng.brq.redhat.com>
References: <1270227683-14631-1-git-send-email-jolsa@redhat.com>
 <1270227683-14631-5-git-send-email-jolsa@redhat.com>
 <1272332143.9739.39.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272332143.9739.39.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 09:35:43PM -0400, Steven Rostedt wrote:
> On Fri, 2010-04-02 at 19:01 +0200, Jiri Olsa wrote:
> > hi,
> > 
> > adding support for graph output for preemptirqsoff/preemptoff tracers.
> > 
> 
> So far I like the series. But I'm confused why this patch is separate
> from patch 3. Is there some reason for it?
> 
> If not, I'll just merge this into patch 3

no particular reason, just wanted to separate the graph support
for single tracer... I have no problem with merging those 2

jirka

> 
> -- Steve
> 
> > wbr,
> > jirka
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/trace/trace_irqsoff.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> > index cc20d7c..6fd486e 100644
> > --- a/kernel/trace/trace_irqsoff.c
> > +++ b/kernel/trace/trace_irqsoff.c
> > @@ -672,9 +672,15 @@ static struct tracer preemptoff_tracer __read_mostly =
> >  	.start		= irqsoff_tracer_start,
> >  	.stop		= irqsoff_tracer_stop,
> >  	.print_max	= 1,
> > +	.print_header   = irqsoff_print_header,
> > +	.print_line     = irqsoff_print_line,
> > +	.flags		= &tracer_flags,
> > +	.set_flag	= irqsoff_set_flag,
> >  #ifdef CONFIG_FTRACE_SELFTEST
> >  	.selftest    = trace_selftest_startup_preemptoff,
> >  #endif
> > +	.open		= irqsoff_trace_open,
> > +	.close		= irqsoff_trace_close,
> >  };
> >  # define register_preemptoff(trace) register_tracer(&trace)
> >  #else
> > @@ -700,9 +706,15 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
> >  	.start		= irqsoff_tracer_start,
> >  	.stop		= irqsoff_tracer_stop,
> >  	.print_max	= 1,
> > +	.print_header   = irqsoff_print_header,
> > +	.print_line     = irqsoff_print_line,
> > +	.flags		= &tracer_flags,
> > +	.set_flag	= irqsoff_set_flag,
> >  #ifdef CONFIG_FTRACE_SELFTEST
> >  	.selftest    = trace_selftest_startup_preemptirqsoff,
> >  #endif
> > +	.open		= irqsoff_trace_open,
> > +	.close		= irqsoff_trace_close,
> >  };
> >  
> >  # define register_preemptirqsoff(trace) register_tracer(&trace)
> 
> 
