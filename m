Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0LWO3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:29:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60335 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0LWO3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:29:45 -0500
Date: Thu, 23 Dec 2010 15:29:34 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net,
        David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spi_imx.c: TRIVIAL mx25 & mx35 SPI_VER is 0.7
Message-ID: <20101223142934.GU14221@pengutronix.de>
References: <1293102730-32528-1-git-send-email-richard.genoud@gmail.com> <1293102730-32528-2-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1293102730-32528-2-git-send-email-richard.genoud@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:12:10PM +0100, Richard Genoud wrote:
> The check on cpu_is_mx25 and cpu_is_mx35 was made twice.
> This is obviously wrong.
obviously wrong but no wrong behaviour.  Your patch only makes the code
consistent, but IMHO it doesn't qualify as a bugfix.

> Anyway, this patch won't change the previous behaviour which is
> SPI_IMX_VER_0_7 for mx25 and mx35.
This conflicts with
http://mid.gmane.org/1290589546-21662-1-git-send-email-u.kleine-koenig@pengutronix.de

which I prefer.  The platform IDs have it correct (i.e.

	imx25-cspi -> 0.7
	imx31-cspi -> 0.4
	imx35-cspi -> 0.7

)

Best regards
Uwe

> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  drivers/spi/spi_imx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
> index 793ae99..96be9d1 100644
> --- a/drivers/spi/spi_imx.c
> +++ b/drivers/spi/spi_imx.c
> @@ -806,7 +806,7 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
>  		if (cpu_is_mx25() || cpu_is_mx35())
>  			spi_imx->devtype_data =
>  				spi_imx_devtype_data[SPI_IMX_VER_0_7];
> -		else if (cpu_is_mx25() || cpu_is_mx31() || cpu_is_mx35())
> +		else if (cpu_is_mx31())
>  			spi_imx->devtype_data =
>  				spi_imx_devtype_data[SPI_IMX_VER_0_4];
>  		else if (cpu_is_mx27() || cpu_is_mx21())
> -- 
> 1.7.1
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
