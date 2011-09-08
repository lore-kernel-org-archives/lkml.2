Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab1IIC3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:29:39 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54727 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757691Ab1IIC3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:29:36 -0400
Date: Thu, 8 Sep 2011 10:16:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/32] nohz: Move nohz load balancer selection into
 idle logic
Message-ID: <20110908171651.GI2671@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-9-git-send-email-fweisbec@gmail.com>
 <1314629117.2816.79.camel@twins>
 <20110908140851.GC6222@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908140851.GC6222@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11090902-6078-0000-0000-000000827E17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 04:08:54PM +0200, Frederic Weisbecker wrote:
> On Mon, Aug 29, 2011 at 04:45:17PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > > We want the nohz load balancer to be an idle CPU, thus
> > > move that selection to strict dyntick idle logic.
> > 
> > Again, the important part is missing, why is this correct?
> > 
> > I'm not at all convinced this is correct, suppose all your cpus (except
> > the system CPU, which we'll assume has many tasks) are busy running 1
> > task. Then two of them get an extra task, now if those two happen to be
> > SMT siblings you want the load-balancer to pull on task out from the SMT
> > pair, however nobody is pulling since nobody is idle.
> > 
> > AFAICT this breaks stuff and the ILB needs some serious attention in
> > order to fix this.
> 
> Right, we have the support for trigger_load_balance() in scheduler_tick()
> that is still missing.
> 
> What about using that CPU that has to stay awake with a periodic tick
> to handle jiffies? We could force that CPU to be the idle load balancer.
> The problem is perhaps to find the right frequency for doing that because
> we have all the rq to handle.

If this CPU can also be the RCU grace-period advancer of last resort,
that would make it easier to arrive at an improved RCU_FAST_NO_HZ.

							Thanx, Paul

