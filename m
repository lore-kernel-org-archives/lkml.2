Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2JAQji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:39:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63280 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2JAQjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:39:36 -0400
Date: Mon, 1 Oct 2012 12:39:55 -0400
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "S, Venkatraman" <svenkatr@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 08/13] mmc: omap_hsmmc: limit max_segs with the EDMA
 DMAC
Message-ID: <20121001163955.GO5641@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-9-git-send-email-mporter@ti.com>
 <CANfBPZ81anOy8fWgKM1PgCtB4V2pEp2x1Qi4x1uPsq7QieMN5g@mail.gmail.com>
 <20120921184721.GD31374@n2100.arm.linux.org.uk>
 <1348738868.1648.13.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348738868.1648.13.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 03:11:08PM +0530, Vinod Koul wrote:
> On Fri, 2012-09-21 at 19:47 +0100, Russell King - ARM Linux wrote:
> > On Fri, Sep 21, 2012 at 10:45:29PM +0530, S, Venkatraman wrote:
> > > On Thu, Sep 20, 2012 at 8:13 PM, Matt Porter <mporter@ti.com> wrote:
> > > > The EDMA DMAC has a hardware limitation that prevents supporting
> > > > scatter gather lists with any number of segments. Since the EDMA
> > > > DMA Engine driver sets the maximum segments to 16, we do the
> > > > same.
> > > >
> > > > Note: this can be removed once the DMA Engine API supports an
> > > > API to query the DMAC's segment limitations.
> > > >
> > > 
> > > I wouldn't want to bind the properties of EDMA to omap_hsmmc as this patch
> > > suggests. Why don't we have a max_segs property, which when explicitly specified
> > > in DT, will override the default ?
> > 
> > Why not have a generic way that DMA engine can export these kinds of
> > properties?
> We discussed this at KS. I was of opinion that  DMA engine should export
> controller and channel capabilities as part of the channel it returns.
> 
> Some folks had an opinion that they already know how to use controller
> so may not be very helpful, but if it is going to help (which I think),
> i have a patch for this :)

Anything you can show at this point? ;) I'd be happy to drop the half-hack
for a real API. If not, I'm going to carry that to v2 atm.

-Matt
