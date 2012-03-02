Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2CBKNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:13:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36120 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2CBKNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:13:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of marek.vasut@gmail.com designates 10.213.20.19 as permitted sender) smtp.mail=marek.vasut@gmail.com; dkim=pass header.i=marek.vasut@gmail.com
From: Marek Vasut <marek.vasut@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] regulator: Simplify the code to get selector in isl6271a_set_voltage
Date: Fri, 2 Mar 2012 11:13:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1330651142.6247.1.camel@phoenix>
In-Reply-To: <1330651142.6247.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021113.11269.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/isl6271a-regulator.c |   14 +++-----------
>  1 files changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/regulator/isl6271a-regulator.c
> b/drivers/regulator/isl6271a-regulator.c index c1a456c..775f5fd 100644
> --- a/drivers/regulator/isl6271a-regulator.c
> +++ b/drivers/regulator/isl6271a-regulator.c
> @@ -63,23 +63,15 @@ static int isl6271a_set_voltage(struct regulator_dev
> *dev, unsigned *selector)
>  {
>  	struct isl_pmic *pmic = rdev_get_drvdata(dev);
> -	int vsel, err, data;
> +	int err, data;
> 
>  	if (minuV < ISL6271A_VOLTAGE_MIN || minuV > ISL6271A_VOLTAGE_MAX)
>  		return -EINVAL;
>  	if (maxuV < ISL6271A_VOLTAGE_MIN || maxuV > ISL6271A_VOLTAGE_MAX)
>  		return -EINVAL;
> 
> -	/* Align to 50000 mV */

Heh ... 50000mV ? :-)

> -	vsel = minuV - (minuV % ISL6271A_VOLTAGE_STEP);
> -
> -	/* If the result fell out of [minuV,maxuV] range, put it back */
> -	if (vsel < minuV)
> -		vsel += ISL6271A_VOLTAGE_STEP;
> -
> -	/* Convert the microvolts to data for the chip */
> -	data = (vsel - ISL6271A_VOLTAGE_MIN) / ISL6271A_VOLTAGE_STEP;
> -
> +	data = DIV_ROUND_UP(minuV - ISL6271A_VOLTAGE_MIN,
> +			    ISL6271A_VOLTAGE_STEP);

Ok, this makes sense.

Acked-by: Marek Vasut <marek.vasut@gmail.com>

>  	*selector = data;
> 
>  	mutex_lock(&pmic->mtx);
