Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab2IUSvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:51:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37717 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509Ab2IUSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:51:22 -0400
Date: Fri, 21 Sep 2012 19:50:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Porter <mporter@ti.com>
Cc: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, "Cousson, Benoit" <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 01/13] ARM: davinci: move private EDMA API to
	arm/common
Message-ID: <20120921185054.GE31374@n2100.arm.linux.org.uk>
References: <1348152226-13588-1-git-send-email-mporter@ti.com> <1348152226-13588-2-git-send-email-mporter@ti.com> <20120921092923.GA31374@n2100.arm.linux.org.uk> <1BAFE6F6C881BF42822005164F1491C33EA8AA3C@DBDE01.ent.ti.com> <20120921094205.GC31374@n2100.arm.linux.org.uk> <20120921183446.GH16522@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921183446.GH16522@beef>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 02:34:46PM -0400, Matt Porter wrote:
> On Fri, Sep 21, 2012 at 10:42:05AM +0100, Russell King wrote:
> > Here's the pertinant question: "is it platform data?"  Looking at the
> > file, it appears to be internal data structures and register definitions
> > for the driver itself.  Therefore, it isn't platform data, and it
> > shouldn't be living separately from the driver.
> > 
> > If the driver itself only makes use of the data structures, the data
> > structures should be defined either within the driver, or a header file
> > co-located next to the driver itself.  The same goes for register
> > definitions too.
> > 
> > The only structure that I can find which isn't internal to the driver
> > is struct edma_soc_info, struct edma_rsv_info, and the enum dma_event_q.
> > Those can go to include/linux/platform_data, but the rest should not.
> 
> Ok, but is it ok to keep the actual private EDMA API portion in
> arch/arm/include/asm/mach/? It's not a problem to move the internal
> portions to a local include and that pdata to the appropriate place.

Move the platform data parts to include/linux/platform_data.
Move the driver specific parts to be either in the .c file for the
driver, or in a .h file _along_ _side_ the .c file.

Private data for drivers should be kept as close to the driver as
possible, whether that be in the same .c file as the driver itself,
or a header co-located with the .c file.
