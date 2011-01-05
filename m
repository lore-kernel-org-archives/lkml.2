Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1AEV3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:29:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:64955 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1AEV3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:29:36 -0500
Date: Wed, 5 Jan 2011 16:29:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [34-longterm 251/260] USB: atmel_usba_udc: force vbus_pin at
 -EINVAL when gpio_request failled
Message-ID: <20110105212921.GZ30150@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
 <1293952756-15010-252-git-send-email-paul.gortmaker@windriver.com>
 <20110105185917.GI2965@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105185917.GI2965@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Jan 2011 21:29:22.0696 (UTC) FILETIME=[9E9E5880:01CBAD1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [34-longterm 251/260] USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled] On 05/01/2011 (Wed 19:59) Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 02:19 Sun 02 Jan     , Paul Gortmaker wrote:
> > From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > 
> > commit 969affff54702785330de553b790372e261e93f9 upstream.
> > 
> > to ensure gpio_is_valid return false
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > ---
> >  drivers/usb/gadget/atmel_usba_udc.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> > index 75a256f..8fd88e1 100644
> > --- a/drivers/usb/gadget/atmel_usba_udc.c
> > +++ b/drivers/usb/gadget/atmel_usba_udc.c
> > @@ -2015,6 +2015,9 @@ static int __init usba_udc_probe(struct platform_device *pdev)
> >  			} else {
> >  				disable_irq(gpio_to_irq(udc->vbus_pin));
> >  			}
> > +		} else {
> > +			/* gpio_request fail so use -EINVAL for gpio_is_valid */
> > +			ubc->vbus_pin = -EINVAL;
> there is a typo here
> please change to 
> 			udc->vbus_pin = -EINVAL;

Thanks -- I see I had the upstream typo fix (b488095186318) already
queued up in next_round; but it looks like it needs to be dragged back
into this round.

I'll go do that now.

Paul.

> 
> Best Regards,
> J.
