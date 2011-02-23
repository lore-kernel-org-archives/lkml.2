Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1BWTRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:17:06 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52958 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450Ab1BWTRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:17:03 -0500
Date: Wed, 23 Feb 2011 11:16:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223191658.GV2163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110223161645.GA1819@nowhere>
 <1298479302.7666.94.camel@gandalf.stny.rr.com>
 <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
 <alpine.DEB.2.00.1102231132140.562@router.home>
 <1298485027.7666.98.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1102231225330.3906@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102231225330.3906@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:29:59PM -0600, Christoph Lameter wrote:
> On Wed, 23 Feb 2011, Steven Rostedt wrote:
> 
> > On Wed, 2011-02-23 at 11:34 -0600, Christoph Lameter wrote:
> >
> > > > > True, but we could also argue that the multiple checks for being preempt
> > > > > can also be an issue.
> > > >
> > > > At least on x86 preemption don't actually need to be disabled: selection
> > > > of the right per-cpu memory location is done atomically with the rest of
> > > > the instruction by the segment selector.
> > >
> > > Right.
> >
> > But a test still needs to be made. Because three access of this_cpu_*()
> > that gets preempted and scheduled on another CPU can access a different
> > CPU var for each access. This does not matter how atomic the
> > this_cpu_*() code is.
> 
> Right if the kthread context can be rescheduled then either preemption
> needs to be disabled to guarantee that all three access the same per cpu
> area data or the code needs to be changed in such a way that a this_cpu
> RMW instructions can do the mods in one go.

Reschedules can happen in this case due to CPU hotplug events.  :-(

							Thanx, Paul
