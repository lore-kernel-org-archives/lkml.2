Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1CBU7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:59:49 -0500
Received: from kroah.org ([198.145.64.141]:33955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab1CBU7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:59:48 -0500
Date: Wed, 2 Mar 2011 16:00:20 -0500
From: Greg KH <greg@kroah.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: gregkh@suse.de, haiyangz@microsoft.com, hjanssen@microsoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: Staging: hv: netvsc_drv.c: no assignment within if +
 whitespace clean up
Message-ID: <20110302210020.GA20485@kroah.com>
References: <1299087367-7580-1-git-send-email-toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1299087367-7580-1-git-send-email-toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 06:36:07PM +0100, Toralf Förster wrote:
> This patch fixes all complaints of checkpatch.pl.
> 
> Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
> ---
>  drivers/staging/hv/netvsc_drv.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
> index b41c964..2f3a9e9 100644
> --- a/drivers/staging/hv/netvsc_drv.c
> +++ b/drivers/staging/hv/netvsc_drv.c
> @@ -126,8 +126,9 @@ static void netvsc_xmit_completion(void *context)
>  
>  		dev_kfree_skb_any(skb);
>  
> -		if ((net_device_ctx->avail += num_pages) >= PACKET_PAGES_HIWATER)
> -			netif_wake_queue(net);
> +		net_device_ctx->avail += num_pages;
> +		if (net_device_ctx->avail >= PACKET_PAGES_HIWATER)
> +			netif_wake_queue(net);

This fix is already in the linux-next tree, what tree did you diff this
against?

You can't make staging tree cleanups against Linus's tree, sorry, they
need to be against linux-next in order to properly get all of the
pending patches already queued up.

thanks,

greg k-h
