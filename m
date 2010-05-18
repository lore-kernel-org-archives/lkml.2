Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0ESNHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:07:40 -0400
Received: from bamako.nerim.net ([62.4.17.28]:55559 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab0ESNHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:07:38 -0400
Date: Tue, 18 May 2010 19:31:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>, stable@kernel.org
Subject: Re: [PATCH] drivers/mfd: remove unneeded and dangerous clearing of
 clientdata
Message-ID: <20100518193115.62bb6b4e@hyperion.delvare>
In-Reply-To: <1274098229-13858-1-git-send-email-w.sang@pengutronix.de>
References: <1274098229-13858-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 14:10:29 +0200, Wolfram Sang wrote:
> Unlike real i2c-devices which get detached from the driver, dummy-devices get
> truly unregistered. So, there has never been a need to clear the clientdata
> because the device will go away anyhow. For the occasions fixed here, clearing
> clientdata was even dangerous as the structure was freed already.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: stable@kernel.org

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
> 
> Note: While most of the other calls clearing clientdata became superfluous
> meanwhile and will be fixed later to remove redundancy, this is a seperate
> issue. It was wrong from the beginning and needs to be fixed as it can cause
> crashes. Hopefully, during this release-cycle, all other clearings of
> clientdata will be removed and we will never see the related confusion again.
> 
>  drivers/mfd/88pm860x-i2c.c |    1 -
>  drivers/mfd/max8925-i2c.c  |    2 --
>  2 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
> index 4a6e718..e55f3d2 100644
> --- a/drivers/mfd/88pm860x-i2c.c
> +++ b/drivers/mfd/88pm860x-i2c.c
> @@ -200,7 +200,6 @@ static int __devexit pm860x_remove(struct i2c_client *client)
>  
>  	pm860x_device_exit(chip);
>  	i2c_unregister_device(chip->companion);
> -	i2c_set_clientdata(chip->companion, NULL);
>  	i2c_set_clientdata(chip->client, NULL);
>  	kfree(chip);
>  	return 0;
> diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
> index d9fd878..e73f3f5 100644
> --- a/drivers/mfd/max8925-i2c.c
> +++ b/drivers/mfd/max8925-i2c.c
> @@ -173,8 +173,6 @@ static int __devexit max8925_remove(struct i2c_client *client)
>  	max8925_device_exit(chip);
>  	i2c_unregister_device(chip->adc);
>  	i2c_unregister_device(chip->rtc);
> -	i2c_set_clientdata(chip->adc, NULL);
> -	i2c_set_clientdata(chip->rtc, NULL);
>  	i2c_set_clientdata(chip->i2c, NULL);
>  	kfree(chip);
>  	return 0;


-- 
Jean Delvare
