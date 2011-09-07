Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1IHE6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 00:58:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59600 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1IHE6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 00:58:38 -0400
Date: Wed, 7 Sep 2011 10:37:02 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 53/62] spi: irq: Remove IRQF_DISABLED
Message-ID: <20110907173702.GB9937@ponder.secretlab.ca>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-54-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315383059-3673-54-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 04:10:50PM +0800, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/spi/spi-bfin5xx.c       |    2 +-
>  drivers/spi/spi-coldfire-qspi.c |    2 +-
>  drivers/spi/spi-ppc4xx.c        |    2 +-
>  drivers/spi/spi-sh-msiof.c      |    2 +-
>  drivers/spi/spi-sh.c            |    2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
> index b8d25f2..3b83ff8 100644
> --- a/drivers/spi/spi-bfin5xx.c
> +++ b/drivers/spi/spi-bfin5xx.c
> @@ -1098,7 +1098,7 @@ static int bfin_spi_setup(struct spi_device *spi)
>  
>  	if (chip->pio_interrupt && !drv_data->irq_requested) {
>  		ret = request_irq(drv_data->spi_irq, bfin_spi_pio_irq_handler,
> -			IRQF_DISABLED, "BFIN_SPI", drv_data);
> +			0, "BFIN_SPI", drv_data);
>  		if (ret) {
>  			dev_err(&spi->dev, "Unable to register spi IRQ\n");
>  			goto error;
> diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
> index ae2cd1c..7397c4d 100644
> --- a/drivers/spi/spi-coldfire-qspi.c
> +++ b/drivers/spi/spi-coldfire-qspi.c
> @@ -487,7 +487,7 @@ static int __devinit mcfqspi_probe(struct platform_device *pdev)
>  		goto fail2;
>  	}
>  
> -	status = request_irq(mcfqspi->irq, mcfqspi_irq_handler, IRQF_DISABLED,
> +	status = request_irq(mcfqspi->irq, mcfqspi_irq_handler, 0,
>  			     pdev->name, mcfqspi);
>  	if (status) {
>  		dev_dbg(&pdev->dev, "request_irq failed\n");
> diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
> index b267fd9..8ec43e0 100644
> --- a/drivers/spi/spi-ppc4xx.c
> +++ b/drivers/spi/spi-ppc4xx.c
> @@ -514,7 +514,7 @@ static int __init spi_ppc4xx_of_probe(struct platform_device *op)
>  	/* Request IRQ */
>  	hw->irqnum = irq_of_parse_and_map(np, 0);
>  	ret = request_irq(hw->irqnum, spi_ppc4xx_int,
> -			  IRQF_DISABLED, "spi_ppc4xx_of", (void *)hw);
> +			  0, "spi_ppc4xx_of", (void *)hw);
>  	if (ret) {
>  		dev_err(dev, "unable to allocate interrupt\n");
>  		goto free_gpios;
> diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
> index e00d94b..e38554f 100644
> --- a/drivers/spi/spi-sh-msiof.c
> +++ b/drivers/spi/spi-sh-msiof.c
> @@ -635,7 +635,7 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
>  		goto err2;
>  	}
>  
> -	ret = request_irq(i, sh_msiof_spi_irq, IRQF_DISABLED,
> +	ret = request_irq(i, sh_msiof_spi_irq, 0,
>  			  dev_name(&pdev->dev), p);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to request irq\n");
> diff --git a/drivers/spi/spi-sh.c b/drivers/spi/spi-sh.c
> index 9eedd71..e0343d4 100644
> --- a/drivers/spi/spi-sh.c
> +++ b/drivers/spi/spi-sh.c
> @@ -484,7 +484,7 @@ static int __devinit spi_sh_probe(struct platform_device *pdev)
>  		goto error2;
>  	}
>  
> -	ret = request_irq(irq, spi_sh_irq, IRQF_DISABLED, "spi_sh", ss);
> +	ret = request_irq(irq, spi_sh_irq, 0, "spi_sh", ss);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "request_irq error\n");
>  		goto error3;
> -- 
> 1.7.4.1
> 
