Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2E3Kh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:37:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60751 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2E3Kh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:37:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fe76d0000023f5-9a-4fc5f8668b31
Message-id: <4FC5F866.6030708@samsung.com>
Date: Wed, 30 May 2012 19:37:26 +0900
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
 <4FC43018.9040702@samsung.com>
 <CAKew6eXq-5vCDgncYYPKUdKE2CNyqDErKUUdPbWeYe0uurpQ-w@mail.gmail.com>
In-reply-to: <CAKew6eXq-5vCDgncYYPKUdKE2CNyqDErKUUdPbWeYe0uurpQ-w@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAd20H0f9DWb0WVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M6xsa2QrmS1Vc+DaLqYFxkUgXIyeHhICJxPxXe9kgbDGJC/fW
	A9lcHEICixgllrT0MIIkeAUEJX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMEPV9TBLrXh1n
	hajXkljV9IcZxGYRUJX48aUTLM4mICfxtukbI8gcUYEIiV/9HCBhEQEDiYlL5rGCzGEW+MQo
	sfDsPBaQhLCAr8SOlpfsEAu+MUq8eDUTbCinQLDEmtYG9gmMArOQ3DcL4b5ZSO5bwMi8ilE0
	tSC5oDgpPddQrzgxt7g0L10vOT93EyM4AJ9J7WBc2WBxiFGAg1GJh7f43lF/IdbEsuLK3EOM
	EhzMSiK8V28BhXhTEiurUovy44tKc1KLDzFKc7AoifPaLd7hLySQnliSmp2aWpBaBJNl4uCU
	amBMLoiou5IRsej3Sr/V3nyvdDYnLba5syRuXsaPSxn29SndPovCl1Xm63SuaviwN/5ritrE
	V07ea5tO7X215qeoK0MCYxSzvKTgPvmrZUq2d4R9P+xcxTzvnkG8xNG9E2TvZvgei7/JdK1X
	68kG1aznnlL8l4KOzcndtUtqh9+bl/2CGmcEjpxWYinOSDTUYi4qTgQACgSLvjwCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadwinder,

I'm sorry for late reply. I understand the problem you pointed out, but
i don't agree with you all.

On 2012년 05월 29일 13:20, Yadwinder Singh Brar wrote:

> On Tue, May 29, 2012 at 7:40 AM,  <jonghwa3.lee@samsung.com> wrote:
>  Hi Jonghwa,
> 
>>>> +
>>>> +       for (i = 0; i < MAX77686_REGULATORS; i++) {
>>>> +               if (pdata)
>>>> +                       init_data[pdata->regulators[i].id] =
>>>> +                                                pdata->regulators[i].initdata;
>>>
>>> I  think we can directly use  pdata->regulators[i].initdata instead of
>>> init_data[i].
>>> In case if pdata is not their we can use same instance of
>>> init_data(default)  for all regulators.
>>>
>>
>>
>> This if for some situation that pdata's initdata doensn't line up. When
> 
> Ok, but I think this not right place for sorting (sorting is not taking
> place.) You have to sort it before entering in loop for registering
> regulators.
> 
>> user sets only initdata considered it being used, there may be
>> regulators not having initdata, also its order is not clear. So for
> 
> Ok, I think this is a bug in present driver also, because
> without checking pdata->num_regulators, you are running in
> loop  for (i = 0; i < MAX77686_REGULATORS; i++)
> where MAX77686_REGULATORS should be equal to
> pdata->num_regulators for this driver to work fine.
>


I think we have same variable num_regulators but use differently. In my
code, it represents number of regulators to be used actually, but in
your code it equals to total number of regulators. Since it has
different meaning, it doesn't have to same with MAX77686_REGULATORS.
MAX77686_REGULATORS is macro which indicates total number of regulators
in max77686, and it equals to ARRAY_SIZE(regulators). Even if they are
not same, it's not a bug because we want to register all regulators
whether it will be used or not.

 
> If we consider a case pdata->num_regulators is
> equal to MAX77686_REGULATORS and initdata is
> not their(i.e. NULL) than I think it will initialise
> init_data[pdata->regulators[i].id to NULL, which again will be a bug.
> 
>> those state, i think just using temporary array which satisfies
>> regulator's id order is fine while it can't use pdata's initdata directly.
>>
> 
> If I am not wrong, I think we can also sort pdata's initdata also using
> kernel's sort api and use one instance of (default)initdata for
> all unused or uninitialized regulators in platform file.
> 


If init_data references to NULL, it will be ignored while
register_regulators() does initialize. Thus it doesn't make any problem.

I'm afraid of using Kernel's sort API because of its overhead. Do you
think it will be better to use them? If you mind that init_data has been
dynamic allocated, it can be modified to a static pointer array.

>>>> +

>>>> +               config.init_data = init_data[i];
>>>> +               rdev[i] = regulator_register(&regulators[i], &config);
>>>> +
>>>
> 
> 
> Regards,
>  Yadwinder.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Thanks,
