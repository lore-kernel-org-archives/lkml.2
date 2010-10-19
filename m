Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0JSKVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:21:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:4505 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab0JSKVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:21:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="618141167"
Date: Tue, 19 Oct 2010 12:21:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Douglas Schilling Landgraf <dougsland@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND][PATCH 2/2 v2] mfd: Add timberdale video-in driver to
 timberdale
Message-ID: <20101019102142.GJ2736@sortiz-mobl>
References: <1287074260.6322.18.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287074260.6322.18.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Thu, Oct 14, 2010 at 06:37:40PM +0200, Richard Röjfors wrote:
> This patch defines platform data for the video-in driver
> and adds it to all configurations of timberdale.
> 
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
Mauro, please add my:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Richard, you can automatically add it when re-sending your patchset.

Cheers,
Samuel.

> ---
> diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
> index ac59950..52a651b 100644
> --- a/drivers/mfd/timberdale.c
> +++ b/drivers/mfd/timberdale.c
> @@ -40,6 +40,7 @@
>  #include <linux/spi/mc33880.h>
>  
>  #include <media/timb_radio.h>
> +#include <media/timb_video.h>
>  
>  #include <linux/timb_dma.h>
>  
> @@ -238,7 +239,24 @@ static const __devinitconst struct resource timberdale_uartlite_resources[] = {
>  	},
>  };
>  
> -static const __devinitconst struct resource timberdale_radio_resources[] = {
> +static __devinitdata struct i2c_board_info timberdale_adv7180_i2c_board_info = {
> +	/* Requires jumper JP9 to be off */
> +	I2C_BOARD_INFO("adv7180", 0x42 >> 1),
> +	.irq = IRQ_TIMBERDALE_ADV7180
> +};
> +
> +static __devinitdata struct timb_video_platform_data
> +	timberdale_video_platform_data = {
> +	.dma_channel = DMA_VIDEO_RX,
> +	.i2c_adapter = 0,
> +	.encoder = {
> +		.module_name = "adv7180",
> +		.info = &timberdale_adv7180_i2c_board_info
> +	}
> +};
> +
> +static const __devinitconst struct resource
> +timberdale_radio_resources[] = {
>  	{
>  		.start	= RDSOFFSET,
>  		.end	= RDSEND,
> @@ -272,6 +290,18 @@ static __devinitdata struct timb_radio_platform_data
>  	}
>  };
>  
> +static const __devinitconst struct resource timberdale_video_resources[] = {
> +	{
> +		.start	= LOGIWOFFSET,
> +		.end	= LOGIWEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	/*
> +	note that the "frame buffer" is located in DMA area
> +	starting at 0x1200000
> +	*/
> +};
> +
>  static __devinitdata struct timb_dma_platform_data timb_dma_platform_data = {
>  	.nr_channels = 10,
>  	.channels = {
> @@ -372,6 +402,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
>  		.data_size = sizeof(timberdale_gpio_platform_data),
>  	},
>  	{
> +		.name = "timb-video",
> +		.num_resources = ARRAY_SIZE(timberdale_video_resources),
> +		.resources = timberdale_video_resources,
> +		.platform_data = &timberdale_video_platform_data,
> +		.data_size = sizeof(timberdale_video_platform_data),
> +	},
> +	{
>  		.name = "timb-radio",
>  		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
>  		.resources = timberdale_radio_resources,
> @@ -430,6 +467,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
>  		.resources = timberdale_mlogicore_resources,
>  	},
>  	{
> +		.name = "timb-video",
> +		.num_resources = ARRAY_SIZE(timberdale_video_resources),
> +		.resources = timberdale_video_resources,
> +		.platform_data = &timberdale_video_platform_data,
> +		.data_size = sizeof(timberdale_video_platform_data),
> +	},
> +	{
>  		.name = "timb-radio",
>  		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
>  		.resources = timberdale_radio_resources,
> @@ -478,6 +522,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
>  		.data_size = sizeof(timberdale_gpio_platform_data),
>  	},
>  	{
> +		.name = "timb-video",
> +		.num_resources = ARRAY_SIZE(timberdale_video_resources),
> +		.resources = timberdale_video_resources,
> +		.platform_data = &timberdale_video_platform_data,
> +		.data_size = sizeof(timberdale_video_platform_data),
> +	},
> +	{
>  		.name = "timb-radio",
>  		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
>  		.resources = timberdale_radio_resources,
> @@ -521,6 +572,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
>  		.data_size = sizeof(timberdale_gpio_platform_data),
>  	},
>  	{
> +		.name = "timb-video",
> +		.num_resources = ARRAY_SIZE(timberdale_video_resources),
> +		.resources = timberdale_video_resources,
> +		.platform_data = &timberdale_video_platform_data,
> +		.data_size = sizeof(timberdale_video_platform_data),
> +	},
> +	{
>  		.name = "timb-radio",
>  		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
>  		.resources = timberdale_radio_resources,
> diff --git a/drivers/mfd/timberdale.h b/drivers/mfd/timberdale.h
> index c11bf6e..4412acd 100644
> --- a/drivers/mfd/timberdale.h
> +++ b/drivers/mfd/timberdale.h
> @@ -23,7 +23,7 @@
>  #ifndef MFD_TIMBERDALE_H
>  #define MFD_TIMBERDALE_H
>  
> -#define DRV_VERSION		"0.2"
> +#define DRV_VERSION		"0.3"
>  
>  /* This driver only support versions >= 3.8 and < 4.0  */
>  #define TIMB_SUPPORTED_MAJOR	3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
