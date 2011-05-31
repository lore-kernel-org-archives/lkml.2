Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1EaAQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:16:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37848 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab1EaAQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:16:30 -0400
Date: Mon, 30 May 2011 17:16:34 -0700
From: Olof Johansson <olof@lixom.net>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, arnd@arndb.de,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 2/4] ARM: mxc: migrate mach-mx5 gpio driver to gpio-mxc
Message-ID: <20110531001634.GB3411@quad.lixom.net>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
 <1306767139-24763-3-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306767139-24763-3-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 30, 2011 at 10:52:17PM +0800, Shawn Guo wrote:
> It adds platform device for drivers/gpio/gpio-mxc, and migrates
> mx50/mx51/mx53 gpio driver to gpio-mxc.
> 

[...]

> diff --git a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
> new file mode 100644
> index 0000000..3b10da0
> --- /dev/null
> +++ b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
> @@ -0,0 +1,69 @@
> +/*
> + * Copyright 2011 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright 2011 Linaro Limited
> + *
> + * This program is free software; you can redistribute it and/or modify it under
> + * the terms of the GNU General Public License version 2 as published by the
> + * Free Software Foundation.
> + */
> +#include <linux/compiler.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +
> +#include <mach/hardware.h>
> +#include <mach/devices-common.h>
> +
> +static struct platform_device *__init mxc_add_gpio(int id,
> +	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high)
> +{
> +	struct resource res[] = {
> +		{
> +			.start = iobase,
> +			.end = iobase + iosize - 1,
> +			.flags = IORESOURCE_MEM,
> +		}, {
> +			.start = irq,
> +			.end = irq,
> +			.flags = IORESOURCE_IRQ,
> +		}, {
> +			.start = irq_high,
> +			.end = irq_high,
> +			.flags = IORESOURCE_IRQ,
> +		},
> +	};
> +
> +	return platform_device_register_resndata(&mxc_aips_bus,
> +			"gpio-mxc", id, res, ARRAY_SIZE(res), NULL, 0);

Why bother returning the value, it's never checked below?

> +static int __init mxc_add_mxc_gpio(void)

Minor nits: Redundant mxcs? Also, 'gpios' would be more accurate naming.

> +{
> +	if (cpu_is_mx50()) {
> +		mxc_add_gpio(0, MX50_GPIO1_BASE_ADDR, SZ_16K, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH);
> +		mxc_add_gpio(1, MX50_GPIO2_BASE_ADDR, SZ_16K, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH);
> +		mxc_add_gpio(2, MX50_GPIO3_BASE_ADDR, SZ_16K, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH);
> +		mxc_add_gpio(3, MX50_GPIO4_BASE_ADDR, SZ_16K, MX50_INT_GPIO4_LOW, MX50_INT_GPIO4_HIGH);
> +		mxc_add_gpio(4, MX50_GPIO5_BASE_ADDR, SZ_16K, MX50_INT_GPIO5_LOW, MX50_INT_GPIO5_HIGH);
> +		mxc_add_gpio(5, MX50_GPIO6_BASE_ADDR, SZ_16K, MX50_INT_GPIO6_LOW, MX50_INT_GPIO6_HIGH);
> +	}
> +
> +	if (cpu_is_mx51()) {
> +		mxc_add_gpio(0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
> +		mxc_add_gpio(1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
> +		mxc_add_gpio(2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
> +		mxc_add_gpio(3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
> +	}
> +
> +	if (cpu_is_mx53()) {
> +		mxc_add_gpio(0, MX53_GPIO1_BASE_ADDR, SZ_16K, MX53_INT_GPIO1_LOW, MX53_INT_GPIO1_HIGH);
> +		mxc_add_gpio(1, MX53_GPIO2_BASE_ADDR, SZ_16K, MX53_INT_GPIO2_LOW, MX53_INT_GPIO2_HIGH);
> +		mxc_add_gpio(2, MX53_GPIO3_BASE_ADDR, SZ_16K, MX53_INT_GPIO3_LOW, MX53_INT_GPIO3_HIGH);
> +		mxc_add_gpio(3, MX53_GPIO4_BASE_ADDR, SZ_16K, MX53_INT_GPIO4_LOW, MX53_INT_GPIO4_HIGH);
> +		mxc_add_gpio(4, MX53_GPIO5_BASE_ADDR, SZ_16K, MX53_INT_GPIO5_LOW, MX53_INT_GPIO5_HIGH);
> +		mxc_add_gpio(5, MX53_GPIO6_BASE_ADDR, SZ_16K, MX53_INT_GPIO6_LOW, MX53_INT_GPIO6_HIGH);
> +		mxc_add_gpio(6, MX53_GPIO7_BASE_ADDR, SZ_16K, MX53_INT_GPIO7_LOW, MX53_INT_GPIO7_HIGH);
> +	}

The above tables are pretty crazy, and they only get worse later in the series
when the other SoCs are added. Is it really worth it to have a common initcall
entry for the various SoCs here?

It'd seem cleaner to me to just call the registration function for the
family you're running from in per-family-init code such as where it was
removed above (irq init, which makes some sense since the gpios provide
interrupt sources as well).

It's different on OMAP since there it is data driven with a shared
registration function, but here it's really just a hardcoded table
(as code even, not as data) per SoC.


-Olof
