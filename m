Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422933Ab2KBKGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:06:00 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45341 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422708Ab2KBKF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:05:58 -0400
Message-ID: <50939B04.8060404@kernel.org>
Date: Fri, 02 Nov 2012 10:05:56 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: hid-sensor: Return proper error if kmemdup fails
References: <1351350210.10004.3.camel@phoenix>
In-Reply-To: <1351350210.10004.3.camel@phoenix>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2012 04:03 PM, Axel Lin wrote:
> Return -ENOMEM instead of 0 if kmemdup fails.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Added to fixes-togreg branch of iio.git
Thanks
> ---
>  drivers/iio/accel/hid-sensor-accel-3d.c       |    6 +++---
>  drivers/iio/gyro/hid-sensor-gyro-3d.c         |    6 +++---
>  drivers/iio/light/hid-sensor-als.c            |    5 ++---
>  drivers/iio/magnetometer/hid-sensor-magn-3d.c |    6 +++---
>  4 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
> index 1b49931..2046208 100644
> --- a/drivers/iio/accel/hid-sensor-accel-3d.c
> +++ b/drivers/iio/accel/hid-sensor-accel-3d.c
> @@ -319,10 +319,10 @@ static int __devinit hid_accel_3d_probe(struct platform_device *pdev)
>  		goto error_free_dev;
>  	}
>  
> -	channels = kmemdup(accel_3d_channels,
> -					sizeof(accel_3d_channels),
> -					GFP_KERNEL);
> +	channels = kmemdup(accel_3d_channels, sizeof(accel_3d_channels),
> +			   GFP_KERNEL);
>  	if (!channels) {
> +		ret = -ENOMEM;
>  		dev_err(&pdev->dev, "failed to duplicate channels\n");
>  		goto error_free_dev;
>  	}
> diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
> index 705dc49..c93dd59 100644
> --- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
> +++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
> @@ -319,10 +319,10 @@ static int __devinit hid_gyro_3d_probe(struct platform_device *pdev)
>  		goto error_free_dev;
>  	}
>  
> -	channels = kmemdup(gyro_3d_channels,
> -					sizeof(gyro_3d_channels),
> -					GFP_KERNEL);
> +	channels = kmemdup(gyro_3d_channels, sizeof(gyro_3d_channels),
> +			   GFP_KERNEL);
>  	if (!channels) {
> +		ret = -ENOMEM;
>  		dev_err(&pdev->dev, "failed to duplicate channels\n");
>  		goto error_free_dev;
>  	}
> diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
> index 4c35ac7..ea59daa 100644
> --- a/drivers/iio/light/hid-sensor-als.c
> +++ b/drivers/iio/light/hid-sensor-als.c
> @@ -285,10 +285,9 @@ static int __devinit hid_als_probe(struct platform_device *pdev)
>  		goto error_free_dev;
>  	}
>  
> -	channels = kmemdup(als_channels,
> -					sizeof(als_channels),
> -					GFP_KERNEL);
> +	channels = kmemdup(als_channels, sizeof(als_channels), GFP_KERNEL);
>  	if (!channels) {
> +		ret = -ENOMEM;
>  		dev_err(&pdev->dev, "failed to duplicate channels\n");
>  		goto error_free_dev;
>  	}
> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> index a02dc98..63d0a38 100644
> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> @@ -320,10 +320,10 @@ static int __devinit hid_magn_3d_probe(struct platform_device *pdev)
>  		goto error_free_dev;
>  	}
>  
> -	channels = kmemdup(magn_3d_channels,
> -					sizeof(magn_3d_channels),
> -					GFP_KERNEL);
> +	channels = kmemdup(magn_3d_channels, sizeof(magn_3d_channels),
> +			   GFP_KERNEL);
>  	if (!channels) {
> +		ret = -ENOMEM;
>  		dev_err(&pdev->dev, "failed to duplicate channels\n");
>  		goto error_free_dev;
>  	}
> 
