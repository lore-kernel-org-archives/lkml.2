Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1FNMn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:43:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56056 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab1FNMn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:43:27 -0400
Date: Tue, 14 Jun 2011 05:43:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, "Shi, Alex" <alex.shi@intel.com>
Subject: Re: rcu: performance regression
Message-ID: <20110614124323.GC2264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1308029185.15392.147.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308029185.15392.147.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 01:26:25PM +0800, Shaohua Li wrote:
> Commit a26ac2455ffcf3(rcu: move TREE_RCU from softirq to kthread)
> introduced performance regression. In our AIM7 test, this commit caused
> about 40% regression.
> The commit runs rcu callbacks in a kthread instead of softirq. We
> observed high rate of context switch which is caused by this. Out test
> system has 64 CPUs and HZ is 1000, so we saw more than 64k context
> switch per second which is caused by the rcu thread.
> I also did trace and found when rcy thread is woken up, most time the
> thread doesn't handle any callbacks actually, it just initializes new gp
> or end one gp or similar.
> >From my understanding, the purpose to make rcu runs in kthread is to
> speed up rcu callbacks run (with help of rtmutex PI), not for end gp and
> so on, which runs pretty fast actually and doesn't need boost.
> To verify my findings, I had below debug patch applied. It still handles
> rcu callbacks in kthread if there is any pending callbacks, but other
> things are still running in softirq. this completely solved our
> regression. I thought this can still boost callbacks run. but I'm not
> expert in the area, so please help.

Hello, Shaohua,

Could you please try the following patch?  In the meantime, I will
also look over the patch that you sent.

							Thanx, Paul
