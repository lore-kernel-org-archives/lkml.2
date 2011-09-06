Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1IFJPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 05:15:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39238 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1IFJPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 05:15:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110906084938.GI6619@n2100.arm.linux.org.uk>
References: <1315297950-12720-1-git-send-email-linus.walleij@stericsson.com>
	<20110906084938.GI6619@n2100.arm.linux.org.uk>
Date: Tue, 6 Sep 2011 11:15:42 +0200
Message-ID: <CACRpkda0-SU5rUYkg7MyNSDpYZPmKYuosfJDh=yHA+Skac1Upg@mail.gmail.com>
Subject: Re: [PATCH] gpio: rewrite U300 GPIO to use gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 10:49 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

>> +#include <linux/io.h>
>> +#include <mach/hardware.h>
>> +#include <asm/irq.h>
>> +#include <asm-generic/gpio.h>
>>
>> +/* Map these overrides to gpiolib functions, simply */
>> +#define gpio_get_value  __gpio_get_value
>> +#define gpio_set_value  __gpio_set_value
>> +#define gpio_cansleep   __gpio_cansleep
>> +#define gpio_to_irq     __gpio_to_irq
>>
>> +#endif
>
> This is how mach/gpio.h ends up looking - two things:
>
> 1. is there any reason for asm/irq.h and linux/io.h in there?

No.

> 2. asm/gpio.h already includes asm-generic/gpio.h and defines
>   the dispatchers for the trivial case.

Yep.

> So, I think this is how it should look:
>
> #ifndef __MACH_U300_GPIO_H
> #define __MACH_U300_GPIO_H
> #include <mach/hardware.h>
> #endif
>
> Or even just:
>
> /* empty */

It works fine when left empty, so respinning it like
that.

> if mach/hardware.h include is not required for ARCH_NR_GPIOS.

It'll survive with just the default number of GPIOs.

Thanks,
Linus Walleij
