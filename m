Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1KQGuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 01:50:39 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49833 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab1KQGuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 01:50:37 -0500
Message-ID: <4EC4AEC2.1050500@kernel.org>
Date: Thu, 17 Nov 2011 06:50:42 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 4/5] staging:iio: Use module_i2c_driver to register I2C
 drivers
References: <1321434819-23678-1-git-send-email-lars@metafoo.de> <1321434819-23678-5-git-send-email-lars@metafoo.de>
In-Reply-To: <1321434819-23678-5-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 09:13 AM, Lars-Peter Clausen wrote:
> Use the newly introduced module_i2c_driver macro for registering I2C drivers.
> This allows us to remove a few lines of boilerplate code.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  drivers/staging/iio/adc/ad7291.c                |   14 +-------------
>  drivers/staging/iio/adc/ad799x_core.c           |   14 +-------------
>  drivers/staging/iio/adc/adt7410.c               |   14 +-------------
>  drivers/staging/iio/adc/max1363_core.c          |   14 +-------------
>  drivers/staging/iio/addac/adt7316-i2c.c         |   14 +-------------
>  drivers/staging/iio/cdc/ad7150.c                |   14 +-------------
>  drivers/staging/iio/cdc/ad7152.c                |   14 +-------------
>  drivers/staging/iio/cdc/ad7746.c                |   14 +-------------
>  drivers/staging/iio/dac/max517.c                |   14 +-------------
>  drivers/staging/iio/impedance-analyzer/ad5933.c |   13 +------------
>  drivers/staging/iio/light/isl29018.c            |   14 +-------------
>  drivers/staging/iio/light/tsl2563.c             |   14 +-------------
>  drivers/staging/iio/light/tsl2583.c             |   14 +-------------
>  drivers/staging/iio/magnetometer/ak8975.c       |   14 +-------------
>  drivers/staging/iio/magnetometer/hmc5843.c      |   14 +-------------
>  drivers/staging/iio/meter/ade7854-i2c.c         |   14 +-------------
>  16 files changed, 16 insertions(+), 207 deletions(-)
> 
> diff --git a/drivers/staging/iio/adc/ad7291.c b/drivers/staging/iio/adc/ad7291.c
> index 10e79e8..aa44a52 100644
> --- a/drivers/staging/iio/adc/ad7291.c
> +++ b/drivers/staging/iio/adc/ad7291.c
> @@ -700,20 +700,8 @@ static struct i2c_driver ad7291_driver = {
>  	.remove = __devexit_p(ad7291_remove),
>  	.id_table = ad7291_id,
>  };
> -
> -static __init int ad7291_init(void)
> -{
> -	return i2c_add_driver(&ad7291_driver);
> -}
> -
> -static __exit void ad7291_exit(void)
> -{
> -	i2c_del_driver(&ad7291_driver);
> -}
> +module_i2c_driver(ad7291_driver);
>  
>  MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
>  MODULE_DESCRIPTION("Analog Devices AD7291 ADC driver");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(ad7291_init);
> -module_exit(ad7291_exit);
> diff --git a/drivers/staging/iio/adc/ad799x_core.c b/drivers/staging/iio/adc/ad799x_core.c
> index ee6cd79..c0d2f88 100644
> --- a/drivers/staging/iio/adc/ad799x_core.c
> +++ b/drivers/staging/iio/adc/ad799x_core.c
> @@ -929,21 +929,9 @@ static struct i2c_driver ad799x_driver = {
>  	.remove = __devexit_p(ad799x_remove),
>  	.id_table = ad799x_id,
>  };
> -
> -static __init int ad799x_init(void)
> -{
> -	return i2c_add_driver(&ad799x_driver);
> -}
> -
> -static __exit void ad799x_exit(void)
> -{
> -	i2c_del_driver(&ad799x_driver);
> -}
> +module_i2c_driver(ad799x_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD799x ADC");
>  MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS("i2c:ad799x");
> -
> -module_init(ad799x_init);
> -module_exit(ad799x_exit);
> diff --git a/drivers/staging/iio/adc/adt7410.c b/drivers/staging/iio/adc/adt7410.c
> index a289e42..3481cf6 100644
> --- a/drivers/staging/iio/adc/adt7410.c
> +++ b/drivers/staging/iio/adc/adt7410.c
> @@ -844,21 +844,9 @@ static struct i2c_driver adt7410_driver = {
>  	.remove = __devexit_p(adt7410_remove),
>  	.id_table = adt7410_id,
>  };
> -
> -static __init int adt7410_init(void)
> -{
> -	return i2c_add_driver(&adt7410_driver);
> -}
> -
> -static __exit void adt7410_exit(void)
> -{
> -	i2c_del_driver(&adt7410_driver);
> -}
> +module_i2c_driver(adt7410_driver);
>  
>  MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
>  MODULE_DESCRIPTION("Analog Devices ADT7410 digital"
>  			" temperature sensor driver");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(adt7410_init);
> -module_exit(adt7410_exit);
> diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
> index eb699ad..3f28f1a 100644
> --- a/drivers/staging/iio/adc/max1363_core.c
> +++ b/drivers/staging/iio/adc/max1363_core.c
> @@ -1410,20 +1410,8 @@ static struct i2c_driver max1363_driver = {
>  	.remove = max1363_remove,
>  	.id_table = max1363_id,
>  };
> -
> -static __init int max1363_init(void)
> -{
> -	return i2c_add_driver(&max1363_driver);
> -}
> -
> -static __exit void max1363_exit(void)
> -{
> -	i2c_del_driver(&max1363_driver);
> -}
> +module_i2c_driver(max1363_driver);
>  
>  MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
>  MODULE_DESCRIPTION("Maxim 1363 ADC");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(max1363_init);
> -module_exit(max1363_exit);
> diff --git a/drivers/staging/iio/addac/adt7316-i2c.c b/drivers/staging/iio/addac/adt7316-i2c.c
> index 07d718e..2c03a39 100644
> --- a/drivers/staging/iio/addac/adt7316-i2c.c
> +++ b/drivers/staging/iio/addac/adt7316-i2c.c
> @@ -151,21 +151,9 @@ static struct i2c_driver adt7316_driver = {
>  	.resume = adt7316_i2c_resume,
>  	.id_table = adt7316_i2c_id,
>  };
> -
> -static __init int adt7316_i2c_init(void)
> -{
> -	return i2c_add_driver(&adt7316_driver);
> -}
> -
> -static __exit void adt7316_i2c_exit(void)
> -{
> -	i2c_del_driver(&adt7316_driver);
> -}
> +module_i2c_driver(adt7316_driver);
>  
>  MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
>  MODULE_DESCRIPTION("I2C bus driver for Analog Devices ADT7316/7/9 and"
>  			"ADT7516/7/8 digital temperature sensor, ADC and DAC");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(adt7316_i2c_init);
> -module_exit(adt7316_i2c_exit);
> diff --git a/drivers/staging/iio/cdc/ad7150.c b/drivers/staging/iio/cdc/ad7150.c
> index a761ca9..4718187 100644
> --- a/drivers/staging/iio/cdc/ad7150.c
> +++ b/drivers/staging/iio/cdc/ad7150.c
> @@ -657,20 +657,8 @@ static struct i2c_driver ad7150_driver = {
>  	.remove = __devexit_p(ad7150_remove),
>  	.id_table = ad7150_id,
>  };
> -
> -static __init int ad7150_init(void)
> -{
> -	return i2c_add_driver(&ad7150_driver);
> -}
> -
> -static __exit void ad7150_exit(void)
> -{
> -	i2c_del_driver(&ad7150_driver);
> -}
> +module_i2c_driver(ad7150_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices AD7150/1/6 capacitive sensor driver");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(ad7150_init);
> -module_exit(ad7150_exit);
> diff --git a/drivers/staging/iio/cdc/ad7152.c b/drivers/staging/iio/cdc/ad7152.c
> index 662584d..152d3be 100644
> --- a/drivers/staging/iio/cdc/ad7152.c
> +++ b/drivers/staging/iio/cdc/ad7152.c
> @@ -540,20 +540,8 @@ static struct i2c_driver ad7152_driver = {
>  	.remove = __devexit_p(ad7152_remove),
>  	.id_table = ad7152_id,
>  };
> -
> -static __init int ad7152_init(void)
> -{
> -	return i2c_add_driver(&ad7152_driver);
> -}
> -
> -static __exit void ad7152_exit(void)
> -{
> -	i2c_del_driver(&ad7152_driver);
> -}
> +module_i2c_driver(ad7152_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices AD7152/3 capacitive sensor driver");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(ad7152_init);
> -module_exit(ad7152_exit);
> diff --git a/drivers/staging/iio/cdc/ad7746.c b/drivers/staging/iio/cdc/ad7746.c
> index 2867943..9df5908 100644
> --- a/drivers/staging/iio/cdc/ad7746.c
> +++ b/drivers/staging/iio/cdc/ad7746.c
> @@ -788,20 +788,8 @@ static struct i2c_driver ad7746_driver = {
>  	.remove = __devexit_p(ad7746_remove),
>  	.id_table = ad7746_id,
>  };
> -
> -static __init int ad7746_init(void)
> -{
> -	return i2c_add_driver(&ad7746_driver);
> -}
> -
> -static __exit void ad7746_exit(void)
> -{
> -	i2c_del_driver(&ad7746_driver);
> -}
> +module_i2c_driver(ad7746_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD7746/5/7 capacitive sensor driver");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(ad7746_init);
> -module_exit(ad7746_exit);
> diff --git a/drivers/staging/iio/dac/max517.c b/drivers/staging/iio/dac/max517.c
> index adfbd20..a4df6d7 100644
> --- a/drivers/staging/iio/dac/max517.c
> +++ b/drivers/staging/iio/dac/max517.c
> @@ -280,20 +280,8 @@ static struct i2c_driver max517_driver = {
>  	.resume		= max517_resume,
>  	.id_table	= max517_id,
>  };
> -
> -static int __init max517_init(void)
> -{
> -	return i2c_add_driver(&max517_driver);
> -}
> -
> -static void __exit max517_exit(void)
> -{
> -	i2c_del_driver(&max517_driver);
> -}
> +module_i2c_driver(max517_driver);
>  
>  MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
>  MODULE_DESCRIPTION("MAX517/MAX518/MAX519 8-bit DAC");
>  MODULE_LICENSE("GPL");
> -
> -module_init(max517_init);
> -module_exit(max517_exit);
> diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
> index 1086e0b..454d131 100644
> --- a/drivers/staging/iio/impedance-analyzer/ad5933.c
> +++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
> @@ -796,18 +796,7 @@ static struct i2c_driver ad5933_driver = {
>  	.remove = __devexit_p(ad5933_remove),
>  	.id_table = ad5933_id,
>  };
> -
> -static __init int ad5933_init(void)
> -{
> -	return i2c_add_driver(&ad5933_driver);
> -}
> -module_init(ad5933_init);
> -
> -static __exit void ad5933_exit(void)
> -{
> -	i2c_del_driver(&ad5933_driver);
> -}
> -module_exit(ad5933_exit);
> +module_i2c_driver(ad5933_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD5933 Impedance Conv. Network Analyzer");
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> index 9dc9e63..4763836 100644
> --- a/drivers/staging/iio/light/isl29018.c
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -603,19 +603,7 @@ static struct i2c_driver isl29018_driver = {
>  	.remove	 = __devexit_p(isl29018_remove),
>  	.id_table = isl29018_id,
>  };
> -
> -static int __init isl29018_init(void)
> -{
> -	return i2c_add_driver(&isl29018_driver);
> -}
> -
> -static void __exit isl29018_exit(void)
> -{
> -	i2c_del_driver(&isl29018_driver);
> -}
> -
> -module_init(isl29018_init);
> -module_exit(isl29018_exit);
> +module_i2c_driver(isl29018_driver);
>  
>  MODULE_DESCRIPTION("ISL29018 Ambient Light Sensor driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
> index 7e984bc..1942db1 100644
> --- a/drivers/staging/iio/light/tsl2563.c
> +++ b/drivers/staging/iio/light/tsl2563.c
> @@ -866,20 +866,8 @@ static struct i2c_driver tsl2563_i2c_driver = {
>  	.remove		= __devexit_p(tsl2563_remove),
>  	.id_table	= tsl2563_id,
>  };
> -
> -static int __init tsl2563_init(void)
> -{
> -	return i2c_add_driver(&tsl2563_i2c_driver);
> -}
> -
> -static void __exit tsl2563_exit(void)
> -{
> -	i2c_del_driver(&tsl2563_i2c_driver);
> -}
> +module_i2c_driver(tsl2563_i2c_driver);
>  
>  MODULE_AUTHOR("Nokia Corporation");
>  MODULE_DESCRIPTION("tsl2563 light sensor driver");
>  MODULE_LICENSE("GPL");
> -
> -module_init(tsl2563_init);
> -module_exit(tsl2563_exit);
> diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
> index 80f77cf..3836f73 100644
> --- a/drivers/staging/iio/light/tsl2583.c
> +++ b/drivers/staging/iio/light/tsl2583.c
> @@ -933,19 +933,7 @@ static struct i2c_driver taos_driver = {
>  	.probe = taos_probe,
>  	.remove = __devexit_p(taos_remove),
>  };
> -
> -static int __init taos_init(void)
> -{
> -	return i2c_add_driver(&taos_driver);
> -}
> -
> -static void __exit taos_exit(void)
> -{
> -	i2c_del_driver(&taos_driver);
> -}
> -
> -module_init(taos_init);
> -module_exit(taos_exit);
> +module_i2c_driver(taos_driver);
>  
>  MODULE_AUTHOR("J. August Brenner<jbrenner@taosinc.com>");
>  MODULE_DESCRIPTION("TAOS tsl2583 ambient light sensor driver");
> diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
> index 8b01712..db31d6d 100644
> --- a/drivers/staging/iio/magnetometer/ak8975.c
> +++ b/drivers/staging/iio/magnetometer/ak8975.c
> @@ -572,19 +572,7 @@ static struct i2c_driver ak8975_driver = {
>  	.remove		= __devexit_p(ak8975_remove),
>  	.id_table	= ak8975_id,
>  };
> -
> -static int __init ak8975_init(void)
> -{
> -	return i2c_add_driver(&ak8975_driver);
> -}
> -
> -static void __exit ak8975_exit(void)
> -{
> -	i2c_del_driver(&ak8975_driver);
> -}
> -
> -module_init(ak8975_init);
> -module_exit(ak8975_exit);
> +module_i2c_driver(ak8975_driver);
>  
>  MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
>  MODULE_DESCRIPTION("AK8975 magnetometer driver");
> diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
> index fc9ee97..7bb1bc6 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843.c
> @@ -618,20 +618,8 @@ static struct i2c_driver hmc5843_driver = {
>  	.suspend	= hmc5843_suspend,
>  	.resume		= hmc5843_resume,
>  };
> -
> -static int __init hmc5843_init(void)
> -{
> -	return i2c_add_driver(&hmc5843_driver);
> -}
> -
> -static void __exit hmc5843_exit(void)
> -{
> -	i2c_del_driver(&hmc5843_driver);
> -}
> +module_i2c_driver(hmc5843_driver);
>  
>  MODULE_AUTHOR("Shubhrajyoti Datta <shubhrajyoti@ti.com");
>  MODULE_DESCRIPTION("HMC5843 driver");
>  MODULE_LICENSE("GPL");
> -
> -module_init(hmc5843_init);
> -module_exit(hmc5843_exit);
> diff --git a/drivers/staging/iio/meter/ade7854-i2c.c b/drivers/staging/iio/meter/ade7854-i2c.c
> index cbca3fd..1e1faa0 100644
> --- a/drivers/staging/iio/meter/ade7854-i2c.c
> +++ b/drivers/staging/iio/meter/ade7854-i2c.c
> @@ -253,19 +253,7 @@ static struct i2c_driver ade7854_i2c_driver = {
>  	.remove   = __devexit_p(ade7854_i2c_remove),
>  	.id_table = ade7854_id,
>  };
> -
> -static __init int ade7854_i2c_init(void)
> -{
> -	return i2c_add_driver(&ade7854_i2c_driver);
> -}
> -module_init(ade7854_i2c_init);
> -
> -static __exit void ade7854_i2c_exit(void)
> -{
> -	i2c_del_driver(&ade7854_i2c_driver);
> -}
> -module_exit(ade7854_i2c_exit);
> -
> +module_i2c_driver(ade7854_i2c_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADE7854/58/68/78 Polyphase Multifunction Energy Metering IC I2C Driver");

