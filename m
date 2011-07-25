Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1GYPoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:44:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43869 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab1GYPoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:44:12 -0400
Subject: Re: [RFC][PATCH] musb: Avoid musb_gadget_pullup "Unhandled fault"
 oops on omap4
From: john stultz <johnstul@us.ibm.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <1311206974.2945.198.camel@work-vm>
References: <1311206974.2945.198.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 08:43:54 -0700
Message-ID: <1311608634.2945.265.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 17:09 -0700, John Stultz wrote:
> I've recently run across an "Unhandled fault: imprecise external abort"
> oops that is caused when a driver called usb_gadget_connect() when there
> was no cable plugged into the musb gadget port.

Felipe: Ping? Any thoughts on this patch?

thanks
-john


> Reported-by: Zach Pfeffer <zach.pfeffer@linaro.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> 
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> index 6aeb363..548338c 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -1698,6 +1698,8 @@ static int musb_gadget_pullup(struct usb_gadget *gadget, int is_on)
>  
>  	is_on = !!is_on;
>  
> +	pm_runtime_get_sync(musb->controller);
> +
>  	/* NOTE: this assumes we are sensing vbus; we'd rather
>  	 * not pullup unless the B-session is active.
>  	 */
> @@ -1707,6 +1709,9 @@ static int musb_gadget_pullup(struct usb_gadget *gadget, int is_on)
>  		musb_pullup(musb, is_on);
>  	}
>  	spin_unlock_irqrestore(&musb->lock, flags);
> +
> +	pm_runtime_put(musb->controller);
> +
>  	return 0;
>  }
>  
> 


