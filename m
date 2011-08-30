Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1H3P3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:29:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:60296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1H3P3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:29:18 -0400
Subject: Re: [PATCH 13/32] nohz: Adaptive tick stop and restart on nohz
 cpuset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Date: Tue, 30 Aug 2011 17:28:29 +0200
In-Reply-To: <20110830143801.GQ9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
	 <1314631689.2816.91.camel@twins>
	 <20110829180222.GG9748@somewhere.redhat.com>
	 <1314641230.2816.129.camel@twins>
	 <20110829182836.GI9748@somewhere.redhat.com>
	 <1314708250.5812.0.camel@twins>
	 <20110830143801.GQ9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314718109.5812.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 16:38 +0200, Frederic Weisbecker wrote:
> On Tue, Aug 30, 2011 at 02:44:10PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-08-29 at 20:28 +0200, Frederic Weisbecker wrote:
> > > tick_nohz_stop_sched_tick() checks that
> > > with {rcu,printk,arch}_needs_cpu() and restores a periodic behaviour
> > > until nobody else needs the CPU. 
> > 
> > tick_nohz_stop_sched_tick() should not restore stuff, it should at worst
> > fail to stop but never enable that's just weird.
> 
> It's not really enablement, it's just nohz behaviour but the next tick is
> in HZ :o)
> 
> Like you said before it's an optimization. 

I'm still not feeling very confident about all that..

> I can do the things differently
> for idle and non-idle cases there but I'm not sure it's really a good thing.

its not, but I'm very sure I've lost you on why that should be the case.
