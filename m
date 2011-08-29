Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1H2SHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:07:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:35430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab1H2SH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:07:26 -0400
Subject: Re: [PATCH 13/32] nohz: Adaptive tick stop and restart on nohz
 cpuset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 20:07:10 +0200
In-Reply-To: <20110829180222.GG9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
	 <1314631689.2816.91.camel@twins>
	 <20110829180222.GG9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314641230.2816.129.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 20:02 +0200, Frederic Weisbecker wrote:
> On Mon, Aug 29, 2011 at 05:28:09PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > > +bool cpuset_nohz_can_stop_tick(void)
> > > +{
> > > +       struct rq *rq;
> > > +
> > > +       rq = this_rq();
> > > +
> > > +       /* More than one running task need preemption */
> > > +       if (rq->nr_running > 1)
> > > +               return false;
> > > +
> > > +       return true;
> > > +} 
> > 
> > int sched_needs_cpu(int cpu), seems the right name, matches the existing
> > {rcu,printk,arch}_needs_cpu() functions.
> 
> tick_nohz_stop_sched_tick() already handles that by keeping a periodic
> behaviour if one of these conditions are met.

What? tick_nohz_stop_sched_tick() most surely cannot access struct rq,
so it cannot do the nr_running test.

> It has also the upside to restore the periodic behaviour if needed
> from irq return if the tick was stopped.

Again, what?
