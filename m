Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1BIPyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 10:54:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:47673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1BIPyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 10:54:23 -0500
Subject: Re: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@gmail.com>
In-Reply-To: <1297108399.8221.35.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1296852688-1665-1-git-send-email-venki@google.com>
	 <1296854731-25039-1-git-send-email-venki@google.com>
	 <1297086642.13327.15.camel@laptop>
	 <AANLkTi=xo8bq6uTjYQ7yxJ69ATry1Xs3q0deE7UN9jPj@mail.gmail.com>
	 <1297108399.8221.35.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 16:55:28 +0100
Message-ID: <1297266928.13327.216.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 11:53 -0800, Suresh Siddha wrote:
> 
> Peter, to answer your question of why SMT is treated different to cores
> sharing cache, performance improvements contributed by SMT is far less
> compared to the cores and any wrong decisions in SMT load balancing
> (especially in the presence of idle cores, packages) has a bigger
> impact.
> 
> I think in the tbench case referred by Nick, idle HT siblings in a busy
> package picked the load instead of the idle packages. And thus we
> probably had to wait for active load balance to kick in to distribute
> the load etc by which the damage would have been. Performance impact of
> this condition wouldn't be as severe in the cores sharing last level
> cache and other resources.
> 
> Also there are lot of changes in this area since 2005. So it would be
> nice to revisit the tbench case and see if the logic of propagating busy
> sibling status to the higher level load balances is still needed or not.
> 
> On the contrary, perhaps there might be some workloads which may benefit
> in performance/latency if we completely do away with this less
> aggressive SMT load balancing. 

Right, but our current capacity logic does exactly that and seems to
work for more than 2 smt siblings (it does the whole asymmetric power7
muck).

>From a quick glance at the sched.c state at the time of Nick's patch,
the capacity logic wasn't around then.

So I see no reason what so ever to keep this SMT exception.

