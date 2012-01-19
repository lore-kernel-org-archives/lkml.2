Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab2ASLVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:21:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab2ASLVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:21:08 -0500
Date: Thu, 19 Jan 2012 06:21:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] blkcg: update blkg get functions take blkio_cgroup
 as parameter
Message-ID: <20120119112102.GD2649@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326935490-11827-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 05:11:23PM -0800, Tejun Heo wrote:

[..]
> -static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
> +static struct throtl_grp *throtl_get_tg(struct throtl_data *td,
> +					struct blkio_cgroup *blkcg)
>  {
>  	struct throtl_grp *tg = NULL, *__tg = NULL;
> -	struct blkio_cgroup *blkcg;
>  	struct request_queue *q = td->queue;
>  
>  	/* no throttling for dead queue */
>  	if (unlikely(blk_queue_dead(q)))
>  		return NULL;
>  
> -	blkcg = task_blkio_cgroup(current);
>  	tg = throtl_find_tg(td, blkcg);
>  	if (tg)
>  		return tg;
>  
> +	if (!css_tryget(&blkcg->css))
> +		return NULL;
> +

This reference is to make sure that blkcg does not go away while we drop
the rcu lock and do the group allocation?

Thanks
Vivek
