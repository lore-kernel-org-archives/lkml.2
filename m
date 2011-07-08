Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1GHKga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:36:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33560 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GHKg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:36:27 -0400
Date: Fri, 8 Jul 2011 12:36:22 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Shawn Guo <shawn.guo@linaro.org>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH v3 0/3] Add device tree probe for imx/mxc gpio
Message-ID: <20110708103622.GF26347@pengutronix.de>
References: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
 <20110707192705.GL2824@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707192705.GL2824@ponder.secretlab.ca>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:31:32 up 16 days, 16:18, 60 users,  load average: 0.66, 0.49,
 0.44
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 01:27:05PM -0600, Grant Likely wrote:
> On Thu, Jul 07, 2011 at 12:37:40AM +0800, Shawn Guo wrote:
> > The first patch removes the uses of cpu_is_mx(), the second one
> > changes mxc gpio number macro, and the third one adds actual device
> > tree probe support.
> > 
> > Changes since v2:
> >  * Keep platform case gpio range code path unchanged, and get range
> >    from gpio core only for dt case.
> > 
> > Changes since v1:
> >  * Address review comments given by Grant and Sascha
> >  * Add patch #1 to get gpio range/base from gpio core
> > 
> > Shawn Guo (3):
> >       gpio/mxc: get rid of the uses of cpu_is_mx()
> >       ARM: mxc: use ARCH_NR_GPIOS to define gpio number
> >       gpio/mxc: add device tree probe support
> 
> Sascha; so are we good?  Should I merge this series?

These patches neither fit onto your gpio tree nor on the i.MX tree. I
suggest that we give these patches a rest until both trees are merged.

That's the downside of moving core drivers to drivers/ and thus to
different maintainers, but I think things will become better once
the actual move is completed.

Sascha

> 
> g.
> 
> > 
> >  .../devicetree/bindings/gpio/fsl-imx-gpio.txt      |   22 +++
> >  arch/arm/mach-imx/mm-imx1.c                        |    8 +-
> >  arch/arm/mach-imx/mm-imx21.c                       |   12 +-
> >  arch/arm/mach-imx/mm-imx25.c                       |    9 +-
> >  arch/arm/mach-imx/mm-imx27.c                       |   13 +-
> >  arch/arm/mach-imx/mm-imx31.c                       |    6 +-
> >  arch/arm/mach-imx/mm-imx35.c                       |    7 +-
> >  arch/arm/mach-mx5/mm-mx50.c                        |   13 +-
> >  arch/arm/mach-mx5/mm.c                             |   24 ++--
> >  arch/arm/plat-mxc/devices/platform-gpio-mxc.c      |    4 +-
> >  arch/arm/plat-mxc/include/mach/common.h            |    2 +-
> >  arch/arm/plat-mxc/include/mach/irqs.h              |   21 +---
> >  drivers/gpio/gpio-mxc.c                            |  157 +++++++++++++++++---
> >  13 files changed, 211 insertions(+), 87 deletions(-)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
