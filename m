Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab2CMR1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:27:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60642 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab2CMR1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:27:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Tue, 13 Mar 2012 18:27:38 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 3/3] i2c-s3c2410: Add HDMIPHY quirk for S3C2440
In-reply-to: <1331657679-31302-4-git-send-email-k.lewandowsk@samsung.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F5F838A.6030908@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
 <1331657679-31302-4-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karol,
Please refer to comments below,

Regards,
Tomasz Stanislawski

On 03/13/2012 05:54 PM, Karol Lewandowski wrote:
> This patch adds support for s3c2440 I2C bus controller dedicated HDMIPHY device on
> Exynos4 platform. Some quirks are introduced due to differences between HDMIPHY
> and other I2C controllers on Exynos4.  These differences are:
> - no GPIOs, HDMIPHY is inside the SoC and the controller is connected
>   internally
> - due to unknown reason (probably HW bug in HDMIPHY and/or the controller) a
>   transfer fails to finish. The controller hangs after sending the last byte,
>   the workaround for this bug is resetting the controller after each transfer
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/i2c/samsung-i2c.txt        |   10 ++++-
>  drivers/i2c/busses/i2c-s3c2410.c                   |   36 ++++++++++++++++++++
>  2 files changed, 44 insertions(+), 2 deletions(-)
> 
[snip]
> @@ -871,6 +896,14 @@ s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
>  		return;
>  
>  	pdata->bus_num = -1; /* i2c bus number is dynamically assigned */
> +
> +	if (s3c24xx_i2c_is_type(i2c, TYPE_S3C2440) &&

I think that type checking should be removed because hdmiphy quirk is something
orthogonal to the controller type.

> +	    of_get_property(np, "samsung,i2c-quirk-hdmiphy", NULL))
> +		i2c->type |= FLAG_HDMIPHY;
> +
> +	if (of_get_property(np, "samsung,i2c-no-gpio", NULL))
> +		i2c->type |= FLAG_NO_GPIO;
> +
>  	of_property_read_u32(np, "samsung,i2c-sda-delay", &pdata->sda_delay);
>  	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata->slave_addr);
>  	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
> @@ -1128,6 +1161,9 @@ static struct platform_device_id s3c24xx_driver_ids[] = {
>  	}, {
>  		.name		= "s3c2440-i2c",
>  		.driver_data	= TYPE_S3C2440,
> +	}, {
> +		.name		= "s3c2440-hdmiphy-i2c",
> +		.driver_data	= TYPE_S3C2440 | FLAG_HDMIPHY | FLAG_NO_GPIO,
>  	}, { },
>  };
>  MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);

