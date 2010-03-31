Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0CaHhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0CaHhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:37:52 -0400
Date: Wed, 31 Mar 2010 09:37:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHv3 0/2] tracing: function graph output for
 preempt/irqs-off tracers
Message-ID: <20100331073738.GA2152@jolsa.lab.eng.brq.redhat.com>
References: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
 <1269615239.19685.78.camel@gandalf.stny.rr.com>
 <20100329111701.GC1715@jolsa>
 <1269875347.19685.4492.camel@gandalf.stny.rr.com>
 <20100329152154.GF1715@jolsa>
 <1269877299.19685.4527.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269877299.19685.4527.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 11:41:39AM -0400, Steven Rostedt wrote:
> On Mon, 2010-03-29 at 17:21 +0200, Jiri Olsa wrote:
> 
> > > Understand what I'm trying to ask?
> > 
> > ok, so what you mean is:
> > - dont clear the max_tr and 
> > - add function graph events.
> > 
> > So when the tracing_enabled and display-graph are disabled we will
> > get events output rather than 'unknown event' output... right?
> 
> Right, although when the display-graph is disabled, we lose the /* */
> but that's fine.

ok, I have it done, but found another issue..

It's the tracer_flags which governs the tracer output. As I'm using
the function_graph tracer output functions, they follow function_graph
tracer's flags settings..

My first idea was a change that would allow tracer using flags
of other tracers.. so, when enabling irqsoff tracer the function_graph
tracer's options would become available.

I made the patch but got to the set_flag function which can be overloaded
by tracer. So I'd need to remember the flags's tracer, and it does
not seem right.. :)

any ideas?

thanks,
jirka
