Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3ABTih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:38:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3ABTif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:38:35 -0500
Date: Wed, 2 Jan 2013 14:38:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 17/24] blkcg: implement blkcg_policy->on/offline_pd_fn()
 and blkcg_gq->online
Message-ID: <20130102193828.GE4306@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-18-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-18-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:39PM -0800, Tejun Heo wrote:

[..]
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 40f5b97..678e89e 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -106,12 +106,17 @@ struct blkcg_gq {
>  	/* reference count */
>  	int				refcnt;
>  
> +	/* is this blkg online? protected by both blkcg and q locks */
> +	bool				online;
> +

Hi Tejun,

What does above mean? One needs to take one lock or both the locks to
check/modify blkg->online.

Thanks
Vivek
