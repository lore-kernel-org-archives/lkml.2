Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1JWOUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:20:07 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:15811
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755567Ab1JWOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:20:06 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKc8kzz1202hzz8275bhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sun, 23 Oct 2011 22:30:58 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mike Turquette <mturquette@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <jeremy.kerr@canonical.com>, <broonie@opensource.wolfsonmicro.com>,
        <tglx@linutronix.de>, <linus.walleij@stericsson.com>,
        <amit.kucheria@linaro.org>, <dsaxena@linaro.org>, <patches@linaro.org>,
        <linaro-dev@lists.linaro.org>, <paul@pwsan.com>,
        <grant.likely@secretlab.ca>, <sboyd@quiinc.com>, <skannan@quicinc.com>,
        <magnus.damm@gmail.com>, <arnd.bergmann@linaro.org>,
        <linux@arm.linux.org.uk>, <eric.miao@linaro.org>,
        <richard.zhao@linaro.org>
Subject: Re: [PATCH v2 3/7] clk: Add fixed-rate clock
Message-ID: <20111023143057.GF1401@S2100-06.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-4-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316730422-20027-4-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 03:26:58PM -0700, Mike Turquette wrote:
> From: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Mike Turquette <mturquette@ti.com>
> ---
> Changes since v1:
> Add copyright header
> 
>  drivers/clk/Kconfig     |    4 ++++
>  drivers/clk/Makefile    |    1 +
>  drivers/clk/clk-fixed.c |   24 ++++++++++++++++++++++++
>  include/linux/clk.h     |   14 ++++++++++++++
>  4 files changed, 43 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/clk-fixed.c
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index c53ed59..d8313d7 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -8,3 +8,7 @@ config HAVE_MACH_CLKDEV
>  
>  config GENERIC_CLK
>  	bool
> +
> +config GENERIC_CLK_FIXED
> +	bool
> +	depends on GENERIC_CLK
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 570d5b9..9a3325a 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -1,3 +1,4 @@
>  
>  obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
>  obj-$(CONFIG_GENERIC_CLK)	+= clk.o
> +obj-$(CONFIG_GENERIC_CLK_FIXED)	+= clk-fixed.o
> diff --git a/drivers/clk/clk-fixed.c b/drivers/clk/clk-fixed.c
> new file mode 100644
> index 0000000..956fb9a
> --- /dev/null
> +++ b/drivers/clk/clk-fixed.c
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Simple fixed-rate clock implementation
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +
> +#define to_clk_fixed(c) container_of(c, struct clk_hw_fixed, hw)
> +
> +static unsigned long clk_fixed_recalc_rate(struct clk_hw *hw)
> +{
> +	return to_clk_fixed(hw)->rate;
> +}
> +
> +struct clk_hw_ops clk_fixed_ops = {
> +	.recalc_rate = clk_fixed_recalc_rate,
> +};
> +EXPORT_SYMBOL_GPL(clk_fixed_ops);
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 0d2cd5e..1903dd8 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -110,6 +110,20 @@ int clk_prepare(struct clk *clk);
>   */
>  void clk_unprepare(struct clk *clk);
>  
> +/* Base clock implementations. Platform clock implementations can use these
> + * directly, or 'subclass' as approprate */
> +
/*
 * Multiple lines comments
 */

Regards,
Shawn

> +#ifdef CONFIG_GENERIC_CLK_FIXED
> +
> +struct clk_hw_fixed {
> +	struct clk_hw	hw;
> +	unsigned long	rate;
> +};
> +
> +extern struct clk_hw_ops clk_fixed_ops;
> +
> +#endif /* CONFIG_GENERIC_CLK_FIXED */
> +
>  /**
>   * clk_register - register and initialize a new clock
>   *
> -- 
> 1.7.4.1
> 
> 

