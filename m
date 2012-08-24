Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524Ab2HXVLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:11:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab2HXVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:11:09 -0400
Date: Fri, 24 Aug 2012 14:11:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] aoe: for performance support larger packet
 payloads
Message-Id: <20120824141108.27da5e79.akpm@linux-foundation.org>
In-Reply-To: <7c895879cfd1e15dd76c2469b417b48d0462d7df.1345743801.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
	<7c895879cfd1e15dd76c2469b417b48d0462d7df.1345743801.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2012 21:18:37 -0400
Ed Cashin <ecashin@coraid.com> wrote:

> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -279,6 +279,9 @@ aoeblk_gdalloc(void *vp)
>  	if (bdi_init(&d->blkq->backing_dev_info))
>  		goto err_blkq;
>  	spin_lock_irqsave(&d->lock, flags);
> +	blk_queue_max_hw_sectors(d->blkq, BLK_DEF_MAX_SECTORS);
> +	d->blkq->backing_dev_info.ra_pages = BLK_DEF_MAX_SECTORS * 1024;
> +	d->blkq->backing_dev_info.ra_pages /= PAGE_CACHE_SIZE;

This seems a bit abusive of BLK_DEF_MAX_SECTORS, which is in units of
512-byte sectors.  (BLK_DEF_MAX_SECTORS * 512)/PAGE_CACHE_SIZE would
make sense.


