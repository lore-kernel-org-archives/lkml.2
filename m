Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab1E0Brq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:47:46 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:18877 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab1E0Brp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:47:45 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1306460864!20649878!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 26 May 2011 20:47:42 -0500
Subject: RE: [PATCH 5/5] spi/ep93xx: add DMA support
Thread-Topic: [PATCH 5/5] spi/ep93xx: add DMA support
Thread-Index: AcwYonodVAwr+chUQ96uNnjY4Ayi8QDbTEfQ
Message-ID: <0D753D10438DA54287A00B027084269764D331A4B7@AUSP01VMBX24.collaborationhost.net>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <f05f92e531fdb613657bc16c8fd4a2f8653ece55.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <f05f92e531fdb613657bc16c8fd4a2f8653ece55.1306082097.git.mika.westerberg@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 22, 2011 10:03 AM, Mika Westerberg wrote:
>
> This patch adds DMA support for the EP93xx SPI driver. By default the DMA is
> not enabled but it can be enabled by setting ep93xx_spi_info.use_dma to true
> in board configuration file.
> 
> Note that the SPI driver still uses PIO for small transfers (<= 8 bytes) for
> performance reasons.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  Documentation/spi/ep93xx_spi                   |   10 +
>  arch/arm/mach-ep93xx/core.c                    |    6 +-
>  arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h |    2 +
>  drivers/spi/ep93xx_spi.c                       |  303 +++++++++++++++++++++++-
>  4 files changed, 308 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/spi/ep93xx_spi b/Documentation/spi/ep93xx_spi
> index 6325f5b..fc43818 100644
> --- a/Documentation/spi/ep93xx_spi
> +++ b/Documentation/spi/ep93xx_spi
> @@ -88,6 +88,16 @@ static void __init ts72xx_init_machine(void)
>  			    ARRAY_SIZE(ts72xx_spi_devices));
>  }
>  
> +The driver can use DMA for the transfers also. In this case ts72xx_spi_info
> +becomes:
> +
> +static struct ep93xx_spi_info ts72xx_spi_info = {
> +	.num_chipselect	= ARRAY_SIZE(ts72xx_spi_devices),
> +	.use_dma	= true;
> +};
> +
> +Note that CONFIG_DMA_ENGINE and CONFIG_EP93XX_DMA should be enabled as well.

CONFIG_DMA_ENGINE is selected by CONFIG_EP93XX_DMA and it's hidden for that
matter.  Remove that part of the comment.

The reset looks good.

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
