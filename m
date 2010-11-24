Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0KXFSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:18:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:50298 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab0KXFSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:18:23 -0500
Date: Wed, 24 Nov 2010 16:18:13 +1100
From: Neil Brown <neilb@suse.de>
To: djwong@us.ibm.com
Cc: linux-raid@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] md: Call blk_queue_flush() to establish flush/fua
 support
Message-ID: <20101124161813.2f5bc0d6@notabene.brown>
In-Reply-To: <20101123190103.GW14383@tux1.beaverton.ibm.com>
References: <20101122232208.GU14383@tux1.beaverton.ibm.com>
	<20101123105000.331b40f8@notabene.brown>
	<20101123190103.GW14383@tux1.beaverton.ibm.com>
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 11:01:03 -0800
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> Here's a shorter version that sets up flush/fua unconditionally.
> ---
> Before 2.6.37, the md layer had a mechanism for catching I/Os with the barrier
> flag set, and translating the barrier into barriers for all the underlying
> devices.  With 2.6.37, I/O barriers have become plain old flushes, and the md
> code was updated to reflect this.  However, one piece was left out -- the md
> layer does not tell the block layer that it supports flushes or FUA access at
> all, which results in md silently dropping flush requests.
> 
> Since the support already seems there, just add this one piece of bookkeeping.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/md/md.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 324a366..43243a4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4338,6 +4338,8 @@ static int md_alloc(dev_t dev, char *name)
>  	if (mddev->kobj.sd &&
>  	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
>  		printk(KERN_DEBUG "pointless warning\n");
> +
> +	blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
>   abort:
>  	mutex_unlock(&disks_mutex);
>  	if (!error && mddev->kobj.sd) {


Applied, thanks.

NeilBrown

