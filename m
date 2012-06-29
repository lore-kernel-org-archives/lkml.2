Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab2F2XEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 19:04:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39465 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2F2XE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 19:04:28 -0400
Date: Fri, 29 Jun 2012 16:01:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
Message-ID: <20120629230152.GF2416@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1340964584.2936.40.camel@lappy>
 <20120629172320.GA2416@linux.vnet.ibm.com>
 <1341006040.26928.4.camel@lappy>
 <20120629222744.GD2416@linux.vnet.ibm.com>
 <1341009607.27537.0.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341009607.27537.0.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12062923-6148-0000-0000-000007336ADC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2012 at 12:40:07AM +0200, Sasha Levin wrote:
> On Fri, 2012-06-29 at 15:27 -0700, Paul E. McKenney wrote:
> > On Fri, Jun 29, 2012 at 11:40:40PM +0200, Sasha Levin wrote:
> > > On Fri, 2012-06-29 at 10:23 -0700, Paul E. McKenney wrote:
> > > > On Fri, Jun 29, 2012 at 12:09:44PM +0200, Sasha Levin wrote:
> > > > > Hi Paul,
> > > > > 
> > > > > I think I've stumbled on another bug that will increase your paranoia levels even further.
> > > > > 
> > > > > I got the following lockup when fuzzing with trinity inside a KVM tools guest, using latest linux-next.
> > > > > 
> > > > > It appears that it was caused by a03d6178 ("rcu: Move RCU grace-period cleanup into kthread"). This issue doesn't reproduce easily though, it took some fuzzing before hitting it.
> > > > 
> > > > Hmmm...  If the preemption at that point in __rcu_read_unlock() is
> > > > required to make this happen, then it would be pretty hard to hit.
> > > > I suspect that you can make it reproduce more quickly by putting
> > > > a udelay(10) or similar right after the assignment of INT_MIN to
> > > > t->rcu_read_lock_nesting in __rcu_read_unlock() in kernel/rcupdate.c.
> > > > Can this be reproduced while running with lockdep enabled?
> > > 
> > > The good news are that it is much easier to reproduce it by adding a udelay(10) at the point you've mentioned.
> > 
> > How quickly does it reproduce?
> 
> 10 seconds more or less.

Very good -- if an alleged fix survives for 10 minutes, we have excellent
statistical confidence that it is in fact a fix.

							Thanx, Paul

