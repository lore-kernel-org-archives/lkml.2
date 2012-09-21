Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab2IUTBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:01:30 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51459 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab2IUTB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:01:28 -0400
Date: Fri, 21 Sep 2012 15:03:12 -0400
From: Matt Porter <mporter@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "S, Venkatraman" <svenkatr@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 08/13] mmc: omap_hsmmc: limit max_segs with the EDMA
 DMAC
Message-ID: <20120921190312.GL16522@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-9-git-send-email-mporter@ti.com>
 <CANfBPZ81anOy8fWgKM1PgCtB4V2pEp2x1Qi4x1uPsq7QieMN5g@mail.gmail.com>
 <20120921184721.GD31374@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921184721.GD31374@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 07:47:21PM +0100, Russell King wrote:
> On Fri, Sep 21, 2012 at 10:45:29PM +0530, S, Venkatraman wrote:
> > On Thu, Sep 20, 2012 at 8:13 PM, Matt Porter <mporter@ti.com> wrote:
> > > The EDMA DMAC has a hardware limitation that prevents supporting
> > > scatter gather lists with any number of segments. Since the EDMA
> > > DMA Engine driver sets the maximum segments to 16, we do the
> > > same.
> > >
> > > Note: this can be removed once the DMA Engine API supports an
> > > API to query the DMAC's segment limitations.
> > >
> > 
> > I wouldn't want to bind the properties of EDMA to omap_hsmmc as this patch
> > suggests. Why don't we have a max_segs property, which when explicitly specified
> > in DT, will override the default ?
> 
> Why not have a generic way that DMA engine can export these kinds of
> properties?

That's exactly what my note above is suggesting...

Something along the lines of:

	struct slave_sg_caps
	{
		int max_segs;	/* <0 is no limit */
	}

	struct slave_sg_cap *
	dmaengine_get_slave_sg_caps(struct dma_chan *chan);

I'm sure there are or will be other characteristics worth providing to
slave drivers.

-Matt
