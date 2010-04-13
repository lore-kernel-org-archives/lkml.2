Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab0DMM3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 08:29:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0DMM3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:29:37 -0400
Subject: Re: [PATCH 5/5] sched: make fix_small_imbalance work with
 asymmetric packing
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100409062119.10AC5CBB6D@localhost.localdomain>
References: <20100409062119.10AC5CBB6D@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 14:29:29 +0200
Message-ID: <1271161769.4807.1283.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 16:21 +1000, Michael Neuling wrote:
> With the asymmetric packing infrastructure, fix_small_imbalance is
> causing idle higher threads to pull tasks off lower threads.  
> 
> This is being caused by an off-by-one error.  
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
> I'm not sure this is the right fix but without it, higher threads pull
> tasks off the lower threads, then the packing pulls it back down, etc
> etc and tasks bounce around constantly.

Would help if you expand upon the why/how it manages to get pulled up.

I can't immediately spot anything wrong with the patch, but then that
isn't my favourite piece of code either.. Suresh, any comments?

> ---
> 
>  kernel/sched_fair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-ozlabs/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/kernel/sched_fair.c
> +++ linux-2.6-ozlabs/kernel/sched_fair.c
> @@ -2652,7 +2652,7 @@ static inline void fix_small_imbalance(s
>  						 * SCHED_LOAD_SCALE;
>  	scaled_busy_load_per_task /= sds->busiest->cpu_power;
>  
> -	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
> +	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >
>  			(scaled_busy_load_per_task * imbn)) {
>  		*imbalance = sds->busiest_load_per_task;
>  		return;

