Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2KWPuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:50:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43470 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2KWPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:50:05 -0500
Date: Fri, 23 Nov 2012 15:50:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/5] Input: bu21013_ts - Request a regulator that
 actually exists
Message-ID: <20121123155000.GC28552@gmail.com>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352900837-20759-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently the BU21013 Touch Screen driver requests a regulator by the
> name of 'V-TOUCH', which doesn't exist anywhere in the kernel. The
> correct name, as referenced in platform regulator code is 'avdd'. Here,
> when we request a regulator, we use the correct name instead.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/input/touchscreen/bu21013_ts.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
> index 5c487d2..2fae682 100644
> --- a/drivers/input/touchscreen/bu21013_ts.c
> +++ b/drivers/input/touchscreen/bu21013_ts.c
> @@ -461,7 +461,7 @@ static int __devinit bu21013_probe(struct i2c_client *client,
>  	bu21013_data->chip = pdata;
>  	bu21013_data->client = client;
>  
> -	bu21013_data->regulator = regulator_get(&client->dev, "V-TOUCH");
> +	bu21013_data->regulator = regulator_get(&client->dev, "avdd");
>  	if (IS_ERR(bu21013_data->regulator)) {
>  		dev_err(&client->dev, "regulator_get failed\n");
>  		error = PTR_ERR(bu21013_data->regulator);
> -- 
> 1.7.9.5

Friendly poke for Dmitry.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
