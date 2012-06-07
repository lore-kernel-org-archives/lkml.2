Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047Ab2FGPH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:07:56 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46441 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760909Ab2FGPHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:07:54 -0400
From: Oliver Neukum <oliver@neukum.org>
To: stefani@seibold.net
Subject: Re: [PATCH 03/13] remove dead code
Date: Thu, 7 Jun 2012 17:04:39 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org
References: <1339057243-10029-1-git-send-email-stefani@seibold.net> <1339057243-10029-4-git-send-email-stefani@seibold.net>
In-Reply-To: <1339057243-10029-4-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206071704.39688.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 7. Juni 2012, 10:20:33 schrieb stefani@seibold.net:
> From: Stefani Seibold <stefani@seibold.net>
> 
> All code which use processed_urb can be eliminated.

If you eliminate it, how do you balance the completion?

	Regards
		Oliver
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  drivers/usb/usb-skeleton.c |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
> index 7385aa8..92cdfca 100644
> --- a/drivers/usb/usb-skeleton.c
> +++ b/drivers/usb/usb-skeleton.c
> @@ -59,7 +59,6 @@ struct usb_skel {
>  	__u8			bulk_out_endpointAddr;	/* the address of the bulk out endpoint */
>  	int			errors;			/* the last request tanked */
>  	bool			ongoing_read;		/* a read is going on */
> -	bool			processed_urb;		/* indicates we haven't processed the urb */
>  	spinlock_t		err_lock;		/* lock for errors */
>  	struct kref		kref;
>  	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
> @@ -256,17 +255,6 @@ retry:
>  		 * we must finish now
>  		 */
>  		dev->bulk_in_copied = 0;
> -		dev->processed_urb = true;
> -	}
> -
> -	if (!dev->processed_urb) {
> -		/*
> -		 * the URB hasn't been processed
> -		 * do it now
> -		 */
> -		wait_for_completion(&dev->bulk_in_completion);
> -		dev->bulk_in_copied = 0;
> -		dev->processed_urb = true;
>  	}
>  
>  	/* errors must be reported */
> -- 
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


