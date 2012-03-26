Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2CZDpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 23:45:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1307 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2CZDpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 23:45:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 25 Mar 2012 20:45:08 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Mar 2012 09:15:03 +0530
Subject: RE: [PATCH 2/2] mfd: tps65090: Don't use I2C-specific suspend and
 resume operations
Thread-Topic: [PATCH 2/2] mfd: tps65090: Don't use I2C-specific suspend and
 resume operations
Thread-Index: Ac0IWxV8QwFqDBWDTia6lSaIahETuwCp19qA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD312816D@BGMAIL02.nvidia.com>
References: <1332441541-28197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332441541-28197-2-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1332441541-28197-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> It's not clear to me that we should have these operations at all...
Mark,
Can you please explain why do you think that these operations are not needed?


> 
>  drivers/mfd/tps65090.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
> index ac7e8b1..6dc4c345 100644
> --- a/drivers/mfd/tps65090.c
> +++ b/drivers/mfd/tps65090.c
> @@ -335,21 +335,27 @@ static int __devexit tps65090_i2c_remove(struct
> i2c_client *client)
>  }
> 
>  #ifdef CONFIG_PM_SLEEP
> -static int tps65090_i2c_suspend(struct i2c_client *client, pm_message_t state)
> +static int tps65090_suspend(struct device *dev)
>  {
> +	struct i2c_client *client = to_i2c_client(dev);
>  	if (client->irq)
>  		disable_irq(client->irq);
>  	return 0;
>  }
> 
> -static int tps65090_i2c_resume(struct i2c_client *client)
> +static int tps65090_resume(struct device *dev)
>  {
> +	struct i2c_client *client = to_i2c_client(dev);
>  	if (client->irq)
>  		enable_irq(client->irq);
>  	return 0;
>  }
>  #endif
> 
> +static const struct dev_pm_ops tps65090_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(tps65090_suspend, tps65090_resume)
> +};
> +
>  static const struct i2c_device_id tps65090_id_table[] = {
>  	{ "tps65090", 0 },
>  	{ },
> @@ -360,13 +366,10 @@ static struct i2c_driver tps65090_driver = {
>  	.driver	= {
>  		.name	= "tps65090",
>  		.owner	= THIS_MODULE,
> +		.pm	= &tps65090_pm_ops,
>  	},
>  	.probe		= tps65090_i2c_probe,
>  	.remove		= __devexit_p(tps65090_i2c_remove),
> -#ifdef CONFIG_PM_SLEEP
> -	.suspend	= tps65090_i2c_suspend,
> -	.resume		= tps65090_i2c_resume,
> -#endif
>  	.id_table	= tps65090_id_table,
>  };
> 
> --
> 1.7.9.1

