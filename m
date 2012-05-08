Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2EHPsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:48:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47960 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab2EHPsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:48:33 -0400
Message-ID: <1336492081.8226.13.camel@twins>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 08 May 2012 17:48:01 +0200
In-Reply-To: <alpine.DEB.2.00.1205081035550.27713@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
	 <1335830115-14335-8-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1205071053070.1060@router.home>
	 <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
	 <1336488626.16236.41.camel@twins>
	 <alpine.DEB.2.00.1205081016370.27713@router.home>
	 <1336490832.8226.5.camel@twins>
	 <alpine.DEB.2.00.1205081035550.27713@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 10:38 -0500, Christoph Lameter wrote:
> On Tue, 8 May 2012, Peter Zijlstra wrote:
> 
> > isolating how? The only way to do that is with the (broken) isolcpus
> > crap and cpusets. There is no other way.
> 
> For some reason this seems to work here. What is broken with isolcpus?

It mostly still works I think, but iirc there were a few places that
ignored the cpuisol mask.

But really the moment we get proper means of flushing cpu state
(currently achievable by unplug-replug) isolcpu gets depricated and
eventually removed.

cpusets can do what isolcpu can and more (provided this flush thing).

> > Furthermore there is no other partitioning scheme, cpusets is it.
> 
> One can partition the system anyway one wants by setting cpu affinities
> and memory policies etc. No need for cpusets/cgroups.

Not so, the load-balancer will still try to move the tasks and
subsequently fail. Partitioning means it won't even try to move tasks
across the partition boundary.

By proper partitioning you can split load balance domains (or completely
disable the load-balancer by giving it a single cpu domain).


