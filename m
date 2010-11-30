Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0K3OX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:23:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab0K3OXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:23:55 -0500
Date: Tue, 30 Nov 2010 09:23:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: Get rid of on_st flag
Message-ID: <20101130142349.GA26758@redhat.com>
References: <4CF4B8BB.7050106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF4B8BB.7050106@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 04:41:31PM +0800, Gui Jianfeng wrote:
> It's able to check whether a CFQ group on a service tree by
> checking "cfqg->rb_node". There's no need to maintain an
> extra flag here.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/cfq-iosched.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index e18d316..5d0349d 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -179,7 +179,6 @@ struct cfq_group {
>  	/* group service_tree key */
>  	u64 vdisktime;
>  	unsigned int weight;
> -	bool on_st;
>  
>  	/* number of cfqq currently on this group */
>  	int nr_cfqq;
> @@ -863,7 +862,7 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	struct rb_node *n;
>  
>  	cfqg->nr_cfqq++;
> -	if (cfqg->on_st)
> +	if (!RB_EMPTY_NODE(&cfqg->rb_node))
>  		return;
>  
>  	/*
> @@ -879,7 +878,6 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  		cfqg->vdisktime = st->min_vdisktime;
>  
>  	__cfq_group_service_tree_add(st, cfqg);
> -	cfqg->on_st = true;
>  	st->total_weight += cfqg->weight;
>  }
>  
> @@ -896,7 +894,6 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  		return;
>  
>  	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
> -	cfqg->on_st = false;
>  	st->total_weight -= cfqg->weight;
>  	if (!RB_EMPTY_NODE(&cfqg->rb_node))
>  		cfq_rb_erase(&cfqg->rb_node, st);
> -- 
> 1.6.5.2
> 
