Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2CZEjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 00:39:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39731 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2CZEjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 00:39:19 -0400
X-AuditID: cbfee60b-b7c20ae000005349-03-4f6ff2f177ed
Date: Mon, 26 Mar 2012 04:39:13 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] regulator: Convert max8952 to set_voltage_sel
To: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120326043822296@myungjoo.ham
Msgkey: 20120326043822296@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120326043822296@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7532902.56821332736753002.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2Q4e2Up011682

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/regulator/max8952.c |   28 +++++++---------------------
>  1 files changed, 7 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
> index e9c0a0e..c35236a 100644
> --- a/drivers/regulator/max8952.c
> +++ b/drivers/regulator/max8952.c
> @@ -130,11 +130,10 @@ static int max8952_get_voltage(struct regulator_dev *rdev)
>  	return max8952_voltage(max8952, vid);
>  }
>  
> -static int max8952_set_voltage(struct regulator_dev *rdev,
> -			       int min_uV, int max_uV, unsigned *selector)
> +static int max8952_set_voltage_sel(struct regulator_dev *rdev,
> +				   unsigned selector)
>  {
>  	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
> -	s8 vid = -1, i;
>  
>  	if (!gpio_is_valid(max8952->pdata->gpio_vid0) ||
>  			!gpio_is_valid(max8952->pdata->gpio_vid1)) {
> @@ -142,23 +141,10 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
>  		return -EPERM;
>  	}
>  
> -	for (i = 0; i < MAX8952_NUM_DVS_MODE; i++) {
> -		int volt = max8952_voltage(max8952, i);
> -
> -		/* Set the voltage as low as possible within the range */
> -		if (volt <= max_uV && volt >= min_uV)
> -			if (vid == -1 || max8952_voltage(max8952, vid) > volt)
> -				vid = i;
> -	}
> -
> -	if (vid >= 0 && vid < MAX8952_NUM_DVS_MODE) {
> -		max8952->vid0 = vid & 0x1;
> -		max8952->vid1 = (vid >> 1) & 0x1;
> -		*selector = vid;
> -		gpio_set_value(max8952->pdata->gpio_vid0, max8952->vid0);
> -		gpio_set_value(max8952->pdata->gpio_vid1, max8952->vid1);
> -	} else
> -		return -EINVAL;
> +	max8952->vid0 = selector & 0x1;
> +	max8952->vid1 = (selector >> 1) & 0x1;
> +	gpio_set_value(max8952->pdata->gpio_vid0, max8952->vid0);
> +	gpio_set_value(max8952->pdata->gpio_vid1, max8952->vid1);
>  
>  	return 0;
>  }
> @@ -169,7 +155,7 @@ static struct regulator_ops max8952_ops = {
>  	.enable			= max8952_enable,
>  	.disable		= max8952_disable,
>  	.get_voltage		= max8952_get_voltage,
> -	.set_voltage		= max8952_set_voltage,
> +	.set_voltage_sel	= max8952_set_voltage_sel,
>  	.set_suspend_disable	= max8952_disable,
>  };
>  
> -- 
> 1.7.5.4
> 
--
MyungJoo Ham (ÇÔ¸íÁÖ), PHD
System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
