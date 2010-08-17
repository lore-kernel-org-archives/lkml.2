Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0HQOLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:11:02 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:30077 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0HQOLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:11:00 -0400
Date: Tue, 17 Aug 2010 16:10:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Thomas <pthomas8589@gmail.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2] hwmon: (ads7871) Fix ads7871_probe error path
Message-ID: <20100817161048.51b42394@hyperion.delvare>
In-Reply-To: <1282048884.2626.2.camel@phoenix>
References: <1282048884.2626.2.camel@phoenix>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 20:41:24 +0800, Axel Lin wrote:
> This patch moves hwmon_device_register() to the end of ads7871_probe().
> So we can make sure the device exists and is properly initialized
> before the device is exposed to user-space.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/hwmon/ads7871.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
> index b300a20..45f5829 100644
> --- a/drivers/hwmon/ads7871.c
> +++ b/drivers/hwmon/ads7871.c
> @@ -176,12 +176,6 @@ static int __devinit ads7871_probe(struct spi_device *spi)
>  	if (status < 0)
>  		goto error_free;
>  
> -	pdata->hwmon_dev = hwmon_device_register(&spi->dev);
> -	if (IS_ERR(pdata->hwmon_dev)) {
> -		err = PTR_ERR(pdata->hwmon_dev);
> -		goto error_remove;
> -	}
> -
>  	spi_set_drvdata(spi, pdata);
>  
>  	/* Configure the SPI bus */
> @@ -204,6 +198,12 @@ static int __devinit ads7871_probe(struct spi_device *spi)
>  		goto error_remove;
>  	}
>  
> +	pdata->hwmon_dev = hwmon_device_register(&spi->dev);
> +	if (IS_ERR(pdata->hwmon_dev)) {
> +		err = PTR_ERR(pdata->hwmon_dev);
> +		goto error_remove;
> +	}
> +
>  	return 0;
>  
>  error_remove:

Applied, thanks.

-- 
Jean Delvare
