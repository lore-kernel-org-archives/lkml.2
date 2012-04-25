Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab2DYGdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 02:33:12 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:60628 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab2DYGdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 02:33:10 -0400
Message-ID: <4F979AAE.6010902@ti.com>
Date: Wed, 25 Apr 2012 09:33:18 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120403 Thunderbird/11.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH 5/5] mfd: twl6040-core: Convert to devm_regmap_init_i2c()
References: <1335319315.30909.2.camel@phoenix> <1335319786.30909.11.camel@phoenix>
In-Reply-To: <1335319786.30909.11.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:09 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/twl6040-core.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
> index 2d6beda..493f4a6 100644
> --- a/drivers/mfd/twl6040-core.c
> +++ b/drivers/mfd/twl6040-core.c
> @@ -524,7 +524,7 @@ static int __devinit twl6040_probe(struct i2c_client *client,
>  		goto err;
>  	}
>  
> -	twl6040->regmap = regmap_init_i2c(client, &twl6040_regmap_config);
> +	twl6040->regmap = devm_regmap_init_i2c(client, &twl6040_regmap_config);
>  	if (IS_ERR(twl6040->regmap)) {
>  		ret = PTR_ERR(twl6040->regmap);
>  		goto err;
> @@ -623,7 +623,6 @@ gpio2_err:
>  		gpio_free(twl6040->audpwron);
>  gpio1_err:
>  	i2c_set_clientdata(client, NULL);
> -	regmap_exit(twl6040->regmap);
>  err:
>  	return ret;
>  }
> @@ -643,7 +642,6 @@ static int __devexit twl6040_remove(struct i2c_client *client)
>  
>  	mfd_remove_devices(&client->dev);
>  	i2c_set_clientdata(client, NULL);
> -	regmap_exit(twl6040->regmap);
>  
>  	return 0;
>  }

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
