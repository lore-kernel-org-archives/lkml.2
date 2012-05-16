Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033Ab2EPSB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:01:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43613 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759746Ab2EPSB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:01:56 -0400
Date: Wed, 16 May 2012 20:01:54 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: mc13xxx: Core should not be user visible
Message-ID: <20120516180154.GL22395@pengutronix.de>
References: <1337190669-29328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337190669-29328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 16, 2012 at 06:51:08PM +0100, Mark Brown wrote:
> Since the core is not usable without one of the bus modules it should not
> be presented in the UI but should instead be selected by the bus modules.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/Kconfig |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index ffb7c05..8bc76aa 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -614,7 +614,7 @@ config MFD_MC13783
>  	tristate
>  
>  config MFD_MC13XXX
> -	tristate "Support Freescale MC13783 and MC13892"
> +	tristate
>  	depends on SPI_MASTER || I2C
>  	select MFD_CORE
>  	select MFD_MC13783
> @@ -624,12 +624,11 @@ config MFD_MC13XXX
>  	  additional drivers must be enabled in order to use the
>  	  functionality of the device.
>  
> -if MFD_MC13XXX
> -
>  config MFD_MC13XXX_SPI
>  	tristate "MC13xxx SPI interface" if SPI_MASTER
>  	default SPI_MASTER
>  	select REGMAP_SPI
> +	select MFD_MC13XXX
>  	help
>  	  Select this if your MC13xxx is connected via an SPI bus.
>  
> @@ -637,11 +636,10 @@ config MFD_MC13XXX_I2C
>  	tristate "MC13xxx I2C interface" if I2C
>  	default I2C
>  	select REGMAP_I2C
> +	select MFD_MC13XXX
>  	help
>  	  Select this if your MC13xxx is connected via an I2C bus.
>  
> -endif
> -
If you change the logic in this way please change

	tristate "MC13xxx SPI interface" if SPI_MASTER
	default SPI_MASTER

to

	tristate "Freescale MC13783 and MC13892 SPI interface"
	depends on SPI_MASTER

and similar to the i2c part. IIRC only MC13892 supports i2c.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
