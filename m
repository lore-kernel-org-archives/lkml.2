Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab1GXJA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 05:00:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:42716 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1GXJAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 05:00:53 -0400
Date: Sun, 24 Jul 2011 11:00:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, laijs@cn.fujitsu.com,
        darren@dvhart.com, rostedt@goodmis.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rtmutex: Permit rt_mutex_unlock() to be invoked with
 irqs disabled
In-Reply-To: <20110724051744.GF2415@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1107241057320.2702@ionos>
References: <20110719201410.GA10553@linux.vnet.ibm.com> <1311247968.29152.122.camel@twins> <20110723220348.GD2415@linux.vnet.ibm.com> <alpine.LFD.2.02.1107240118550.2702@ionos> <alpine.LFD.2.02.1107240202500.2702@ionos>
 <20110724051744.GF2415@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011, Paul E. McKenney wrote:
> On Sun, Jul 24, 2011 at 02:05:13AM +0200, Thomas Gleixner wrote:
> > On Sun, 24 Jul 2011, Thomas Gleixner wrote:
> > > > > Thomas, I'm inclined to merge this, any objections?
> > > > 
> > > > FWIW, it has been passing tests here.
> > > 
> > > If it's only the unlock path, I'm fine with that change.
> > > 
> > > Acked-by-me
> > 
> > Hrmpft. That's requiring all places to take the lock irq safe. Not
> > really amused. For -RT that's a hotpath and we can really do without
> > the irq fiddling there. That needs a bit more thought.
> 
> Indeed...  If I make only some of the lock acquisitions irq safe, lockdep
> will yell at me.  And rightfully so, as that could result in deadlock.
> 
> So, what did you have in mind?

Have no real good idea yet for this. Could you grab rt and check
whether you can observe any impact when the patch is applied?

Thanks,

	tglx
