Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab2JKQ0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:26:47 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52899 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab2JKQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:26:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAEk6gTD-ko5MXteB3DOTUkF1bJSj9Yga3wh0JTKD=D+YWjy6jQ@mail.gmail.com>
References: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com>
	<CACRpkdY+niVs58Ay3gVNYeQPx8T7RppBJft0Bwii_RwrT2zfdw@mail.gmail.com>
	<CAEk6gTDOCEk84yuhNudxVjABFSs4f1-Dhvc0JmZCv++SgM694Q@mail.gmail.com>
	<CACRpkdb+txD9hfhs7pfnzmDuU59VXEdzJc86z=tdy2yqYBCqOg@mail.gmail.com>
	<CAEk6gTD-ko5MXteB3DOTUkF1bJSj9Yga3wh0JTKD=D+YWjy6jQ@mail.gmail.com>
Date: Thu, 11 Oct 2012 18:26:44 +0200
Message-ID: <CACRpkdZG6Oz1XTCGim2offVpRxw-X17omAVe7zqR5m9TwwPobw@mail.gmail.com>
Subject: Re: [PATCH][GPIO] Add IRQ edge setter to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 4:22 PM, Drasko DRASKOVIC
<drasko.draskovic@gmail.com> wrote:
> [Me]
>> So can you explain exactly why userspace want to configure
>> GPIO pins in interrupt mode, when there is no way whatsoever
>> for userspace to handle these IRQs?
>
> Maybe I understand something wrong, but explicit configuration of GPIO
> interrupt trigger type visible in sysfs is possible __only__ from the
> userspace today, and that is exactly limitation I am addressing.

So this is the real problem is it not?

So if we consider this:

static irqreturn_t my_callback(int irq, void *dev_id)
{
        return IRQ_HANDLED;
}

int my_gpio, my_irq, ret;

my_gpio = 17; /* For some reason I like this pin */
ret = gpio_request(my_gpio);
ret = gpio_direction_input(my_gpio);
my_irq = gpio_to_irq(my_gpio);
ret = request_any_context_irq(my_irq,
    my_callback,
    IRQF_TRIGGER_FALLING,
    "my gpio thing");

(some error handling removed, based on drivers/mmc/host/mmci.c)

What is wrong with this picture? Do you mean that the problem is
that the trigger type I just set up for the IRQ connected to the pin
is not reflected in GPIO sysfs?

Yours,
Linus Walleij
