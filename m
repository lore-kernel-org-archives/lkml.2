Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab1EPPDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:03:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19214 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1EPPDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:03:46 -0400
Date: Mon, 16 May 2011 08:01:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: fabien.marteau@armadeus.com
Cc: khali@linux-fr.org, guenter.roeck@ericsson.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Driver for as1531, Austria-Microsystem Analog to
 Digital Converter.
Message-Id: <20110516080119.e13284b6.randy.dunlap@oracle.com>
In-Reply-To: <1305553154-18195-2-git-send-email-fabien.marteau@armadeus.com>
References: <fabien.marteau@armadeus.com>
	<1305553154-18195-2-git-send-email-fabien.marteau@armadeus.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4DD13C50.0082:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011 15:39:14 +0200 fabien.marteau@armadeus.com wrote:

> From: Fabien Marteau <fabien.marteau@armadeus.com>
> 
> 
> Signed-off-by: Fabien Marteau <fabien.marteau@armadeus.com>
> ---
>  drivers/hwmon/Kconfig  |   10 ++
>  drivers/hwmon/Makefile |    1 +
>  drivers/hwmon/as1531.c |  297 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 308 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/as1531.c
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 50e40db..d2ba655 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -104,6 +104,16 @@ config SENSORS_ADCXX
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called adcxx.
>  
> +config SENSORS_AS1531
> +	tristate "Austria Microsystems AS1531 Analog to Digital Converter"
> +	depends on SPI_MASTER
> +	help
> +	  If you say yes here you get support for Austria Microsystems AS1531.
> +		AS1531 is a 12 bits Analog to digitals converter with 8 channels

is a 12? bits

what is the character after the "12", please?

Analog to digital converter

> +		provided by Austria-Microsystems company.
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called as1531.
> +
>  config SENSORS_ADM1021
>  	tristate "Analog Devices ADM1021 and compatibles"
>  	depends on I2C


> +/*----------------------------------------------------------------------*/
> +
> +static int __devinit as1531_probe(struct spi_device *spi)
> +{
> +	struct as1531 *adc;
> +	int status;
> +	int i;
> +
> +	adc = kzalloc(sizeof(struct as1531), GFP_KERNEL);
> +	if (adc == NULL)
> +		return -ENOMEM;
> +
> +	mutex_init(&adc->lock);
> +	mutex_lock(&adc->lock);
> +
> +	dev_set_drvdata(&spi->dev, adc);
> +
> +	for (i = 0; i < 11; i++) {

s/11/ARRAY_SIZE(as1531_input)/

> +		status = device_create_file(&spi->dev,
> +						&as1531_input[i].dev_attr);
> +		if (status < 0) {
> +			dev_err(&spi->dev, "device_create_file failed.\n");
> +			goto out_err;
> +		}
> +	}



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
