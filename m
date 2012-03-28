Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2C1OCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:02:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18426 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2C1OCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:02:06 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=3MQ0ZmHyo4IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=jSEJt4LoyX3-zb7zFowA:9 a=Ak-uIdZ1FoMXoSyzatUA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332943322.23924.181.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
From: Steven Rostedt <rostedt@goodmis.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
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
Date: Wed, 28 Mar 2012 10:02:02 -0400
In-Reply-To: <CAOtvUMen0N1rTa3b4KtK+Aw6nV_=3DMq2RB5CE5smSJDFtGrfA@mail.gmail.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	 <1332338318-5958-13-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1203210953220.20482@router.home>
	 <20120327121341.GE13196@somewhere>
	 <alpine.DEB.2.00.1203271111110.1170@router.home>
	 <1332865469.23924.129.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1203271939170.11825@router.home>
	 <1332896805.23924.148.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1203272013260.13193@router.home>
	 <1332898535.23924.157.camel@gandalf.stny.rr.com>
	 <1332904677.23924.174.camel@gandalf.stny.rr.com>
	 <CAOtvUMen0N1rTa3b4KtK+Aw6nV_=3DMq2RB5CE5smSJDFtGrfA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 09:55 +0200, Gilad Ben-Yossef wrote:
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

Are they teenagers yet? When they become that, the male of the family
becomes the point of frustration relief for them :-p  I've been their
target for the last week. ;-)

> At the risk of butting in on this little flame war, I think it is
> worth mentioning
> that this discussion arouse in the context of of a feature
> (cpuset/nohz) that deals
> with a single task running alone on a CPU and making zero use of
> kernel services,
> from scheduling, through interrupts, to system calls. It's just a pure
> 100% cpu  bound task.

I perfectly understand, and I said several times that latency has
different meanings for different people. It's as abused as the term
realtime is. I just took offense that he claimed I was using the term as
a marketing ploy.

> 
> For the work loads this is intended for, the time it takes to respond
> to an interrupt
> or context switch to the kernel and back for a system call, is too
> high. It doesn't matter
> how predictable that time is - if the time to do a system call in the
> best possible case
> is too high for you, having that time predictable only means you are
> predictably late :-)

And I agree with this too.

> 
> This is not an observation about Linux, or preempt-rt, or any OS for
> that matter. It's just
> a statement of fact. There is nothing you can do to make the OS better
> to get the time
> lower. It's just a process that doesn't want OS involvement at all
> from the point it is started
> until it's done, except in exception cases. The entire OS is overhead.

Agreed as well.

> 
> The traditional way to deal with these beasts is to run it on bare
> metal with no OS.

I've always said the best realtime OS was DOS ;-)

> What we're discussing is a way to get Linux to give a task bare metal
> like performance.
> That is useful because you can debug and manage the tasks using OS services, but
> still get bare metal like performance. In the context of this
> discussion, *any* kernel
> activity on that CPU during its run time is overhead, really.

Agreed too.

> 
> Preempt-rt is good. I know because I was involved in implementing it
> in a real time
> system that have saved dozen of lives already. When that system misses
> a dead line,
> that is exactly what you get - a line of dead people. Seriously. But
> it works. It just doesn't
> happen to apply here.

And this is why I asked to use the term overhead and not latency. As
latency has different meanings in different contexts, overhead and
determinism are more concrete. Lets stick with those terms so we don't
need to pick the color of the bike shed.

> 
> I don't know if this is what Christoph meant to say, but can we please
> try to get along now? :-)

Oh, I love Christoph. He knows I do. I was just releasing my built up
frustration on him ;-)

-- Steve


