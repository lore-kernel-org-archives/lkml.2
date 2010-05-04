Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0EDKGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:06:42 -0400
Received: from bamako.nerim.net ([62.4.17.28]:50941 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab0EDKGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:06:41 -0400
Date: Tue, 4 May 2010 12:06:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Alex Murray <murray.alex@gmail.com>
Subject: Re: [PATCH] hwmon: applesmc: Add temperature sensor labels to sysfs
 interface
Message-ID: <20100504120638.70244e8e@hyperion.delvare>
In-Reply-To: <1272966929-14501-1-git-send-email-rydberg@euromail.se>
References: <1272966929-14501-1-git-send-email-rydberg@euromail.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue,  4 May 2010 11:55:29 +0200, Henrik Rydberg wrote:
> From: Alex Murray <murray.alex@gmail.com>
> 
> The Apple SMC uses a systematic labeling scheme for the hardware
> temperature sensors. This scheme is currently hidden from
> userland. Since the sensor set, and consequently the numbering,
> differs between models, an extensive database of configurations is
> required for an application such as fan control. This patch adds the
> SMC labels to the hwmon sysfs interface, allowing applications to use
> the sensors more intelligibly.

I like the idea.

> Signed-off-by: Alex Murray <murray.alex@gmail.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hwmon/applesmc.c |  145 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 144 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 36a0d62..8be86ef 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> (...)
> @@ -1252,6 +1387,9 @@ static struct attribute *temperature_attributes[] = {
>  static const struct attribute_group temperature_attributes_group =
>  	{ .attrs = temperature_attributes };
>  
> +static const struct attribute_group label_attributes_group = {
> +	.attrs = label_attributes
> +};

Missing blank like.

>  /* Module stuff */
>  
>  /*
> @@ -1568,7 +1706,8 @@ static int __init applesmc_init(void)
>  	for (i = 0;
>  	     temperature_sensors_sets[applesmc_temperature_set][i] != NULL;
>  	     i++) {
> -		if (temperature_attributes[i] == NULL) {
> +		if (temperature_attributes[i] == NULL ||
> +		    label_attributes[i] == NULL) {
>  			printk(KERN_ERR "applesmc: More temperature sensors "
>  				"in temperature_sensors_sets (at least %i)"
>  				"than available sysfs files in "
> @@ -1578,6 +1717,8 @@ static int __init applesmc_init(void)
>  		}
>  		ret = sysfs_create_file(&pdev->dev.kobj,
>  						temperature_attributes[i]);

Missing error handling.

> +		ret = sysfs_create_file(&pdev->dev.kobj,
> +						label_attributes[i]);
>  		if (ret)
>  			goto out_temperature;
>  	}

Other than that, the patch looks good.

-- 
Jean Delvare
