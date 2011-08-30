Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1H3O1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:27:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43421 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1H3O1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:27:15 -0400
Date: Tue, 30 Aug 2011 16:27:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to idle
 enter/exit APIs
Message-ID: <20110830142705.GO9748@somewhere.redhat.com>
References: <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
 <1314627922.2816.65.camel@twins>
 <20110829171155.GD9748@somewhere.redhat.com>
 <1314640155.2816.117.camel@twins>
 <20110829175954.GF9748@somewhere.redhat.com>
 <1314641160.2816.128.camel@twins>
 <20110829233521.GK9748@somewhere.redhat.com>
 <1314703062.2799.1.camel@twins>
 <20110830141106.GM9748@somewhere.redhat.com>
 <1314713637.5812.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314713637.5812.4.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 04:13:57PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-30 at 16:11 +0200, Frederic Weisbecker wrote:
> > On Tue, Aug 30, 2011 at 01:17:42PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2011-08-30 at 01:35 +0200, Frederic Weisbecker wrote:
> > > > But rcu read side critical sections (preemption disabled, rcu_read_lock(),
> > > > softirq disabled) don't need the tick to enforce the critical section
> > > > itself. 
> > > 
> > > Note that with PREEMPT_RCU only the rcu_read_lock() is actually an rcu
> > > read side critical section, non of the others should be used as such.
> > > Relying on preempt_disable(), local_bh_disable() and similar is broken
> > > as per a long while ago.
> > 
> > Sure yeah.
> > 
> > My point was that the patchset doesn't care about all that anyway. Read
> > side critical section still work as usual. What changes is the way we
> > notice periods where we are *not* in rcu read side critical sections.
> > This was previously partly made through the tick. Now it's still the case
> > but we need to remotely wake up that tick first.
> 
> But you wake up the tick for any callback - systemwide - right? That's a
> massive fail.

Until we find a better solution yeah.
