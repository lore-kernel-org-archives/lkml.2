Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab2DTNVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:21:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53344 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2DTNVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:21:43 -0400
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>
In-Reply-To: <20120420122120.097464672@linutronix.de>
References: <20120420122120.097464672@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 15:21:38 +0200
Message-ID: <1334928098.2463.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 13:05 +0000, Thomas Gleixner wrote:
> This first part moves the idle thread management for non-boot cpus
> into the core. fork_idle() is called in a workqueue as it is
> implemented in a few architectures already. This is necessary when not
> all cpus are brought up by the early boot code as otherwise we would
> take a ref on the user task VM of the thread which brings the cpu up
> via the sysfs interface. 

So I was thinking about this and I think we should make that kthreadd
instead of a random workqueue thread due to all that cgroup crap. People
are wanting to place all sorts of kernel threads in cgroups and I'm
still arguing that kthreadd should not be allowed in cgroups.

Tejun, what's the status of that patch? Afaict David Rientjes's use-case
is insane and mostly a side effect of memcg broken-ness.

