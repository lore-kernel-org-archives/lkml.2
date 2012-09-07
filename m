Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab2IGV2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:28:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab2IGV2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:28:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Murali Karicheri <m-karicheri2@ti.com>, <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@secretlab.ca>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1346351121-27710-1-git-send-email-m-karicheri2@ti.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>
References: <1346351121-27710-1-git-send-email-m-karicheri2@ti.com>
Message-ID: <20120907212813.20289.53844@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH] spi:clk: preparation for switch to common clock framework
Date: Fri, 07 Sep 2012 14:28:13 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Murali Karicheri (2012-08-30 11:25:21)
> As a first step towards migrating davinci platforms to use common clock
> framework, replace all instances of clk_enable() with clk_prepare_enable()
> and clk_disable() with clk_disable_unprepare(). Until the platform is
> switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
> adds a might_sleep() call and would work without any issues.
> 
> This will make it easy later to switch to common clk based implementation
> of clk driver from DaVinci specific driver.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Acked-by: Mike Turquette <mturquette@linaro.org>

> ---
>  drivers/spi/spi-davinci.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
> index 9b2901f..71a6423 100644
> --- a/drivers/spi/spi-davinci.c
> +++ b/drivers/spi/spi-davinci.c
> @@ -873,7 +873,7 @@ static int __devinit davinci_spi_probe(struct platform_device *pdev)
>                 ret = -ENODEV;
>                 goto put_master;
>         }
> -       clk_enable(dspi->clk);
> +       clk_prepare_enable(dspi->clk);
>  
>         master->bus_num = pdev->id;
>         master->num_chipselect = pdata->num_chipselect;
> @@ -959,7 +959,7 @@ free_dma:
>         edma_free_channel(dspi->dma.rx_channel);
>         edma_free_slot(dspi->dma.dummy_param_slot);
>  free_clk:
> -       clk_disable(dspi->clk);
> +       clk_disable_unprepare(dspi->clk);
>         clk_put(dspi->clk);
>  put_master:
>         spi_master_put(master);
> @@ -995,7 +995,7 @@ static int __devexit davinci_spi_remove(struct platform_device *pdev)
>  
>         spi_bitbang_stop(&dspi->bitbang);
>  
> -       clk_disable(dspi->clk);
> +       clk_disable_unprepare(dspi->clk);
>         clk_put(dspi->clk);
>         spi_master_put(master);
>         free_irq(dspi->irq, dspi);
> -- 
> 1.7.9.5
