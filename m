Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab1LEKgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:36:20 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44639 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab1LEKgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:36:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2XJ4TCEaN1rMRjMZNRn5Wx6jcTRC_DmyN4Qyf2zztWSsg@mail.gmail.com>
References: <1323074921-29291-1-git-send-email-thomas.abraham@linaro.org>
	<CAH9JG2XJ4TCEaN1rMRjMZNRn5Wx6jcTRC_DmyN4Qyf2zztWSsg@mail.gmail.com>
Date: Mon, 5 Dec 2011 16:06:17 +0530
Message-ID: <CAJuYYwTT2jbbquZM=ZwK=Gh39ss=iG0WDCc3TYjzHLEgfeC1gA@mail.gmail.com>
Subject: Re: [PATCH] backlight: add regulator support for platform_lcd driver
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: rpurdie@rpsys.net, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Park,

On 5 December 2011 15:40, Kyungmin Park <kmpark@infradead.org> wrote:
[...]

>> +     /*
>> +      * If power to lcd and/or lcd interface is controlled using a regulator,
>> +      * enable or disable the regulator based in the power setting.
>> +      */
>> +     lcd_regulator = regulator_get(plcd->us, "vcc_lcd");
>> +     if (IS_ERR(lcd_regulator)) {
>> +             dev_info(plcd->us, "could not get regulator\n");
>> +             goto set_power;
>> +     }
>
> Recent regulator discussion. it should be failed instead fall through
> gracefully.

Ok. But in this case, there could be boards that do not use a
regulator for the lcd/display interface. Is it mandatory for fail if
regulator is not found. Sorry, I have not read through the regulator
discussion.

>> +
>> +     if (lcd_power) {
>> +             if (plcd->pdata->min_uV || plcd->pdata->max_uV)
>> +                     if (regulator_set_voltage(lcd_regulator,
>> +                             plcd->pdata->min_uV, plcd->pdata->max_uV))
>> +                             dev_info(plcd->us,
>> +                                     "regulator voltage set failed\n");
> Are there case to change the voltage? Doesn't it easy to set the
> voltage at board file? I mean don't need to setup at drivers?

The constraint 'apply_uV' cannot be expressed with a device tree. So
there has be a mechanism to set the required output voltage for a
regulator.

In case of platform-lcd driver, the power source should be turned off
to the lcd/interfaces until the display controller driver is enabled.
Powering on the lcd/interfaces at boot time by default would not be
ideal.

Thanks for your review and comments.

Regards,
Thomas.

>
> Thank you,
> Kyungmin Park

[...]
