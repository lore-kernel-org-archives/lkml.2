Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab2EWEQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:16:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49692 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2EWEQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:16:21 -0400
MIME-Version: 1.0
In-Reply-To: <4FBC3FF0.5080408@samsung.com>
References: <y@samsung.com>
	<4fbb2ada.63de440a.589d.78e2@mx.google.com>
	<4FBC3FF0.5080408@samsung.com>
Date: Wed, 23 May 2012 09:46:19 +0530
Message-ID: <CAKew6eW2eGrBnzSGsr3N_dXSixXv-bkBo7xkbC-o9DNnwBhcuw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] regulator: Add support for MAX77686.
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: jonghwa3.lee@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Kyungmin Park and Samuel Ortiz)

Hi,

Yes, It happened unintentionally. I didn't know about your patch
before submitting
the initial version of my patches. I agree with you, I will review
your patches and
will try to incorporate extra features from your patches.

On Wed, May 23, 2012 at 7:10 AM,  <jonghwa3.lee@samsung.com> wrote:
> Hi, Yadwinder,
> As you know, both of us, recently, had competition for one driver
> whether you intend or not. And now, i think it is time to stop this and
> to find appropriate goal. From now on, i won't update this driver no
> more. I recommend you to review my patch and apply feature that you can
> apply. And also check comments that i wrote below.
>
> On 2012년 05월 22일 14:57, yadi.brar01@gmail.com wrote:
>
>> From: Yadwinder Singh Brar <yadi.brar@samsung.com>
>>
>> Add support for PMIC/regulator portion of MAX77686 multifunction device.
>> MAX77686 provides LDOs[1-26] and BUCKs[1-9]. This is initial release of driv
>> which supports setting and getting the voltage of a regulator with I2C
>> interface.

>> +     return DIV_ROUND_UP(rdev->desc->uV_step *
>> +                         abs(new_sel - old_sel),
>> +                         100);
>> +}
>> +
>
>
> Does LDO also need waiting for voltage change? I afraid it's not.
>

Yes, according to technical reference manual which I have, ramp rate for
LDOs is also 100mV/us.

>> +
>> +     if (pdata->ramp_delay < MAX77686_RAMP_RATE_13MV ||
>> +             pdata->ramp_delay > MAX77686_RAMP_RATE_100MV)
>> +             pdata->ramp_delay = MAX77686_RAMP_RATE_27MV;    /* default */

If pdata doesn't have proper ramp_delay, it will get value
MAX77686_RAMP_RATE_27MV.

>> +
>> +     max77686->ramp_delay = pdata->ramp_delay - 1;
>
>
> I think it is better to check pdata->ramp_delay is available.
> If pdata doesn't have ramp_delay member it might be error.
>

Yes, we have taken care of this case above before setting value of
max77686->ramp_delay.

>> +     max77686_update_reg(i2c, MAX77686_REG_BUCK2CTRL1,
>> +             max77686->ramp_delay << 6, RAMP_MASK);
>> +     max77686_update_reg(i2c, MAX77686_REG_BUCK3CTRL1,
>> +             max77686->ramp_delay << 6, RAMP_MASK);
>> +     max77686_update_reg(i2c, MAX77686_REG_BUCK4CTRL1,
>> +             max77686->ramp_delay << 6, RAMP_MASK);
>> +
>
>
> Why do you use i2c client still? If you registered regmap you can use
> its API. I recommend you to use regmap_update_bits() directly.
>
>

Yes, we are using regmap_update_bits().  max77686_update_reg() is just
a wrapper over it.

>> +     platform_set_drvdata(pdev, max77686);
>> +

>
> MAX77686 has crystal oscillator in it. And original version of this
> driver which was written by Chiwoon Byun, registers it as a regulator.
> As Mark says, we have to change it to use generic clock API. Where do
> you think should we put them into? In my opinion, it is proper that just
> leave them in regulator driver because this driver is almost core of
> PMIC. I already applied generic API in my local repository but i
> couldn't test yet. Because it crashed with SOC's private clock API.
> Anyway if you register 32khz clock with generic API ,DEFINE_CLK_GATE()
> will help you out which defined in linux/clk-private.h.
>

Yes, I was also thinking about where to put it. I am not sure whether this
is a proper place to put them. Anyway I will again think about it.

Thanks,
Yadwinder.
