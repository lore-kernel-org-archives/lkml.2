Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2KBOhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:37:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2KBOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:37:29 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wowpZ7sFJ74A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Z-wZqcGM7j4A:10 a=fZvPyAdTvHJ97n_rM5EA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351867045.4004.141.camel@gandalf.local.home>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Date: Fri, 02 Nov 2012 10:37:25 -0400
In-Reply-To: <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
References: <20121029202711.062749374@goodmis.org>
	 <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 14:23 +0000, Christoph Lameter wrote:
> On Mon, 29 Oct 2012, Steven Rostedt wrote:
> 
> > A while ago Frederic posted a series of patches to get an idea on
> > how to implement nohz cpusets. Where you can add a task to a cpuset
> > and mark the set to be 'nohz'. When the task runs on a CPU and is
> > the only task scheduled (nr_running == 1), the tick will stop.
> > The idea is to give the task the least amount of kernel interference
> > as possible. If the task doesn't do any system calls (and possibly
> > even if it does), no timer interrupt will bother it. By using
> > isocpus and nohz cpuset, a task would be able to achieve true cpu
> > isolation.
> 
> I thought isolcpus was on the way out? If there is no timer interrupt then
> there will also be no scheduler activity. Why do we need both?

I probably shouldn't have mentioned isolcpus. I was using that as
something that is general to get everything off of a cpu (irq affinity
for example).

> 
> Also could we have this support without cpusets? There are multiple means
> to do system segmentation (f.e. cgroups) and something like hz control is
> pretty basic. Control via some cpumask like irq affinities in f.e.
> 
> 	/sys/devices/system/cpu/nohz
> 
> or a per cpu flag in
> 
> /sys/devices/system/cpu/cpu0/hz
> 
> would be easier and not be tied to something like cpusets.

Frederic will have to answer this. I was just starting with his patches.
Note, we are holding off this work for now until Frederic's other work
is done (the irq_work and printk updates).

> 
> also it would be best to sync this conceptually with the processors
> enabled for rcu processing.

Processors can be disabled for rcu processing? Or are you talking about
Paul's new work of offloading rcu callbacks?

> 
> Maybe have a series of cpumasks in /sys/devices/system/cpu/ ?
> 
> > This has been long asked for by those in the RT community. If a task
> > requires uninterruptible CPU time, this would be able to give a task
> > that, even without the full PREEMPT-RT patch set.
> 
> Also those interested in low latency are very very interested in this
> feature in particular in support without any preempt support on in the
> kernel.
> 

Yep understood. We really need to get things rolling.

-- Steve


