Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab0HUBwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 21:52:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64742 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0HUBwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 21:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HmhlYy0sU3Tt0lXCC/vIhaGqPexQfLeiTnLW2CArQBcTPRZZ8uWQmHxNZqhMgjFt4H
         COghIf+lH9J7inddaLk/FPCa+lTHJQSmPc3DWD7JZiXRHsWJxBgrXDNuVsRkrW6OECAb
         BcHMxcWAeof1fu3wWS1h+2TbBlJPLapBrFw5o=
MIME-Version: 1.0
In-Reply-To: <1282321028-32196-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1282321028-32196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1282321028-32196-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Sat, 21 Aug 2010 10:52:44 +0900
Message-ID: <AANLkTiknsnER2Z-4_h8OC=VAqbjEfF0H0-y8etzW3i0q@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH 2/2] spi/spi_s3c64xx: Staticise
 non-exported functions
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 1:17 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/spi/spi_s3c64xx.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
> index a0b63b7..7e627f7 100644
> --- a/drivers/spi/spi_s3c64xx.c
> +++ b/drivers/spi/spi_s3c64xx.c
> @@ -447,8 +447,8 @@ static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
>        writel(val, regs + S3C64XX_SPI_CLK_CFG);
>  }
>
> -void s3c64xx_spi_dma_rxcb(struct s3c2410_dma_chan *chan, void *buf_id,
> -                               int size, enum s3c2410_dma_buffresult res)
> +static void s3c64xx_spi_dma_rxcb(struct s3c2410_dma_chan *chan, void *buf_id,
> +                                int size, enum s3c2410_dma_buffresult res)
>  {
>        struct s3c64xx_spi_driver_data *sdd = buf_id;
>        unsigned long flags;
> @@ -467,8 +467,8 @@ void s3c64xx_spi_dma_rxcb(struct s3c2410_dma_chan *chan, void *buf_id,
>        spin_unlock_irqrestore(&sdd->lock, flags);
>  }
>
> -void s3c64xx_spi_dma_txcb(struct s3c2410_dma_chan *chan, void *buf_id,
> -                               int size, enum s3c2410_dma_buffresult res)
> +static void s3c64xx_spi_dma_txcb(struct s3c2410_dma_chan *chan, void *buf_id,
> +                                int size, enum s3c2410_dma_buffresult res)
>  {
>        struct s3c64xx_spi_driver_data *sdd = buf_id;
>        unsigned long flags;

Oh, yes. What was I thinking ?!

Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
