Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2IUSlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:41:15 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38477 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab2IUSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:41:12 -0400
Date: Fri, 21 Sep 2012 14:42:56 -0400
From: Matt Porter <mporter@ti.com>
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 08/13] mmc: omap_hsmmc: limit max_segs with the EDMA
 DMAC
Message-ID: <20120921184256.GJ16522@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-9-git-send-email-mporter@ti.com>
 <CANfBPZ81anOy8fWgKM1PgCtB4V2pEp2x1Qi4x1uPsq7QieMN5g@mail.gmail.com>
 <CANfBPZ-h7MD4X_NRYfwOmMnEyOKy0bTNNLNRmdbef2pe=2aHyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANfBPZ-h7MD4X_NRYfwOmMnEyOKy0bTNNLNRmdbef2pe=2aHyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 10:47:30PM +0530, S, Venkatraman wrote:
> On Fri, Sep 21, 2012 at 10:45 PM, S, Venkatraman <svenkatr@ti.com> wrote:
> > On Thu, Sep 20, 2012 at 8:13 PM, Matt Porter <mporter@ti.com> wrote:
> >> The EDMA DMAC has a hardware limitation that prevents supporting
> >> scatter gather lists with any number of segments. Since the EDMA
> >> DMA Engine driver sets the maximum segments to 16, we do the
> >> same.
> >>
> >> Note: this can be removed once the DMA Engine API supports an
> >> API to query the DMAC's segment limitations.
> >>
> >
> > I wouldn't want to bind the properties of EDMA to omap_hsmmc as this patch
> > suggests. Why don't we have a max_segs property, which when explicitly specified
> > in DT, will override the default ?
> 
> If you are adventurous, this can be a generic mmc DT binding instead
> of restricting it to OMAP.

I think it's bad practice to add something to a binding that is not part
of the hardware definition for the device. In this case, the limitations
comes strictly from the DMAC. As I noted, the proper fix for this is to
have the DMA Engine API extended to allow querying the DMAC SG
capabilities before setting up a DMA transfer. I brought this up
previously in the thread where the actual EDMA dmaengine wrapper driver
was discussed and Vinod indicated that he was open to dmaengine
providing this information.

It makes sense as DMA Engine should tell the slave driver everything it
needs to know to set up a transfer...this is just a missing piece right
now. FWIW, we have this issue in davinci_mmc.c as well...it just was
already hardcoded with a value to satisfy the EDMA DMAC. However, I'd
like to see that go away as well.

-Matt
