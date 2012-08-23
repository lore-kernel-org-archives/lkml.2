Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab2HWKo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:44:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37964 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089Ab2HWKov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:44:51 -0400
X-AuditID: cbfee611-b7fd76d00000288b-46-503609a1cb3e
Date: Thu, 23 Aug 2012 10:44:49 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/2] devfreq: exynos4: Support initialization of freq_table
 and max_state of devfreq's profile.
To: =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Xiaoguang Chen <chenxg@marvell.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120823104418707@myungjoo.ham
Msgkey: 20120823104418707@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120823104418707@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25766018.317281345718689872.JavaMail.weblogic@epml13>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t/tGboLOc0CDM7stbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZW6f8ZC/YJ1bxeOcBpgbGD6JdjJwcQgLqEouWnGQDsSUETCRa
	zqxhh7DFJC7cWw8U5wKqmc8osajzPVgRi4CqRFPjRKAiDg42AT2JmZ+TQcLCAsUSXz/PYwKp
	FxHYxSjx4tUXZhCHWWA7o8TpE39ZILYpSazZ9wrM5hUQlDg58wkLxDZVibsLnkPF1SR+738F
	dYWExKzpF1ghbF6JGe1PoerlJKZ9XcMMYUtLnJ+1gRHm6sXfH0PF+SWO3d7BBHIoSO+T+8Ew
	Y3Zv/gL1sIDE1DMHoVq1JL7uXAe1ik9izcK3LDBjdp1azgzTe3/LXCYQm1lAUWJK90N2CFtL
	4suPfWzo3uIVcJJ4svw+6wRGuVlIUrOQtM9C0o6sZgEjyypG0dSC5ILipPRUc73ixNzi0rx0
	veT83E2M4Eh/JriDcWmDxSFGAQ5GJR7ejFjTACHWxLLiytxDjBIczEoivF7ANCHEm5JYWZVa
	lB9fVJqTWnyIUZqDRUmcd86LL/5CAumJJanZqakFqUUwWSYOTqkGxvOXdl/sLt34ock5ZPvu
	NY2L7GOUe2rf+lpmaTmulcxYEhSppsiXl2q5xWCtj+7Pn5fNssO1px6T5KjbcC/22aqrD5/M
	vuy6aYvGHy3vg4wSEl0zf7he8ddnvD9rtctDN/2LltOWbpA94s1rfueL08QZrwOrWBI2hbyJ
	PPRE/3SBwOI7Lz1vmSuxFGckGmoxFxUnAgBEL0f88AIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7NAjOAi029892

> This patch initializes freq_table and max_state of devfreq's profile.
> They will be used for creating transition table.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/devfreq/exynos4_bus.c |   30 +++++++++++++++++++++++++++++-
>  1 files changed, 29 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index 88ddc77..9c08855 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -985,7 +985,8 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
>  	struct busfreq_data *data;
>  	struct opp *opp;
>  	struct device *dev = &pdev->dev;
> -	int err = 0;
> +	int err = 0, i;
> +	unsigned int *freq_table;
>  
>  	data = kzalloc(sizeof(struct busfreq_data), GFP_KERNEL);
>  	if (data == NULL) {
> @@ -1042,6 +1043,33 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, data);
>  
> +	switch (data->type) {
> +	case TYPE_BUSF_EXYNOS4210:
> +		freq_table = devm_kzalloc(&pdev->dev, sizeof(unsigned int) * EX4210_LV_NUM,
> +					GFP_KERNEL);
> +
> +		for (i = 0; i < EX4210_LV_NUM; i++)
> +			freq_table[i] = exynos4210_busclk_table[i].clk;
> +
> +		exynos4_devfreq_profile.max_state = EX4210_LV_NUM;
> +		break;
> +	case TYPE_BUSF_EXYNOS4x12:
> +		freq_table = devm_kzalloc(&pdev->dev, sizeof(unsigned int) * EX4x12_LV_NUM,
> +					GFP_KERNEL);
> +
> +		for (i = 0; i < EX4x12_LV_NUM; i++)
> +			freq_table[i] = exynos4x12_mifclk_table[i].clk;
> +
> +		exynos4_devfreq_profile.max_state = EX4x12_LV_NUM;
> +		break;
> +	default:
> +		dev_err(dev, "Cannot determine the device id %d\n", data->type);
> +		err = -EINVAL;
> +		goto err_opp_add;
> +	}
> +
> +	exynos4_devfreq_profile.freq_table = freq_table;
> +
>  	busfreq_mon_reset(data);
>  
>  	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
> -- 
> 1.7.4.1
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
