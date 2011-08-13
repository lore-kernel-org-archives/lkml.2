Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab1HMQ25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 12:28:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56678 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1HMQ2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 12:28:54 -0400
Date: Sat, 13 Aug 2011 09:27:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
Message-ID: <20110813162735.GA2650@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313232790.25267.7.camel@twins>
 <1313236135.4486.10.camel@marge.simson.net>
 <1313236713.25267.10.camel@twins>
 <1313243965.4486.36.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313243965.4486.36.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 03:59:25PM +0200, Mike Galbraith wrote:
> On Sat, 2011-08-13 at 13:58 +0200, Peter Zijlstra wrote:
> > On Sat, 2011-08-13 at 13:48 +0200, Mike Galbraith wrote:
> > > On Sat, 2011-08-13 at 12:53 +0200, Peter Zijlstra wrote:
> > > > Whee, I can skip release announcements too!
> > > > 
> > > > So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
> > > > grabs.
> > > > 
> > > > Changes include (including the missing -rt10):
> > > > 
> > > >   - hrtimer fix that should make RT_GROUP work again
> > > >   - RCU fixes that should make the RCU stalls go away
> > > 
> > > Oh goodie, I was just looking at some of those.
> > > 
> > > coverdale:/abuild/mike/linux-3.0-rt/:[1]# wget http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.tar.bz2
> > > --2011-08-13 13:38:13--  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.tar.bz2
> > > Resolving www.kernel.org... 130.239.17.5, 199.6.1.165, 2001:6b0:e:4017:1994:313:1:0, ...
> > > Connecting to www.kernel.org|130.239.17.5|:80... connected.
> > > HTTP request sent, awaiting response... 404 Not Found
> > > 2011-08-13 13:38:13 ERROR 404: Not Found.
> > > 
> > > Aw poo.  Darn mirrors. 
> > 
> > Try -rt10, except for an SMP=n build fix its identical.. kernel.org
> > seems to experience some trouble atm..
> 
> Hohum.  rt10 did change the symptom.  Box no longer gripes at some
> random point while just idling along, now it gripes (and dies as well)
> during boot.
> 
> First boot, it choked on sr0 a wee bit later, second boot here.
> 
> [   40.582256] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
> [   40.582260] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 08:00:69:15:c1:d5
> [   40.582335] igb 0000:01:00.1: eth1: PBA No: FFFFFF-0FF
> [   40.582338] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [  100.409012] INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by 21, t=60002 jiffies)
> 
> Guess I should try x3550 M3 or Q6600.  They were griping the same way UV
> box did earlier this morning (with an earlier -rt though), and they make
> much smaller gripes.
> 
> Gripe attached.  Looks a lot like the old gripes to me, just earlier and
> deadlier.  But I don't speak rcu.

Strange.  By the time it got around to printing the stall, no one was
stalling:

[  100.409012] INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by 21, t=60002 jiffies)

Now it -is- possible for the stall to end just as we get ready to detect
it, but that window is really really small.  The most recent occurrence
of this sort of thing was due misconfigured timekeeping, but I don't see
any sign of that in the trace.

This happens repeatedly?

							Thanx, Paul
