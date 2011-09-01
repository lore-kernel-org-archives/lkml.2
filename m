Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab1IAVdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:33:09 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18355 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039Ab1IAVdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:33:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 01 Sep 2011 14:33:03 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 1 Sep 2011 14:33:01 -0700
Subject: RE: [PATCH 2/4 v6] pinmux: add a driver for the U300 pinmux
Thread-Topic: [PATCH 2/4 v6] pinmux: add a driver for the U300 pinmux
Thread-Index: Acxoij7VLNoLXj7FTUaCd1s4AqOSYQAY69zA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B327A40C@HQMAIL01.nvidia.com>
References: <1314869552-5531-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1314869552-5531-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Thursday, September 01, 2011 3:33 AM:
> This adds a driver for the U300 pinmux portions of the system
> controller "SYSCON". It also serves as an example of how to use
> the pinmux subsystem. This driver also houses the platform data
> for the only supported platform.

> diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinmux-u300.c

> +/*
> + * We define explicit indexes of the groups since these will be
> + * referenced in the pinmuxes below.
> + */
> +#define POWERGRP_INDEX 0
> +#define UART0GRP_INDEX 1
> +#define MMC0GRP_INDEX 2
> +#define SPI0GRP_INDEX 3
> +
> +static const struct u300_pin_group u300_pin_groups[] = {
> +	[POWERGRP_INDEX] = {
> +		.name = "powergrp",
> +		.pins = power_pins,
> +		.num_pins = ARRAY_SIZE(power_pins),
> +	},
...
> +/**
> + * struct u300_pmx_func - describes U300 pinmux functions
> + * @name: the name of this specific function
> + * @groups: corresponding pin groups
> + * @onmask: bits to set to enable this when doing pin muxing
> + */
> +struct u300_pmx_func {
> +	const char *name;
> +	const unsigned groups[1];
> +	const struct u300_pmx_mask *mask;
> +};
> +
> +static const struct u300_pmx_func u300_pmx_functions[] = {
> +	{
> +		.name = "power",
> +		.groups = { POWERGRP_INDEX },
> +		/* Mask is N/A */
> +	},

Hmmm. That's a lot of _INDEX defines that'd need to be set up, at least
to fully represent a chip like Tegra. Can the pinmux core be modified
such that the group list is an array of names (char*) rather than the
actual numeric IDs of the groups? Still, perhaps we could use the enum
we already have for this, so perhaps it isn't a big deal...

-- 
nvpublic

