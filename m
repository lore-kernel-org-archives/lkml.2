Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2C1LxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:53:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38557 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2C1LxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:53:12 -0400
Date: Wed, 28 Mar 2012 13:53:07 +0200
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
Message-ID: <20120328115304.GC17189@somewhere.redhat.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <1332338318-5958-13-git-send-email-fweisbec@gmail.com>
 <alpine.DEB.2.00.1203210953220.20482@router.home>
 <20120327121341.GE13196@somewhere>
 <alpine.DEB.2.00.1203271111110.1170@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203271111110.1170@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 11:13:39AM -0500, Christoph Lameter wrote:
> On Tue, 27 Mar 2012, Frederic Weisbecker wrote:
> 
> > > Is there any way for userspace to know that the tick is not off yet due to
> > > this? It would make sense for us to have busy loop in user space that
> > > waits until the OS has completed all processing if that avoids future
> > > latencies for the application.
> >
> > What is the usecase you have in mind? Is it for realtime purpose?
> 
> Please do not use "realtime" since I am not sure what you mean by that.
> Its for a low latency applications that cannot use "realtime" because that
> implies high latencies.
> 
> > The "tick stopped" is a volatile and relative state.
> 
> The use case is an application that cannot tolerate the latencies
> introduced by timer tick processing. It will only start running when the
> system is in a sufficiently quiet state.
> 
> > Relative because if a timer list is enqueued to fire 1 second later,
> > the tick will be stopped until that happens. How do we consider this (common)
> > case?
> >
> > Also as Chris noted it is volatile because the tick can be restarted anytime
> > for random reasons: the CPU receives an IPI which makes it restart the
> > periodic tick.
> 
> Ok some sort of notification would be good for that case. If a timer tick
> happens and that was unavoidable then it would be good to log the reason
> why this occured so that the system can be configured in such a way that
> these interruptions are minimized.

tracing is probably the right place to log these things. But that's
about debugging. This won't be a notification on top of which your app
could recover.
