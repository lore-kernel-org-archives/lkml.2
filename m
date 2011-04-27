Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098Ab1D0WHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:07:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49198 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab1D0WHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:07:24 -0400
Date: Wed, 27 Apr 2011 15:07:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
Message-ID: <20110427220717.GR2135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110425214933.GO2468@linux.vnet.ibm.com>
 <20110426081904.0d2b1494@pluto.restena.lu>
 <20110426112756.GF4308@linux.vnet.ibm.com>
 <20110426183859.6ff6279b@neptune.home>
 <20110426190918.01660ccf@neptune.home>
 <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
 <alpine.LFD.2.02.1104262314110.3323@ionos>
 <20110427081501.5ba28155@pluto.restena.lu>
 <20110427204139.1b0ea23b@neptune.home>
 <20110427224023.10bd4f33@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110427224023.10bd4f33@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:40:23PM +0200, Bruno Prémont wrote:
> On Wed, 27 April 2011 Bruno Prémont wrote:
> > On Wed, 27 April 2011 Bruno Prémont wrote:
> > > On Wed, 27 Apr 2011 00:28:37 +0200 (CEST) Thomas Gleixner wrote:
> > > > Also please apply the patch below and check, whether the printk shows
> > > > up in your dmesg.
> > > 
> > > > Index: linux-2.6-tip/kernel/sched_rt.c
> > > > ===================================================================
> > > > --- linux-2.6-tip.orig/kernel/sched_rt.c
> > > > +++ linux-2.6-tip/kernel/sched_rt.c
> > > > @@ -609,6 +609,7 @@ static int sched_rt_runtime_exceeded(str
> > > >  
> > > >  	if (rt_rq->rt_time > runtime) {
> > > >  		rt_rq->rt_throttled = 1;
> > > > +		printk_once(KERN_WARNING "sched: RT throttling activated\n");
> > 
> > This gun is triggering right before RCU-managed slabs start piling up as
> > visible under slabtop so chances are it's at least a related!
> 
> Letting the machine idle (except running collectd and slabtop) scheduler
> suddenly decided to restart giving rcu_kthread CPU cycles (after two hours
> or so! if I read my statistics graphs correctly)

And this also returned the slab memory, right?

Two hours is quite some time...

							Thanx, Paul

> While looking at lkml during the above 2 hours I stumbled across this (the
> patch of which doesn't help in my case) which looked possibly related.
>   http://thread.gmane.org/gmane.linux.kernel/1129614
> 
> Bruno
