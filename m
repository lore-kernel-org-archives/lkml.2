Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2C1Hzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:55:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44988 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2C1Hzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:55:38 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1332904677.23924.174.camel@gandalf.stny.rr.com>
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
Date: Wed, 28 Mar 2012 09:55:37 +0200
Message-ID: <CAOtvUMen0N1rTa3b4KtK+Aw6nV_=3DMq2RB5CE5smSJDFtGrfA@mail.gmail.com>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs it
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 5:17 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-03-27 at 21:35 -0400, Steven Rostedt wrote:
>
>> > > I call that "lower overhead".
>> >
>> > Good marketing but it does not change the facts.
>
> I'm replying again because this comment just pisses me off.
>
> I'm the only male in my household, living with a wife, two teenage
> daughters and two bitches (I own two female dogs). This is not the time
> of month to be arguing with me!

LOL. I'm married with two daughters. I feel your pain  :-)

>
> The fact is, you live in your own little world. You see things from your
> own little perspective. You can define the time a system call takes as a
> latency, but that is just one very small aspect of latencies. There's
> lots of other kinds of latencies and if you did the search I told you
> to, you would see that. In fact, the latency caused by system calls is
> such a small niche of the types of latencies there are. I'm not counting
> the time a system call waits for a device. Although a preempt kernel
> would be faster for such a case.
>

At the risk of butting in on this little flame war, I think it is
worth mentioning
that this discussion arouse in the context of of a feature
(cpuset/nohz) that deals
with a single task running alone on a CPU and making zero use of
kernel services,
from scheduling, through interrupts, to system calls. It's just a pure
100% cpu  bound task.

For the work loads this is intended for, the time it takes to respond
to an interrupt
or context switch to the kernel and back for a system call, is too
high. It doesn't matter
how predictable that time is - if the time to do a system call in the
best possible case
is too high for you, having that time predictable only means you are
predictably late :-)

This is not an observation about Linux, or preempt-rt, or any OS for
that matter. It's just
a statement of fact. There is nothing you can do to make the OS better
to get the time
lower. It's just a process that doesn't want OS involvement at all
from the point it is started
until it's done, except in exception cases. The entire OS is overhead.

The traditional way to deal with these beasts is to run it on bare
metal with no OS.
What we're discussing is a way to get Linux to give a task bare metal
like performance.
That is useful because you can debug and manage the tasks using OS services, but
still get bare metal like performance. In the context of this
discussion, *any* kernel
activity on that CPU during its run time is overhead, really.

Preempt-rt is good. I know because I was involved in implementing it
in a real time
system that have saved dozen of lives already. When that system misses
a dead line,
that is exactly what you get - a line of dead people. Seriously. But
it works. It just doesn't
happen to apply here.

I don't know if this is what Christoph meant to say, but can we please
try to get along now? :-)

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
