Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0ESBVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:21:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45690 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab0ESBU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:20:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] mm: remove all rcu head initializations
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@efficios.com
In-Reply-To: <20100518190932.GA6982@linux.vnet.ibm.com>
References: <20100518190932.GA6982@linux.vnet.ibm.com>
Message-Id: <20100519101730.881B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 19 May 2010 10:20:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hello!
> 
> Would you guys like to carry this patch, or should I push it up
> -tip?  If I don't hear otherwise from you, I will push it up -tip.
> The INIT_RCU_HEAD() primitive is going away in favor of debugobjects.
> 
> 							Thanx, Paul

Personally, I don't think this patch can make major conflict. So, I guess
-tip is best.

Thanks.


> 
> ------------------------------------------------------------------------
> 
> mm: remove all rcu head initializations
> 
> Remove all rcu head inits. We don't care about the RCU head state before passing
> it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
> keep track of objects on stack.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 707d0dc..f03d8d6 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -663,7 +663,6 @@ int bdi_init(struct backing_dev_info *bdi)
>  	bdi->max_ratio = 100;
>  	bdi->max_prop_frac = PROP_FRAC_BASE;
>  	spin_lock_init(&bdi->wb_lock);
> -	INIT_RCU_HEAD(&bdi->rcu_head);
>  	INIT_LIST_HEAD(&bdi->bdi_list);
>  	INIT_LIST_HEAD(&bdi->wb_list);
>  	INIT_LIST_HEAD(&bdi->work_list);
> diff --git a/mm/slob.c b/mm/slob.c
> index 837ebd6..6de238d 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -647,7 +647,6 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
>  	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
>  		struct slob_rcu *slob_rcu;
>  		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
> -		INIT_RCU_HEAD(&slob_rcu->head);
>  		slob_rcu->size = c->size;
>  		call_rcu(&slob_rcu->head, kmem_rcu_free);
>  	} else {
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



