Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1KPQzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:55:41 -0500
Received: from smtp-out-055.synserver.de ([212.40.185.55]:1052 "HELO
	smtp-out-054.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754919Ab1KPQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:55:38 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24959
Message-ID: <4EC3EB33.8010304@metafoo.de>
Date: Wed, 16 Nov 2011 17:56:19 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 7/7] staging:iio:dac: Add AD5380 driver
References: <1321457302-8724-1-git-send-email-lars@metafoo.de> <1321457302-8724-7-git-send-email-lars@metafoo.de>
In-Reply-To: <1321457302-8724-7-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 04:28 PM, Lars-Peter Clausen wrote:
> This patch adds support for the Analog Devices D5380, AD5381,
> AD5382, AD5383, AD5384, AD5390, AD5391, AD5392 multi-channel
> Digital to Analog Converters.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> ---
> There should be no compile time dependencies to the regmap patches earlier in
> this series, so this patch can be merged independently of it.
> ---
>  drivers/staging/iio/dac/Kconfig  |   11 +
>  drivers/staging/iio/dac/Makefile |    1 +
>  drivers/staging/iio/dac/ad5380.c |  669 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 681 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/iio/dac/ad5380.c
> 
> diff --git a/drivers/staging/iio/dac/Kconfig b/drivers/staging/iio/dac/Kconfig
> index a71defb..aaa6d46 100644
> --- a/drivers/staging/iio/dac/Kconfig
> +++ b/drivers/staging/iio/dac/Kconfig
> @@ -24,6 +24,17 @@ config AD5360
>  	  To compile this driver as module choose M here: the module will be called
>  	  ad5360.
>  
> +config AD5380
> +	tristate "Analog Devices AD5380/81/82/83/84/90/91/92 DAC driver"
> +	depends on (SPI_MASTER || I2C)

Somehow the 'select REGMAP_I2C if I2C' and 'select REGMAP_SPI if SPI_MASTER'
didn't made it into this patch. I'll fix it for v2.

> +	help
> +	  Say yes here to build support for Analog Devices AD5380, AD5381,
> +	  AD5382, AD5383, AD5384, AD5390, AD5391, AD5392 multi-channel
> +	  Digital to Analog Converters (DAC).
> +
> +	  To compile this driver as module choose M here: the module will be called
> +	  ad5380.
> +
>  config AD5421
>  	tristate "Analog Devices AD5421 DAC driver"
>  	depends on SPI
> diff --git a/drivers/staging/iio/dac/Makefile b/drivers/staging/iio/dac/Makefile
> index e75b0c8..840e94e 100644
> --- a/drivers/staging/iio/dac/Makefile
> +++ b/drivers/staging/iio/dac/Makefile
> @@ -3,6 +3,7 @@
>  #
>  
>  obj-$(CONFIG_AD5360) += ad5360.o
> +obj-$(CONFIG_AD5380) += ad5380.o
>  obj-$(CONFIG_AD5421) += ad5421.o
>  obj-$(CONFIG_AD5624R_SPI) += ad5624r_spi.o
>  obj-$(CONFIG_AD5064) += ad5064.o
> [...]
