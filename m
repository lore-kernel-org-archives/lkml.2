Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab1DNCal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:30:41 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:60335 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184Ab1DNCak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:30:40 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Date: Wed, 13 Apr 2011 19:26:53 -0700
Subject: RE: [PATCH 11/13] power_supply: max8925: use platform_data from cell
Thread-Topic: [PATCH 11/13] power_supply: max8925: use platform_data from
 cell
Thread-Index: Acv57BeuMCevetT0R8K2C/qjiK8H4QAXwh8g
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05AB00@SC-VEXCH1.marvell.com>
References: <1302706264-25815-3-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-9-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-10-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-11-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
 <20110413150324.GA16679@oksana.dev.rtsoft.ru>
In-Reply-To: <20110413150324.GA16679@oksana.dev.rtsoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3E2Uipg017130



>-----Original Message-----
>From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
>Sent: 2011å¹´4æœˆ13æ—¥ 11:03 PM
>To: Haojian Zhuang
>Cc: sameo@linux.intel.com; haojian.zhuang@gmail.com; linux-
>kernel@vger.kernel.org; David Woodhouse
>Subject: Re: [PATCH 11/13] power_supply: max8925: use platform_data from
>cell
>
>On Wed, Apr 13, 2011 at 10:51:02PM +0800, Haojian Zhuang wrote:
>> Avoid to get platform_data from parent device. Get it from mfd cell
>> device instead.
>>
>> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
>> Cc: Anton Vorontsov <cbou@mail.ru>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> ---
>
>I don't see the whole series, but I hope the patch doesn't break any
>existing in-tree users of that driver?
>
Excuse me for not include you in the whole series. I checked that it won't
break existing code.

The fix for this patch is already sent. Please help to review.

>>  drivers/power/max8925_power.c |   16 +++++-----------
>>  1 files changed, 5 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/power/max8925_power.c
>b/drivers/power/max8925_power.c
>> index 8e5aec2..359c53c 100644
>> --- a/drivers/power/max8925_power.c
>> +++ b/drivers/power/max8925_power.c
>> @@ -425,21 +425,16 @@ static __devexit int
>max8925_deinit_charger(struct max8925_power_info *info)
>>  static __devinit int max8925_power_probe(struct platform_device *pdev)
>>  {
>>  	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
>> -	struct max8925_platform_data *max8925_pdata;
>>  	struct max8925_power_pdata *pdata = NULL;
>>  	struct max8925_power_info *info;
>> -	int ret;
>> -
>> -	if (pdev->dev.parent->platform_data) {
>> -		max8925_pdata = pdev->dev.parent->platform_data;
>> -		pdata = max8925_pdata->power;
>> -	}
>> +	int ret = -EINVAL;
>
>I guess you don't need the initializer.
>
OK

>>
>> -	if (!pdata) {
>> +	pdata = pdev->dev.platform_data;
>> +	if (pdata == NULL) {
>
>I'd prefer to keep '!pdata'.
>
OK

>>  		dev_err(&pdev->dev, "platform data isn't assigned to "
>>  			"power supply\n");
>>  		return -EINVAL;
>> -	}
>> +	};
>
>No need for the semicolon.
OK

>
>>
>>  	info = kzalloc(sizeof(struct max8925_power_info), GFP_KERNEL);
>>  	if (!info)
>> @@ -447,6 +442,7 @@ static __devinit int max8925_power_probe(struct
>platform_device *pdev)
>>  	info->chip = chip;
>>  	info->gpm = chip->i2c;
>>  	info->adc = chip->adc;
>> +	dev_set_drvdata(&pdev->dev, info);
>
>As this is a platform driver, you'd better do platform_set_drvdata(pdev,
>info),
>not dev_set_drvdata(). In the end, it's the same thing.
>
Got it.

>>
>>  	info->ac.name = "max8925-ac";
>>  	info->ac.type = POWER_SUPPLY_TYPE_MAINS;
>> @@ -482,8 +478,6 @@ static __devinit int max8925_power_probe(struct
>platform_device *pdev)
>>  	info->topoff_threshold = pdata->topoff_threshold;
>>  	info->fast_charge = pdata->fast_charge;
>>  	info->set_charger = pdata->set_charger;
>> -	dev_set_drvdata(&pdev->dev, info);
>> -	platform_set_drvdata(pdev, info);
>>
>>  	max8925_init_charger(chip, info);
>>  	return 0;
>
>Thanks,
>
>--
>Anton Vorontsov
>Email: cbouatmailru@gmail.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
