Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1EPVYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:24:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44669 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1EPVYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:24:52 -0400
Date: Mon, 16 May 2011 14:24:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110516212449.GJ2573@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110513121906.GA3676@elte.hu>
 <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
 <20110513141431.GV2258@linux.vnet.ibm.com>
 <20110513150744.GE32688@elte.hu>
 <20110513162646.GW2258@linux.vnet.ibm.com>
 <20110516070808.GC24836@elte.hu>
 <20110516074822.GE2573@linux.vnet.ibm.com>
 <20110516115148.GA2421@elte.hu>
 <20110516122329.GA29356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516122329.GA29356@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 02:23:29PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > In the meantime, would you be willing to try out the patch at 
> > > https://lkml.org/lkml/2011/5/14/89?  This patch helped out Yinghai in 
> > > several configurations.
> > 
> > Wasn't this the one i tested - or is it a new iteration?
> > 
> > I'll try it in any case.
> 
> oh, this was a new iteration, mea culpa!
> 
> And yes, it solves all problems for me as well. Mind pushing it as a fix? :-)

;-)

Unfortunately, the only reason I can see that it works is (1) there
is some obscure bug in my code or (2) someone somewhere is failing to
call irq_exit() on some interrupt-exit path.  Much as I might be tempted
to paper this one over, I believe that we do need to find whatever the
underlying bug is.

Oh, yes, there is option (3) as well: maybe if an interrupt deschedules
a process, the final irq_exit() is omitted in favor of rcu_enter_nohz()?
But I couldn't see any evidence of this in my admittedly cursory scan
of the x86 interrupt-handling code.

So until I learn differently, I am assuming that each and every
irq_enter() has a matching call to irq_exit(), and that rcu_enter_nohz()
is called after the final irq_exit() of a given burst of interrupts.

If my assumptions are mistaken, please do let me know!

							Thanx, Paul
