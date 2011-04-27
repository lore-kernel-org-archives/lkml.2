Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab1D0Ukj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:40:39 -0400
Received: from legolas.restena.lu ([158.64.1.34]:41441 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab1D0Ukg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:40:36 -0400
Date: Wed, 27 Apr 2011 22:40:23 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        paulmck@linux.vnet.ibm.com, Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
Message-ID: <20110427224023.10bd4f33@neptune.home>
In-Reply-To: <20110427204139.1b0ea23b@neptune.home>
References: <20110425180450.1ede0845@neptune.home>
	<BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com>
	<20110425190032.7904c95d@neptune.home>
	<BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com>
	<20110425203606.4e78246c@neptune.home>
	<20110425191607.GL2468@linux.vnet.ibm.com>
	<20110425231016.34b4293e@neptune.home>
	<BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com>
	<20110425214933.GO2468@linux.vnet.ibm.com>
	<20110426081904.0d2b1494@pluto.restena.lu>
	<20110426112756.GF4308@linux.vnet.ibm.com>
	<20110426183859.6ff6279b@neptune.home>
	<20110426190918.01660ccf@neptune.home>
	<BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
	<alpine.LFD.2.02.1104262314110.3323@ionos>
	<20110427081501.5ba28155@pluto.restena.lu>
	<20110427204139.1b0ea23b@neptune.home>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 April 2011 Bruno Prémont wrote:
> On Wed, 27 April 2011 Bruno Prémont wrote:
> > On Wed, 27 Apr 2011 00:28:37 +0200 (CEST) Thomas Gleixner wrote:
> > > Also please apply the patch below and check, whether the printk shows
> > > up in your dmesg.
> > 
> > > Index: linux-2.6-tip/kernel/sched_rt.c
> > > ===================================================================
> > > --- linux-2.6-tip.orig/kernel/sched_rt.c
> > > +++ linux-2.6-tip/kernel/sched_rt.c
> > > @@ -609,6 +609,7 @@ static int sched_rt_runtime_exceeded(str
> > >  
> > >  	if (rt_rq->rt_time > runtime) {
> > >  		rt_rq->rt_throttled = 1;
> > > +		printk_once(KERN_WARNING "sched: RT throttling activated\n");
> 
> This gun is triggering right before RCU-managed slabs start piling up as
> visible under slabtop so chances are it's at least a related!

Letting the machine idle (except running collectd and slabtop) scheduler
suddenly decided to restart giving rcu_kthread CPU cycles (after two hours
or so! if I read my statistics graphs correctly)

While looking at lkml during the above 2 hours I stumbled across this (the
patch of which doesn't help in my case) which looked possibly related.
  http://thread.gmane.org/gmane.linux.kernel/1129614

Bruno
