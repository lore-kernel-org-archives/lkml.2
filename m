Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1AAPYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 10:24:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab1AAPYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 10:24:06 -0500
Subject: Re: [PATCH wq#for-2.6.38] workqueue: use WQ_MEM_RECLAIM instead of
 WQ_RESCUER
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Neil Brown <neilb@suse.de>
In-Reply-To: <20101231140109.GL18831@htj.dyndns.org>
References: <20101231140109.GL18831@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Sat, 01 Jan 2011 15:24:36 +0000
Message-ID: <1293895476.2432.13.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The GFS2 part of this is already in the -nmw git tree and you acked the
patch when I originally wrote it :-) So it will be merged at the next
merge window,

Steve.

On Fri, 2010-12-31 at 15:01 +0100, Tejun Heo wrote:
> WQ_RESCUER is now an internal flag and should only be used in the
> workqueue implementation proper.  Use WQ_MEM_RECLAIM instead.
> 
> This doesn't introduce any functional difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: dm-devel@redhat.com
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Neil Brown <neilb@suse.de>
> ---
> As this is trivial, I'd like to carry this through the wq tree if
> there's no objection.
> 
> Thank you.
> 
>  drivers/md/md.c    |    2 +-
>  fs/gfs2/glock.c    |    8 ++++----
>  fs/nfs/inode.c     |    2 +-
>  net/sunrpc/sched.c |    2 +-
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 84c46a1..66a01f7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7287,7 +7287,7 @@ static int __init md_init(void)
>  {
>  	int ret = -ENOMEM;
>  
> -	md_wq = alloc_workqueue("md", WQ_RESCUER, 0);
> +	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
>  	if (!md_wq)
>  		goto err_wq;
>  
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index f92c177..beea184 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -1782,12 +1782,12 @@ int __init gfs2_glock_init(void)
>  	}
>  #endif
>  
> -	glock_workqueue = alloc_workqueue("glock_workqueue", WQ_RESCUER |
> -					  WQ_HIGHPRI | WQ_FREEZEABLE, 0);
> +	glock_workqueue = alloc_workqueue("glock_workqueue",
> +				WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_FREEZEABLE, 0);
>  	if (IS_ERR(glock_workqueue))
>  		return PTR_ERR(glock_workqueue);
> -	gfs2_delete_workqueue = alloc_workqueue("delete_workqueue", WQ_RESCUER |
> -						WQ_FREEZEABLE, 0);
> +	gfs2_delete_workqueue = alloc_workqueue("delete_workqueue",
> +					WQ_MEM_RECLAIM | WQ_FREEZEABLE, 0);
>  	if (IS_ERR(gfs2_delete_workqueue)) {
>  		destroy_workqueue(glock_workqueue);
>  		return PTR_ERR(gfs2_delete_workqueue);
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 314f571..9403f3f 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -1497,7 +1497,7 @@ static int nfsiod_start(void)
>  {
>  	struct workqueue_struct *wq;
>  	dprintk("RPC:       creating workqueue nfsiod\n");
> -	wq = alloc_workqueue("nfsiod", WQ_RESCUER, 0);
> +	wq = alloc_workqueue("nfsiod", WQ_MEM_RECLAIM, 0);
>  	if (wq == NULL)
>  		return -ENOMEM;
>  	nfsiod_workqueue = wq;
> diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
> index 243fc09..2841cc6 100644
> --- a/net/sunrpc/sched.c
> +++ b/net/sunrpc/sched.c
> @@ -908,7 +908,7 @@ static int rpciod_start(void)
>  	 * Create the rpciod thread and wait for it to start.
>  	 */
>  	dprintk("RPC:       creating workqueue rpciod\n");
> -	wq = alloc_workqueue("rpciod", WQ_RESCUER, 0);
> +	wq = alloc_workqueue("rpciod", WQ_MEM_RECLAIM, 0);
>  	rpciod_workqueue = wq;
>  	return rpciod_workqueue != NULL;
>  }


