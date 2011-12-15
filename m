Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849Ab1LOXW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:22:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47668 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759828Ab1LOXWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:22:16 -0500
Date: Thu, 15 Dec 2011 18:22:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH 1/3] usb: musb: fix pm_runtime mismatches
In-Reply-To: <1323990310-11905-2-git-send-email-felipe.contreras@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1112151821360.1644-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011, Felipe Contreras wrote:

> Properly call pm_runtime_put() afer pm_runttime_get() on errors.
> 
> Untested.
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  drivers/usb/musb/musb_gadget.c |    1 +
>  drivers/usb/musb/omap2430.c    |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> index 922148f..95bfd2d 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -1960,6 +1960,7 @@ static int musb_gadget_start(struct usb_gadget *g,
>  err2:
>  	if (!is_otg_enabled(musb))
>  		musb_stop(musb);
> +	pm_runtime_put(musb->controller);
>  err0:
>  	return retval;
>  }
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index ba85f27..4edfb91 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -385,6 +385,7 @@ static void omap2430_musb_disable(struct musb *musb)
>  
>  static int omap2430_musb_exit(struct musb *musb)
>  {
> +	pm_runtime_put(musb->controller);
>  	del_timer_sync(&musb_idle_timer);
>  
>  	omap2430_low_level_exit(musb);

Should these calls be pm_runtime_put_sync() instead of 
pm_runtime_put()?

Alan Stern

