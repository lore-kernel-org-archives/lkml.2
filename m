Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2CZGvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:51:25 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8020 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2CZGvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:51:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 25 Mar 2012 23:51:19 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 26 Mar 2012 12:21:15 +0530
Subject: RE: [PATCH 2/2] regulator: Remove _en_reg, _en_bit and _ops
 parameters from tps65090_REG macro
Thread-Topic: [PATCH 2/2] regulator: Remove _en_reg, _en_bit and _ops
 parameters from tps65090_REG macro
Thread-Index: Ac0Jae8DT9UDgBgVQMaMsIePzDoCggBsscBw
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD31281F5@BGMAIL02.nvidia.com>
References: <1332557760.10528.0.camel@phoenix>
 <1332557873.10528.2.camel@phoenix>
In-Reply-To: <1332557873.10528.2.camel@phoenix>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2Q6pr0w012288

> Both _en_bit and _ops parameters for all DCDCs and FETs are the same, so we
> can hardcode it in tps65090_REG macro.
> 
> _en_reg can be calculated by _id + 12, so we can also remove it.
Looks good to me.
Acked by: Venu Byravarasu <vbyravarasu@nvidia.com>
 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/tps65090-regulator.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/regulator/tps65090-regulator.c
> b/drivers/regulator/tps65090-regulator.c
> index 470ca7e..7baff2e 100644
> --- a/drivers/regulator/tps65090-regulator.c
> +++ b/drivers/regulator/tps65090-regulator.c
> @@ -94,31 +94,31 @@ static struct regulator_ops tps65090_ops = {
>  	.is_enabled	= tps65090_reg_is_enabled,
>  };
> 
> -#define tps65090_REG(_id, _en_reg, _en_bit, _ops)	\
> +#define tps65090_REG(_id)				\
>  {							\
> -	.reg_en_reg	= _en_reg,			\
> -	.en_bit		= _en_bit,			\
> +	.reg_en_reg	= (TPS65090_ID_##_id) + 12,	\
> +	.en_bit		= 0,				\
>  	.id		= TPS65090_ID_##_id,		\
>  	.desc = {					\
>  		.name = tps65090_rails(_id),		\
>  		.id = TPS65090_ID_##_id,		\
> -		.ops = &_ops,				\
> +		.ops = &tps65090_ops,			\
>  		.type = REGULATOR_VOLTAGE,		\
>  		.owner = THIS_MODULE,			\
>  	},						\
>  }
> 
>  static struct tps65090_regulator TPS65090_regulator[] = {
> -	tps65090_REG(DCDC1, 12, 0, tps65090_ops),
> -	tps65090_REG(DCDC2, 13, 0, tps65090_ops),
> -	tps65090_REG(DCDC3, 14, 0, tps65090_ops),
> -	tps65090_REG(FET1,  15, 0, tps65090_ops),
> -	tps65090_REG(FET2,  16, 0, tps65090_ops),
> -	tps65090_REG(FET3,  17, 0, tps65090_ops),
> -	tps65090_REG(FET4,  18, 0, tps65090_ops),
> -	tps65090_REG(FET5,  19, 0, tps65090_ops),
> -	tps65090_REG(FET6,  20, 0, tps65090_ops),
> -	tps65090_REG(FET7,  21, 0, tps65090_ops),
> +	tps65090_REG(DCDC1),
> +	tps65090_REG(DCDC2),
> +	tps65090_REG(DCDC3),
> +	tps65090_REG(FET1),
> +	tps65090_REG(FET2),
> +	tps65090_REG(FET3),
> +	tps65090_REG(FET4),
> +	tps65090_REG(FET5),
> +	tps65090_REG(FET6),
> +	tps65090_REG(FET7),
>  };
> 
>  static inline struct tps65090_regulator *find_regulator_info(int id)
> --
> 1.7.5.4
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
