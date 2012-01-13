Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2AMBfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:35:48 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:25264
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab2AMBfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:35:43 -0500
X-SpamScore: -14
X-BigFish: VS-14(z6c9Mz1432N98dKzz1202hzz8275dhz2dhc1ahc1bh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Fri, 13 Jan 2012 09:35:09 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Michael Thalmeier <michael.thalmeier@hale.at>
CC: Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michael@thalmeier.at>
Subject: Re: [PATCH] usb/gadget/fsl_udc_core.c: fix oops on resume
Message-ID: <20120113013508.GA19288@nchen-desktop>
References: <1326271577-13418-1-git-send-email-michael.thalmeier@hale.at>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1326271577-13418-1-git-send-email-michael.thalmeier@hale.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 09:46:17AM +0100, Michael Thalmeier wrote:
> Sometimes the fsl_udc_irq function oopses when waking up from suspend.
What's the situation it will happen? The udc driver will bind with gadget
first, then open the interrupt enable. When unload gadget driver, it will
disable all interrupt bits first, then unbind the gadget driver.
> 
> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
> ---
>  drivers/usb/gadget/fsl_udc_core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
> index d7ea6c0..4070c7a 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -1749,7 +1749,7 @@ static void suspend_irq(struct fsl_udc *udc)
>  	udc->usb_state = USB_STATE_SUSPENDED;
>  
>  	/* report suspend to the driver, serial.c does not support this */
> -	if (udc->driver->suspend)
> +	if (udc->driver && udc->driver->suspend)
>  		udc->driver->suspend(&udc->gadget);
>  }
>  
> @@ -1759,7 +1759,7 @@ static void bus_resume(struct fsl_udc *udc)
>  	udc->resume_state = 0;
>  
>  	/* report resume to the driver, serial.c does not support this */
> -	if (udc->driver->resume)
> +	if (udc->driver && udc->driver->resume)
>  		udc->driver->resume(&udc->gadget);
>  }
>  
> -- 
> 1.7.7.5
> 
> 
> 
> --
> Scanned by MailScanner.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Best Regards,
Peter Chen

