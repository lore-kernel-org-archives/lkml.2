Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2AHNGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 08:06:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54391 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2AHNF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 08:05:59 -0500
Date: Sun, 8 Jan 2012 21:05:44 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, w.sang@pengutronix.de, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, cjb@laptop.org,
        devicetree-discuss@lists.ozlabs.org, shawn.guo@freescale.com
Subject: Re: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
Message-ID: <20120108130542.GC2203@richard-laptop>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-4-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324402840-32451-4-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
> --- /dev/null
> +++ b/drivers/pinctrl/pinctrl-imx53.c
> @@ -0,0 +1,443 @@
> +/*
> + * imx53 pinctrl driver based on imx pinmux core
> + *
> + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> + * Copyright (C) 2011 Linaro, Inc.
> + *
> + * Author: Dong Aisheng <dong.aisheng@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/pinctrl/pinmux.h>
> +
> +#include "pinctrl-imx-core.h"
> +
> +#define IMX53_IOMUXC_MUX_OFFSET 0x20
> +#define IMX53_IOMUXC_MAXPIN	(23*23)
> +
> +enum imx_imx53_pinctrl_pads {
> +	MX53_GPIO_19 = 0,
> +	MX53_KEY_COL0 = 1,
> +	MX53_KEY_ROW0 = 2,
> +	MX53_KEY_COL1 = 3,
> +	MX53_KEY_ROW1 = 4,
> +	MX53_KEY_COL2 = 5,
> +	MX53_KEY_ROW2 = 6,
...
Why not describe it in dts and make this file generic for imx?
One node for one pad, it'll be easy to extend pad properties. You know
the pad may set pull up/down, open drain, drive strenth, daisy chain etc.
The features have to be supported, to make your model usefull.

Thanks
Richard
