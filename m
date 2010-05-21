Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab0EURxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:53:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab0EURxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:53:04 -0400
X-Authority-Analysis: v=1.1 cv=APwCx09NCuKDvl2mjFwkKdJZScS8XOZHPgx3WG6BpL0= c=1 sm=0 a=7mmTDdiQ3XMA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=RlT1C3hwJo7kYmo02AEA:9 a=R7cB2Wr5SLNJuC9JWcBtkEcJjNgA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 01/10] perf, trace: Remove IRQ-disable from
 perf/tracepoint interaction
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <y0maartf8ve.fsf@fche.csb>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.419716197@chello.nl>  <y0maartf8ve.fsf@fche.csb>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 21 May 2010 13:53:00 -0400
Message-ID: <1274464380.26328.3992.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 13:43 -0400, Frank Ch. Eigler wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > [...]
> > @@ -799,13 +799,10 @@ perf_trace_templ_##call(struct ftrace_ev
> >  static notrace void perf_trace_##call(proto)				\
> >  {									\
> >  	struct ftrace_event_call *event_call = &event_##call;		\
> > -	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
> > -									\
> > -	perf_fetch_caller_regs(__regs, 1);				\
> > -									\
> > -	perf_trace_templ_##template(event_call, __regs, args);		\
> > +	struct pt_regs __regs;						\
> >  									\
> > -	put_cpu_var(perf_trace_regs);					\
> > +	perf_fetch_caller_regs(&__regs, 1);				\
> > +	perf_trace_templ_##template(event_call, &__regs, args);		\
> >  }
> >  [...]
> 
> To what extent are you worried about something the size of struct
> pt_regs being auto/stack allocated?

Isn't pt_regs already allocated on the stack when interrupted?

-- Steve


