Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2JAQhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:37:09 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47338 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2JAQhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:37:06 -0400
Date: Mon, 1 Oct 2012 12:37:24 -0400
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 10/13] spi: omap2-mcspi: dma_request_slave_channel()
 support for DT platforms
Message-ID: <20121001163723.GN5641@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-11-git-send-email-mporter@ti.com>
 <20120920220931.GJ28835@atomide.com>
 <201209210816.01473.arnd@arndb.de>
 <20120921154247.GZ28835@atomide.com>
 <20120921183729.GI16522@beef>
 <1348738594.1648.9.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348738594.1648.9.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 03:06:34PM +0530, Vinod Koul wrote:
> On Fri, 2012-09-21 at 14:37 -0400, Matt Porter wrote:
> > On Fri, Sep 21, 2012 at 08:42:47AM -0700, Tony Lindgren wrote:
> > > 
> > > Can't we come up with a version of dma_request_slave_channel that works
> > > both ways for now:
> > > 
> > > 	mcspi_dma->dma_rx =
> > > 		dma_request_slave_channel_compat(mask, omap_dma_filter_fn, &sig,
> > > 					&master->dev, mcspi_dma->dma_rx_ch_name);
> > > 	...			
> > > 
> > > Then it's just question of patching away two lines later on rather than
> > > having to add all this if else to all the drivers first, then patching
> > > it away again.
> > 
> > I think that something like that is workable with the implementation
> > simply checking for of_node to do the right thing.
> Yes, I think it would be better to have common API but underneath two
> implementations in transitional phase.

Ok, I'll implement something for discussion in the v2 series.

-Matt
