Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2GJOkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:40:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38215 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2GJOku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:40:50 -0400
Date: Tue, 10 Jul 2012 07:40:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Subject: Re: [PATCH] usb: twl6030-usb: variable otg not declared in
 twl6030_usbotg_irq() in linux-next
Message-ID: <20120710144046.GB15912@kroah.com>
References: <1341901940-12277-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341901940-12277-1-git-send-email-dev@snitselaar.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 11:32:20PM -0700, Gerard Snitselaar wrote:
> commit ff9cce82 added back 2 lines that were removed by commit
> c83a8542 causing build of twl6030-usb to get an error due to otg being
> referenced, but not declared. This patch removes those 2 lines again
> to restore intent of commit c83a8542.
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
> ---
>  drivers/usb/otg/twl6030-usb.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
> index a3d0c04..6907d8d 100644
> --- a/drivers/usb/otg/twl6030-usb.c
> +++ b/drivers/usb/otg/twl6030-usb.c
> @@ -302,8 +302,6 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
>  		twl6030_writeb(twl, TWL_MODULE_USB, 0x1, USB_ID_INT_EN_HI_CLR);
>  		twl6030_writeb(twl, TWL_MODULE_USB, 0x10, USB_ID_INT_EN_HI_SET);
>  		status = OMAP_MUSB_ID_GROUND;
> -		otg->default_a = true;
> -		twl->phy.state = OTG_STATE_A_IDLE;

Didn't I apply this same patch yesterday?  Can you verify that this is
still needed in the usb-next branch of my git tree?

confused,

greg k-h
