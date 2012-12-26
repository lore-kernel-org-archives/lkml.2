Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2LZBRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:17:11 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52168 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2LZBRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:17:07 -0500
Message-ID: <50DA500B.5090305@gmail.com>
Date: Wed, 26 Dec 2012 10:16:59 +0900
From: gshark <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp8755: Fix lp8755_regulator_init unwind code
References: <1356401180.14680.6.camel@phoenix>
In-Reply-To: <1356401180.14680.6.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012년 12월 25일 11:06, Axel Lin 쓴 글:
> This patch also includes below cleanups:
> Show correct regulator id in dev_err.
> Remove __devexit_p.
>
> Signed-off-by: Axel Lin<axel.lin@ingics.com>
> ---
>   drivers/regulator/lp8755.c |    9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
> index dbc4d12..06a82e2 100644
> --- a/drivers/regulator/lp8755.c
> +++ b/drivers/regulator/lp8755.c
> @@ -358,7 +358,9 @@ static int lp8755_regulator_init(struct lp8755_chip *pchip)
>   		    regulator_register(&lp8755_regulators[buck_num], &rconfig);
>   		if (IS_ERR(pchip->rdev[buck_num])) {
>   			ret = PTR_ERR(pchip->rdev[buck_num]);
> -			dev_err(pchip->dev, "regulator init failed: buck 0\n");
> +			pchip->rdev[buck_num] = NULL;
> +			dev_err(pchip->dev, "regulator init failed: buck %d\n",
> +				buck_num);
>   			goto err_buck;
>   		}
>   	}
> @@ -367,8 +369,7 @@ static int lp8755_regulator_init(struct lp8755_chip *pchip)
>   
>   err_buck:
>   	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
> -		if (pchip->rdev[icnt] != NULL)
> -			regulator_unregister(pchip->rdev[icnt]);
> +		regulator_unregister(pchip->rdev[icnt]);
>   	return ret;
>   }
>   
> @@ -557,7 +558,7 @@ static struct i2c_driver lp8755_i2c_driver = {
>   		   .name = LP8755_NAME,
>   		   },
>   	.probe = lp8755_probe,
> -	.remove = __devexit_p(lp8755_remove),
> +	.remove = lp8755_remove,
>   	.id_table = lp8755_id,
>   };
>   
> -- 1.7.9.5
Thank you Alex.
I will check your patch and test it using my board.
