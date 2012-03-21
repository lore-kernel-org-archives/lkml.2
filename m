Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030620Ab2CUKH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:07:27 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:58424 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2CUKHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:07:25 -0400
Date: Wed, 21 Mar 2012 10:59:07 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        dmitry.torokhov@gmail.com, mpm@selenic.com,
        herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it
Subject: Re: [PATCH 2/6] mmc: Kconfig: remove choice between at91_mci and
 atmel-mci
Message-ID: <20120321095907.GI11834@ldesroches-Latitude-E6320>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
 <d86c9743d2434e2c6a2a34cefe6c989e0efa9652.1331826095.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d86c9743d2434e2c6a2a34cefe6c989e0efa9652.1331826095.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:57:18PM +0100, Nicolas Ferre wrote:
> This choice is not so important now that atmel-mci supports every
> Atmel AT91 SoC except AT91RM9200. As this newer driver is better
> maintained choose this one to avoid confusion.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks for this patch, it's a new step to have only one mci driver.

Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Regards

Ludovic

> ---
>  drivers/mmc/host/Kconfig |   13 ++-----------
>  1 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 00fcbed..455a414 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -270,16 +270,9 @@ config MMC_AU1X
>  
>  	  If unsure, say N.
>  
> -choice
> -	prompt "Atmel SD/MMC Driver"
> -	depends on AVR32 || ARCH_AT91
> -	default MMC_ATMELMCI if AVR32
> -	help
> -	  Choose which driver to use for the Atmel MCI Silicon
> -
>  config MMC_AT91
>  	tristate "AT91 SD/MMC Card Interface support"
> -	depends on ARCH_AT91
> +	depends on ARCH_AT91RM9200
>  	help
>  	  This selects the AT91 MCI controller.
>  
> @@ -287,7 +280,7 @@ config MMC_AT91
>  
>  config MMC_ATMELMCI
>  	tristate "Atmel Multimedia Card Interface support"
> -	depends on AVR32 || ARCH_AT91
> +	depends on AVR32 || (ARCH_AT91 && !ARCH_AT91RM9200)
>  	help
>  	  This selects the Atmel Multimedia Card Interface driver. If
>  	  you have an AT32 (AVR32) or AT91 platform with a Multimedia
> @@ -295,8 +288,6 @@ config MMC_ATMELMCI
>  
>  	  If unsure, say N.
>  
> -endchoice
> -
>  config MMC_ATMELMCI_DMA
>  	bool "Atmel MCI DMA support"
>  	depends on MMC_ATMELMCI && (AVR32 || ARCH_AT91SAM9G45) && DMA_ENGINE
> -- 
> 1.7.9
> 
