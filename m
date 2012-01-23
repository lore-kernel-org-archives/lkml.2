Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2AWPBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:01:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab2AWPA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:00:57 -0500
Date: Mon, 23 Jan 2012 10:00:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] blkcg: make CONFIG_BLK_CGROUP bool
Message-ID: <20120123150051.GC25986@redhat.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327202725-3383-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 07:25:09PM -0800, Tejun Heo wrote:
> Block cgroup core can be built as module; however, it isn't too useful
> as blk-throttle can only be built-in and cfq-iosched is usually the
> default built-in scheduler.  Scheduled blkcg cleanup requires calling
> into blkcg from block core.  To simplify that, disallow building blkcg
> as module by making CONFIG_BLK_CGROUP bool.
> 
> If building blkcg core as module really matters, which I doubt, we can
> revisit it after blkcg API cleanup.

I think not allowing compiling blk-cgroup as module is a good thing.

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/Kconfig.iosched |    5 +----
>  block/blk-cgroup.c    |   17 -----------------
>  block/blk-cgroup.h    |   10 ++--------
>  init/Kconfig          |    2 +-
>  4 files changed, 4 insertions(+), 30 deletions(-)
> 
> diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
> index 3199b76..8dca96d 100644
> --- a/block/Kconfig.iosched
> +++ b/block/Kconfig.iosched
> @@ -23,8 +23,7 @@ config IOSCHED_DEADLINE
>  
>  config IOSCHED_CFQ
>  	tristate "CFQ I/O scheduler"
> -	# If BLK_CGROUP is a module, CFQ has to be built as module.
> -	depends on (BLK_CGROUP=m && m) || !BLK_CGROUP || BLK_CGROUP=y
> +	depends on BLK_CGROUP

You don't need above dependency now. Otherwise if BLK_CGROUP=n then one
can't use CFQ. We just want cfq group scheduling to be dependent on
BLK_CGROUP.

Thanks
Vivek
