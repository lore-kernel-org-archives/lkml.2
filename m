Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab0LNWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:25:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758361Ab0LNWZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:25:26 -0500
Date: Tue, 14 Dec 2010 17:25:19 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: don't check cfqg in choose_service_tree()
Message-ID: <20101214222519.GA19693@redhat.com>
References: <4D070F7C.3060503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D070F7C.3060503@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 02:32:28PM +0800, Gui Jianfeng wrote:
> When cfq_choose_cfqg() is called in select_queue(), there must be at least one
> backlogged CFQ queue waiting for dispatching, hence there must be at least one
> backlogged CFQ group on service tree. So we never call choose_service_tree()
> with cfqg == NULL.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---

Thanks Gui for the cleanup. This patch looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

>  block/cfq-iosched.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 9b186fd..c19d015 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2103,12 +2103,6 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	unsigned group_slice;
>  	enum wl_prio_t original_prio = cfqd->serving_prio;
>  
> -	if (!cfqg) {
> -		cfqd->serving_prio = IDLE_WORKLOAD;
> -		cfqd->workload_expires = jiffies + 1;
> -		return;
> -	}
> -
>  	/* Choose next priority. RT > BE > IDLE */
>  	if (cfq_group_busy_queues_wl(RT_WORKLOAD, cfqd, cfqg))
>  		cfqd->serving_prio = RT_WORKLOAD;
> -- 
> 1.6.5.2
> 
