Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab1FVCtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:49:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59106 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1FVCtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:49:05 -0400
X-AuditID: cbfee60b-b7c8bae000000f98-00-4e0158186813
Date: Wed, 22 Jun 2011 02:48:56 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] regulator: MAX8997: Fix for divide by zero error
To: Tushar Behera <tushar.behera@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Cc: "patches@linaro.org" <patches@linaro.org>, "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110622024513074@myungjoo.ham
Msgkey: 20110622024513074@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110622024513074@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29765534.104601308710936223.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5M2nMFe020348

Sender : Tushar Behera<tushar.behera@linaro.org>
Date : 2011-06-21 12:38 (GMT+09:00)
> Currently, ramp_delay variable is used uninitialzed in
> max8997_set_voltage_ldobuck which gets called through
> regulator_register calls.
> 
> To fix the problem, in max8997_pmic_probe, ramp_delay initialization
> code is moved before calls to regulator_register.
> 
> Cc: Liam Girdwood 
> Cc: Mark Brown 
> Cc: MyungJoo Ham 
> Cc: Kyungmin Park 
> Cc: Samuel Ortiz 
> Signed-off-by: Tushar Behera 

Although I've never been reported such an issue, but I'm sure this will cause one any time. Thanks!

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
> drivers/regulator/max8997.c |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index 10d5a1d..0fc7b8c 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -1124,6 +1124,10 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
> 0x3f);
> }
> 
> + /* Misc Settings */
> + max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
> + max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
> +
> for (i = 0; i < pdata->num_regulators; i++) {
> const struct voltage_map_desc *desc;
> int id = pdata->regulators[i].id;
> @@ -1148,10 +1152,6 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
> }
> }
> 
> - /* Misc Settings */
> - max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
> - max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
> -
> return 0;
> err:
> for (i = 0; i < max8997->num_regulators; i++)
> -- 
> 1.7.4.1
> 
> 



 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
