Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0DOTyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 15:54:11 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:40285 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab0DOTyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pfbLmmyME3sYFwDMZGfuYnCNef/PzrhV4d05a/iCEvBYmHw7JhRJr4VCuqgsZqP/sU
         sPgaSmoicjoB7NCUnOIpeJumC9CresjmbNmVztBwP4XZ37kNkOcjgCMtKHPhQUtZgZJs
         F2Uer5JOuc0Q4hdiFQKtgSI2k9/JCO+FpD6Cs=
Date: Thu, 15 Apr 2010 21:50:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 3/4] tracing: graph output support for irqsoff tracer
Message-ID: <20100415195042.GD5069@nowhere>
References: <1270227683-14631-1-git-send-email-jolsa@redhat.com> <1270227683-14631-4-git-send-email-jolsa@redhat.com> <20100412233332.GH8285@nowhere> <20100414075052.GA2021@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414075052.GA2021@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 09:50:52AM +0200, Jiri Olsa wrote:
> On Tue, Apr 13, 2010 at 01:33:37AM +0200, Frederic Weisbecker wrote:
> > On Fri, Apr 02, 2010 at 07:01:22PM +0200, Jiri Olsa wrote:
> > > +#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_CPU | \
> > > +			    TRACE_GRAPH_PRINT_PROC)
> > > +
> > > +static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
> > > +{
> > > +	u32 flags = GRAPH_TRACER_FLAGS;
> > > +
> > > +	if (trace_flags & TRACE_ITER_LATENCY_FMT)
> > > +		flags |= TRACE_GRAPH_PRINT_DURATION;
> > > +	else
> > > +		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
> > 
> > 
> > 
> > Why not having ABS_TIME in any case?
> > 
> > And more important, you probably want to add TRACE_ITER_LATENCY_FMT
> > as well to get the contexts (need-resched, hardirq/softirq, preempt-depth,
> > lock-depth)
> 
> hi,
> 
> latency info
> 	The latency info is governed by global 'trace_flags', the graph tracers
> 	follows that as well.
> 


Doh, right.


 
> absolute time
> 	The idea was to follow the current irqsoff function trace format. Though
> 	it cannot be exatly the same, it can print the same info.
> 
> 	By default I added TRACE_GRAPH_PRINT_CPU and TRACE_GRAPH_PRINT_PROC,
> 	since they are always there for current irqsoff trace.
> 
> 	Then the absolute time is printed only in the case when the
> 	latency info is switched off.
> 
> 	AFAICS the 'time' field in the output (for latency enabled) actually
> 	represents the duration	(computed/printed in trace_print_lat_context function).
> 	Hence I added TRACE_GRAPH_PRINT_DURATION to graph output for the latency case.
> 
> 	So the answer to your question is, the absolute time is not part
> 	of the output, since it's not part of the original trace output.
> 	My opinion is the absolute time is not be that important
> 	for this tracer, the duration is.



I agree, I've actually made a confusion between both :)



> 
> 
> 	latency output OFF:
> 
> 		current tracer:
> 		TASK-PID    CPU#    TIMESTAMP FUNCTION
> 
> 
> 		graph tracer:
> 		TIME        CPU  TASK/PID                      FUNCTION CALLS
> 
> 
> 	latency output ON:
> 
> 		current tracer:
> 				_------=> CPU#
> 			       / _-----=> irqs-off
> 			      | / _----=> need-resched
> 			      || / _---=> hardirq/softirq
> 			      ||| / _--=> preempt-depth
> 			      |||| /_--=> lock-depth
> 			      |||||/       delay
> 		cmd     pid   |||||| time    |   caller
> 		   \\   /      ||||||   \\   |   /
> 
> 
> 
> 		graph tracer:
> 				      _-----=> irqs-off        
> 				     / _----=> need-resched    
> 				    | / _---=> hardirq/softirq 
> 				    || / _--=> preempt-depth   
> 				    ||| / _-=> lock-depth      
> 				    |||| /                     
> 		CPU  TASK/PID       |||||  DURATION                  FUNCTION CALLS
> 
> 
> 	Also the non-latency case covers the 'verbose' option output.
> 
> 
> 
> 
> thanks for your comments,
> hopefully I haven't missed anything.. ;)



And thanks for your work!

For me it's ok.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Steve?

