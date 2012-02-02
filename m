Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab2BBS2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:28:06 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55418 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab2BBS2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:28:03 -0500
Date: Thu, 2 Feb 2012 10:27:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 39/41] rcu: Wait at least a jiffy before
 declaring a CPU to be offline
Message-ID: <20120202182705.GA2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-39-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202061228.GV29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202061228.GV29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020218-3352-0000-0000-000002593877
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 10:12:28PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:57AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The force_quiescent_state() function uses a state machine to help
> > force grace periods to completion.  One of its responsibilities is to
> > detect offline CPUs, and to report quiescent states on their behalf.
> > However, the CPU hotplug process is not atomic, in fact, there is
> > significant uncertainty as to exactly when a given CPU came online or
> > went offline.  For example, once a CPU has marked itself offline and
> > executed the CPU_DYING notifiers, it continues executing, entering
> > the scheduler and perhaps also the idle loop.
> > 
> > In the old days, force_quiescent_state() was guaranteed to wait for
> > several jiffies before declaring a given CPU offline.  This is no
> > longer the case, due to some of the more aggressive rcutorture tests
> > and the CONFIG_RCU_FAST_NO_HZ idle-entry code.  Therefore, this commit
> > makes force_quiescent_state() explicitly wait for at least a jiffy
> > before declaring a CPU to be offline.
> 
> This commit seems to implement behavior documented as working in patch
> 38.  Shouldn't those bits go together?

It really needs to have gone with the addition of of the fqs_ module
parameters to rcutorture.c, but that was some years back.  Failing that,
it needs to have gone with the addition of RCU_FAST_NO_HZ, but that
was more than a year ago as well.

But yes, merging with #38 makes sense to me!

The still-ongoing top-to-bottom review of RCU is still yielding results, 
and this is one of them.  Working through the hotplug code has been
time consuming, buteducational.  ;-)

							Thanx, Paul

