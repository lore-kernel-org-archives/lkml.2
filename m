Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3AHQ7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:59:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab3AHQ7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:59:46 -0500
Date: Tue, 8 Jan 2013 11:59:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 18/24] blkcg: s/blkg_rwstat_sum()/blkg_rwstat_total()/
Message-ID: <20130108165939.GI29635@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-19-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-19-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:40PM -0800, Tejun Heo wrote:
> Rename blkg_rwstat_sum() to blkg_rwstat_total().  sum will be used for
> summing up stats from multiple blkgs.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/blk-cgroup.h  | 4 ++--
>  block/cfq-iosched.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 678e89e..586c0ac 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -461,14 +461,14 @@ static inline struct blkg_rwstat blkg_rwstat_read(struct blkg_rwstat *rwstat)
>  }
>  
>  /**
> - * blkg_rwstat_sum - read the total count of a blkg_rwstat
> + * blkg_rwstat_total - read the total count of a blkg_rwstat
>   * @rwstat: blkg_rwstat to read
>   *
>   * Return the total count of @rwstat regardless of the IO direction.  This
>   * function can be called without synchronization and takes care of u64
>   * atomicity.
>   */
> -static inline uint64_t blkg_rwstat_sum(struct blkg_rwstat *rwstat)
> +static inline uint64_t blkg_rwstat_total(struct blkg_rwstat *rwstat)
>  {
>  	struct blkg_rwstat tmp = blkg_rwstat_read(rwstat);
>  
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index e8f3106..d43145cc 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -536,7 +536,7 @@ static void cfqg_stats_set_start_empty_time(struct cfq_group *cfqg)
>  {
>  	struct cfqg_stats *stats = &cfqg->stats;
>  
> -	if (blkg_rwstat_sum(&stats->queued))
> +	if (blkg_rwstat_total(&stats->queued))
>  		return;
>  
>  	/*
> @@ -580,7 +580,7 @@ static void cfqg_stats_update_avg_queue_size(struct cfq_group *cfqg)
>  	struct cfqg_stats *stats = &cfqg->stats;
>  
>  	blkg_stat_add(&stats->avg_queue_size_sum,
> -		      blkg_rwstat_sum(&stats->queued));
> +		      blkg_rwstat_total(&stats->queued));
>  	blkg_stat_add(&stats->avg_queue_size_samples, 1);
>  	cfqg_stats_update_group_wait_time(stats);
>  }
> -- 
> 1.8.0.2
