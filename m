Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2KBUWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:22:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab2KBUWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:22:36 -0400
Date: Fri, 2 Nov 2012 16:22:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robin Dong <sanbai@taobao.com>
Subject: Re: [PATCH 1/2 v5] block/throttle: remove redundant type transition
Message-ID: <20121102202232.GU3300@redhat.com>
References: <1351848697-26087-1-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351848697-26087-1-git-send-email-robin.k.dong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 05:31:36PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> We don't need to convert tg to blkg and then convert it back in
> throtl_update_dispatch_stats().
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

>  block/blk-throttle.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index a9664fa..46ddeff 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -674,10 +674,9 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
>  	return 0;
>  }
>  
> -static void throtl_update_dispatch_stats(struct blkcg_gq *blkg, u64 bytes,
> +static void throtl_update_dispatch_stats(struct throtl_grp *tg, u64 bytes,
>  					 int rw)
>  {
> -	struct throtl_grp *tg = blkg_to_tg(blkg);
>  	struct tg_stats_cpu *stats_cpu;
>  	unsigned long flags;
>  
> @@ -708,7 +707,7 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
>  	tg->bytes_disp[rw] += bio->bi_size;
>  	tg->io_disp[rw]++;
>  
> -	throtl_update_dispatch_stats(tg_to_blkg(tg), bio->bi_size, bio->bi_rw);
> +	throtl_update_dispatch_stats(tg, bio->bi_size, bio->bi_rw);
>  }
>  
>  static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
> @@ -1127,7 +1126,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
>  	tg = throtl_lookup_tg(td, blkcg);
>  	if (tg) {
>  		if (tg_no_rule_group(tg, rw)) {
> -			throtl_update_dispatch_stats(tg_to_blkg(tg),
> +			throtl_update_dispatch_stats(tg,
>  						     bio->bi_size, bio->bi_rw);
>  			goto out_unlock_rcu;
>  		}
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
