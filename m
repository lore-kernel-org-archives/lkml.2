Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2EWEkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:40:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11828 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2EWEkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:40:15 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fe76d0000023f5-f3-4fbc6a2db355
Message-id: <4FBC6A2D.6040408@samsung.com>
Date: Wed, 23 May 2012 13:40:13 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 2/2] regulator: Add support for MAX77686.
References: <y@samsung.com> <4fbb2ada.63de440a.589d.78e2@mx.google.com>
 <4FBC3FF0.5080408@samsung.com>
 <CAKew6eW2eGrBnzSGsr3N_dXSixXv-bkBo7xkbC-o9DNnwBhcuw@mail.gmail.com>
In-reply-to: <CAKew6eW2eGrBnzSGsr3N_dXSixXv-bkBo7xkbC-o9DNnwBhcuw@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jQV3drD3+BhcWqllc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVMauhiLPjIXvHvfjdTA+Mkti5GTg4JAROJjZPnsUDY
	YhIX7q0HinNxCAlMZ5RomHGbHSTBKyAo8WPyPaAiDg5mAXmJI5eyQcLMAuoSk+YtYoaof8so
	cX/iZ2aIei2Jk3d3gS1gEVCVaJm+ggnEZhOQk3jb9I0RZI6oQITEr34OkLCIgIHExCXzWEHm
	MAvsZJJ49uwOI0hCWMBBYvba6YwQC9YzSlw8uArsIE6BYIkp2yewTGAUmIXkvlkI981Cct8C
	RuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGh+ExqB+PKBotDjAIcjEo8vD/c9vgLsSaW
	FVfmHmKU4GBWEuFdP323vxBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeu8U7/IUE0hNLUrNTUwtS
	i2CyTBycUg2MUUcmCT/59/gRs9JTuXnR5+wk1fc/3M7LsO7nxOPvI1XqbK0dy1izrr+5O2nT
	HNbcbu2/by+sm6d95G5Dget0xTjRGTv++zop/re7umMpb1i394fY7aXaDtfuKC7y4VpUp+YX
	4aT7xuU8X+LdrZ+OJzCqOYZdmiRTEhcQlhI0y8rpBseUrcnVSizFGYmGWsxFxYkAJg5NwkEC	AAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 05월 23일 13:16, Yadwinder Singh Brar wrote:

>>> +     max77686_update_reg(i2c, MAX77686_REG_BUCK2CTRL1,
>>> +             max77686->ramp_delay << 6, RAMP_MASK);
>>> +     max77686_update_reg(i2c, MAX77686_REG_BUCK3CTRL1,
>>> +             max77686->ramp_delay << 6, RAMP_MASK);
>>> +     max77686_update_reg(i2c, MAX77686_REG_BUCK4CTRL1,
>>> +             max77686->ramp_delay << 6, RAMP_MASK);
>>> +
>>
>>
>> Why do you use i2c client still? If you registered regmap you can use
>> its API. I recommend you to use regmap_update_bits() directly.
>>
>>
> 
> Yes, we are using regmap_update_bits().  max77686_update_reg() is just
> a wrapper over it.
> 


Yes, i know what you mean. However it doesn't need max77686_update_reg()
any more since it uses regmap API. Why don't you just pass iodev->regmap
to regmap_update_bits(). It is clear that there is no reason for using
i2c client as a medium. Please check regulator and mfd driver of my
previous patch.


Thanks.
