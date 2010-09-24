Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0IXOot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 10:44:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50278 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab0IXOos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 10:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MZKXqwZ5TF3B98wfRvJ9pyhHRVb/CcnjD5s8ILxdSi8Yrpe0Q4GxJmw2/MPs92wWRm
         XdwkfTNffcJHD/SDyPHza3WNjCTVTHR1FtmCzdIo2ZUqhezCpSjuvaoo7jlAc1bMAHjm
         bu6AOMKyqM4OuC+SGTPtG5Xmqhy1QlUseoMis=
MIME-Version: 1.0
In-Reply-To: <20100924141046.GA26454@sirena.org.uk>
References: <AANLkTin9Qji_bdyd3yqrP_-ti5xRT9jJ4je2fPM=uHFX@mail.gmail.com>
	<20100924141046.GA26454@sirena.org.uk>
Date: Fri, 24 Sep 2010 16:44:46 +0200
Message-ID: <AANLkTinfUWiWza8vyqfn0nCA7P24nBJSKY6Zr=aFgVQu@mail.gmail.com>
Subject: Re: [PATCH 1/6] This patch adds support for the ST-Ericsson CG2900
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for your comments.

2010/9/24 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Sep 24, 2010 at 03:46:44PM +0200, Par-Gunnar Hjalmdahl wrote:
>
>> +#ifndef PIN_INPUT_PULLUP
>> +#define PIN_INPUT_PULLUP             (PIN_DIR_INPUT | PIN_PULL_UP)
>> +#endif
>> +
>> +#ifndef GPIO_LOW
>> +#define GPIO_LOW                     0
>> +#endif
>> +
>> +#ifndef GPIO_HIGH
>> +#define GPIO_HIGH                    1
>> +#endif
>> +
>> +#ifndef GPIO_TO_IRQ
>> +#define GPIO_TO_IRQ                  NOMADIK_GPIO_TO_IRQ
>> +#endif
>
> None of this looks like things that should be added in driver code -
> there should be standard ways of doing this stuff that you should use
> and if there aren't and they are useful they should be added in generic
> code so that other code can use them.

You are absolutely correct in this. As I wrote in the "cover letter"
[PATCH 0/6] we are already planning changes to this driver where we
instead register as platform driver and will use normal Kernel
methodology to implement this. As you can see in the patch these
comments are regarding a file located in arch/arm/mach-ux500 and the
driver therefore has a dependency to the Board configuration which
isn't particularly nice. This will be corrected. These type of defines
should of course not be located in a C-file either.

>
>> +/** BT_ENABLE_GPIO - GPIO to enable/disable the BT module.
>> + */
>> +#define BT_ENABLE_GPIO                       170
>
> This sort of thing should be passed in from the board configuration
> normallly.

See answer above.

>
>> +void cg2900_devices_enable_chip(void)
>> +{
>> +     gpio_set_value(GBF_ENA_RESET_GPIO, GPIO_HIGH);
>> +}
>> +EXPORT_SYMBOL(cg2900_devices_enable_chip);
>
> This looks like something that the driver should be organising rather
> than something that should be exported for some random code to pick up?
> In general most of the code in here looks like it should have more
> device model usage and make more use of standard kernel infrastructure.

See answer above. Will be a callback function in a driver data struct.

>
>> +static irqreturn_t cg2900_devices_interrupt(int irq, void *dev_id)
>> +{
>> +     disable_irq_nosync(irq);
>> +     if (cg2900_dev_callback && cg2900_dev_callback->interrupt_cb)
>> +             cg2900_dev_callback->interrupt_cb();
>> +
>> +     return IRQ_HANDLED;
>> +}
>
> Why is there this callback mechanism - I'd expect the users of this code
> to just be using the standard IRQ infrastructure?
>

I will have to get back to you regarding this. I did not implement
that specific part and the guy who did is back on Monday.


/P-G
