Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1LLCSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 21:18:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8961 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab1LLCST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 21:18:19 -0500
X-AuditID: cbfee60b-b7c21ae000002d2e-ac-4ee564699b14
Date: Mon, 12 Dec 2011 02:18:17 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2 5/6] max17042: Fix value scaling for VCELL and avgVCELL
To: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Jason.Wortham@maxim-ic.com" <Jason.Wortham@maxim-ic.com>,
        Bruce Robertson <bruce.e.robertson@intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111212021733442@myungjoo.ham
Msgkey: 20111212021733442@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111212021733442@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <26423792.479621323656296884.JavaMail.weblogic@epml26>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBC2IWjE015499

> From: Bruce Robertson <bruce.e.robertson@intel.com>
> 
> The bottom three bits of the register are don't care bits.  The LSB
> value is 625 uV.  Adjust the returned values appropriately
> 
> Signed-off-by: Bruce Robertson <bruce.e.robertson@intel.com>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/power/max17042_battery.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
> index 001eca1..80a6ee7 100644
> --- a/drivers/power/max17042_battery.c
> +++ b/drivers/power/max17042_battery.c
> @@ -148,11 +148,15 @@ static int max17042_get_property(struct power_supply *psy,
>  		break;
>  	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
>  		val->intval = max17042_read_reg(chip->client,
> -				MAX17042_VCELL) * 83; /* 1000 / 12 = 83 */
> +				MAX17042_VCELL);
> +		val->intval >>= 3;
> +		val->intval *= 625; /* Units of LSB = 625 uV */
>  		break;
>  	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
>  		val->intval = max17042_read_reg(chip->client,
> -				MAX17042_AvgVCELL) * 83;
> +				MAX17042_AvgVCELL);
> +		val->intval >>= 3;
> +		val->intval *= 625; /* Units of LSB = 625 uV */
>  		break;
>  	case POWER_SUPPLY_PROP_CAPACITY:
>  		val->intval = max17042_read_reg(chip->client,
> -- 
> 1.7.7.3
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
