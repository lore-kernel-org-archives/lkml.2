Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab2FOIoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:44:07 -0400
Received: from smtp-out-050.synserver.de ([212.40.185.50]:1074 "EHLO
	smtp-out-048.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751734Ab2FOIoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:44:02 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29226
Message-ID: <4FDAF6A9.5060908@metafoo.de>
Date: Fri, 15 Jun 2012 10:47:37 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] iio: dac: Convert ad5380 to devm_regmap_* APIs
References: <1339749621.7253.1.camel@phoenix>
In-Reply-To: <1339749621.7253.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 10:40 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
>  drivers/iio/dac/ad5380.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iio/dac/ad5380.c b/drivers/iio/dac/ad5380.c
> index 5dfb445..14991ac 100644
> --- a/drivers/iio/dac/ad5380.c
> +++ b/drivers/iio/dac/ad5380.c
> @@ -373,7 +373,7 @@ static int __devinit ad5380_probe(struct device *dev, struct regmap *regmap,
>  	if (indio_dev == NULL) {
>  		dev_err(dev, "Failed to allocate iio device\n");
>  		ret = -ENOMEM;
> -		goto error_regmap_exit;
> +		goto error_out;
>  	}
>  
>  	st = iio_priv(indio_dev);
> @@ -436,8 +436,7 @@ error_free_reg:
>  	kfree(indio_dev->channels);
>  error_free:
>  	iio_device_free(indio_dev);
> -error_regmap_exit:
> -	regmap_exit(regmap);
> +error_out:
>  
>  	return ret;
>  }
> @@ -456,7 +455,6 @@ static int __devexit ad5380_remove(struct device *dev)
>  		regulator_put(st->vref_reg);
>  	}
>  
> -	regmap_exit(st->regmap);
>  	iio_device_free(indio_dev);
>  
>  	return 0;
> @@ -485,7 +483,7 @@ static int __devinit ad5380_spi_probe(struct spi_device *spi)
>  	const struct spi_device_id *id = spi_get_device_id(spi);
>  	struct regmap *regmap;
>  
> -	regmap = regmap_init_spi(spi, &ad5380_regmap_config);
> +	regmap = devm_regmap_init_spi(spi, &ad5380_regmap_config);
>  
>  	if (IS_ERR(regmap))
>  		return PTR_ERR(regmap);
> @@ -559,7 +557,7 @@ static int __devinit ad5380_i2c_probe(struct i2c_client *i2c,
>  {
>  	struct regmap *regmap;
>  
> -	regmap = regmap_init_i2c(i2c, &ad5380_regmap_config);
> +	regmap = devm_regmap_init_i2c(i2c, &ad5380_regmap_config);
>  
>  	if (IS_ERR(regmap))
>  		return PTR_ERR(regmap);

