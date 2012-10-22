Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab2JVWXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:23:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42499 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2JVWXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:23:50 -0400
MIME-Version: 1.0
In-Reply-To: <1350913454-26927-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1350913454-26927-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Tue, 23 Oct 2012 00:23:49 +0200
Message-ID: <CACRpkdbxfL+1NQ73ve8Hz4VKaVMzJS-P7H50kSNVODAU9mm7QA@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib: add gpio get direction support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 3:44 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Add gpio_get_direction() for checking the current direction of a gpio.
> Returns 1 for input, 0 for output, or negative error.
> Gpio drivers need to set the gpio_chip .get_direction callback for this
> functionality, otherwise gpio_get_direction() returns error.

OK...

> If the .get_direction callback is set, then gpiolib will use it
> for showing correct gpio direction in sysfs and debug. If not set
> then it will work the old way; e.g. guessing everything is input
> until direction is set.

If the driver cannot report the direction setting you *could*
cache the result of all calls to gpio_direction_output()
and gpio_direction_input() somewhere. But I don't know
if it's a good idea.

Anyway, if the callback is only called internally in the GPIOlib
why are you making the function public to the entire
kernel like this?

> include/asm-generic/gpio.h
> +extern int gpio_get_direction(unsigned gpio);

> include/linux/gpio.h
> +static inline int gpio_get_direction(unsigned gpio)
> +{
> +       return -ENOSYS;
> +}
> +

Yours,
Linus Walleij
