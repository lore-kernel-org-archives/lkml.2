Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2FTG4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:56:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38558 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2FTG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:56:29 -0400
X-AuditID: cbfee612-b7fbe6d000007898-16-4fe1741984e1
Date: Wed, 20 Jun 2012 06:56:25 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] regulator: max77686: Implement .set_ramp_delay()
 callback.
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        =?euc-kr?Q?=BA=AF=C4=A1=BF=F5?= <woong.byun@samsung.com>,
        Axel Lin <axel.lin@gmail.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120620065049740@myungjoo.ham
Msgkey: 20120620065049740@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120620065049740@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <8918866.625501340175384370.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t/tGbqSJQ/9DT4cYLS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZh3pTC94oVGydtIK5gfGPfBcjJ4eQgLrEoiUn2UBsCQETiXnT
	e5ggbDGJC/fWA8W5gGrmM0oc3bAEyOHgYBFQlZj0WxHEZBPQk5j5ORmkXFggSOLD5hWMIGER
	gWKJ15cUQMLMAq+YJDYv54TYpCSxZt8rFhCbV0BQ4uTMJywg5RJAAx9/j4UIq0nMffieFeIA
	CYlZ0y9A2bwSM9qfskDYchLTvq5hhrClJc7P2sAIc/Di74+h4vwSx27vYIIYzyvx5H4wzJjd
	m79A/SogMfXMQahWLYmfd25C/c0nsWbhWxaYMbtOLWeG+ERRYkr3Q3YIW0viy499bOg+4RVw
	lFjX6zWBUXYWkswsJN2zkHQjq1nAyLKKUTS1ILmgOCk91UKvODG3uDQvXS85P3cTIziGnwnt
	YFzWYHGIUYCDUYmHd0L2Q38h1sSy4srcQ4wSHMxKIrzMCUAh3pTEyqrUovz4otKc1OJDjNIc
	LErivH3WF/yFBNITS1KzU1MLUotgskwcnFINjM2fFaemWmgu8igy4wt8KbqwxyLVcaaVn57M
	ZRWu2PcuoitWvZww02Gx3qzVOVxX23ke/S/bG8/zbarh8dWOWidqVv+5/Tru7iz77O9bWmtf
	dNo6tDBaR1cczJSbwV/jnZ6w6oLcoy/3zxpPu6S3bpWe9BzPrcnXEzc+F5kdOzdyzsx9Zed/
	xyqxFGckGmoxFxUnAgB482/73QIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5K6uZHR000369

> This patch implements the .set_ramp_delay callback to set the ramp_delay on
> hardware for BUCK2/3/4 if ramp_delay is set in regulator constraints.
> 
> This patch also do some cleaning work for unrequired members of
> struct max77686_data.
> 
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>

I guess code-clean part may be seperated. Anyway, except that, it looks good.


Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/regulator/max77686.c |   37 +++++++++++++++++++++++++++++--------
>  1 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> index a29eee3..5c2a32f 100644
> --- a/drivers/regulator/max77686.c
> +++ b/drivers/regulator/max77686.c
> @@ -65,11 +65,34 @@ enum max77686_ramp_rate {
>  };
>  
>  struct max77686_data {
> -	struct device *dev;
> -	struct max77686_dev *iodev;
>  	struct regulator_dev **rdev;
>  };
>  
> +static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
> +{
> +	unsigned int ramp_value = RAMP_RATE_NO_CTRL;
> +
> +	switch (ramp_delay) {
> +	case 1 ... 13750:
> +		ramp_value = RAMP_RATE_13P75MV;
> +		break;
> +	case 13751 ... 27500:
> +		ramp_value = RAMP_RATE_27P5MV;
> +		break;
> +	case 27501 ... 55000:
> +		ramp_value = RAMP_RATE_55MV;
> +		break;
> +	case 55001 ... 100000:
> +		break;
> +	default:
> +		pr_warn("%s: ramp_delay: %d not supported, setting 100000\n",
> +			rdev->desc->name, ramp_delay);
> +	}
> +
> +	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> +				  MAX77686_RAMP_RATE_MASK, ramp_value << 6);
> +}
> +
>  static struct regulator_ops max77686_ops = {
>  	.list_voltage		= regulator_list_voltage_linear,
>  	.map_voltage		= regulator_map_voltage_linear,
> @@ -90,6 +113,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
>  	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
>  	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
>  	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
> +	.set_ramp_delay		= max77686_set_ramp_delay,
>  };
>  
>  #define regulator_desc_ldo(num)		{				\
> @@ -238,20 +262,17 @@ static __devinit int max77686_pmic_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	rdev = max77686->rdev;
> -	max77686->dev = &pdev->dev;
> -	max77686->iodev = iodev;
> +	config.dev = &pdev->dev;
> +	config.regmap = iodev->regmap;
>  	platform_set_drvdata(pdev, max77686);
>  
>  	for (i = 0; i < MAX77686_REGULATORS; i++) {
> -		config.dev = max77686->dev;
> -		config.regmap = iodev->regmap;
> -		config.driver_data = max77686;
>  		config.init_data = pdata->regulators[i].initdata;
>  
>  		rdev[i] = regulator_register(&regulators[i], &config);
>  		if (IS_ERR(rdev[i])) {
>  			ret = PTR_ERR(rdev[i]);
> -			dev_err(max77686->dev,
> +			dev_err(&pdev->dev,
>  				"regulator init failed for %d\n", i);
>  				rdev[i] = NULL;
>  				goto err;
> -- 
> 1.7.0.4
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
