Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1JMC0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 22:26:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37575 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1JMCZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 22:25:38 -0400
Date: Wed, 12 Oct 2011 18:34:49 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] ARM: at91/dma: remove platform data from DMA
 controller
Message-ID: <20111013003449.GF14042@ponder.secretlab.ca>
References: <f91f267b82ac0f0459c11a7bdf3ab0ea8758656a.1318438197.git.nicolas.ferre@atmel.com>
 <bcf2b73ecc158bf20f94b00d3b8a6d140eff2026.1318438197.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcf2b73ecc158bf20f94b00d3b8a6d140eff2026.1318438197.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 06:57:13PM +0200, Nicolas Ferre wrote:
> DMA controller can deduce its configuration data from
> the platform. Remove the platform data and match device
> types with the compatible ones.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  arch/arm/mach-at91/at91sam9g45_devices.c   |    9 +--------
>  arch/arm/mach-at91/at91sam9rl_devices.c    |    8 +-------
>  arch/arm/mach-at91/include/mach/at_hdmac.h |   10 ----------
>  3 files changed, 2 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 600bffb..c9b897f 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -38,10 +38,6 @@
>  #if defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)
>  static u64 hdmac_dmamask = DMA_BIT_MASK(32);
>  
> -static struct at_dma_platform_data atdma_pdata = {
> -	.nr_channels	= 8,
> -};
> -
>  static struct resource hdmac_resources[] = {
>  	[0] = {
>  		.start	= AT91_BASE_SYS + AT91_DMA,
> @@ -56,12 +52,11 @@ static struct resource hdmac_resources[] = {
>  };
>  
>  static struct platform_device at_hdmac_device = {
> -	.name		= "at_hdmac",
> +	.name		= "at91sam9g45_dma",
>  	.id		= -1,
>  	.dev		= {
>  				.dma_mask		= &hdmac_dmamask,
>  				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &atdma_pdata,
>  	},
>  	.resource	= hdmac_resources,
>  	.num_resources	= ARRAY_SIZE(hdmac_resources),
> @@ -69,8 +64,6 @@ static struct platform_device at_hdmac_device = {
>  
>  void __init at91_add_device_hdmac(void)
>  {
> -	dma_cap_set(DMA_MEMCPY, atdma_pdata.cap_mask);
> -	dma_cap_set(DMA_SLAVE, atdma_pdata.cap_mask);
>  	platform_device_register(&at_hdmac_device);
>  }
>  #else
> diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
> index aacb19d..81954f7 100644
> --- a/arch/arm/mach-at91/at91sam9rl_devices.c
> +++ b/arch/arm/mach-at91/at91sam9rl_devices.c
> @@ -33,10 +33,6 @@
>  #if defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)
>  static u64 hdmac_dmamask = DMA_BIT_MASK(32);
>  
> -static struct at_dma_platform_data atdma_pdata = {
> -	.nr_channels	= 2,
> -};
> -
>  static struct resource hdmac_resources[] = {
>  	[0] = {
>  		.start	= AT91_BASE_SYS + AT91_DMA,
> @@ -51,12 +47,11 @@ static struct resource hdmac_resources[] = {
>  };
>  
>  static struct platform_device at_hdmac_device = {
> -	.name		= "at_hdmac",
> +	.name		= "at91sam9rl_dma",
>  	.id		= -1,
>  	.dev		= {
>  				.dma_mask		= &hdmac_dmamask,
>  				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &atdma_pdata,
>  	},
>  	.resource	= hdmac_resources,
>  	.num_resources	= ARRAY_SIZE(hdmac_resources),
> @@ -64,7 +59,6 @@ static struct platform_device at_hdmac_device = {
>  
>  void __init at91_add_device_hdmac(void)
>  {
> -	dma_cap_set(DMA_MEMCPY, atdma_pdata.cap_mask);
>  	platform_device_register(&at_hdmac_device);
>  }
>  #else
> diff --git a/arch/arm/mach-at91/include/mach/at_hdmac.h b/arch/arm/mach-at91/include/mach/at_hdmac.h
> index 187cb58..652c1a1 100644
> --- a/arch/arm/mach-at91/include/mach/at_hdmac.h
> +++ b/arch/arm/mach-at91/include/mach/at_hdmac.h
> @@ -14,16 +14,6 @@
>  #include <linux/dmaengine.h>
>  
>  /**
> - * struct at_dma_platform_data - Controller configuration parameters
> - * @nr_channels: Number of channels supported by hardware (max 8)
> - * @cap_mask: dma_capability flags supported by the platform
> - */
> -struct at_dma_platform_data {
> -	unsigned int	nr_channels;
> -	dma_cap_mask_t  cap_mask;
> -};
> -
> -/**
>   * enum at_dma_slave_width - DMA slave register access width.
>   * @AT_DMA_SLAVE_WIDTH_8BIT: Do 8-bit slave register accesses
>   * @AT_DMA_SLAVE_WIDTH_16BIT: Do 16-bit slave register accesses
> -- 
> 1.7.5.4
> 
