Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab1IHOJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:09:04 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64522 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab1IHOJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:09:01 -0400
Date: Thu, 8 Sep 2011 16:08:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/32] nohz: Move nohz load balancer selection into idle
 logic
Message-ID: <20110908140851.GC6222@somewhere>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-9-git-send-email-fweisbec@gmail.com>
 <1314629117.2816.79.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314629117.2816.79.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:45:17PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > We want the nohz load balancer to be an idle CPU, thus
> > move that selection to strict dyntick idle logic.
> 
> Again, the important part is missing, why is this correct?
> 
> I'm not at all convinced this is correct, suppose all your cpus (except
> the system CPU, which we'll assume has many tasks) are busy running 1
> task. Then two of them get an extra task, now if those two happen to be
> SMT siblings you want the load-balancer to pull on task out from the SMT
> pair, however nobody is pulling since nobody is idle.
> 
> AFAICT this breaks stuff and the ILB needs some serious attention in
> order to fix this.

Right, we have the support for trigger_load_balance() in scheduler_tick()
that is still missing.

What about using that CPU that has to stay awake with a periodic tick
to handle jiffies? We could force that CPU to be the idle load balancer.
The problem is perhaps to find the right frequency for doing that because
we have all the rq to handle.
