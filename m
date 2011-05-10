Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1EJHzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:55:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34169 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1EJHzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:55:18 -0400
Date: Tue, 10 May 2011 09:54:57 +0200
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
Message-ID: <20110510075457.GJ11595@elte.hu>
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

> > I think its rather obvious how the unification should be done: check 
> > tip:tmp.perf/trace for the 'trace' command that does tracing.
> 
> I'll tell you what. I've been talking with other developers and one thing we 
> came up with that we all seem to agree with is that ftrace is designed to 
> trace the entire system, and it does it very well. Perf is designed to trace 
> individual tasks, and it does it very well (trace is an example of this. It's 
> focus is on tasks not the system). Ftrace can also trace individual tasks and 
> perf can also trace the entire system, but they both do those poorly.

Not sure where you picked that up but it's 100% nonsense and you could not be 
more wrong.

The reason why you see most instrumentation users use per task tracing and 
profiling is very simple: they *can* do it and local views are what most 
developer are interested in!

Otherwise perf has been designed to do system-wide (global) tracing pretty much 
from day one on. In fact one of the first applications of perf: kerneltop, the 
tool that evolved into 'perf top' has a system-wide view and never had any 
other default but system-wide tracing+profiling ...

'perf top' is what many kernel developers use and it's very popular because the 
kernel itself is 'system-wide' so obviously kernel developers want to have (and 
need to have) a system-wide view.

ftrace uses system-wide tracing because that's pretty much the only model it 
has. That is one of its many design mistakes, not a feature.

But the world is a lot more than just kernel focused workflows and perf 
supports various other popular views:

  - per task
  - per task hierarchy (tree spanning fork()/exec()/clone() trees of tasks)
  - per cgroup
  - system-wide

And you want to keep ftrace a forked identity on the weird notion that somehow 
perf can not do system-wide event collection and that somehow fundamentally 
instrumentation can not serve these goals of event grouping?

Steve, your opinion is, sadly, very narrow.

Thanks,

	Ingo
