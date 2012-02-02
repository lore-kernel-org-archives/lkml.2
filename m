Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2BBWrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:47:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab2BBWrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:47:14 -0500
Date: Thu, 2 Feb 2012 17:47:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] blkcg: move per-queue blkg list heads and counters
 to queue and blkg
Message-ID: <20120202224708.GF1723@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328131156-13290-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 01:19:14PM -0800, Tejun Heo wrote:

[..]
> diff --git a/block/blk-core.c b/block/blk-core.c
> index ab0a11b..025ef60 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -546,6 +546,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
>  	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
>  	INIT_LIST_HEAD(&q->timeout_list);
>  	INIT_LIST_HEAD(&q->icq_list);
> +#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)

BLK_CGROUP_MODULE not required as you got rid of this possiblity in the
first patch itself

>  
>  	struct list_head	icq_list;
> +#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)

Ditto.

Thanks
Vivek
