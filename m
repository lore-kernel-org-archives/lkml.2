Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0KRMGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:06:30 -0500
Received: from mail.openrapids.net ([64.15.138.104]:39980 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750917Ab0KRMG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:06:29 -0500
Date: Thu, 18 Nov 2010 07:06:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
	directory
Message-ID: <20101118120626.GB27474@Krystal>
References: <20101118035803.453609353@goodmis.org> <1290076866.2109.1305.camel@laptop> <1290081203.30543.96.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290081203.30543.96.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:01:55 up 56 days, 16:04,  1 user,  load average: 1.21, 1.27,
	1.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-11-18 at 11:41 +0100, Peter Zijlstra wrote:
> > On Wed, 2010-11-17 at 22:58 -0500, Steven Rostedt wrote:
> > > For example, I added a trace_printk() in kernel/sched.c at line 2180
> > > and it creates:
> > > 
> > > # ls /debug/tracing/events/printk/kernel/sched.c/2180/
> > > enable  format
> > > 
> > > The format is the printk format:
> > > 
> > > # cat /debug/tracing/events/printk/kernel/sched.c/2180/format 
> > > "migrate task %s:%d"
> > 
> > *groan*, so you're creating a tracepoint per instance?
> > 
> > That's going to be massive pain for perf.. I really don't see the point
> > in splitting all that out.
> 
> a) The file directory was what was asked about in the referenced email.
> b) This is just an example of a way to display it to the user, which
> seems to be very intuitive.
> c) Perf can implement the details anyway it wants. It can make a single
> tracepoint callback and have the enabling of the points as a special
> filter.
> d) This was just an RFC that Frederic asked if I would do. I thought it
> would be a fun challenge and did it. Let it bit rot in hell for all I
> care, I wasn't taking it any further anyway.

Hi Steven,

The LTTng tree still keeps the "trace_mark()" kernel markers, which are
very very similar to ftrace_printk(). I'd be happy to combine the two
eventually. This one file per line approach seems very good -- rather than
explicitely naming each instance, as I did in trace_mark(), you end up
automatically naming them by file/line number.

How does this behave from within static inlines called multiple times and
unrolled loops ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
