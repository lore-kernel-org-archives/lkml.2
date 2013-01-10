Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3AJKwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:52:46 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:40498 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3AJKwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:52:45 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYHFp=nd+7Kq3t7q_SZnybKN+enX=v++iDhq21_x7SEow@mail.gmail.com>
References: <CAMuHMdWqb_OxBV=8K_NAN_rgC6Tq9URbwmHTu2LgojWjYxEJUA@mail.gmail.com>
	<CACRpkdYHFp=nd+7Kq3t7q_SZnybKN+enX=v++iDhq21_x7SEow@mail.gmail.com>
Date: Thu, 10 Jan 2013 11:52:44 +0100
X-Google-Sender-Auth: nI6HeoBOk_QqbvLtuirckxl3vJ0
Message-ID: <CAMuHMdV9tZZ94QuCcyYCwgZZN9du48vq-h7++1aVjPKZ79d-Qg@mail.gmail.com>
Subject: Re: redefinition of devm_gpio_request
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 10:46 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Sun, Dec 16, 2012 at 2:11 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On current linus/HEAD, m68k allmodconfig gives:
>> drivers/gpio/devres.c:52: error: redefinition of ‘devm_gpio_request’
>> include/linux/gpio.h:99: error: previous definition of
>> ‘devm_gpio_request’ was here
>> drivers/gpio/devres.c:82: error: redefinition of ‘devm_gpio_request_one’
>> include/linux/gpio.h:111: error: previous definition of
>> ‘devm_gpio_request_one’ was here
>> drivers/gpio/devres.c:114: error: redefinition of ‘devm_gpio_free’
>> include/linux/gpio.h:129: error: previous definition of
>> ‘devm_gpio_free’ was here
>> make[5]: *** [drivers/gpio/devres.o] Error 1
>>
>> The !CONFIG_GENERIC_GPIO dummy definitions in include/linux/gpio.h conflict
>> with the real ones in drivers/gpio/devres.c.
>> Should devres.c really be compiled if !CONFIG_GENERIC_GPIO?
>
> I've looked at it but I just can't figure this one out :-(
>
> obj-$(CONFIG_GPIOLIB)           += gpiolib.o devres.o
>
> GPIOLIB selects GENERIC_GPIO.
>
> So this *should* not be compiled unless GENERIC_GPIO is also
> selected.

I guess it was caused by ssb/bcma selecting GPIOLIB, which got fixed in the
mean time.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
