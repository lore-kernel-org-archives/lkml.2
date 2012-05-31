Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab2EaNBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:01:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40792 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab2EaNBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:01:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAKew6eWf1Cnk3qWh0kw7Ggdvgz3_sZ6-6X0pC12apYgvOZZ9mw@mail.gmail.com>
References: <1337919230-8296-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAKew6eXsf5UKe4t5m3MAuU1OUSZcUPBoSRUCjyR-gKRmDC8MOw@mail.gmail.com>
	<4FC43018.9040702@samsung.com>
	<CAKew6eXq-5vCDgncYYPKUdKE2CNyqDErKUUdPbWeYe0uurpQ-w@mail.gmail.com>
	<4FC5F866.6030708@samsung.com>
	<CAKew6eVjUCSkX=JRtYV2mRQ8hy4J1SSsvNn+p=MQcTD51J__sQ@mail.gmail.com>
	<4FC71617.7070801@samsung.com>
	<CAKew6eWf1Cnk3qWh0kw7Ggdvgz3_sZ6-6X0pC12apYgvOZZ9mw@mail.gmail.com>
Date: Thu, 31 May 2012 18:31:04 +0530
Message-ID: <CAKew6eVaxMxB48M5iLbvkQj8wdxXfqkH8tn1SC0g0ti=Zcqydg@mail.gmail.com>
Subject: Re: [PATCH v4] regulator: MAX77686: Add Maxim 77686 regulator driver
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: jonghwa3.lee@samsung.com
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLEASE ignore previous incomplete mails. Sorry for noise by mistake.

On Thu, May 31, 2012 at 6:16 PM, Yadwinder Singh Brar
<yadi.brar01@gmail.com> wrote:
> On Thu, May 31, 2012 at 12:26 PM,  <jonghwa3.lee@samsung.com> wrote:
>> On 2012년 05월 30일 21:08, Yadwinder Singh Brar wrote:
>>
>>> Hi Jonghwa,
>>>
>>> On Wed, May 30, 2012 at 4:07 PM,  <jonghwa3.lee@samsung.com> wrote:
>>>> Hi Yadwinder,
>>>>
>>>> I'm sorry for late reply. I understand the problem you pointed out, but
>>>> i don't agree with you all.
>>>
>>> Sorry,I think you didn't get my points. Lets forget my code and talk
>>> about this code now.
>>>
>>>>>>>> +
>>>>>>>> +       for (i = 0; i < MAX77686_REGULATORS; i++) {
>>>>>>>> +               if (pdata)
>>>>>>>> +                       init_data[pdata->regulators[i].id] =
>>>>>>>> +                                                pdata->regulators[i].initdata;
>>>
>>> In case we have a list of 5 regulators only in pdata, than what will
>>> happen here when i > 5 ???
>>>
>>
>>
>> You're right, it has bug. How do you think that change the condition to
>> (pdata && i < pdata->num_regulators)?
>>
>
 I think this stuff is not at right place, It should be moved out of this loop
 to solve this both problems.
 Please try to do all this stuff related to platform file at starting while
 checking if(pdata) {...}
>
>>>>>>>
>>>>>>> I  think we can directly use  pdata->regulators[i].initdata instead of
>>>>>>> init_data[i].
>>>>>>> In case if pdata is not their we can use same instance of
>>>>>>> init_data(default)  for all regulators.
>>>>>>>
>>>>>>
>>>>>>
>>>>>> This if for some situation that pdata's initdata doensn't line up. When
>>>
>>>>>>>> +               config.init_data = init_data[i];
>>>>>>>> +               rdev[i] = regulator_register(&regulators[i], &config);
>>>
>>> In case pdata->regulators[0] is not the first regulator(i.e id > 0), then
>>> will it get proper initdata for regulators[0] before registering ????
>>>
>>
>>
>> Yes, because above code replaces pdata->regalator's initdata to proper
>> position of initdata array referencing regulator's id.
>>
>
> No, sorry i think you again missed the point.
> Anyways, moving above stuff out of this loop
> will also sove this problem.
>
>>>>>
>>>>> Ok, but I think this not right place for sorting (sorting is not taking
>>>>> place.) You have to sort it before entering in loop for registering
>>>>> regulators.
>>>>>
>>>>>> user sets only initdata considered it being used, there may be
>>>>>> regulators not having initdata, also its order is not clear. So for
>>>>>
>>>>> Ok, I think this is a bug in present driver also, because
>>>>> without checking pdata->num_regulators, you are running in
>>>>> loop  for (i = 0; i < MAX77686_REGULATORS; i++)
>>>>> where MAX77686_REGULATORS should be equal to
>>>>> pdata->num_regulators for this driver to work fine.
>>>>>

>> So, to sum up to this, you think it is better to sort pdata->regulators
>> by its id before entering loop and just use pdata->regulators directly,
>> right? Okay, I'll do modify it.
>>
>
 Yes, this will allow us to add device tree support without any
 modifications to this code in future and keeping our code simple
 and compact.

 In my opinion since we are unconditionally registering all the regulators
to keep our code simple, as mark said, we should also populate also
all regulators in pdata list in platform file in sorted order to keep our code
simple here.
So that here we need to verify only if (pdata->num_regulators ==
MAX77686_REGULATORS).

>>>  Regards,
>>>  Yadwinder.
