Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2KZJeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:34:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44397 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab2KZJeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:34:01 -0500
Message-ID: <50B33783.80704@ti.com>
Date: Mon, 26 Nov 2012 10:33:55 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 3/3] pwm: New driver to support PWM driven LEDs on
 TWL4030/6030 series of PMICs
References: <1353405382-9226-1-git-send-email-peter.ujfalusi@ti.com> <1353405382-9226-4-git-send-email-peter.ujfalusi@ti.com> <20121123150412.GB16810@avionic-0098.adnet.avionic-design.de> <50B3288B.5020500@ti.com> <20121126091756.GA8602@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121126091756.GA8602@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 10:17 AM, Thierry Reding wrote:
>>> Doesn't this belong in the drivers/leds subsystem? Besides that, the
>>> same comments as for the previous patch apply. One additional note
>>> below.
>>
>> The PINs itself are called as LED but they are PWMs at the end. If we
>> represent them as PWMs they can be used for different purposes which is going
>> to be needed for example in BeagleBoard, where the LEDA (PWMA) is used as a
>> GPO to enable/disable the USB host power.
> 
> Heh, that's an interesting use-case for a PWM. =)

You should have seen the expression on my face when I saw this on the
schematics ;)

>> Also the removed 'twl6030-pwm' driver was only controlled the LED part of twl6030.
>> With this series I enable the use of the PWMs and the PWMs behind of the LED
>> functions to give us flexibility on how we are using them.
> 
> Alright, we can keep it in the PWM subsystem then.

Thank you.

>>>> +static struct platform_driver twl_pwmled_driver = {
>>>> +	.driver = {
>>>> +		.name = "twl-pwmled",
>>>> +		.of_match_table = of_match_ptr(twl_pwmled_of_match),
>>>> +	},
>>>> +	.probe = twl_pwmled_probe,
>>>> +	.remove = __devexit_p(twl_pwmled_remove),
>>>
>>> You didn't annotate twl_pwmled_remove() with __devexit, so __devexit_p
>>> isn't needed here either.
>>
>> Oh yes, I have also received patches from a series which removes the
>> _devexit_p() from the kernel.
>> But should the __devexit need to be added to the remove function?
> 
> __devexit_p without a corresponding __devexit doesn't make sense. But as
> all of __devinit, __devexit and __devexit_p will be removed sooner or
> later, new code just shouldn't bother adding it. In this case, just drop
> __devexit_p.

I'll get rid of them.

Thank you,
Péter
