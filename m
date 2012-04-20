Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2DTNr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:47:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:45147 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2DTNr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:47:28 -0400
Date: Fri, 20 Apr 2012 15:47:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
In-Reply-To: <1334928098.2463.56.camel@laptop>
Message-ID: <alpine.LFD.2.02.1204201540400.2542@ionos>
References: <20120420122120.097464672@linutronix.de> <1334928098.2463.56.camel@laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012, Peter Zijlstra wrote:

> On Fri, 2012-04-20 at 13:05 +0000, Thomas Gleixner wrote:
> > This first part moves the idle thread management for non-boot cpus
> > into the core. fork_idle() is called in a workqueue as it is
> > implemented in a few architectures already. This is necessary when not
> > all cpus are brought up by the early boot code as otherwise we would
> > take a ref on the user task VM of the thread which brings the cpu up
> > via the sysfs interface. 
> 
> So I was thinking about this and I think we should make that kthreadd
> instead of a random workqueue thread due to all that cgroup crap. People
> are wanting to place all sorts of kernel threads in cgroups and I'm
> still arguing that kthreadd should not be allowed in cgroups.

So your fear is that the idle_thread will end up in some random cgroup
because some illdesigned user space code decided to stick kernel
threads into cgroups.

Can we please have some sanity restrictions on this cgroup muck? I
don't care when user space creates cgroups in circles, but holding the
whole kernel hostage of this madness is going too far.

Thanks,

	tglx
