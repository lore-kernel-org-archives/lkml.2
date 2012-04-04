Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab2DDT4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:56:02 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45435 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932515Ab2DDT4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:56:01 -0400
Message-ID: <1333569359.23520.12.camel@joe2Laptop>
Subject: Re: [PATCHv3 1/3] misc: clean up bmp085 driver
From: Joe Perches <joe@perches.com>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com, broonie@opensource.wolfsonmicro.com
Date: Wed, 04 Apr 2012 12:55:59 -0700
In-Reply-To: <1333568759-13536-2-git-send-email-eric.andersson@unixphere.com>
References: <1333568759-13536-1-git-send-email-eric.andersson@unixphere.com>
	 <1333568759-13536-2-git-send-email-eric.andersson@unixphere.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 21:45 +0200, Eric Andersson wrote:
> This patch includes various cleaning of the bmp085 driver including:
> - Whitespaces and alignment fixes
> - Minor typos
> - Consistency fixes

just some more trivial things:

> diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
[]
> @@ -222,8 +217,10 @@ exit:
>  /*
>   * This function starts the pressure measurement and returns the value
>   * in millibar. Since the pressure depends on the ambient temperature,
> - * a temperature measurement is executed if the last known value is older
> - * than one second.
> + * a temperature measurement is executed according to the given temperature
> + * measurememt period (default is 1 sec boundary). This period could vary

typo: measurement

> + * and needs to be adjusted according to the sensor environment, i.e. if big
> + * temperature variations then the temperature needs to be read out often.

> @@ -386,25 +387,23 @@ static int bmp085_detect(struct i2c_client *client, struct i2c_board_info *info)
>  
>  static int bmp085_init_client(struct i2c_client *client)
[]
> -	dev_info(&data->client->dev, "BMP085 ver. %d.%d found.\n",
> -			(version & 0x0F), (version & 0xF0) >> 4);

Why remove the "version" output?

[]
>  static int __devinit bmp085_probe(struct i2c_client *client,
> -			 const struct i2c_device_id *id)
> +			const struct i2c_device_id *id)
[]
> @@ -430,8 +426,9 @@ static int __devinit bmp085_probe(struct i2c_client *client,
>  	if (err)
>  		goto exit_free;
>  
> -	dev_info(&data->client->dev, "Successfully initialized bmp085!\n");
> -	goto exit;
> +	dev_info(&client->dev, "Succesfully initialized %s!\n", BMP085_NAME);

typo: successfully


