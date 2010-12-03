Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab0LCOJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:09:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0LCOJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:09:07 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=wnbCvAVmVDgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=7d_E57ReAAAA:8 a=-XCUuMyHlfz9xJ10Rd8A:9 a=FeQ9XXDifW9PLQnoxV4A:7 a=YSz3QGRuFxp9MIZxMvvgL51jLdAA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=D6-X0JM3zdQA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/2 v2] tracing: Add TRACE_EVENT_CONDITIONAL()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101203045402.GA29609@Krystal>
References: <20101203040358.955427199@goodmis.org>
	 <20101203040822.144348122@goodmis.org>  <20101203045402.GA29609@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 09:09:04 -0500
Message-ID: <1291385344.3228.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 23:54 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> [...]
> > -#define __DO_TRACE(tp, proto, args)					\
> > +#define __DO_TRACE(tp, proto, args, cond)				\
> >  	do {								\
> >  		struct tracepoint_func *it_func_ptr;			\
> >  		void *it_func;						\
> >  		void *__data;						\
> >  									\
> > +		if (!(cond))						\
> 
> One small documentation-related detail: my guess is that you are leaving
> "cond" without likely/unlikely builtin expect purposefully so that we
> can write, in TP_CONDITION:
> 
>   TP_CONDITION(unlikely(someparam)),

I actually think this is an abuse of "unlikely".

> 
> when we expect the condition to be usually false (and likely() for the
> reverse). Maybe it could be worth documenting that expressions like the
> following are valid :
> 
>   TP_CONDITION((likely(param1) && unlikely(param2)) || likely(param3))
> 
> It's fair to assume that kernel developers know this already, but given
> we plan to re-use TRACE_EVENT() for the user-space tracer soon enough,
> documenting this kind of use-case now can save us the trouble in the
> future.

I would frown on someone using unlikely here. But a TRACE_EVENT()
belongs to the maintainer, not me.

> 
> Other than that,
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks!

-- Steve



