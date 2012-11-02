Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab2KBSLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:11:04 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60559 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602Ab2KBSLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:11:02 -0400
Date: Fri, 2 Nov 2012 11:10:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Shan Wei <shanwei88@gmail.com>
Cc: dipankar@in.ibm.com, Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org
Subject: Re: [PATCH v2 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
Message-ID: <20121102181026.GY3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5093EE6B.3070906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5093EE6B.3070906@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110218-7408-0000-0000-000009EA04B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 12:01:47AM +0800, Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> ---
>  kernel/rcutree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 74df86b..441b945 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1960,7 +1960,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
>  	struct rcu_node *rnp_old = NULL;
> 
>  	/* Funnel through hierarchy to reduce memory contention. */
> -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> +	rnp = __this_cpu_read(rsp->rda->mynode);

OK, I'll bite...  Why this instead of:

	rnp = __this_cpu_read(rsp->rda)->mynode;

							Thanx, Paul

>  	for (; rnp != NULL; rnp = rnp->parent) {
>  		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
>  		      !raw_spin_trylock(&rnp->fqslock);
> -- 
> 1.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

