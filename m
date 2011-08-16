Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1HPGKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:10:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27057 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1HPGKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:10:15 -0400
X-AuditID: cbfee60c-b7c93ae000000826-f6-4e4a09c57c92
Date: Tue, 16 Aug 2011 06:10:13 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] power: max17042: divide by 0 Crash because r_sns init too
 late
To: Philip Rakity <prakity@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110816060835541@myungjoo.ham
Msgkey: 20110816060835541@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110816060835541@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11091080.93181313475012613.JavaMail.weblogic@epml13>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7G6AOKk027677

Philip Rakity<prakity@marvell.com> Date : 2011-08-13 13:18 (GMT+09:00)
> On MMP2 brownstone divide by 0 error since probe sets r_sns
> after calling power_supply_register.
> 
> Move the code up a few lines.  r_sns comes from the platform
> data.
> 
> PROP_CURRENT_AVG and PROP_CURRENT divide the result by r_sns.
> 
> Signed-off-by: Philip Rakity 

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
> drivers/power/max17042_battery.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
> index 9f0183c..4245806 100644
> --- a/drivers/power/max17042_battery.c
> +++ b/drivers/power/max17042_battery.c
> @@ -210,6 +210,9 @@ static int __devinit max17042_probe(struct i2c_client *client,
> if (!chip->pdata->enable_current_sense)
> chip->battery.num_properties -= 2;
> 
> + if (chip->pdata->r_sns == 0)
> + chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
> +
> ret = power_supply_register(&client->dev, &chip->battery);
> if (ret) {
> dev_err(&client->dev, "failed: power supply register\n");
> @@ -226,9 +229,6 @@ static int __devinit max17042_probe(struct i2c_client *client,
> max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
> max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
> max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
> - } else {
> - if (chip->pdata->r_sns == 0)
> - chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
> }
> 
> return 0;
> -- 
> 1.7.0.4
> 
> 

 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
