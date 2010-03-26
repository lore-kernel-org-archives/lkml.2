Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0CZKOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 06:14:43 -0400
Received: from mga06.intel.com ([134.134.136.21]:30105 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752910Ab0CZKOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 06:14:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,313,1267430400"; 
   d="scan'208";a="503888247"
Date: Fri, 26 Mar 2010 11:15:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] mfd: Add timb-dma to all configurations of
 timberdale
Message-ID: <20100326101525.GA3237@sortiz.org>
References: <1269542663.9188.39.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269542663.9188.39.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Thu, Mar 25, 2010 at 07:44:23PM +0100, Richard Röjfors wrote:
> Add platform data for timb-dma, and add it in to timb-dma
> in all configurations of timberdale.
> 
> Also incremented the version number.
Many thanks, patch applied to my for-next branch.

Cheers,
Samuel.


> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
> index 1d52349..a7f3048 100644
> --- a/drivers/mfd/timberdale.c
> +++ b/drivers/mfd/timberdale.c
> @@ -40,6 +40,8 @@
>  
>  #include <media/timb_radio.h>
>  
> +#include <linux/timb_dma.h>
> +
>  #include "timberdale.h"
>  
>  #define DRIVER_NAME "timberdale"
> @@ -269,6 +271,65 @@ static __devinitdata struct timb_radio_platform_data
>  	}
>  };
>  
> +static __devinitdata struct timb_dma_platform_data timb_dma_platform_data = {
> +	.nr_channels = 10,
> +	.channels = {
> +		{
> +			/* UART RX */
> +			.rx = true,
> +			.descriptors = 2,
> +			.descriptor_elements = 1
> +		},
> +		{
> +			/* UART TX */
> +			.rx = false,
> +			.descriptors = 2,
> +			.descriptor_elements = 1
> +		},
> +		{
> +			/* MLB RX */
> +			.rx = true,
> +			.descriptors = 2,
> +			.descriptor_elements = 1
> +		},
> +		{
> +			/* MLB TX */
> +			.rx = false,
> +			.descriptors = 2,
> +			.descriptor_elements = 1
> +		},
> +		{
> +			/* Video RX */
> +			.rx = true,
> +			.bytes_per_line = 1440,
> +			.descriptors = 2,
> +			.descriptor_elements = 16
> +		},
> +		{
> +			/* Video framedrop */
> +		},
> +		{
> +			/* SDHCI RX */
> +			.rx = true,
> +		},
> +		{
> +			/* SDHCI TX */
> +		},
> +		{
> +			/* ETH RX */
> +			.rx = true,
> +			.descriptors = 2,
> +			.descriptor_elements = 1
> +		},
> +		{
> +			/* ETH TX */
> +			.rx = false,
> +			.descriptors = 2,
> +			.descriptor_elements = 1
> +		},
> +	}
> +};
> +
>  const static __devinitconst struct resource timberdale_dma_resources[] = {
>  	{
>  		.start	= DMAOFFSET,
> @@ -284,6 +345,13 @@ const static __devinitconst struct resource timberdale_dma_resources[] = {
>  
>  static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
>  	{
> +		.name = "timb-dma",
> +		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
> +		.resources = timberdale_dma_resources,
> +		.platform_data = &timb_dma_platform_data,
> +		.data_size = sizeof(timb_dma_platform_data),
> +	},
> +	{
>  		.name = "timb-uart",
>  		.num_resources = ARRAY_SIZE(timberdale_uart_resources),
>  		.resources = timberdale_uart_resources,
> @@ -321,14 +389,16 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
>  		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
>  		.resources = timberdale_eth_resources,
>  	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
>  	{
>  		.name = "timb-dma",
>  		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
>  		.resources = timberdale_dma_resources,
> +		.platform_data = &timb_dma_platform_data,
> +		.data_size = sizeof(timb_dma_platform_data),
>  	},
> -};
> -
> -static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
>  	{
>  		.name = "timb-uart",
>  		.num_resources = ARRAY_SIZE(timberdale_uart_resources),
> @@ -377,14 +447,16 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
>  		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
>  		.resources = timberdale_eth_resources,
>  	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
>  	{
>  		.name = "timb-dma",
>  		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
>  		.resources = timberdale_dma_resources,
> +		.platform_data = &timb_dma_platform_data,
> +		.data_size = sizeof(timb_dma_platform_data),
>  	},
> -};
> -
> -static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
>  	{
>  		.name = "timb-uart",
>  		.num_resources = ARRAY_SIZE(timberdale_uart_resources),
> @@ -418,14 +490,16 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
>  		.platform_data = &timberdale_xspi_platform_data,
>  		.data_size = sizeof(timberdale_xspi_platform_data),
>  	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
>  	{
>  		.name = "timb-dma",
>  		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
>  		.resources = timberdale_dma_resources,
> +		.platform_data = &timb_dma_platform_data,
> +		.data_size = sizeof(timb_dma_platform_data),
>  	},
> -};
> -
> -static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
>  	{
>  		.name = "timb-uart",
>  		.num_resources = ARRAY_SIZE(timberdale_uart_resources),
> @@ -464,11 +538,6 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
>  		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
>  		.resources = timberdale_eth_resources,
>  	},
> -	{
> -		.name = "timb-dma",
> -		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
> -		.resources = timberdale_dma_resources,
> -	},
>  };
>  
>  static const __devinitconst struct resource timberdale_sdhc_resources[] = {
> diff --git a/drivers/mfd/timberdale.h b/drivers/mfd/timberdale.h
> index 8d27ffa..3683a47 100644
> --- a/drivers/mfd/timberdale.h
> +++ b/drivers/mfd/timberdale.h
> @@ -23,7 +23,7 @@
>  #ifndef MFD_TIMBERDALE_H
>  #define MFD_TIMBERDALE_H
>  
> -#define DRV_VERSION		"0.1"
> +#define DRV_VERSION		"0.2"
>  
>  /* This driver only support versions >= 3.8 and < 4.0  */
>  #define TIMB_SUPPORTED_MAJOR	3
> @@ -127,4 +127,16 @@
>  #define GPIO_PIN_BT_RST		15
>  #define GPIO_NR_PINS		16
>  
> +/* DMA Channels */
> +#define DMA_UART_RX         0
> +#define DMA_UART_TX         1
> +#define DMA_MLB_RX          2
> +#define DMA_MLB_TX          3
> +#define DMA_VIDEO_RX        4
> +#define DMA_VIDEO_DROP      5
> +#define DMA_SDHCI_RX        6
> +#define DMA_SDHCI_TX        7
> +#define DMA_ETH_RX          8
> +#define DMA_ETH_TX          9
> +
>  #endif
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
