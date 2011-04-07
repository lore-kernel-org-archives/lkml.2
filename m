Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1DGNeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:34:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:32861 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751087Ab1DGNeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:34:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+C1QsJVROC1SYlJ2cp60S1YPoyumpC4+52FzG84p
	mbyRlO/gWcVhwV
Subject: Re: [PATCH]sched: convert wall-time to vruntime for
 check_preempt_tick
From: Mike Galbraith <efault@gmx.de>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, zheng.z.yan@intel.com
In-Reply-To: <20110407124332.GA31809@sli10-conroe.sh.intel.com>
References: <20110407124332.GA31809@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 15:34:20 +0200
Message-ID: <1302183260.8065.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 20:43 +0800, Shaohua Li wrote:
> In check_preempt_tick(), delta is vruntime and ideal_runtime is wall runtime.
> Comparing vruntime and ideal_runtime looks buggy.

Why is that buggy?  It's a distance in units ns, ala wakeup_granularity,
a number.  This number just happens to be variable.

> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 3f7ec9e..0b76e3a 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1121,7 +1121,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  		if (delta < 0)
>  			return;
>  
> -		if (delta > ideal_runtime)
> +		if (delta > calc_delta_fair(ideal_runtime, curr))
>  			resched_task(rq_of(cfs_rq)->curr);
>  	}
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


