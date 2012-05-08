Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab2EHP1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:27:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42304 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab2EHP1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:27:43 -0400
Message-ID: <1336490832.8226.5.camel@twins>
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
Date: Tue, 08 May 2012 17:27:12 +0200
In-Reply-To: <alpine.DEB.2.00.1205081016370.27713@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
	 <1335830115-14335-8-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1205071053070.1060@router.home>
	 <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
	 <1336488626.16236.41.camel@twins>
	 <alpine.DEB.2.00.1205081016370.27713@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 10:18 -0500, Christoph Lameter wrote:
> On Tue, 8 May 2012, Peter Zijlstra wrote:
> 
> > There's no such policy, but I don't get why Christoph objects to
> > cpusets, its the option I would prefer. You're going to use cpusets
> > anyway to partition your system, might as well also use it to mark a
> > whole partition/set as nohz.
> 
> We are currently not using cpusets but are simply isolating processors as
> needed. Not sure that I want the overhead (administratively as well as in
> kernel) to deal with this.

isolating how? The only way to do that is with the (broken) isolcpus
crap and cpusets. There is no other way.

> Someone may be using a different partitioning technique (like cgroups) etc
> and then wont be able to use nohz. Having it not depend on cpusets makes
> it more universal.

You seem terminally confused on cpuset vs cgroups thing. One more time:
cpusets is a cgroup controller. Without cgroup support there is no
cpusets.

Furthermore there is no other partitioning scheme, cpusets is it.


