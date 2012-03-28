Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2C1DSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 23:18:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2C1DSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 23:18:01 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=3MQ0ZmHyo4IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=40tUe2xViGbTcreL8WAA:9 a=AKo0WnOVk4W3LmyX8pgA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332904677.23924.174.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Date: Tue, 27 Mar 2012 23:17:57 -0400
In-Reply-To: <1332898535.23924.157.camel@gandalf.stny.rr.com>
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
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 21:35 -0400, Steven Rostedt wrote:

> > > I call that "lower overhead".
> > 
> > Good marketing but it does not change the facts.

I'm replying again because this comment just pisses me off.

I'm the only male in my household, living with a wife, two teenage
daughters and two bitches (I own two female dogs). This is not the time
of month to be arguing with me!

The fact is, you live in your own little world. You see things from your
own little perspective. You can define the time a system call takes as a
latency, but that is just one very small aspect of latencies. There's
lots of other kinds of latencies and if you did the search I told you
to, you would see that. In fact, the latency caused by system calls is
such a small niche of the types of latencies there are. I'm not counting
the time a system call waits for a device. Although a preempt kernel
would be faster for such a case.

Having zero preemption in the kernel makes the system calls the fastest.
And to a single thread running by itself on a CPU, this would be the
latency it is most interested in. But a system as a whole, this can
actually be the cause of much larger latencies.

Compile your kernel without preemption (Sever). Use it for a while as a
desktop. Then compile it with CONFIG_PREEMPT, the Preemptible Kernel
option (which in the menu is also called: Low-Latency Desktop!)

Run that for a bit. You'll notice a smoother feeling with the
CONFIG_PREEMPT kernel.

You're talking about overhead not latency. Sure, overhead can cause
latencies, and latencies can cause overhead. What we call latency has
*nothing* to do with marketing. We happen to handle the other 98% of
latencies in the system.

-- Steve



