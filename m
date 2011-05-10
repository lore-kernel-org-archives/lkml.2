Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab1EJIma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:42:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab1EJImW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:42:22 -0400
Date: Tue, 10 May 2011 10:41:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110510084158.GC27426@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
 <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
 <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo>
 <20110507190033.GA11465@elte.hu>
 <1304996847.2969.151.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304996847.2969.151.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > Check whether there's any feature missing from it that you'd like to see, add 
> > it. Rinse, repeat.
> 
> Again, the design of trace/perf is task oriented. Ftrace is system
> oriented. Could we agree on that?

Like i said in the previous mail, i don't know where you got this nonsensical 
idea from. ftrace is indeed system oriented and that's hardcoded at the design 
- i.e. its a design mistake.

perf is fundamentally *event* oriented - and various levels of grouping and 
buffering can be applied to events.

'system wide', 'per cpu', 'per workload', 'per task' or 'per cgroup' are just 
one of the many natural groupings of events that users/developers would like to 
see - and we offer these.

 - that is why sysprof is using perf events to collect system-wide events.

 - that is why PowerTOP uses perf events in system-wide event collection mode.

 - that is why 'perf top' uses system wide profiling by default (but can do per 
   CPU or per task profiling as well)

 - that is why 'perf record' defaults to a per workload (not a per task as you 
   claim) mode of event collection

 - that is why 'perf stat' defalts to per workload events

Do you see that it is ftrace that remained behind the times, by stubbornly 
forcing some nonsensical global view and encoding it not only in its design but 
in its APIs as well?

I really meant it when i told you that perf events were the natural next step 
after ftrace, in the evolution of Linux tracing/instrumentation.

> > > Now that perf has entered the tracing field, I would be happy to bring 
> > > the two together. [...]
> > 
> > Great - please see tip:tmp.perf/trace, that would be a very good point to 
> > start. It's a working prototype for an ftrace-alike tracing workflow.
> 
> I'll do it, if we can agree about the ftrace as system tracing/debugging, and 
> trace can focus on user specific tracing.

Ok, you've finally admitted that you do not really want 'unification' between 
ftrace and perf - which was my suspicion all along. I really prefer 100% honest 
discussions with people from whom i pull and it took quite some time for you to 
admit to this position ...

Despite what you say perf and 'trace' can do system-wide tracing just fine:

  $ trace record -a
  ^C
  # trace recorded [205.108 MB] - try 'trace summary' to get an overview

( and note that the code in tip:tmp.perf/trace2 is a very early prototype, 
  barely tested - it just demonstrates the idea. )

In fact we could make 'trace' default to system-wide tracing by default and it 
would fall back to workload level tracing only if it does not have the 
privileges to trace the whole system.

Why not use the correctly designed tracing approach and enhance it, and merge 
all the remaining useful bits of ftrace into it?

Thanks,

	Ingo
