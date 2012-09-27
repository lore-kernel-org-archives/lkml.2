Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab2I0JrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:47:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:30586 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab2I0JrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="197850987"
Subject: Re: [RFC PATCH 08/13] mmc: omap_hsmmc: limit max_segs with the
 EDMA DMAC
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "S, Venkatraman" <svenkatr@ti.com>, Matt Porter <mporter@ti.com>,
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
In-Reply-To: <20120921184721.GD31374@n2100.arm.linux.org.uk>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
	 <1348152226-13588-9-git-send-email-mporter@ti.com>
	 <CANfBPZ81anOy8fWgKM1PgCtB4V2pEp2x1Qi4x1uPsq7QieMN5g@mail.gmail.com>
	 <20120921184721.GD31374@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 15:11:08 +0530
Message-ID: <1348738868.1648.13.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 19:47 +0100, Russell King - ARM Linux wrote:
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
We discussed this at KS. I was of opinion that  DMA engine should export
controller and channel capabilities as part of the channel it returns.

Some folks had an opinion that they already know how to use controller
so may not be very helpful, but if it is going to help (which I think),
i have a patch for this :)


-- 
~Vinod

