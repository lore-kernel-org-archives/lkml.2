Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab1HAWKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 18:10:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:48050 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1HAWKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 18:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,302,1309762800"; 
   d="scan'208";a="34411645"
Date: Mon, 1 Aug 2011 15:10:19 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andiry Xu <andiry.xu@amd.com>, Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH][Resend] USB: Remove test for NULL that'll never happen
 in usb_disconnect()
Message-ID: <20110801221019.GA22726@xanatos>
References: <alpine.LNX.2.00.1108020001310.31999@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1108020001310.31999@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

You probably need to send this directly to Greg, instead of to the list.
I'm not sure if Greg's still on vacation, so resend in a couple days if
you don't hear from him.

Sarah Sharp

On Tue, Aug 02, 2011 at 12:03:24AM +0200, Jesper Juhl wrote:
> In drivers/usb/core/hub.c::usb_disconnect(), 'udev' will never be
> NULL, so remove the test and printing of debug message.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/core/hub.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index a428aa0..99fff6b 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1636,11 +1636,6 @@ void usb_disconnect(struct usb_device **pdev)
>  	int			i;
>  	struct usb_hcd		*hcd = bus_to_hcd(udev->bus);
>  
> -	if (!udev) {
> -		pr_debug ("%s nodev\n", __func__);
> -		return;
> -	}
> -
>  	/* mark the device as inactive, so any further urb submissions for
>  	 * this device (and any of its children) will fail immediately.
>  	 * this quiesces everything except pending urbs.
> -- 
> 1.7.6
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
