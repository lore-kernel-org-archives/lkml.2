Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3AFLiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:38:08 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55852 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3AFLiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:38:07 -0500
Message-ID: <50E9621D.9000003@kernel.org>
Date: Sun, 06 Jan 2013 11:38:05 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] iio: lp8788_adc: fix a parent device in _probe()
References: <A874F61F95741C4A9BA573A70FE3998F69E10FCB@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E10FCB@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 06:28 AM, Kim, Milo wrote:
>  The lp8788-adc is a platform driver of lp8788-mfd.
>  The platform device is allocated when mfd_add_devices() is called
>  in lp8788-mfd.
>  On the other hand, 'lp->dev' is the i2c client device.
> 
>  Therefore, this 'platform_device' is a proper parent device of
>  iio device and device kernel message.

Added to togreg branch of iio.git

Thanks,
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/iio/adc/lp8788_adc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/adc/lp8788_adc.c b/drivers/iio/adc/lp8788_adc.c
> index 72955e4..4c9b0f7 100644
> --- a/drivers/iio/adc/lp8788_adc.c
> +++ b/drivers/iio/adc/lp8788_adc.c
> @@ -214,7 +214,7 @@ static int lp8788_adc_probe(struct platform_device *pdev)
>  
>  	mutex_init(&adc->lock);
>  
> -	indio_dev->dev.parent = lp->dev;
> +	indio_dev->dev.parent = &pdev->dev;
>  	indio_dev->name = pdev->name;
>  	indio_dev->modes = INDIO_DIRECT_MODE;
>  	indio_dev->info = &lp8788_adc_info;
> @@ -223,7 +223,7 @@ static int lp8788_adc_probe(struct platform_device *pdev)
>  
>  	ret = iio_device_register(indio_dev);
>  	if (ret) {
> -		dev_err(lp->dev, "iio dev register err: %d\n", ret);
> +		dev_err(&pdev->dev, "iio dev register err: %d\n", ret);
>  		goto err_iio_device;
>  	}
>  
> 
