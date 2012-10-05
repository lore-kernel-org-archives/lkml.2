Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2JEMki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:40:38 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51628 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab2JEMkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com>
References: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com>
Date: Fri, 5 Oct 2012 14:40:36 +0200
Message-ID: <CACRpkdY+niVs58Ay3gVNYeQPx8T7RppBJft0Bwii_RwrT2zfdw@mail.gmail.com>
Subject: Re: [PATCH][GPIO] Add IRQ edge setter to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Drasko DRASKOVIC <drasko.draskovic@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 2:20 PM, Drasko DRASKOVIC
<drasko.draskovic@gmail.com> wrote:

> please find a patch that adds IRQ edge set-up mechanism to sysfs that
> can be called from the kernel.
>
> This functionality can be very useful for embedded systems, as it
> permits kernel to do GPIO set-up during boot stage. Configuration
> which defines pins behavior is often kept in NVRAM, and during boot
> stage these structures can be parsed and executed by the kernel, so
> that when user processes already find all sysfs environment ready and
> correctly set-up.
>
> While at the present it is possible to export GPIO pins to sysfs (and
> correct direction / value), it is not possible to export IRQ
> configuration as well, so this must be done in user space (most often
> via command line). this patch implements missing functionality, so
> that  gpio_sysfs_set_edge() function can be called directly from the
> kernel.

Why not put the above text into the patch commit blurb?

I really won't touch this unless I get a comment from Grant
and/or Thomas Gleixner about it.

The common GPIO sysfs is hairy enough as it is, and
not universally liked.

If I understand correctly the below more or less exports
struct irq_chip to userspace,
trying to hide it by instead exposing a property of the
containing struct gpio_chip and it worries me.

One possible comment is that you shouldn't
add this to gpiolib, if you want to mess around with the
irq_chip you should create sysfs entries for the irq_chip
per se, then we can have a symbolic link from the
gpio_chip to its irq_chip in sysfs, and you can follow that
to change trigger flanks, right?

Part of me doesn't like it when userspace is messing
around with this kind of thing. Why can't this be set
up from the kernel itself by some jam table?

I can understand it if this is some lab board with GPIO
or so, if it's some embedded GPIO controller within
a laptop or something it surely should be in kernelspace.

So please detail your usecase a bit... what is the code
daemon etc in userspace poking around at these pins?
What is is doing and why?

Yours,
Linus Walleij
