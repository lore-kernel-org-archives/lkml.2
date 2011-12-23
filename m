Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1LWBA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 20:00:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab1LWBAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 20:00:53 -0500
Date: Thu, 22 Dec 2011 20:00:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] block: fix deadlock through percpu allocation in
 blk-cgroup
Message-ID: <20111223010042.GA12738@redhat.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
 <1324590326-10135-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324590326-10135-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 01:45:26PM -0800, Tejun Heo wrote:

[..]
> +/*
> + * Percpu mempool for blkgio_group_stats_cpu which are allocated on-demand
> + * on IO path.  As percpu doesn't support NOIO allocations, we need to
> + * buffer them through mempool.
> + */
> +struct percpu_mempool *blkg_stats_cpu_pool;
> +EXPORT_SYMBOL_GPL(blkg_stats_cpu_pool);
> +

Thanks for this work Tejun.

So this pool is global and shared by all devices (both by CFQ and
throttling logic). I am not sure if there are any advantages of having
this pool per queue. In one of the mails you mentioned that dm is having
one pool across many devices which defeats the purpose of having mempool.

**********************************************************************
It seemed the problem was dm sharing the same pool from multiple devices
(which defeats the purpose of using mempool BTW)
*********************************************************************

Not sure why devices sharing a mempool is a bad idea. Having a global pool
definitely simplifies the implementation a lot in this case.

Thanks
Vivek
