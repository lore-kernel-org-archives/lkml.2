Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1H3OiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:38:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58451 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1H3OiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:38:08 -0400
Date: Tue, 30 Aug 2011 16:38:03 +0200
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
Subject: Re: [PATCH 13/32] nohz: Adaptive tick stop and restart on nohz cpuset
Message-ID: <20110830143801.GQ9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
 <1314631689.2816.91.camel@twins>
 <20110829180222.GG9748@somewhere.redhat.com>
 <1314641230.2816.129.camel@twins>
 <20110829182836.GI9748@somewhere.redhat.com>
 <1314708250.5812.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314708250.5812.0.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 02:44:10PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-29 at 20:28 +0200, Frederic Weisbecker wrote:
> > tick_nohz_stop_sched_tick() checks that
> > with {rcu,printk,arch}_needs_cpu() and restores a periodic behaviour
> > until nobody else needs the CPU. 
> 
> tick_nohz_stop_sched_tick() should not restore stuff, it should at worst
> fail to stop but never enable that's just weird.

It's not really enablement, it's just nohz behaviour but the next tick is
in HZ :o)

Like you said before it's an optimization. I can do the things differently
for idle and non-idle cases there but I'm not sure it's really a good thing.
