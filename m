Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2GXPWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:22:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62436 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2GXPWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:22:17 -0400
Message-ID: <500EBDA4.6020104@gmail.com>
Date: Tue, 24 Jul 2012 17:22:12 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] gpiolib: fix chip->base handling in of_gpio_simple_xlate()
References: <1342977052-7880-1-git-send-email-zonque@gmail.com> <201207241256.56535.arnd@arndb.de> <500E9D75.60002@gmail.com> <201207241408.44168.arnd@arndb.de>
In-Reply-To: <201207241408.44168.arnd@arndb.de>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.07.2012 16:08, Arnd Bergmann wrote:
> On Tuesday 24 July 2012, Daniel Mack wrote:

>>>>> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
>>>>> index d18068a..51bc232 100644
>>>>> --- a/drivers/gpio/gpiolib-of.c
>>>>> +++ b/drivers/gpio/gpiolib-of.c
>>>>> @@ -147,13 +147,13 @@ int of_gpio_simple_xlate(struct gpio_chip *gc,
>>>>>     if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
>>>>>             return -EINVAL;
>>>>>  
>>>>> -   if (gpiospec->args[0] >= gc->ngpio)
>>>>> +   if (gpiospec->args[0] >= gc->ngpio + gc->base)
>>>>>             return -EINVAL;
>>>>>  
>>>>>     if (flags)
>>>>>             *flags = gpiospec->args[1];
>>>>>  
>>>>> -   return gpiospec->args[0];
>>>>> +   return gpiospec->args[0] - gc->base;
>>>>>  }
>>>>>  EXPORT_SYMBOL(of_gpio_simple_xlate);
>>>
>>> Where would that gc->base come from?
>>
>> It is set up when the chips are initialized. Let's put it that way: why
>> would we have this ->base if it is practically unusable in devicetree
>> environments?
> 
> The base gets used to put the gpiochip into the Linux gpio number space,
> which is not necessarily the same as the number space used in the device
> tree. You can dynamically add other gpio controllers that would get
> some arbitrary base assigned at runtime, so you cannot subtract that
> base from the hardware number to get a local one in the common code.
> 
> I fear you will have to provide your own xlate function for pxa if
> you want to use this numbering. Something like this:?

I did my own xlate function in the first place, but then I thought it
could be made working in a more general way. But your explanation makes
sense, so I will add something that is based on your sniplet.

Thanks,
Daniel
