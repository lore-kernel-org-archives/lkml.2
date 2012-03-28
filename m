Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2C1MVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:21:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57175 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2C1MVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:21:43 -0400
Date: Wed, 28 Mar 2012 14:21:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
Message-ID: <20120328122135.GD17189@somewhere.redhat.com>
References: <alpine.DEB.2.00.1203210953220.20482@router.home>
 <20120327121341.GE13196@somewhere>
 <alpine.DEB.2.00.1203271111110.1170@router.home>
 <1332865469.23924.129.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1203271939170.11825@router.home>
 <1332896805.23924.148.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1203272013260.13193@router.home>
 <1332898535.23924.157.camel@gandalf.stny.rr.com>
 <1332904677.23924.174.camel@gandalf.stny.rr.com>
 <CAOtvUMen0N1rTa3b4KtK+Aw6nV_=3DMq2RB5CE5smSJDFtGrfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMen0N1rTa3b4KtK+Aw6nV_=3DMq2RB5CE5smSJDFtGrfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 09:55:37AM +0200, Gilad Ben-Yossef wrote:
> On Wed, Mar 28, 2012 at 5:17 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2012-03-27 at 21:35 -0400, Steven Rostedt wrote:
> >
> >> > > I call that "lower overhead".
> >> >
> >> > Good marketing but it does not change the facts.
> >
> > I'm replying again because this comment just pisses me off.
> >
> > I'm the only male in my household, living with a wife, two teenage
> > daughters and two bitches (I own two female dogs). This is not the time
> > of month to be arguing with me!
> 
> LOL. I'm married with two daughters. I feel your pain  :-)
> 
> >
> > The fact is, you live in your own little world. You see things from your
> > own little perspective. You can define the time a system call takes as a
> > latency, but that is just one very small aspect of latencies. There's
> > lots of other kinds of latencies and if you did the search I told you
> > to, you would see that. In fact, the latency caused by system calls is
> > such a small niche of the types of latencies there are. I'm not counting
> > the time a system call waits for a device. Although a preempt kernel
> > would be faster for such a case.
> >
> 
> At the risk of butting in on this little flame war, I think it is
> worth mentioning
> that this discussion arouse in the context of of a feature
> (cpuset/nohz) that deals
> with a single task running alone on a CPU and making zero use of
> kernel services,
> from scheduling, through interrupts, to system calls. It's just a pure
> 100% cpu  bound task.

Note that cpu isolation is a specific usecase of nohz cpusets. But it's
intended to be more generally useful (probably for most workloads). That
means we really want to support syscalls, interrupts and everything. That's
why it is called adaptive tickless and not just userspace isolated tickless.

Not that what I'm saying is making the debate on latency moving forward,
I just wanted to ensure there is no misunderstanding of this patchset :)
