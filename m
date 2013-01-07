Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3AGMOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 07:14:40 -0500
Received: from [216.228.121.140] ([216.228.121.140]:13225 "EHLO
	hqemgate03.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3AGMOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 07:14:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Jan 2013 04:13:55 -0800
Date: Mon, 7 Jan 2013 14:13:47 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 01/11] clk: tegra: Add tegra specific clocks
Message-ID: <20130107121347.GG26066@tbergstrom-lnx.Nvidia.com>
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
 <1356619644-18565-2-git-send-email-pgaikwad@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1356619644-18565-2-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 03:47:14PM +0100, Prashant Gaikwad wrote:
> Add tegra specific clocks, pll, pll_out, peripheral,
> frac_divider, super.
> 

...

> diff --git a/drivers/clk/tegra/clk-pll-out.c b/drivers/clk/tegra/clk-pll-out.c
> new file mode 100644
> index 0000000..60a117b
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-pll-out.c
> @@ -0,0 +1,124 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clk.h>
> +
> +#include "clk.h"
> +
> +#define to_clk_pll_out(_hw) container_of(_hw, struct tegra_clk_pll_out, hw)
> +
> +#define pll_out_enb(p) (BIT(p->enb_bit_idx))
> +#define pll_out_rst(p) (BIT(p->rst_bit_idx))
> +

Given that these 2 are always consecutive bits, wouldn't it make more sense to
specify the bit offset once and then add 1 for the enable bit?

Cheers,

Peter.
