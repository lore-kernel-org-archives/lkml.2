Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2KPIdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:33:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62777 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2KPIc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:32:59 -0500
Message-ID: <50A5FA32.4000903@gmail.com>
Date: Fri, 16 Nov 2012 16:32:50 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Shan Wei <shanwei88@gmail.com>, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH v3 6/9] rcu: use __this_cpu_read helper instead of per_cpu_ptr(p,
 raw_smp_processor_id())
References: <50A1A7E8.4010802@gmail.com>
In-Reply-To: <50A1A7E8.4010802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shan Wei said, at 2012/11/13 9:52:
> From: Shan Wei <davidshan@tencent.com>
> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> Acked-by: Christoph Lameter <cl@linux.com>

Paul, would you like to pick it up to your tree?

> ---
> no changes vs v3,v2.
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
>  	for (; rnp != NULL; rnp = rnp->parent) {
>  		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
>  		      !raw_spin_trylock(&rnp->fqslock);
> 

