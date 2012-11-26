Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2KZNp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:45:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2KZNpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:45:55 -0500
Date: Mon, 26 Nov 2012 14:45:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Axel Lin <axel.lin@ingics.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: as3711: Fix valid min_uV/max_UV checking
 in as3711_bound_check
In-Reply-To: <1353689452.3260.4.camel@phoenix>
Message-ID: <Pine.LNX.4.64.1211261445320.11501@axis700.grange>
References: <1353689452.3260.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:lgJaZGSfHUxhwi17onnDwmT0nOWvvUpACcb6osgec9B
 evwQo4J3oGYMuYv53KuWknkjSJBbfd+nGJC0dj/9PjbORB7Mzn
 NrrYPzgg181czNIkjJofsSam1wTtb60+3soduwiBdyGm4PUlep
 aYaa3+ru11PlJ6WHQDmJEUtwVBL3hKU/+BIvh1V2S0AvOk+VcZ
 Ydpj3JEDyPEb8g7zE2byVtbcqeFvICwLAykLdd6g374mQUnevv
 oCfeWngbBeZYoUtj8BYfbCFRijeR2cetU7A0tE1cvdcu7XwTVK
 81J4dTHClm6qO6JTfYB+2Pn42lakZWDHyhCcJibXtgvz9jc2fT
 Litb8MYHyW3gQk092c8m6W5KaJU3YNrjTHv2RhGiVweHncRg1o
 wJQGATC+/Xkgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2012, Axel Lin wrote:

> Below cases are supposed to be valid:
> 
> min_uV == max_uV == info->max_uV
> min_uV == max_uV == rdev->desc->min_uV
> 
> Don't return -EINVAL for above cases.
> 
> This patch also includes below cleanups:
> - Use rdev_get_drvdata(rdev) instead of rdev->reg_data.
> - Remove unnecessary WARN_ON, it looks pointless.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/regulator/as3711-regulator.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
> index 81578bf..5e813b9 100644
> --- a/drivers/regulator/as3711-regulator.c
> +++ b/drivers/regulator/as3711-regulator.c
> @@ -69,17 +69,14 @@ static int as3711_list_voltage_dldo(struct regulator_dev *rdev,
>  static int as3711_bound_check(struct regulator_dev *rdev,
>  			      int *min_uV, int *max_uV)
>  {
> -	struct as3711_regulator_info *info = container_of(rdev->desc,
> -					struct as3711_regulator_info, desc);
> -	struct as3711_regulator *reg = rdev->reg_data;
> -
> -	WARN_ON(reg->reg_info != info);
> +	struct as3711_regulator *reg = rdev_get_drvdata(rdev);
> +	struct as3711_regulator_info *info = reg->reg_info;
>  
>  	dev_dbg(&rdev->dev, "%s(), %d, %d, %d\n", __func__,
>  		*min_uV, rdev->desc->min_uV, info->max_uV);
>  
>  	if (*max_uV < *min_uV ||
> -	    *min_uV >= info->max_uV || rdev->desc->min_uV >= *max_uV)
> +	    *min_uV > info->max_uV || rdev->desc->min_uV > *max_uV)
>  		return -EINVAL;
>  
>  	if (rdev->desc->n_voltages == 1)
> -- 
> 1.7.9.5
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
