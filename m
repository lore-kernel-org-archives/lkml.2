Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1DULNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:13:55 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:34456 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab1DULNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:13:54 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Date: Thu, 21 Apr 2011 04:13:28 -0700
Subject: RE: [PATCH 13/14] regulator: max8925: fix not add device if missing
 init data
Thread-Topic: [PATCH 13/14] regulator: max8925: fix not add device if
 missing init data
Thread-Index: AcwAEMPnfkgOpjgiQhavIbSUVNodWgAA9QJQ
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CF0EF027@SC-VEXCH1.marvell.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
 <1303300539-2941-1-git-send-email-haojian.zhuang@marvell.com>
 <20110421104204.GB11788@opensource.wolfsonmicro.com>
In-Reply-To: <20110421104204.GB11788@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3LBE0XE024717



>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>Sent: 2011Äê4ÔÂ21ÈÕ 6:42 PM
>To: Haojian Zhuang
>Cc: sameo@linux.intel.com; haojian.zhuang@gmail.com; linux-
>kernel@vger.kernel.org; lrg@slimlogic.co.uk
>Subject: Re: [PATCH 13/14] regulator: max8925: fix not add device if
>missing init data
>
>On Wed, Apr 20, 2011 at 07:55:39PM +0800, Haojian Zhuang wrote:
>> If regulator[0] is missed in init data, all regulators of max8925
>won't
>> be initialized.
>
>With a changelog like this I'd expect a small change to an error check
>in the startup code or something but this is a very big change to the
>driver initialisation.
>
>> +static struct regulator_init_data
>regulator_pdata[ARRAY_SIZE(regulator_devs)];
>
>That looks really suspicious, what happens if there's two of these
>devices in the system?
>
It's impossible to use two PMIC in one system. At least, I didn't hear.

>> +		memcpy(&regulator_pdata[i], &pdata->regulator[i],
>> +			sizeof(struct regulator_init_data));
>> +		regulator_devs[i].platform_data = &regulator_pdata[i];
>> +		regulator_devs[i].pdata_size = sizeof(regulator_pdata[i]);
>> +		regulator_devs[i].num_resources = 1;
>> +		regulator_devs[i].resources = &regulator_resources[seq];
>> +
>> +		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[i], 1,
>> +				      &regulator_resources[seq], 0);
>> +		if (ret < 0) {
>> +			dev_err(chip->dev, "Failed to add regulator subdev\n");
>> +			goto out;
>
>It's really unclear why the array is needed at all if you're registering
>the devices one at a time.
>
Although there're a lot of regulators, maybe only parts of them are used.
So only add the necessary one. Others will be passed. The number is got
from platform data.

>> -	if (pdata && pdata->regulator[0]) {
>> -		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
>> -				      ARRAY_SIZE(regulator_devs),
>> -				      &regulator_resources[0], 0);
>> -		if (ret < 0) {
>> -			dev_err(chip->dev, "Failed to add regulator subdev\n");
>> -			goto out_dev;
>> -		}
>
>Surely the only change that's needed here is to remove the check to see
>if pdata->regulator[0] is non-null?
All above changes are necessary to me.

Thanks
Haojian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
