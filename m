Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab2AMKA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 05:00:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34900 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2AMKAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 05:00:55 -0500
Subject: Re: [PATCH] backlight: Return proper error in l4f00242t03_probe if
 regulator_get fails
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1326445253.12667.1.camel@phoenix>
References: <1326445253.12667.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jan 2012 11:00:50 +0100
Message-ID: <1326448850.3123.2.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Fri, 2012-01-13 at 17:00 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/backlight/l4f00242t03.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> index fae421a..6022b67 100644
> --- a/drivers/video/backlight/l4f00242t03.c
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -190,6 +190,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
>  
>  	priv->io_reg = regulator_get(&spi->dev, "vdd");
>  	if (IS_ERR(priv->io_reg)) {
> +		ret = PTR_ERR(priv->io_reg);
>  		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
>  		       __func__);
>  		goto err3;
> @@ -197,6 +198,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
>  
>  	priv->core_reg = regulator_get(&spi->dev, "vcore");
>  	if (IS_ERR(priv->core_reg)) {
> +		ret = PTR_ERR(priv->core_reg);
>  		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
>  		       __func__);
>  		goto err4;

Of course, I totally missed them..

Acked-by: Alberto Panizzo <alberto@amarulasolutions.com>

Thank you,
Alberto


