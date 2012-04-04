Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2DDHlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:41:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51517 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2DDHla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:41:30 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: isl6271a: Allow missing init_data for diagnostics
Date: Wed, 4 Apr 2012 09:41:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
References: <1333492036-15990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1333492036-15990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204040941.26056.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mark Brown,

> The regulator core supports this to allow the configuration to be inspected
> at runtime even if no software mangement is enabled.

Acked-by: Marek Vasut <marek.vasut@gmail.com>

> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/isl6271a-regulator.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/regulator/isl6271a-regulator.c
> b/drivers/regulator/isl6271a-regulator.c index 775f5fd..a0430aa 100644
> --- a/drivers/regulator/isl6271a-regulator.c
> +++ b/drivers/regulator/isl6271a-regulator.c
> @@ -140,6 +140,7 @@ static struct regulator_desc isl_rd[] = {
>  static int __devinit isl6271a_probe(struct i2c_client *i2c,
>  				     const struct i2c_device_id *id)
>  {
> +	struct regulator_config config = { };
>  	struct regulator_init_data *init_data	= i2c->dev.platform_data;
>  	struct isl_pmic *pmic;
>  	int err, i;
> @@ -147,11 +148,6 @@ static int __devinit isl6271a_probe(struct i2c_client
> *i2c, if (!i2c_check_functionality(i2c->adapter,
> I2C_FUNC_SMBUS_BYTE_DATA)) return -EIO;
> 
> -	if (!init_data) {
> -		dev_err(&i2c->dev, "no platform data supplied\n");
> -		return -EIO;
> -	}
> -
>  	pmic = kzalloc(sizeof(struct isl_pmic), GFP_KERNEL);
>  	if (!pmic)
>  		return -ENOMEM;

Best regards,
Marek Vasut
