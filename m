Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1G0UTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:19:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37553 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab1G0UTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:19:41 -0400
Date: Wed, 27 Jul 2011 21:19:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: linux-next: manual merge of the slave-dma tree with Linus' tree
Message-ID: <20110727201904.GA30198@n2100.arm.linux.org.uk>
References: <20110727120826.ea1227276707790e162dee18@canb.auug.org.au> <1311736331.1536.45.camel@vkoul-udesk3> <438BB0150E931F4B9CE701519A4463010871EAC8BD@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <438BB0150E931F4B9CE701519A4463010871EAC8BD@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 09:55:44PM +0530, Koul, Vinod wrote:
> > 
> > On Wed, 2011-07-27 at 12:08 +1000, Stephen Rothwell wrote:
> > > Hi Vinod,
> > >
> > > Today's linux-next merge of the slave-dma tree got a conflict in
> > > drivers/spi/spi-pl022.c (called drivers/spi/amba-pl022.c in the sleav-dma
> > > tree) between commit 083be3f05371 ("spi/pl022: initialize burstsize from
> > > FIFO trigger level") from Linus' tree and commit 001b0585ff16 ("Improve
> > > slave/cyclic DMA engine documentation") from the slave-dma tree.
> > >
> > > I fixed it up (see below) anc acn carry the fix as necessary.
> > 
> > The correct fix would be:
> > 
> > diff --cc drivers/spi/spi-pl022.c
> > index eba88c7,99e7880..0000000
> > --- a/drivers/spi/spi-pl022.c
> > +++ b/drivers/spi/spi-pl022.c
> > @@@ -910,11 -908,11 +910,9 @@@ static int configure_dma(struct pl022 *
> >   {
> >         struct dma_slave_config rx_conf = {
> >                 .src_addr = SSP_DR(pl022->phybase),
> > +			.direction = DMA_TO_DEVICE,
> >         };
> >         struct dma_slave_config tx_conf = {
> >                 .dst_addr = SSP_DR(pl022->phybase),
> >                 .direction = DMA_TO_DEVICE,
> >  -              .dst_maxburst = pl022->vendor->fifodepth >> 1,
> >         };
> >         unsigned int pages;
> >         int ret;
> > 
> Grant, Russell,
> Can you please ack this fix before I apply in my tree to resolve this conflict

I don't see why I need to - my documentation patch should only be touching
Documentation/dmaengine.txt, not drivers/spi/spi-pl022.c.  So it really
should not be causing a conflict in this file.
