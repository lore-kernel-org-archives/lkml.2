Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1BCIJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 03:09:17 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:39354 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab1BCIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 03:09:15 -0500
Date: Thu, 3 Feb 2011 09:09:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 02/19] jz4740: mfd_cell is now implicitly available to 
 drivers
Message-ID: <20110203090905.46f57a56@endymion.delvare>
In-Reply-To: <20110202195824.6ebbddff@queued.net>
References: <20110202195417.228e2656@queued.net>
	<20110202195824.6ebbddff@queued.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Wed, 2 Feb 2011 19:58:24 -0800, Andres Salomon wrote:
> 
> No need to explicitly set the cell's platform_data/data_size.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/hwmon/jz4740-hwmon.c   |    2 +-
>  drivers/mfd/jz4740-adc.c       |    4 ----
>  drivers/power/jz4740-battery.c |    2 +-
>  3 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
> index 1c8b3d9..40f106d 100644
> --- a/drivers/hwmon/jz4740-hwmon.c
> +++ b/drivers/hwmon/jz4740-hwmon.c
> @@ -112,7 +112,7 @@ static int __devinit jz4740_hwmon_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	hwmon->cell = pdev->dev.platform_data;
> +	hwmon->cell = mfd_get_cell(pdev);
>  
>  	hwmon->irq = platform_get_irq(pdev, 0);
>  	if (hwmon->irq < 0) {
> diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
> index 0cc5979..aa518b9 100644
> --- a/drivers/mfd/jz4740-adc.c
> +++ b/drivers/mfd/jz4740-adc.c
> @@ -232,8 +232,6 @@ const struct mfd_cell jz4740_adc_cells[] = {
>  		.name = "jz4740-hwmon",
>  		.num_resources = ARRAY_SIZE(jz4740_hwmon_resources),
>  		.resources = jz4740_hwmon_resources,
> -		.platform_data = (void *)&jz4740_adc_cells[0],
> -		.data_size = sizeof(struct mfd_cell),
>  
>  		.enable = jz4740_adc_cell_enable,
>  		.disable = jz4740_adc_cell_disable,
> @@ -243,8 +241,6 @@ const struct mfd_cell jz4740_adc_cells[] = {
>  		.name = "jz4740-battery",
>  		.num_resources = ARRAY_SIZE(jz4740_battery_resources),
>  		.resources = jz4740_battery_resources,
> -		.platform_data = (void *)&jz4740_adc_cells[1],
> -		.data_size = sizeof(struct mfd_cell),
>  
>  		.enable = jz4740_adc_cell_enable,
>  		.disable = jz4740_adc_cell_disable,
> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
> index 02414db..0938650 100644
> --- a/drivers/power/jz4740-battery.c
> +++ b/drivers/power/jz4740-battery.c
> @@ -258,7 +258,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	jz_battery->cell = pdev->dev.platform_data;
> +	jz_battery->cell = mfd_get_cell(pdev);
>  
>  	jz_battery->irq = platform_get_irq(pdev, 0);
>  	if (jz_battery->irq < 0) {

I have no objection, but I can't test the changes either. I presume
these changes should be merged through the mfd tree?

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
