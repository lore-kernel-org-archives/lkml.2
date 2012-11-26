Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2KZKaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:30:46 -0500
Received: from smtp-out-226.synserver.de ([212.40.185.226]:1417 "EHLO
	smtp-out-226.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2KZKap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:30:45 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15713
Message-ID: <50B344D6.8030608@metafoo.de>
Date: Mon, 26 Nov 2012 11:30:46 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com> <20121123075537.A14713E0A91@localhost> <50AF3E21.4000009@ti.com> <50AF4584.7020604@ti.com>
In-Reply-To: <50AF4584.7020604@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 10:44 AM, Peter Ujfalusi wrote:
> Hi Grant,
> 
> On 11/23/2012 10:13 AM, Peter Ujfalusi wrote:
>> Hi Grant,
>>
>> On 11/23/2012 08:55 AM, Grant Likely wrote:
>>> Ugh. and this is why I wanted the PWM and GPIO subsystems to use the
>>> same namespace and binding. <grumble, mutter> But that's not your fault.
>>>
>>> It's pretty horrible to have a separate translator node to convert a PWM
>>> into a GPIO (with output only of course). The gpio properties should
>>> appear directly in the PWM node itself and the translation code should
>>> be in either the pwm or the gpio core. I don't think it should look like
>>> a separate device.
>>
>> Let me see if I understand your suggestion correctly. In the DT you suggest
>> something like this:
>>
>> twl_pwmled: pwmled {
>> 	compatible = "ti,twl4030-pwmled";
>> 	#pwm-cells = <2>;
>> 	#gpio-cells = <2>;
>> 	gpio-controller;
>> };
> 
> After I thought about this.. Is this what we really want?
> After all what we have here is a PWM generator used to emulate a GPIO signal.
> The PWM itself can be used for driving a LED (standard LED or backlight and we
> have DT bindings for these already), vibra motor, or other things.
> If we combine the PWM with GPIO we should go and 'bloat' the DT node to also
> include all sort of other uses of PWM at once?
> 
> IMHO it is better to keep them as separate things.
> pwm node to describe the PWM generator,
> separate nodes to describe it's uses like led, backlight, motor and gpio.
> 

The difference here is that the LED, backlight, etc are all different
physical devices begin driven by the pwm pin, so it makes sense to have a
device tree node for them, while using the pwm as gpio is just a different
function of the same physical pin.  So in a sense the pwm controller also
becomes a gpio controller. I like the idea of the pwm core automatically
instantiating a pwm-gpo device if it sees a gpio-controller property in the
pwm device devicetree node.

- Lars
