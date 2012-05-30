Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2E3MJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:09:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61791 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2E3MJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <4FC5F866.6030708@samsung.com>
References: <1337919230-8296-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAKew6eXsf5UKe4t5m3MAuU1OUSZcUPBoSRUCjyR-gKRmDC8MOw@mail.gmail.com>
	<4FC43018.9040702@samsung.com>
	<CAKew6eXq-5vCDgncYYPKUdKE2CNyqDErKUUdPbWeYe0uurpQ-w@mail.gmail.com>
	<4FC5F866.6030708@samsung.com>
Date: Wed, 30 May 2012 17:38:59 +0530
Message-ID: <CAKew6eVjUCSkX=JRtYV2mRQ8hy4J1SSsvNn+p=MQcTD51J__sQ@mail.gmail.com>
Subject: Re: [PATCH v4] regulator: MAX77686: Add Maxim 77686 regulator driver
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: jonghwa3.lee@samsung.com
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwa,

On Wed, May 30, 2012 at 4:07 PM,  <jonghwa3.lee@samsung.com> wrote:
> Hi Yadwinder,
>
> I'm sorry for late reply. I understand the problem you pointed out, but
> i don't agree with you all.

Sorry,I think you didn't get my points. Lets forget my code and talk
about this code now.

>>>>> +
>>>>> +       for (i = 0; i < MAX77686_REGULATORS; i++) {
>>>>> +               if (pdata)
>>>>> +                       init_data[pdata->regulators[i].id] =
>>>>> +                                                pdata->regulators[i].initdata;

In case we have a list of 5 regulators only in pdata, than what will
happen here when i > 5 ???

>>>>
>>>> I  think we can directly use  pdata->regulators[i].initdata instead of
>>>> init_data[i].
>>>> In case if pdata is not their we can use same instance of
>>>> init_data(default)  for all regulators.
>>>>
>>>
>>>
>>> This if for some situation that pdata's initdata doensn't line up. When

>>>>> +               config.init_data = init_data[i];
>>>>> +               rdev[i] = regulator_register(&regulators[i], &config);

In case pdata->regulators[0] is not the first regulator(i.e id > 0), then
will it get proper initdata for regulators[0] before registering ????

>>
>> Ok, but I think this not right place for sorting (sorting is not taking
>> place.) You have to sort it before entering in loop for registering
>> regulators.
>>
>>> user sets only initdata considered it being used, there may be
>>> regulators not having initdata, also its order is not clear. So for
>>
>> Ok, I think this is a bug in present driver also, because
>> without checking pdata->num_regulators, you are running in
>> loop  for (i = 0; i < MAX77686_REGULATORS; i++)
>> where MAX77686_REGULATORS should be equal to
>> pdata->num_regulators for this driver to work fine.
>>
>
>
> I think we have same variable num_regulators but use differently. In my
> code, it represents number of regulators to be used actually, but in
> your code it equals to total number of regulators. Since it has

not exactly.

> different meaning, it doesn't have to same with MAX77686_REGULATORS.
> MAX77686_REGULATORS is macro which indicates total number of regulators
> in max77686, and it equals to ARRAY_SIZE(regulators). Even if they are
> not same, it's not a bug because we want to register all regulators
> whether it will be used or not.
>
>
>> If we consider a case pdata->num_regulators is
>> equal to MAX77686_REGULATORS and initdata is
>> not their(i.e. NULL) than I think it will initialise
>> init_data[pdata->regulators[i].id to NULL, which again will be a bug.
>>
>>> those state, i think just using temporary array which satisfies
>>> regulator's id order is fine while it can't use pdata's initdata directly.
>>>
>>
>> If I am not wrong, I think we can also sort pdata's initdata also using
>> kernel's sort api and use one instance of (default)initdata for
>> all unused or uninitialized regulators in platform file.
>>
>
>
> If init_data references to NULL, it will be ignored while
> register_regulators() does initialize. Thus it doesn't make any problem.
>
> I'm afraid of using Kernel's sort API because of its overhead. Do you

I don't think it's overhead will matter more than that of allocating a
new array and than
sorting it here.

> think it will be better to use them? If you mind that init_data has been
> dynamic allocated, it can be modified to a static pointer array.
>

No, their is no problem with dynamic.
Anyways, I had just suggested you to use pdata->regulators[i].initdata.

 Regards,
 Yadwinder.
