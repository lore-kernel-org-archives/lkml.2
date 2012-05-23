Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2EWFdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:33:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56033 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2EWFda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:33:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fe76d0000023f5-e6-4fbc76a8d548
Message-id: <4FBC76A8.2070004@samsung.com>
Date: Wed, 23 May 2012 14:33:28 +0900
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
 <4FBC6A2D.6040408@samsung.com>
 <CAKew6eUew+=f-dGjJZD7Wy8Xt2f4smEhkYh=CUhx6Y_EMByFFw@mail.gmail.com>
In-reply-to: <CAKew6eUew+=f-dGjJZD7Wy8Xt2f4smEhkYh=CUhx6Y_EMByFFw@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jAd0VZXv8DTp+qllc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX0nz7MWvCRv2LOjcoGxvM8XYycHBICJhLrLqxkgbDF
	JC7cW8/WxcjFISSwiFHiQvtzJpAEr4CgxI/J94CKODiYBeQljlzKBgkzC6hLTJq3iBmi/i2j
	xMlz+5kh6rUkrj8+wghiswioSnyYNB8sziYgJ/G26RsjyBxRgQiJX/0cIGERAQOJiUvmsYLM
	YRbYySTx7NkdsF5hAQeJ2WunM0IsmM4ksXjGPHaQBKdAsET702PMExgFZiG5bxbCfbOQ3LeA
	kXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAgPpPawbiyweIQowAHoxIP7w+3Pf5CrIll
	xZW5hxglOJiVRHjXT9/tL8SbklhZlVqUH19UmpNafIhRmoNFSZzXbvEOfyGB9MSS1OzU1ILU
	IpgsEwenVAPjVr2cTpcfN+9vvNny1vBoslnTe7F/6pfPSdx39e8P+LI++sKSLyc0lfTz/FYf
	2VMwV1Euf/nqe3aT12Q+z/PRrTm35PuhJ1L8yXdP6M06t6+aq+aZXMDzHWutnl5mzprV6bjo
	xuxJ85xtp08qar08syP+2ofgNCHrHWdXubPFGEZ/sXbpuO68SYmlOCPRUIu5qDgRAOQem8ZA	AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 05월 23일 14:23, Yadwinder Singh Brar wrote:

> On Wed, May 23, 2012 at 10:10 AM,  <jonghwa3.lee@samsung.com> wrote:
>> On 2012년 05월 23일 13:16, Yadwinder Singh Brar wrote:
>>
>>>>> +     max77686_update_reg(i2c, MAX77686_REG_BUCK2CTRL1,
>>>>> +             max77686->ramp_delay << 6, RAMP_MASK);
>>>>> +     max77686_update_reg(i2c, MAX77686_REG_BUCK3CTRL1,
>>>>> +             max77686->ramp_delay << 6, RAMP_MASK);
>>>>> +     max77686_update_reg(i2c, MAX77686_REG_BUCK4CTRL1,
>>>>> +             max77686->ramp_delay << 6, RAMP_MASK);
>>>>> +
>>>>
>>>>
>>>> Why do you use i2c client still? If you registered regmap you can use
>>>> its API. I recommend you to use regmap_update_bits() directly.
>>>>
>>>>
>>>
>>> Yes, we are using regmap_update_bits().  max77686_update_reg() is just
>>> a wrapper over it.
>>>
>>
>>
>> Yes, i know what you mean. However it doesn't need max77686_update_reg()
>> any more since it uses regmap API. Why don't you just pass iodev->regmap
>> to regmap_update_bits(). It is clear that there is no reason for using
>> i2c client as a medium. Please check regulator and mfd driver of my
>> previous patch.
>>
> 
> I agree with you we can use directly  regmap API. But I preferred
> max77686_update_reg() because its a common practice to use
> common read/write API which we define in mfd driver to access
> that particular mfd device from other drivers.
> 
> Regards,
> Yadwinder.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


I inform you my mfd driver has been confirmed by Samuel Oritz and there
is no mfd private API. This situation looks unusual that we registers
mfd driver and regulator driver separately. But how should we do? For
corporation , i'm asking you to consider my suggestion.

Thanks.


Thanks.
