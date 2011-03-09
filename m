Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1CICbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:31:03 -0500
Received: from mail.openrapids.net ([64.15.138.104]:54853 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754348Ab1CICbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:31:00 -0500
Date: Tue, 8 Mar 2011 21:30:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
Message-ID: <20110309023057.GA15055@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com> <20110308232258.GA25987@Krystal> <1299627175.20306.96.camel@gandalf.stny.rr.com> <20110309000753.GA27729@Krystal> <1299629657.20306.105.camel@gandalf.stny.rr.com> <20110309002921.GA744@Krystal> <1299631924.20306.122.camel@gandalf.stny.rr.com> <20110309011716.GB3664@Krystal> <1299636077.20306.132.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299636077.20306.132.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:20:12 up 105 days,  7:23,  1 user,  load average: 0.10, 0.18,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-03-08 at 20:17 -0500, Mathieu Desnoyers wrote:
> 
> > 
> > And about the "default" tracepoints, let's mainly think about tracepoints that
> > would be specified from a trace control application. E.g. the user wants a type
> > of tracing that collects all information required to solve a category of
> > problem, and they get enabled automatically.
> 
> Well, since tracepoints can change (come and go), this tool had better
> be very flexible.

The idea is that a tool activates a set of tracepoints, gather trace data, and
then use the metainformation to figure out which of the tracepoints it requested
are there. If some of the tracepoints it needs are not there, it bails out.

> 
> 
> > Well, thinking a little more about it, I won't be using this way of enabling
> > tracepoints in my tracer, so please feel free to make it as simple as you like.
> > I'm just providing feedback on what the ftrace/perf end user experience will
> > look like and, sadly, it does not look good at all by the look of this proposal.
> 
> Sadly it matters what the point of this change was for. 1) this does not
> affect the way perf enables/disable tracepoints. I'm sure it could
> easily add a syscall interface that would keep a nice wall from the
> user. 2) it was to enable tracing in ftrace as soon as a module is
> loaded. Ideally from a modprobe, not boot time tracing. Although, I
> probably could add something to for that too. But that would come later.
> 
> 
> > I meant that distros can contain packages that are interested in a specific set
> > of tracepoints (views/analysis are tracepoint data consumers), so they can
> > specify a set of tracepoints to enable when tracing is activated.
> 
> Yep, and this patch is not aimed at that. I am interesting in things
> that analyze specific data. But this patch was not something to address
> that. And it could easily exist with other means that do.

As long as this method of enabling TRACE_EVENT probes located in modules before
these are loaded does not become the single and only one, I'm fine with it. It
makes sense for the kernel-developer use-case. Although past experience taught
me to be careful about the "we'll allow better interfaces to come later"
approach.

[...]

> > 
> > Hopefully my feedback can be of some use.
> 
> For who?

For who CC'd me on this thread. ;-)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
