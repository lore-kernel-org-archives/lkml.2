Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab2E2EUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 00:20:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56528 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2E2EUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 00:20:50 -0400
MIME-Version: 1.0
In-Reply-To: <4FC43018.9040702@samsung.com>
References: <1337919230-8296-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAKew6eXsf5UKe4t5m3MAuU1OUSZcUPBoSRUCjyR-gKRmDC8MOw@mail.gmail.com>
	<4FC43018.9040702@samsung.com>
Date: Tue, 29 May 2012 09:50:50 +0530
Message-ID: <CAKew6eXq-5vCDgncYYPKUdKE2CNyqDErKUUdPbWeYe0uurpQ-w@mail.gmail.com>
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

On Tue, May 29, 2012 at 7:40 AM,  <jonghwa3.lee@samsung.com> wrote:
 Hi Jonghwa,

>>> +
>>> +       for (i = 0; i < MAX77686_REGULATORS; i++) {
>>> +               if (pdata)
>>> +                       init_data[pdata->regulators[i].id] =
>>> +                                                pdata->regulators[i].initdata;
>>
>> I  think we can directly use  pdata->regulators[i].initdata instead of
>> init_data[i].
>> In case if pdata is not their we can use same instance of
>> init_data(default)  for all regulators.
>>
>
>
> This if for some situation that pdata's initdata doensn't line up. When

Ok, but I think this not right place for sorting (sorting is not taking
place.) You have to sort it before entering in loop for registering
regulators.

> user sets only initdata considered it being used, there may be
> regulators not having initdata, also its order is not clear. So for

Ok, I think this is a bug in present driver also, because
without checking pdata->num_regulators, you are running in
loop  for (i = 0; i < MAX77686_REGULATORS; i++)
where MAX77686_REGULATORS should be equal to
pdata->num_regulators for this driver to work fine.

If we consider a case pdata->num_regulators is
equal to MAX77686_REGULATORS and initdata is
not their(i.e. NULL) than I think it will initialise
init_data[pdata->regulators[i].id to NULL, which again will be a bug.

> those state, i think just using temporary array which satisfies
> regulator's id order is fine while it can't use pdata's initdata directly.
>

If I am not wrong, I think we can also sort pdata's initdata also using
kernel's sort api and use one instance of (default)initdata for
all unused or uninitialized regulators in platform file.

>>> +
>>> +               config.init_data = init_data[i];
>>> +               rdev[i] = regulator_register(&regulators[i], &config);
>>> +
>>


Regards,
 Yadwinder.
