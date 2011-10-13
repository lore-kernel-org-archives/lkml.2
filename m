Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1JMC12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 22:27:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54906 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1JMCZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 22:25:37 -0400
Date: Wed, 12 Oct 2011 18:35:22 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] ARM: at91/dma: DMA controller registering with DT
 support
Message-ID: <20111013003522.GG14042@ponder.secretlab.ca>
References: <f91f267b82ac0f0459c11a7bdf3ab0ea8758656a.1318438197.git.nicolas.ferre@atmel.com>
 <8d71a02275bc252b3841bf9f0e2e17a16df6deda.1318438197.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d71a02275bc252b3841bf9f0e2e17a16df6deda.1318438197.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 06:57:14PM +0200, Nicolas Ferre wrote:
> Device tree support on at91sam9g45 family SoC. Only call
> platform_device_register() if no dma-controller node is
> found in device tree.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  arch/arm/mach-at91/at91sam9g45_devices.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index c9b897f..b9888c5 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -64,7 +64,13 @@ static struct platform_device at_hdmac_device = {
>  
>  void __init at91_add_device_hdmac(void)
>  {
> -	platform_device_register(&at_hdmac_device);
> +	struct device_node *of_node =
> +		of_find_node_by_name(NULL, "dma-controller");
> +
> +	if (of_node)
> +		of_node_put(of_node);
> +	else
> +		platform_device_register(&at_hdmac_device);
>  }
>  #else
>  void __init at91_add_device_hdmac(void) {}
> -- 
> 1.7.5.4
> 
