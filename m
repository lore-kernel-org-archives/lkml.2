Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566Ab2KBOXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:23:11 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:21870 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab2KBOXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:23:05 -0400
Date: Fri, 2 Nov 2012 14:23:04 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz
 CPUs
In-Reply-To: <20121029202711.062749374@goodmis.org>
Message-ID: <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
References: <20121029202711.062749374@goodmis.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, Steven Rostedt wrote:

> A while ago Frederic posted a series of patches to get an idea on
> how to implement nohz cpusets. Where you can add a task to a cpuset
> and mark the set to be 'nohz'. When the task runs on a CPU and is
> the only task scheduled (nr_running == 1), the tick will stop.
> The idea is to give the task the least amount of kernel interference
> as possible. If the task doesn't do any system calls (and possibly
> even if it does), no timer interrupt will bother it. By using
> isocpus and nohz cpuset, a task would be able to achieve true cpu
> isolation.

I thought isolcpus was on the way out? If there is no timer interrupt then
there will also be no scheduler activity. Why do we need both?

Also could we have this support without cpusets? There are multiple means
to do system segmentation (f.e. cgroups) and something like hz control is
pretty basic. Control via some cpumask like irq affinities in f.e.

	/sys/devices/system/cpu/nohz

or a per cpu flag in

/sys/devices/system/cpu/cpu0/hz

would be easier and not be tied to something like cpusets.

also it would be best to sync this conceptually with the processors
enabled for rcu processing.

Maybe have a series of cpumasks in /sys/devices/system/cpu/ ?

> This has been long asked for by those in the RT community. If a task
> requires uninterruptible CPU time, this would be able to give a task
> that, even without the full PREEMPT-RT patch set.

Also those interested in low latency are very very interested in this
feature in particular in support without any preempt support on in the
kernel.


