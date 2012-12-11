Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2LKAeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 19:34:09 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54191 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2LKAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:34:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121210230749.7820F3E081F@localhost>
References: <1354888899-21907-1-git-send-email-mathias.nyman@linux.intel.com>
	<1354888899-21907-2-git-send-email-mathias.nyman@linux.intel.com>
	<20121210230749.7820F3E081F@localhost>
Date: Tue, 11 Dec 2012 01:34:04 +0100
Message-ID: <CACRpkdaaFZ2Ai1tWy5KYxF9dVWmc8s4Lj8DajACAFYHdBFxBtg@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: add Lynxpoint chipset gpio driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        mika.westerberg@linux.intel.com, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 12:07 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Fri,  7 Dec 2012 16:01:39 +0200, Mathias Nyman <mathias.nyman@linux.intel.com> wrote:
>> Add gpio support for Intel Lynxpoint chipset.
>> Lynxpoint supports 94 gpio pins which can generate interrupts.
>> Driver will fail requests for pins that are marked as owned by ACPI, or
>> set in an alternate mode (non-gpio).
>>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>> +static void lp_gpio_set(struct gpio_chip *chip, unsigned gpio, int value)
>> +{
>> +     struct lp_gpio *lg = container_of(chip, struct lp_gpio, chip);
>> +     unsigned long reg = gpio_reg(chip, gpio, LP_CONFIG1);
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&lg->lock, flags);
>> +
>> +     if (value)
>> +             outl(inl(reg) | OUT_LVL_BIT, reg);
>> +     else
>> +             outl(inl(reg) & ~OUT_LVL_BIT, reg);
>> +
>> +     spin_unlock_irqrestore(&lg->lock, flags);
>> +}
>
> A *lot* of drivers implement their own GPIO ops like this, and they all
> end up looking the same. Please take a look at
> drivers/gpio/gpio-generic.c and see if you can use the stock operations
> provided there.

I was under the impression that the generic code could not be
used off-the-shelf for drivers doing irqchips (like this one).

But maybe I'm mistaken or it's trivial to fix?

Yours,
Linus Walleij
