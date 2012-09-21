Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab2IUJmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:42:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37316 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab2IUJme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:42:34 -0400
Date: Fri, 21 Sep 2012 10:42:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: "Porter, Matt" <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
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
Subject: Re: [RFC PATCH 01/13] ARM: davinci: move private EDMA API to
	arm/common
Message-ID: <20120921094205.GC31374@n2100.arm.linux.org.uk>
References: <1348152226-13588-1-git-send-email-mporter@ti.com> <1348152226-13588-2-git-send-email-mporter@ti.com> <20120921092923.GA31374@n2100.arm.linux.org.uk> <1BAFE6F6C881BF42822005164F1491C33EA8AA3C@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EA8AA3C@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 09:33:42AM +0000, Hebbar, Gururaja wrote:
> On Fri, Sep 21, 2012 at 14:59:23, Russell King - ARM Linux wrote:
> > On Thu, Sep 20, 2012 at 10:43:34AM -0400, Matt Porter wrote:
> > > Move mach-davinci/dma.c to common/edma.c so it can be used
> > > by OMAP (specifically AM33xx atm) as well. This just moves
> > > the private EDMA API but does not support OMAP.
> > > 
> > > Signed-off-by: Matt Porter <mporter@ti.com>
> > > ---
> > >  arch/arm/Kconfig                           |    1 +
> > >  arch/arm/common/Kconfig                    |    3 +
> > >  arch/arm/common/Makefile                   |    1 +
> > >  arch/arm/common/edma.c                     | 1588 ++++++++++++++++++++++++++++
> > >  arch/arm/include/asm/mach/edma.h           |  267 +++++
> > 
> > asm/mach should not be used as a dumping ground for platform header files.
> > It is there to provide the interfaces between generic ARM architecture
> > code and platform code.  (At least four files that are there at the
> > moment need to be moved out of there - patch series to follow...)
> 
> Can this be moved to include/linux/platform_data/ ?

Here's the pertinant question: "is it platform data?"  Looking at the
file, it appears to be internal data structures and register definitions
for the driver itself.  Therefore, it isn't platform data, and it
shouldn't be living separately from the driver.

If the driver itself only makes use of the data structures, the data
structures should be defined either within the driver, or a header file
co-located next to the driver itself.  The same goes for register
definitions too.

The only structure that I can find which isn't internal to the driver
is struct edma_soc_info, struct edma_rsv_info, and the enum dma_event_q.
Those can go to include/linux/platform_data, but the rest should not.
