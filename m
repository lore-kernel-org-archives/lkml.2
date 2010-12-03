Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0LCPiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:38:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab0LCPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:38:50 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=wnbCvAVmVDgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=G3ug3qkQDO10GKmIP28A:9 a=E7-TgCxWMPz8aXLKZEMA:7 a=N4iCPfUhPB-gmKB7O6Pj7Fxr_3cA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/2 v2] tracing: Add TRACE_EVENT_CONDITIONAL()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101203152733.GA25580@Krystal>
References: <20101203040358.955427199@goodmis.org>
	 <20101203040822.144348122@goodmis.org> <20101203045402.GA29609@Krystal>
	 <1291385344.3228.4.camel@gandalf.stny.rr.com>
	 <20101203152733.GA25580@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 10:38:47 -0500
Message-ID: <1291390727.3228.10.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 10:27 -0500, Mathieu Desnoyers wrote:

> > >   TP_CONDITION(unlikely(someparam)),
> > 
> > I actually think this is an abuse of "unlikely".
> 
> Why are you considering this an abuse ?

Because it is overused. I would rather get rid of most unlikely()'s
because they are mostly meaningless. Just run the unlikely profiler, and
you will see a large number of them are just plain incorrect.

Adding them here probably doesn't do any good. The only reason for this
TP_CONDITION() is to ignore those cases that it just does not make sense
to trace. Like a wake up tracepoint that does not wake anything up. No
need for "unlikely" or "likely", by trying to do that, you will most
likely get it wrong.

	unlikely(use_likely_correctly)


-- Steve


