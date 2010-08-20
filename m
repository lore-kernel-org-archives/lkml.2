Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab0HTUqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:46:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51283 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab0HTUqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:46:48 -0400
Date: Fri, 20 Aug 2010 14:46:45 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Jassi Brar <jassi.brar@samsung.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] spi/spi_s3c64xx: Make probe more robust against
 missing board config
Message-ID: <20100820204645.GA13910@angua.secretlab.ca>
References: <1282321028-32196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282321028-32196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 05:17:07PM +0100, Mark Brown wrote:
> The S3C64xx SPI driver requires the machine to call s3c64xx_spi_set_info()
> to select a few options, including the clock to use for the SPI controller.
> If this is not done then a NULL will be passed as the clock name for
> clk_get(), causing an obscure crash. Guard against this and other missing
> configuration by validating that the clock name has been filled in in
> the platform data that ets passed in.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Both patches applied, thanks.

g.

> ---
>  drivers/spi/spi_s3c64xx.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
> index 9736581..a0b63b7 100644
> --- a/drivers/spi/spi_s3c64xx.c
> +++ b/drivers/spi/spi_s3c64xx.c
> @@ -919,6 +919,13 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> +	sci = pdev->dev.platform_data;
> +	if (!sci->src_clk_name) {
> +		dev_err(&pdev->dev,
> +			"Board init must call s3c64xx_spi_set_info()\n");
> +		return -EINVAL;
> +	}
> +
>  	/* Check for availability of necessary resource */
>  
>  	dmatx_res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> @@ -946,8 +953,6 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	sci = pdev->dev.platform_data;
> -
>  	platform_set_drvdata(pdev, master);
>  
>  	sdd = spi_master_get_devdata(master);
> -- 
> 1.7.1
> 
