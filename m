Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1GHSii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:38:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44981 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1GHSih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:38:37 -0400
Date: Fri, 8 Jul 2011 12:38:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH v3 0/3] Add device tree probe for imx/mxc gpio
Message-ID: <20110708183832.GB9070@ponder.secretlab.ca>
References: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
 <20110707192705.GL2824@ponder.secretlab.ca>
 <20110708103622.GF26347@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708103622.GF26347@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 12:36:22PM +0200, Sascha Hauer wrote:
> On Thu, Jul 07, 2011 at 01:27:05PM -0600, Grant Likely wrote:
> > On Thu, Jul 07, 2011 at 12:37:40AM +0800, Shawn Guo wrote:
> > > The first patch removes the uses of cpu_is_mx(), the second one
> > > changes mxc gpio number macro, and the third one adds actual device
> > > tree probe support.
> > > 
> > > Changes since v2:
> > >  * Keep platform case gpio range code path unchanged, and get range
> > >    from gpio core only for dt case.
> > > 
> > > Changes since v1:
> > >  * Address review comments given by Grant and Sascha
> > >  * Add patch #1 to get gpio range/base from gpio core
> > > 
> > > Shawn Guo (3):
> > >       gpio/mxc: get rid of the uses of cpu_is_mx()
> > >       ARM: mxc: use ARCH_NR_GPIOS to define gpio number
> > >       gpio/mxc: add device tree probe support
> > 
> > Sascha; so are we good?  Should I merge this series?
> 
> These patches neither fit onto your gpio tree nor on the i.MX tree. I
> suggest that we give these patches a rest until both trees are merged.
> 
> That's the downside of moving core drivers to drivers/ and thus to
> different maintainers, but I think things will become better once
> the actual move is completed.

It's a trivial conflict though.  I've gone ahead and picked up this
series and pushed it out to gpio/next.  Shawn, please test the
gpio/next branch and make sure there aren't any regressions.  I've
only done a bit of build testing.

g.

> 
> Sascha
> 
> > 
> > g.
> > 
> > > 
> > >  .../devicetree/bindings/gpio/fsl-imx-gpio.txt      |   22 +++
> > >  arch/arm/mach-imx/mm-imx1.c                        |    8 +-
> > >  arch/arm/mach-imx/mm-imx21.c                       |   12 +-
> > >  arch/arm/mach-imx/mm-imx25.c                       |    9 +-
> > >  arch/arm/mach-imx/mm-imx27.c                       |   13 +-
> > >  arch/arm/mach-imx/mm-imx31.c                       |    6 +-
> > >  arch/arm/mach-imx/mm-imx35.c                       |    7 +-
> > >  arch/arm/mach-mx5/mm-mx50.c                        |   13 +-
> > >  arch/arm/mach-mx5/mm.c                             |   24 ++--
> > >  arch/arm/plat-mxc/devices/platform-gpio-mxc.c      |    4 +-
> > >  arch/arm/plat-mxc/include/mach/common.h            |    2 +-
> > >  arch/arm/plat-mxc/include/mach/irqs.h              |   21 +---
> > >  drivers/gpio/gpio-mxc.c                            |  157 +++++++++++++++++---
> > >  13 files changed, 211 insertions(+), 87 deletions(-)
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
