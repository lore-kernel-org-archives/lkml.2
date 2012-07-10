Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2GJPNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:13:37 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35831 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2GJPNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:13:35 -0400
Date: Tue, 10 Jul 2012 08:13:30 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Subject: Re: [PATCH] usb: twl6030-usb: variable otg not declared in
 twl6030_usbotg_irq() in linux-next
Message-ID: <20120710151330.GA27006@cantor.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	balbi@ti.com, kishon@ti.com
References: <1341901940-12277-1-git-send-email-dev@snitselaar.org>
 <20120710144046.GB15912@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710144046.GB15912@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, ignore my patch. It was applied to usb-next already and I forgot to check there.

Jerry

On Tue Jul 10 12, Greg KH wrote:
> On Mon, Jul 09, 2012 at 11:32:20PM -0700, Gerard Snitselaar wrote:
> > commit ff9cce82 added back 2 lines that were removed by commit
> > c83a8542 causing build of twl6030-usb to get an error due to otg being
> > referenced, but not declared. This patch removes those 2 lines again
> > to restore intent of commit c83a8542.
> > 
> > Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
> > ---
> >  drivers/usb/otg/twl6030-usb.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
> > index a3d0c04..6907d8d 100644
> > --- a/drivers/usb/otg/twl6030-usb.c
> > +++ b/drivers/usb/otg/twl6030-usb.c
> > @@ -302,8 +302,6 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
> >  		twl6030_writeb(twl, TWL_MODULE_USB, 0x1, USB_ID_INT_EN_HI_CLR);
> >  		twl6030_writeb(twl, TWL_MODULE_USB, 0x10, USB_ID_INT_EN_HI_SET);
> >  		status = OMAP_MUSB_ID_GROUND;
> > -		otg->default_a = true;
> > -		twl->phy.state = OTG_STATE_A_IDLE;
> 
> Didn't I apply this same patch yesterday?  Can you verify that this is
> still needed in the usb-next branch of my git tree?
> 
> confused,
> 
> greg k-h
