Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab0C2PJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:09:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58566 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab0C2PJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:09:14 -0400
X-Authority-Analysis: v=1.0 c=1 a=ANRBxz73AsgA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=oJ11r6Y4i9pf1Y8698gA:9 a=lwAiG-f0oxWrV6zDyi0A:7 a=Rgki_gqlnZad8aFoHXIUY0UXc58A:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv3 0/2] tracing: function graph output for
 preempt/irqs-off tracers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100329111701.GC1715@jolsa>
References: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
	 <1269615239.19685.78.camel@gandalf.stny.rr.com>
	 <20100329111701.GC1715@jolsa>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 29 Mar 2010 11:09:07 -0400
Message-ID: <1269875347.19685.4492.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 13:17 +0200, Jiri Olsa wrote:

> >  # echo 0 > /debug/tracing/tracing_enabled
> >  # echo 0 > /debug/tracing/option/display-graph
> >  # cat /debug/tracing/trace
> > 
> > # tracer: irqsoff
> > irqbalan-2672    0d..2.   55us+: Unknown type 13
> > irqbalan-2672    0d.h2.   62us+: Unknown type 13
> 
> I forgot the max_tr buffer is actually the one displayed,
> so it needs reset as well when the display-graph option
> is switched on/off.

No! That breaks the rules. It should still show the contents of the
buffer even if we disable the trace or option.


> > I think you can still do the "event" part, without effecting the way the
> > function graph outputs normally. I would not have given up on that
> > method.  You don't need to worry about it processing other events,
> > because when you register it to write as an event, it will only be
> > called when a function graph event was found. It will not be processing
> > other events. Only when the tracer itself overrides the default writing
> > will it do so.
> 
> The events would be called only for TRACE_GRAPH_RET, TRACE_GRAPH_ENT entries and
> not for others, thats right.
> 
> However it's the graph ouput code that outputs other events' text
> within "/*" and "*/".
> 
> So using the event way, all other events would be printed as normal
> events(standard lines not alligned) with the standard header...
> not like comments, as they are in the function_graph tracer.
> 
> I thought it'd be good for graph output to stay the same in irqsoff
> tracer as in function_graph tracer.. if that is not the concern
> the event way would be probably nicer :)

It is, but you missed my point.

> 
> I'm sending updated patchset with above 2 fixies right away,
> I can do/resend the event way later if needed.

What I'm saying is that we should have _both_!  The event way (when the
option is disabled) and the current way when it is not. That is, if the
option is enabled, then the function graph can report all the data the
way it was. If the option is disabled, don't reset it, but have an
"event" print of the trace as well.

Understand what I'm trying to ask?

-- Steve


