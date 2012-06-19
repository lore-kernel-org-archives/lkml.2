Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2FSMU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:20:59 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44564 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2FSMU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:20:58 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <CAKew6eXafa0n+dUcqa3EXEJQj4xNDM_Z2UNVhGu7rCSSEgiieQ@mail.gmail.com>
References: <1340092423-10073-1-git-send-email-yadi.brar@samsung.com>
 <1340092423-10073-2-git-send-email-yadi.brar@samsung.com> <CAF+7xWkopYu2CkPsdPeJ5Kr0NBbYcnf2ez-hC+RCj6QuOFcstw@mail.gmail.com>
 <CAKew6eXafa0n+dUcqa3EXEJQj4xNDM_Z2UNVhGu7rCSSEgiieQ@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 19 Jun 2012 20:20:37 +0800
Message-ID: <CAF+7xWmFZTa8=mDW3gJwivkb0vDOj113u8bC-jP9x5BwYxFkLg@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: max77686: Implement .set_ramp_delay() callback.
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/19 Yadwinder Singh Brar <yadi.brar01@gmail.com>:
> On Tue, Jun 19, 2012 at 1:48 PM, Axel Lin <axel.lin@gmail.com> wrote:
>>>  static struct regulator_ops max77686_ops = {
>>>        .list_voltage           = regulator_list_voltage_linear,
>>>        .map_voltage            = regulator_map_voltage_linear,
>>> @@ -90,6 +114,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
>
>    ^^^^^^^^^^^^^^^^^^^^^^^^^
>>>        .get_voltage_sel        = regulator_get_voltage_sel_regmap,
>>>        .set_voltage_sel        = regulator_set_voltage_sel_regmap,
>>>        .set_voltage_time_sel   = regulator_set_voltage_time_sel,
>>> +       .set_ramp_delay         = max77686_set_ramp_delay,
>>>  };
>>
>> I think what you want here is to set .set_ramp_delay callback for
>> max77686_buck_dvs_ops
>> rather than max77686_ops.
>
> Now I have seen into my code after applying this patch again, yes its
> set for  max77686_buck_dvs_ops.
> I also missed to catch this in patch... :) ..
> Anyways, thanks for review and I think, we don't need to revise this patch.

oh, sorry, my bad.

Just try to apply your patch, I found

+       return regmap_update_bits(rdev->regmap, MAX77686_REG_BUCK2CTRL1 +
+                                 (rdev->desc->id - MAX77686_BUCK2) * 10,
+                                 MAX77686_RAMP_RATE_MASK, ramp_value << 6);

can be simplified to:

return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
                          ramp_value << 6);

How do you think?

Regards,
Axel
