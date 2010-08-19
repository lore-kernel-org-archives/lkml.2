Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab0HSMkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:40:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51589 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0HSMkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NqAh+v/RqKX3P2XbMPLAJL29IDCelS9qofgrkJEM7SMfu0alUtW/obb2yskS9vpveY
         tLdJRatVMhVcibxeWjsdUqPtE8cP/4AzvzbdvkQQjd66zTXayyDLNCas+S3bwRu9gumH
         NQGyN+eFDllGO7u2VQqe9HXJtUHGSzeJZqogI=
Date: Thu, 19 Aug 2010 16:40:42 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dwmw2@infradead.org, felipe.balbi@nokia.com, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com, roger.quadros@nokia.com
Subject: Re: [PATCHv2 2/2] omap: rx51: add support for USB chargers
Message-ID: <20100819124042.GA15837@oksana.dev.rtsoft.ru>
References: <1282219777-17657-1-git-send-email-ext-heikki.krogerus@nokia.com>
 <1282219777-17657-3-git-send-email-ext-heikki.krogerus@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1282219777-17657-3-git-send-email-ext-heikki.krogerus@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 03:09:37PM +0300, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
> 
> This enables isp1704 power supply driver on RX51, allowing
> USB charger detection with N900.
> 
> Signed-off-by: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> index 9a5eb87..a4b1f8b 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -104,6 +104,10 @@ static struct spi_board_info rx51_peripherals_spi_board_info[] __initdata = {
>  	},
>  };
>  
> +static struct platform_device rx51_charger_device = {
> +	.name = "isp1704_charger",
> +};
> +
>  #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
>  
>  #define RX51_GPIO_CAMERA_LENS_COVER	110
> @@ -909,5 +913,6 @@ void __init rx51_peripherals_init(void)
>  	spi_register_board_info(rx51_peripherals_spi_board_info,
>  				ARRAY_SIZE(rx51_peripherals_spi_board_info));
>  	omap2_hsmmc_init(mmc);
> +	platform_device_register(&rx51_charger_device);

Maybe

  platform_device_register_simple("isp1704_charger", -1, NULL, 0);

?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
