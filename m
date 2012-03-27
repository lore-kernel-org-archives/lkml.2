Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2C0MNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 08:13:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56997 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2C0MNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 08:13:48 -0400
Date: Tue, 27 Mar 2012 14:13:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
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
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
Message-ID: <20120327121341.GE13196@somewhere>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <1332338318-5958-13-git-send-email-fweisbec@gmail.com>
 <alpine.DEB.2.00.1203210953220.20482@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203210953220.20482@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 09:54:39AM -0500, Christoph Lameter wrote:
> On Wed, 21 Mar 2012, Frederic Weisbecker wrote:
> 
> > If RCU is waiting for the current CPU to complete a grace
> > period, don't turn off the tick. Unlike dynctik-idle, we
> > are not necessarily going to enter into rcu extended quiescent
> > state, so we may need to keep the tick to note current CPU's
> > quiescent states.
> 
> Is there any way for userspace to know that the tick is not off yet due to
> this? It would make sense for us to have busy loop in user space that
> waits until the OS has completed all processing if that avoids future
> latencies for the application.

What is the usecase you have in mind? Is it for realtime purpose?
The "tick stopped" is a volatile and relative state.

Relative because if a timer list is enqueued to fire 1 second later,
the tick will be stopped until that happens. How do we consider this (common)
case?

Also as Chris noted it is volatile because the tick can be restarted anytime
for random reasons: the CPU receives an IPI which makes it restart the
periodic tick.
