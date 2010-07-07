Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980Ab0GGEOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 00:14:11 -0400
Received: from 1wt.eu ([62.212.114.60]:39076 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab0GGEOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 00:14:09 -0400
Date: Wed, 7 Jul 2010 06:13:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/panel: Prevent double-calling of
 parport_release - fix oops.
Message-ID: <20100707041357.GE12126@1wt.eu>
References: <201007070452.16860.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007070452.16860.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 04:52:16AM +0200, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch prevents the code from calling parport_release and
> parport_unregister_device twice with the same arguments - and thus fixes an oops.
> 
> Rationale:
> After the first call the parport is already released and the
> handle isn't valid anymore and calling parport_release and
> parport_unregister_device twice isn't a good idea.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> KernelVersion: linux-next-20100607
> 
>  drivers/staging/panel/panel.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> index 3154ffe..6fa57be 100644
> --- a/drivers/staging/panel/panel.c
> +++ b/drivers/staging/panel/panel.c
> @@ -2277,6 +2277,7 @@ int panel_init(void)
>  		if (pprt) {
>  			parport_release(pprt);
>  			parport_unregister_device(pprt);
> +			pprt = NULL;
>  		}
>  		parport_unregister_driver(&panel_driver);
>  		printk(KERN_ERR "Panel driver version " PANEL_VERSION
> @@ -2327,6 +2328,7 @@ static void __exit panel_cleanup_module(void)
>  		/* TODO: free all input signals */
>  		parport_release(pprt);
>  		parport_unregister_device(pprt);
> +		pprt = NULL;
>  	}
>  	parport_unregister_driver(&panel_driver);
>  }
> -- 
> 1.7.1

look fine, ACK by me !

Willy

