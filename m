Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab3AGOzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:55:16 -0500
Received: from [216.228.121.35] ([216.228.121.35]:5637 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3AGOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:55:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Jan 2013 06:54:32 -0800
Date: Mon, 7 Jan 2013 16:54:30 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 08/11] clk: tegra: add clock support for tegra30
Message-ID: <20130107145430.GH26066@tbergstrom-lnx.Nvidia.com>
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
 <1356619644-18565-9-git-send-email-pgaikwad@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1356619644-18565-9-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 03:47:21PM +0100, Prashant Gaikwad wrote:
> Add tegra30 clock support based on common clock framework.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> ---
>  drivers/clk/tegra/Makefile      |    1 +
>  drivers/clk/tegra/clk-tegra30.c | 1968 +++++++++++++++++++++++++++++++++++++++
>  drivers/clk/tegra/clk.h         |    6 +
>  3 files changed, 1975 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/tegra/clk-tegra30.c
> 
> diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
> index 00484fd..2b41b0f 100644
> --- a/drivers/clk/tegra/Makefile
> +++ b/drivers/clk/tegra/Makefile
> @@ -8,3 +8,4 @@ obj-y                                   += clk-pll-out.o
>  obj-y                                  += clk-super.o
> 
>  obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
> +obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
> diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
> new file mode 100644
> index 0000000..a5496fe
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-tegra30.c
> @@ -0,0 +1,1968 @@
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

...

> +       TEGRA_INIT_DATA_MUX("i2c1",     "div-clk",      "tegra-i2c.0",          mux_pllp_clkm,          CLK_SOURCE_I2C1,        12,     &periph_l_regs, TEGRA_PERIPH_ON_APB, i2c1),
> +       TEGRA_INIT_DATA_MUX("i2c2",     "div-clk",      "tegra-i2c.1",          mux_pllp_clkm,          CLK_SOURCE_I2C2,        54,     &periph_h_regs, TEGRA_PERIPH_ON_APB, i2c2),
> +       TEGRA_INIT_DATA_MUX("i2c3",     "div-clk",      "tegra-i2c.2",          mux_pllp_clkm,          CLK_SOURCE_I2C3,        67,     &periph_u_regs, TEGRA_PERIPH_ON_APB, i2c3),
> +       TEGRA_INIT_DATA_MUX("i2c4",     "div-clk",      "tegra-i2c.3",          mux_pllp_clkm,          CLK_SOURCE_I2C4,        103,    &periph_v_regs, TEGRA_PERIPH_ON_APB, i2c4),
> +       TEGRA_INIT_DATA_MUX("i2c5",     "div-clk",      "tegra-i2c.4",          mux_pllp_clkm,          CLK_SOURCE_I2C5,        47,     &periph_h_regs, TEGRA_PERIPH_ON_APB, i2c5),

These clocks have a 16bit divider according to the TRM, so I think you need
a new type for this?

Cheers,

Peter.
