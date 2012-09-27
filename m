Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2I0Jmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:42:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:29060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2I0Jmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:42:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="197849752"
Subject: Re: [RFC PATCH 10/13] spi: omap2-mcspi:
 dma_request_slave_channel() support for DT platforms
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Matt Porter <mporter@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20120921183729.GI16522@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
	 <1348152226-13588-11-git-send-email-mporter@ti.com>
	 <20120920220931.GJ28835@atomide.com> <201209210816.01473.arnd@arndb.de>
	 <20120921154247.GZ28835@atomide.com>  <20120921183729.GI16522@beef>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 15:06:34 +0530
Message-ID: <1348738594.1648.9.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 14:37 -0400, Matt Porter wrote:
> On Fri, Sep 21, 2012 at 08:42:47AM -0700, Tony Lindgren wrote:
> > 
> > Can't we come up with a version of dma_request_slave_channel that works
> > both ways for now:
> > 
> > 	mcspi_dma->dma_rx =
> > 		dma_request_slave_channel_compat(mask, omap_dma_filter_fn, &sig,
> > 					&master->dev, mcspi_dma->dma_rx_ch_name);
> > 	...			
> > 
> > Then it's just question of patching away two lines later on rather than
> > having to add all this if else to all the drivers first, then patching
> > it away again.
> 
> I think that something like that is workable with the implementation
> simply checking for of_node to do the right thing.
Yes, I think it would be better to have common API but underneath two
implementations in transitional phase.



-- 
~Vinod

