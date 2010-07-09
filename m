Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0GINSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:18:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab0GINSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:18:07 -0400
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <1278626014.2834.74.camel@sbs-t61.sc.intel.com>
References: <1278088816.1917.279.camel@laptop>
	 <1278089799-11949-1-git-send-email-venki@google.com>
	 <1278598336.1900.150.camel@laptop>
	 <1278611133.2834.10.camel@sbs-t61.sc.intel.com>
	 <1278612989.1900.176.camel@laptop>
	 <1278626014.2834.74.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 15:17:47 +0200
Message-ID: <1278681467.1900.199.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 14:53 -0700, Suresh Siddha wrote:

> Also, looking at all this, don't we need to do something like this in
> the nohz load balance?

Yes, I think you're right, thanks!

> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 9910e1b..ae750e9 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3598,6 +3598,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
>  		}
>  
>  		raw_spin_lock_irq(&this_rq->lock);
> +		update_rq_clock(this_rq);
>  		update_cpu_load(this_rq);
>  		raw_spin_unlock_irq(&this_rq->lock);


