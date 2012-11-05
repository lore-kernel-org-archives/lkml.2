Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab2KEWcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:32:23 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47887 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933266Ab2KEWcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:32:21 -0500
MIME-Version: 1.0
In-Reply-To: <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
References: <20121029202711.062749374@goodmis.org>
	<0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
Date: Mon, 5 Nov 2012 23:32:20 +0100
Message-ID: <CAFTL4hwHDrL6i3SYLfqWrN690+69CxYQRiQd_nKRb46cUk9K7w@mail.gmail.com>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/2 Christoph Lameter <cl@linux.com>:
> Also could we have this support without cpusets? There are multiple means
> to do system segmentation (f.e. cgroups) and something like hz control is
> pretty basic. Control via some cpumask like irq affinities in f.e.
>
>         /sys/devices/system/cpu/nohz
>
> or a per cpu flag in
>
> /sys/devices/system/cpu/cpu0/hz
>
> would be easier and not be tied to something like cpusets.

You really don't want that cpuset interface, do you? ;-)

Yeah I think I agree with you. This adds a dependency to
cpusets/cgroups, I wish we could avoid that if possible. Also cpuset
may be a bit counter intuitive for this usecase. What if a cpu is
included in both a nohz cpuset and a non-nohz cpuset? What is the
behaviour to adopt? An OR on the nohz flag such that as long as the
CPU is in at least one nohz cpuset, it's considered a nohz CPU? Or
only shutdown the tick for the tasks attached in the nohz cpusets? Do
we really want that per cgroup granularity and the overhead /
complexity that comes along?

No I think we should stay simple and have a simple per CPU property
for that, without involving cgroups aside.

So indeed a cpumask in /sys/devices/system/cpu/nohz looks like a
better interface.

>> This has been long asked for by those in the RT community. If a task
>> requires uninterruptible CPU time, this would be able to give a task
>> that, even without the full PREEMPT-RT patch set.
>
> Also those interested in low latency are very very interested in this
> feature in particular in support without any preempt support on in the
> kernel.

Sure, we are trying to make that full dyncticks approach as much
generic as possible.
