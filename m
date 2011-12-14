Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab1LNQxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:53:35 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46359 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757456Ab1LNQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:53:33 -0500
X-Sasl-enc: 1A0I/1aUeMAiU/2Jj5TNBQSTNKV9yjBcwnki7/BCuzzB 1323881612
Date: Wed, 14 Dec 2011 08:10:27 -0800
From: Greg KH <greg@kroah.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Joachim Foerster <joachim.foerster@missinglinkelectronics.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ISP1760: Add flags for interrupt polarity and
 edge/level trigger
Message-ID: <20111214161027.GA5996@kroah.com>
References: <1323768793-20633-1-git-send-email-alexander.stein@systec-electronic.com>
 <20111213180010.GA29980@kroah.com>
 <5171961.tdOaMPUdsK@ws-stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5171961.tdOaMPUdsK@ws-stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 08:57:33AM +0100, Alexander Stein wrote:
> On Tuesday 13 December 2011 10:00:10 Greg KH wrote:
> > On Tue, Dec 13, 2011 at 10:33:13AM +0100, Alexander Stein wrote:
> > > Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> > > ---
> > > 
> > >  drivers/usb/host/isp1760-if.c |    4 ++++
> > >  include/linux/usb/isp1760.h   |    2 ++
> > >  2 files changed, 6 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/usb/host/isp1760-if.c
> > > b/drivers/usb/host/isp1760-if.c index a7dc1e1..0ef9867 100644
> > > --- a/drivers/usb/host/isp1760-if.c
> > > +++ b/drivers/usb/host/isp1760-if.c
> > > @@ -388,6 +388,10 @@ static int __devinit isp1760_plat_probe(struct
> > > platform_device *pdev)> 
> > >  			devflags |= ISP1760_FLAG_DACK_POL_HIGH;
> > >  		
> > >  		if (priv->dreq_polarity_high)
> > >  		
> > >  			devflags |= ISP1760_FLAG_DREQ_POL_HIGH;
> > > 
> > > +		if (priv->interrupt_polarity_high)
> > > +			devflags |= ISP1760_FLAG_INTR_POL_HIGH;
> > > +		if (priv->interrupt_edge_triggered)
> > > +			devflags |= ISP1760_FLAG_INTR_EDGE_TRIG;
> > > 
> > >  	}
> > >  	
> > >  	hcd = isp1760_register(mem_res->start, mem_size, irq_res->start,
> > > 
> > > diff --git a/include/linux/usb/isp1760.h b/include/linux/usb/isp1760.h
> > > index de7de53..c5edbc8 100644
> > > --- a/include/linux/usb/isp1760.h
> > > +++ b/include/linux/usb/isp1760.h
> > > @@ -13,6 +13,8 @@ struct isp1760_platform_data {
> > > 
> > >  	unsigned analog_oc:1;			/* Analog overcurrent */
> > >  	unsigned dack_polarity_high:1;		/* DACK active high */
> > >  	unsigned dreq_polarity_high:1;		/* DREQ active high */
> > > 
> > > +	unsigned interrupt_polarity_high:1;
> > > +	unsigned interrupt_edge_triggered:1;
> > 
> > So you added these, and you check them, but who sets them?  What is the
> > point of this patch at this point in time?
> 
> These platform data bits are set by board configurations, which is completly 
> optional. So currently maybe noone sets/use it, but in future someone may need 
> it. Also dreq_polarity_high is also there and I only found board files setting 
> them to 0... So why not add the feature bits too?

Because we don't add "features" to the kernel that are not used, that's
just unneeded cruft.

If you have a real need and an actual user of these flags, then I will
be glad to accept this patch.

thanks,

greg k-h
