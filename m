Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab2JHFxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:53:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14169 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2JHFxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:53:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 07 Oct 2012 22:53:43 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Laxman Dewangan <ldewangan@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Oct 2012 11:23:39 +0530
Subject: RE: [PATCH 1/5] regulator: tps65090: rename driver name and
 regulator name
Thread-Topic: [PATCH 1/5] regulator: tps65090: rename driver name and
 regulator name
Thread-Index: Ac2j2mv8/P5IKI1PS/Wzluvbf1kTVgBPsVNQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF8AF392@BGMAIL02.nvidia.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
 <1349536671-31714-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1349536671-31714-3-git-send-email-ldewangan@nvidia.com>
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

> -----Original Message-----
> From: Laxman Dewangan
> Sent: Saturday, October 06, 2012 8:48 PM
> To: broonie@opensource.wolfsonmicro.com; lrg@ti.com;
> sameo@linux.intel.com
> Cc: Venu Byravarasu; axel.lin@gmail.com; linux-kernel@vger.kernel.org;
> Laxman Dewangan
> Subject: [PATCH 1/5] regulator: tps65090: rename driver name and regulator
> name
> 
> To make the names proper and more appropriate:
> Rename the driver name from tps65090-regulator to tps65090-pmic.
> Rename the regulators from TPS65090_ID_* to TPS65090_REGULATOR_*
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/regulator/tps65090-regulator.c       |    8 ++++----
>  include/linux/regulator/tps65090-regulator.h |   20 ++++++++++----------
>  2 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/regulator/tps65090-regulator.c
> b/drivers/regulator/tps65090-regulator.c
> index 001ad55..96d59ad 100644
> --- a/drivers/regulator/tps65090-regulator.c
> +++ b/drivers/regulator/tps65090-regulator.c
> @@ -43,14 +43,14 @@ static struct regulator_ops tps65090_ops = {
> 
>  #define tps65090_REG(_id)				\
>  {							\
> -	.id		= TPS65090_ID_##_id,		\
> +	.id		= TPS65090_REGULATOR_##_id,		\
>  	.desc = {					\
>  		.name = tps65090_rails(_id),		\
> -		.id = TPS65090_ID_##_id,		\
> +		.id = TPS65090_REGULATOR_##_id,		\
>  		.ops = &tps65090_ops,			\
>  		.type = REGULATOR_VOLTAGE,		\
>  		.owner = THIS_MODULE,			\
> -		.enable_reg = (TPS65090_ID_##_id) + 12,	\
> +		.enable_reg = (TPS65090_REGULATOR_##_id) + 12,	\
>  		.enable_mask = BIT(0),			\
>  	},						\
>  }
> @@ -126,7 +126,7 @@ static int __devexit
> tps65090_regulator_remove(struct platform_device *pdev)
> 
>  static struct platform_driver tps65090_regulator_driver = {
>  	.driver	= {
> -		.name	= "tps65090-regulator",
> +		.name	= "tps65090-pmic",

As the driver itself is regulator driver, why should we rename it to pmic? 


>  		.owner	= THIS_MODULE,
>  	},
>  	.probe		= tps65090_regulator_probe,
> diff --git a/include/linux/regulator/tps65090-regulator.h
> b/include/linux/regulator/tps65090-regulator.h
> index 0fa04b6..5e27d4a 100644
> --- a/include/linux/regulator/tps65090-regulator.h
> +++ b/include/linux/regulator/tps65090-regulator.h
> @@ -24,16 +24,16 @@
>  #define tps65090_rails(_name) "tps65090_"#_name
> 
>  enum {
> -	TPS65090_ID_DCDC1,
> -	TPS65090_ID_DCDC2,
> -	TPS65090_ID_DCDC3,
> -	TPS65090_ID_FET1,
> -	TPS65090_ID_FET2,
> -	TPS65090_ID_FET3,
> -	TPS65090_ID_FET4,
> -	TPS65090_ID_FET5,
> -	TPS65090_ID_FET6,
> -	TPS65090_ID_FET7,
> +	TPS65090_REGULATOR_DCDC1,
> +	TPS65090_REGULATOR_DCDC2,
> +	TPS65090_REGULATOR_DCDC3,
> +	TPS65090_REGULATOR_FET1,
> +	TPS65090_REGULATOR_FET2,
> +	TPS65090_REGULATOR_FET3,
> +	TPS65090_REGULATOR_FET4,
> +	TPS65090_REGULATOR_FET5,
> +	TPS65090_REGULATOR_FET6,
> +	TPS65090_REGULATOR_FET7,
>  };
> 
>  /*
> --
> 1.7.1.1

