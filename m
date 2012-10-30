Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2J3OCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:02:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60438 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2J3OCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:02:50 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20121029202711.062749374@goodmis.org>
References: <20121029202711.062749374@goodmis.org>
Date: Tue, 30 Oct 2012 16:02:48 +0200
Message-ID: <CAOtvUMeWrZpT21xscqPbRq4KFPNoPvBsydc0tppchz=-2rkK2Q@mail.gmail.com>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 10:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> A while ago Frederic posted a series of patches to get an idea on
> how to implement nohz cpusets.
<snip>
>  By using
> isocpus and nohz cpuset, a task would be able to achieve true cpu
> isolation.
>
> This has been long asked for by those in the RT community. If a task
> requires uninterruptible CPU time, this would be able to give a task
> that, even without the full PREEMPT-RT patch set.
>
> This patch set is not for inclusion. It is just to get the topic
> at the forefront again. The design requires more work and more
> discussion.
>

Three additional data points that might be of interest to the discussion:

1. AFAIK both Tilera and Cavium carry patch sets with similar
functionality in their respective kernels, so the idea has some real
world users already.

2. I tested a previous version of the same patch set (based on 3.3)
together with some fixes* and got the same latency, in cycles, from a
simple test program and a version of said program running bare metal
with no OS. The same program running without this patch got 3 orders
of magnitude higher latency. So, this certainly shows some great
potential.

3. Even if you don't care about latency at all, on a massively
multi-core (or hyperscale, as I've read some people call it now)
systems, assigning a task to a single CPU can makes a lot of sense
from a cache utilization perspective etc; if you that, this feature
can give a performance boost to anything that is mostly CPU bound and
perhaps for some workloads that are not so CPU bound as well.
Specifically, many high performance computing type of workloads come
to mind. So, this has the potential to be useful to both RT folks and
HPC folks, I think.

[*] A newer version patch set:
http://www.spinics.net/lists/linux-mm/msg33860.html and disabling the
part that sends IPI to update cputime for nohz/cpuset CPUs.

Thanks,
Gilad


--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a situation
where the homework eats your dog?"
 -- Jean-Baptiste Queru
