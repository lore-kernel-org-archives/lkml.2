Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2AZVlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:41:17 -0500
Received: from imr4.ericy.com ([198.24.6.9]:53828 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab2AZVlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:41:16 -0500
Date: Thu, 26 Jan 2012 13:39:00 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (SHT15) fix bad error code
Message-ID: <20120126213900.GA23534@ericsson.com>
References: <1327611540-21023-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1327611540-21023-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 03:59:00PM -0500, Vivien Didelot wrote:
> When no platform data was supplied, returned error code was 0.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>  drivers/hwmon/sht15.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
> index fe4104c..5357925 100644
> --- a/drivers/hwmon/sht15.c
> +++ b/drivers/hwmon/sht15.c
> @@ -883,7 +883,7 @@ static int sht15_invalidate_voltage(struct notifier_block *nb,
>  
>  static int __devinit sht15_probe(struct platform_device *pdev)
>  {
> -	int ret = 0;
> +	int ret;
>  	struct sht15_data *data = kzalloc(sizeof(*data), GFP_KERNEL);
>  	u8 status = 0;
>  
> @@ -901,6 +901,7 @@ static int __devinit sht15_probe(struct platform_device *pdev)
>  	init_waitqueue_head(&data->wait_queue);
>  
>  	if (pdev->dev.platform_data == NULL) {
> +		ret = -EINVAL;
>  		dev_err(&pdev->dev, "no platform data supplied\n");
>  		goto err_free_data;
>  	}
> -- 
> 1.7.6.5
> 
Good catch. Applied.

Thanks,
Guenter

