Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1DUItY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:49:24 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:50124
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268Ab1DUItV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:49:21 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKc8kzz1202hzz8275bhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 21 Apr 2011 16:53:17 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <linaro-dev@lists.linaro.org>,
        <sameo@linux.intel.com>, <patches@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] mmc: sdhci: consolidate sdhci-of-esdhc and
 sdhci-esdhc-imx
Message-ID: <20110421085316.GG4024@S2100-06.ap.freescale.net>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <1301042931-4869-5-git-send-email-shawn.guo@linaro.org>
 <20110419102110.GE4164@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110419102110.GE4164@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 12:21:10PM +0200, Wolfram Sang wrote:
> >  config MMC_SDHCI_ESDHC_IMX
> > -	bool "SDHCI platform support for the Freescale eSDHC i.MX controller"
> > +	bool "SDHCI support for the Freescale eSDHC i.MX controller"
> >  	depends on ARCH_MX25 || ARCH_MX35 || ARCH_MX5
> >  	depends on MMC_SDHCI
> > -	select MMC_SDHCI_PLTFM
> > +	select MMC_SDHCI_ESDHC
> >  	select MMC_SDHCI_IO_ACCESSORS
> >  	help
> > -	  This selects the Freescale eSDHC controller support on the platform
> > -	  bus, found on platforms like mx35/51.
> > +	  This selects the Freescale eSDHC controller support on platforms
> > +	  like mx35/51.
> 
> While we are at it, mx25 could be added and mx53 (and you know better
> what else will be coming ;))
> 
It's a direct copy.  Will update it properly.

> > diff --git a/drivers/mmc/host/sdhci-esdhc.c b/drivers/mmc/host/sdhci-esdhc.c
> > new file mode 100644
> > index 0000000..b3d1bc1
> > --- /dev/null
> > +++ b/drivers/mmc/host/sdhci-esdhc.c
> > @@ -0,0 +1,413 @@
> > +/*
> > + * Freescale eSDHC controller driver for MPCxxx and i.MX.
> > + *
> > + * Copyright (c) 2007 Freescale Semiconductor, Inc.
> > + *   Author: Xiaobo Xie <X.Xie@freescale.com>
> > + *
> > + * Copyright (c) 2009 MontaVista Software, Inc.
> > + *   Author: Anton Vorontsov <avorontsov@ru.mvista.com>
> > + *
> > + * Copyright (c) 2010 Pengutronix e.K.
> > + *   Author: Wolfram Sang <w.sang@pengutronix.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License.
> > + */
> > +
> > +#include <linux/io.h>
> > +#include <linux/delay.h>
> > +#include <linux/err.h>
> > +#include <linux/clk.h>
> > +#include <linux/mmc/host.h>
> > +#include <linux/mmc/sdhci-pltfm.h>
> > +#ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
> > +#include <mach/hardware.h>
> > +#endif
> > +#include "sdhci.h"
> > +#include "sdhci-pltfm.h"
> > +
> > +/*
> > + * Ops and quirks for the Freescale eSDHC controller.
> > + */
> > +
> > +#define ESDHC_DEFAULT_QUIRKS	(SDHCI_QUIRK_FORCE_BLK_SZ_2048 | \
> > +				SDHCI_QUIRK_BROKEN_CARD_DETECTION | \
> > +				SDHCI_QUIRK_NO_BUSY_IRQ | \
> > +				SDHCI_QUIRK_NONSTANDARD_CLOCK | \
> > +				SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK | \
> > +				SDHCI_QUIRK_PIO_NEEDS_DELAY | \
> > +				SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET | \
> > +				SDHCI_QUIRK_NO_CARD_NO_RESET)
> 
> These are not the current quirks. Meanwhile BROKEN_CARD_DETECTION is
> gone as well as NO_CARD_NO_RESET (at least for imx). My additions to use
> GPIOs for card detect and write protect are also not in this version.
> 
Next version will be based on mmc-next.

> [...]
> 
> > +static struct sdhci_pltfm_data sdhci_esdhc_mpc_pdata = {
> > +	.quirks = ESDHC_DEFAULT_QUIRKS,
> > +	.ops = &sdhci_esdhc_mpc_ops,
> > +};
> > +#endif
> 
> Please mark the #endif with comments of the expression they are
> depending on, e.g.
> 
> #endif /* CONFIG_MMC_SDHCI_ESDHC_MPC */
> 
> if it is not immediately visible. That helps readability.
> 
Ok, since you like it :)

> [...]
> 
> Phew, due to all these hardware bugs, the driver will get messy, even if
> we try hard. Any chances that future revisions of the core will be
> updated? :)
> 
I doubt all these quirks are design bugs but some designs not fully
compliant to SDHC specification, which you still can say bugs :)

-- 
Regards,
Shawn

