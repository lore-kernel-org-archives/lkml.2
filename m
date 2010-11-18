Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0KRMOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:14:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab0KRMOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:14:16 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=AvpIYEOr2ZAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=jnR3hxDqDRGRDv3j-v4A:9 a=GP4KNBvfEBGc3QOLUkHjB5pPedUA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
 directory
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>
In-Reply-To: <20101118120626.GB27474@Krystal>
References: <20101118035803.453609353@goodmis.org>
	 <1290076866.2109.1305.camel@laptop>
	 <1290081203.30543.96.camel@gandalf.stny.rr.com>
	 <20101118120626.GB27474@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Nov 2010 07:14:14 -0500
Message-ID: <1290082454.30543.98.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 07:06 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Thu, 2010-11-18 at 11:41 +0100, Peter Zijlstra wrote:
> > > On Wed, 2010-11-17 at 22:58 -0500, Steven Rostedt wrote:
> > > > For example, I added a trace_printk() in kernel/sched.c at line 2180
> > > > and it creates:
> > > > 
> > > > # ls /debug/tracing/events/printk/kernel/sched.c/2180/
> > > > enable  format
> > > > 
> > > > The format is the printk format:
> > > > 
> > > > # cat /debug/tracing/events/printk/kernel/sched.c/2180/format 
> > > > "migrate task %s:%d"
> > > 
> > > *groan*, so you're creating a tracepoint per instance?
> > > 
> > > That's going to be massive pain for perf.. I really don't see the point
> > > in splitting all that out.
> > 
> > a) The file directory was what was asked about in the referenced email.
> > b) This is just an example of a way to display it to the user, which
> > seems to be very intuitive.
> > c) Perf can implement the details anyway it wants. It can make a single
> > tracepoint callback and have the enabling of the points as a special
> > filter.
> > d) This was just an RFC that Frederic asked if I would do. I thought it
> > would be a fun challenge and did it. Let it bit rot in hell for all I
> > care, I wasn't taking it any further anyway.
> 
> Hi Steven,
> 
> The LTTng tree still keeps the "trace_mark()" kernel markers, which are
> very very similar to ftrace_printk(). I'd be happy to combine the two
> eventually. This one file per line approach seems very good -- rather than
> explicitely naming each instance, as I did in trace_mark(), you end up
> automatically naming them by file/line number.
> 
> How does this behave from within static inlines called multiple times and
> unrolled loops ?

Actually you mean macros:

You'll get a 2181-1, 2181-2, 2181-3, etc.

Although a trace_printk() in a header static inline may be interesting.

-- Steve


