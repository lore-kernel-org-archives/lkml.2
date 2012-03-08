Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2CHKj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:39:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60078 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2CHKj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:39:56 -0500
Message-ID: <1331203179.11248.382.camel@twins>
Subject: Re: [PATCH] scheduler: domain: correctly initialize 'next_balance'
 in 'nohz' idle balancer
From: Peter Zijlstra <peterz@infradead.org>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>, "'Jens Axboe'" <jaxboe@fusionio.com>,
        "'Randy Dunlap'" <randy.dunlap@oracle.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>
Date: Thu, 08 Mar 2012 11:39:39 +0100
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com>
References: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
	 <1328024684.2446.234.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE466523791832BE9@HQMAIL04.nvidia.com>
	 <1328040137.2446.242.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 14:44 -0800, Diwakar Tundlam wrote:
> scheduler: domain: init next_balance in nohz_idle_balancer with jiffies

That's already in the subject, no need to repeat that in the body.

> The 'next_balance' field of 'nohz' idle balancer must be initialized
> to jiffies. Since jiffies is initialized to negative 300 seconds the
> 'nohz' idle balancer does not run for the first 300s (5mins) after
> bootup. If no new processes are spawed or no idle cycles happen, the
> load on the cpus will remain unbalanced for that duration.
> 
> Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
> ---
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff -up sched/fair.c{.orig,}
> --- sched/fair.c.orig	2012-03-07 08:33:03.000000000 -0800
> +++ sched/fair.c	2012-03-07 13:50:30.787265795 -0800

This doesn't work, patches should apply with -p1. I just read
Documentation/SubmittingPatches and I must admit to that not being very
clear.

In any case, I can recommend to using quilt or git to create patches.

I've hand edited the patch for now, but in future please learn to use
either of these tools.

Final patch for re{f,v}erence.. :-)
---
Subject: scheduler: domain: correctly initialize 'next_balance' in 'nohz' idle balancer
From: Diwakar Tundlam <dtundlam@nvidia.com>
Date: Wed, 7 Mar 2012 14:44:26 -0800

The 'next_balance' field of 'nohz' idle balancer must be initialized
to jiffies. Since jiffies is initialized to negative 300 seconds the
'nohz' idle balancer does not run for the first 300s (5mins) after
bootup. If no new processes are spawed or no idle cycles happen, the
load on the cpus will remain unbalanced for that duration.

Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com
---
 kernel/sched/fair.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5603,6 +5603,7 @@ __init void init_sched_fair_class(void)
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 
 #ifdef CONFIG_NO_HZ
+	nohz.next_balance = jiffies;
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	cpu_notifier(sched_ilb_notifier, 0);
 #endif

