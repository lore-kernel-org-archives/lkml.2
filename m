Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab2E2CKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 22:10:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46072 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2E2CKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 22:10:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7faf6d000001f49-b6-4fc43018a779
Message-id: <4FC43018.9040702@samsung.com>
Date: Tue, 29 May 2012 11:10:32 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4] regulator: MAX77686: Add Maxim 77686 regulator driver
References: <1337919230-8296-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAKew6eXsf5UKe4t5m3MAuU1OUSZcUPBoSRUCjyR-gKRmDC8MOw@mail.gmail.com>
In-reply-to: <CAKew6eXsf5UKe4t5m3MAuU1OUSZcUPBoSRUCjyR-gKRmDC8MOw@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAV0JgyP+BievKFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M7y2H2QoeKFRM/DGJtYHxlHAXIyeHhICJxPOms8wQtpjEhXvr
	2boYuTiEBBYxSrz+cI0RJMErICjxY/I9li5GDg5mAXmJI5eyQcLMAuoSk+YtYoao72OSuNV7
	hxWiXkviUOtrsKEsAqoSZ3YcB5vDJiAn8bbpGyPIHFGBCIlf/RwgYREBA4mJS+axgsxhFvjE
	KLHw7DwWkISwgK/EjpaX7FALGCW+HFzCDpLgFAiWOL7gNusERoFZSO6bhXDfLCT3LWBkXsUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHIDPpHcwrmqwOMQowMGoxMO7QPeIvxBrYllxZe4h
	RgkOZiUR3vf9h/2FeFMSK6tSi/Lji0pzUosPMUpzsCiJ8z5ZssNfSCA9sSQ1OzW1ILUIJsvE
	wSnVwGg/q+J7ofwXqVXxNk0X1d6ILFivkV30/5OCbvfpyZcmn5pw5ejJySnpK5KrIrRzs7ZO
	3q172HzX7Ncaf9fuPrOJv+ja3kzNndc+VP/pPW1c7SsVZfx8huGHw1q15smfOx/OrtZdl1Ax
	KyWtdH4Qc9N1eeXi7Xc+L+J45rxmQn14f/HH9qhOH10lluKMREMt5qLiRAC1839KPAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Yadwinder,

On 2012년 05월 25일 21:27, Yadwinder Singh Brar wrote:

> Hi Jonghwa,
> 
>> +
>> +       if (pdata)
>> +               max77686->opmode_data = pdata->opmode_data;
> 
> I think this is unused(unwanted) now.
> 


Sorry, i missed to remove it out. I'll remove it.

>> +
>> +       for (i = 0; i < MAX77686_REGULATORS; i++) {
>> +               if (pdata)
>> +                       init_data[pdata->regulators[i].id] =
>> +                                                pdata->regulators[i].initdata;
> 
> I  think we can directly use  pdata->regulators[i].initdata instead of
> init_data[i].
> In case if pdata is not their we can use same instance of
> init_data(default)  for all regulators.
> 


This if for some situation that pdata's initdata doensn't line up. When
user sets only initdata considered it being used, there may be
regulators not having initdata, also its order is not clear. So for
those state, i think just using temporary array which satisfies
regulator's id order is fine while it can't use pdata's initdata directly.

>> +
>> +               config.init_data = init_data[i];
>> +               rdev[i] = regulator_register(&regulators[i], &config);
>> +
> 
>> +
>> +       for (i = 0; i < 8; i++) {
>> +               if (pdata->buck2_voltage[i] > 0)
>> +                       ret = regulator_map_voltage_linear(
>> +                                       rdev[MAX77686_LDOS+1],
>> +                                       pdata->buck2_voltage[i],
>> +                                       pdata->buck2_voltage[i]
>> +                                       + MAX77686_DVS_UVSTEP);
>> +               /* 1.1V as default for safety */
>> +               if (pdata->buck2_voltage[i] <= 0 || ret < 0)
>> +                       max77686->buck2_vol[i] = 0x28;
>> +               else
>> +                       max77686->buck2_vol[i] = ret;
>> +               regmap_write(max77686->iodev->regmap,
>> +                        MAX77686_REG_BUCK2DVS1 + i, max77686->buck2_vol[i]);
>> +
>> +               if (pdata->buck3_voltage[i] > 0)
>> +                       ret = regulator_map_voltage_linear(
>> +                                       rdev[MAX77686_LDOS+1],
>> +                                       pdata->buck3_voltage[i],
>> +                                       pdata->buck3_voltage[i]
>> +                                       + MAX77686_DVS_UVSTEP);
>> +               /* 1.1V as default for safety */
>> +               if (pdata->buck3_voltage[i] <= 0 || ret < 0)
>> +                       max77686->buck3_vol[i] = 0x28;
>> +               else
>> +                       max77686->buck3_vol[i] = ret;
>> +               regmap_write(max77686->iodev->regmap,
>> +                        MAX77686_REG_BUCK3DVS1 + i, max77686->buck3_vol[i]);
>> +
>> +               if (pdata->buck4_voltage[i] > 0)
>> +                       ret = regulator_map_voltage_linear(
>> +                                       rdev[MAX77686_LDOS+1],
>> +                                       pdata->buck4_voltage[i],
>> +                                       pdata->buck4_voltage[i]
>> +                                       + MAX77686_DVS_UVSTEP);
>> +               /* 1.1V as default for safety */
>> +               if (pdata->buck4_voltage[i] <= 0 || ret < 0)
>> +                       max77686->buck4_vol[i] = 0x28;
>> +               else
>> +                       max77686->buck4_vol[i] = ret;
>> +               regmap_write(max77686->iodev->regmap,
>> +                        MAX77686_REG_BUCK4DVS1 + i, max77686->buck4_vol[i]);
>> +       }
> 
> Why do we need to initialize the 8 voltage registers of BUCK2/3/4  ?
> 


Yes you're right. It is useless because we don't support DVS mode at
this moment. I'll remove it either.

> 
> Regards,
> Yadwinder.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Thanks ,
Best Regards.
