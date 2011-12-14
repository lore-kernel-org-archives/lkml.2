Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab1LNCUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:20:41 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:19493
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756510Ab1LNCUe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:20:34 -0500
X-SpamScore: 1
X-BigFish: VS1(zzc89bh1432Nc8kzz1202h1082kzz8275bh8275dhz2dh2a8h668h839h941hb79i62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EE8080F.4090700@freescale.com>
Date: Wed, 14 Dec 2011 10:21:03 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Vinod Koul <vinod.koul@intel.com>, Chris Ball <cjb@laptop.org>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>,
        <linux-mmc@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] mtd: fix compile error for gpmi-nand
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org> <1323791286-29574-4-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1323791286-29574-4-git-send-email-shawn.guo@linaro.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月13日 23:48, Shawn Guo 写道:
> From: Huang Shijie <b32955@freescale.com>
>
> The driver gpmi-nand should compile at least.  This patch adds the
> missing gpmi-nand.h to fix the compile error below.
>
>   CC      drivers/mtd/nand/gpmi-nand/gpmi-nand.o
>   CC      drivers/mtd/nand/gpmi-nand/gpmi-lib.o
> drivers/mtd/nand/gpmi-nand/gpmi-nand.c:25:33: fatal error: linux/mtd/gpmi-nand.h: No such file or directory
> drivers/mtd/nand/gpmi-nand/gpmi-lib.c:21:33: fatal error: linux/mtd/gpmi-nand.h: No such file or directory
>
> This header is grabbed from patch below, which has not been postponed
> for merging.
>
>   [PATCH v8 1/4] ARM: mxs: add GPMI-NAND support for imx23/imx28
>   http://permalink.gmane.org/gmane.linux.drivers.mtd/37338
>
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  include/linux/mtd/gpmi-nand.h |   68 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 68 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/mtd/gpmi-nand.h
>
> diff --git a/include/linux/mtd/gpmi-nand.h b/include/linux/mtd/gpmi-nand.h
> new file mode 100644
> index 0000000..69b6dbf
> --- /dev/null
> +++ b/include/linux/mtd/gpmi-nand.h
> @@ -0,0 +1,68 @@
> +/*
> + * Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#ifndef __MACH_MXS_GPMI_NAND_H__
> +#define __MACH_MXS_GPMI_NAND_H__
> +
> +/* The size of the resources is fixed. */
> +#define GPMI_NAND_RES_SIZE	6
> +
> +/* Resource names for the GPMI NAND driver. */
> +#define GPMI_NAND_GPMI_REGS_ADDR_RES_NAME  "GPMI NAND GPMI Registers"
> +#define GPMI_NAND_GPMI_INTERRUPT_RES_NAME  "GPMI NAND GPMI Interrupt"
> +#define GPMI_NAND_BCH_REGS_ADDR_RES_NAME   "GPMI NAND BCH Registers"
> +#define GPMI_NAND_BCH_INTERRUPT_RES_NAME   "GPMI NAND BCH Interrupt"
> +#define GPMI_NAND_DMA_CHANNELS_RES_NAME    "GPMI NAND DMA Channels"
> +#define GPMI_NAND_DMA_INTERRUPT_RES_NAME   "GPMI NAND DMA Interrupt"
> +
> +/**
> + * struct gpmi_nand_platform_data - GPMI NAND driver platform data.
> + *
> + * This structure communicates platform-specific information to the GPMI NAND
> + * driver that can't be expressed as resources.
> + *
> + * @platform_init:           A pointer to a function the driver will call to
> + *                           initialize the platform (e.g., set up the pin mux).
> + * @min_prop_delay_in_ns:    Minimum propagation delay of GPMI signals to and
> + *                           from the NAND Flash device, in nanoseconds.
> + * @max_prop_delay_in_ns:    Maximum propagation delay of GPMI signals to and
> + *                           from the NAND Flash device, in nanoseconds.
> + * @max_chip_count:          The maximum number of chips for which the driver
> + *                           should configure the hardware. This value most
> + *                           likely reflects the number of pins that are
> + *                           connected to a NAND Flash device. If this is
> + *                           greater than the SoC hardware can support, the
> + *                           driver will print a message and fail to initialize.
> + * @partitions:              An optional pointer to an array of partition
> + *                           descriptions.
> + * @partition_count:         The number of elements in the partitions array.
> + */
> +struct gpmi_nand_platform_data {
> +	/* SoC hardware information. */
> +	int		(*platform_init)(void);
> +
> +	/* NAND Flash information. */
> +	unsigned int	min_prop_delay_in_ns;
> +	unsigned int	max_prop_delay_in_ns;
> +	unsigned int	max_chip_count;
> +
> +	/* Medium information. */
> +	struct		mtd_partition *partitions;
> +	unsigned	partition_count;
> +};
> +#endif
thanks a lot.

Huang Shijie

