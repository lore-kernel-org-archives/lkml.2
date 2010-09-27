Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0I0KcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:32:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:6971 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0I0KcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:32:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,242,1283756400"; 
   d="scan'208";a="329099190"
Date: Mon, 27 Sep 2010 12:32:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: timberdale: Use DMA for ks8842
Message-ID: <20100927103234.GD2560@sortiz-mobl>
References: <1284562164.23817.8.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1284562164.23817.8.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Wed, Sep 15, 2010 at 04:49:24PM +0200, Richard Röjfors wrote:
> This patch defines platform data for the ks8842 int the timberdale
> MFD.
> The platform data contains DMA channels to be used by the driver.
Patch applied, thanks.
You may want to rebase your video-in patches so that Mauro will be able to
apply them cleanly.

Cheers,
Samuel.

> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
> index ac59950..727f62c 100644
> --- a/drivers/mfd/timberdale.c
> +++ b/drivers/mfd/timberdale.c
> @@ -43,6 +43,8 @@
>  
>  #include <linux/timb_dma.h>
>  
> +#include <linux/ks8842.h>
> +
>  #include "timberdale.h"
>  
>  #define DRIVER_NAME "timberdale"
> @@ -161,6 +163,12 @@ static const __devinitconst struct resource timberdale_spi_resources[] = {
>  	},
>  };
>  
> +static __devinitdata struct ks8842_platform_data
> +	timberdale_ks8842_platform_data = {
> +	.rx_dma_channel = DMA_ETH_RX,
> +	.tx_dma_channel = DMA_ETH_TX
> +};
> +
>  static const __devinitconst struct resource timberdale_eth_resources[] = {
>  	{
>  		.start	= ETHOFFSET,
> @@ -389,6 +397,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
>  		.name = "ks8842",
>  		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
>  		.resources = timberdale_eth_resources,
> +		.platform_data = &timberdale_ks8842_platform_data,
> +		.data_size = sizeof(timberdale_ks8842_platform_data)
>  	},
>  };
>  
> @@ -447,6 +457,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
>  		.name = "ks8842",
>  		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
>  		.resources = timberdale_eth_resources,
> +		.platform_data = &timberdale_ks8842_platform_data,
> +		.data_size = sizeof(timberdale_ks8842_platform_data)
>  	},
>  };
>  
> @@ -538,6 +550,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
>  		.name = "ks8842",
>  		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
>  		.resources = timberdale_eth_resources,
> +		.platform_data = &timberdale_ks8842_platform_data,
> +		.data_size = sizeof(timberdale_ks8842_platform_data)
>  	},
>  };
>  
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
