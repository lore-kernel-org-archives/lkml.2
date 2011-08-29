Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab1H2RKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:10:31 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35874 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab1H2RK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:10:28 -0400
Date: Mon, 29 Aug 2011 19:10:22 +0200
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
Subject: Re: [PATCH 01/32 RESEND] nohz: Drop useless call in
 tick_nohz_start_idle()
Message-ID: <20110829171020.GC9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-2-git-send-email-fweisbec@gmail.com>
 <1314627790.2816.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314627790.2816.59.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:23:10PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:51 +0200, Frederic Weisbecker wrote:
> > The call to update_ts_time_stats() there is useless. All
> > we need is to save the idle entry_time.
> > 
> > 
> Would have been clearer if you just said the call was a NOP. The whole
> second sentence distracts and confuses as its irrelevant to the change
> at hand.
> 
> If you want to expand you can explain that its a NOP because
> update_ts_time_stats() requires either ts->idle_active and/or
> @last_update_time and our callsite has neither.

Right, will fix the changelog.

> 
> Although this assumes its never called when ts->idle_active is already
> set, is this so (likely)? Do we want a WARN_ON_ONCE() testing that
> assumption?

Not sure. Looking at the ondemand cpufreq governor, it calls
get_cpu_idle_time_us() from an initcall.
