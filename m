Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab2EPC3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:29:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42299 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab2EPC3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:29:36 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH RFT 3/3] regulator: isl6271a: Convert to set_voltage_sel and regulator_map_voltage_linear
Date: Wed, 16 May 2012 04:29:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1337134167.5940.2.camel@phoenix> <1337134273.5940.4.camel@phoenix>
In-Reply-To: <1337134273.5940.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205160429.31382.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Axel Lin,

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/isl6271a-regulator.c |   21 ++++++---------------
>  1 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/regulator/isl6271a-regulator.c
> b/drivers/regulator/isl6271a-regulator.c index 00cb288..56d273f 100644
> --- a/drivers/regulator/isl6271a-regulator.c
> +++ b/drivers/regulator/isl6271a-regulator.c
> @@ -50,25 +50,15 @@ static int isl6271a_get_voltage_sel(struct
> regulator_dev *dev) return idx;
>  }
> 
> -static int isl6271a_set_voltage(struct regulator_dev *dev,
> -				int minuV, int maxuV,
> -				unsigned *selector)
> +static int isl6271a_set_voltage_sel(struct regulator_dev *dev,
> +				    unsigned selector)
>  {
>  	struct isl_pmic *pmic = rdev_get_drvdata(dev);
> -	int err, data;
> -
> -	if (minuV < ISL6271A_VOLTAGE_MIN || minuV > ISL6271A_VOLTAGE_MAX)
> -		return -EINVAL;
> -	if (maxuV < ISL6271A_VOLTAGE_MIN || maxuV > ISL6271A_VOLTAGE_MAX)
> -		return -EINVAL;
> -
> -	data = DIV_ROUND_UP(minuV - ISL6271A_VOLTAGE_MIN,
> -			    ISL6271A_VOLTAGE_STEP);
> -	*selector = data;
> +	int err;
> 
>  	mutex_lock(&pmic->mtx);
> 
> -	err = i2c_smbus_write_byte(pmic->client, data);
> +	err = i2c_smbus_write_byte(pmic->client, selector);
>  	if (err < 0)
>  		dev_err(&pmic->client->dev, "Error setting voltage\n");
> 
> @@ -78,8 +68,9 @@ static int isl6271a_set_voltage(struct regulator_dev
> *dev,
> 
>  static struct regulator_ops isl_core_ops = {
>  	.get_voltage_sel = isl6271a_get_voltage_sel,
> -	.set_voltage	= isl6271a_set_voltage,
> +	.set_voltage_sel = isl6271a_set_voltage_sel,
>  	.list_voltage	= regulator_list_voltage_linear,
> +	.map_voltage	= regulator_map_voltage_linear,
>  };
> 
>  static int isl6271a_get_fixed_voltage(struct regulator_dev *dev)

Hm well, I hope this won't break the driver. I can't test it any soon.

Best regards,
Marek Vasut
