Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2JIMAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:00:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56130 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2JIMAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:00:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAEk6gTDOCEk84yuhNudxVjABFSs4f1-Dhvc0JmZCv++SgM694Q@mail.gmail.com>
References: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com>
	<CACRpkdY+niVs58Ay3gVNYeQPx8T7RppBJft0Bwii_RwrT2zfdw@mail.gmail.com>
	<CAEk6gTDOCEk84yuhNudxVjABFSs4f1-Dhvc0JmZCv++SgM694Q@mail.gmail.com>
Date: Tue, 9 Oct 2012 14:00:34 +0200
Message-ID: <CACRpkdb+txD9hfhs7pfnzmDuU59VXEdzJc86z=tdy2yqYBCqOg@mail.gmail.com>
Subject: Re: [PATCH][GPIO] Add IRQ edge setter to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Drasko DRASKOVIC <drasko.draskovic@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 3:16 PM, Drasko DRASKOVIC
<drasko.draskovic@gmail.com> wrote:
> [Me]
>> If I understand correctly the below more or less exports
>> struct irq_chip to userspace,
>> trying to hide it by instead exposing a property of the
>> containing struct gpio_chip and it worries me.
>
> No, it should not.

You are exporting all of the defines from irq.h,
IRQ_TYPE_NONE, IRQ_TYPE_EDGE_FALLING, etc
to userspace. These are defined in <linux/irq.h> and that file
has this comment on top:

/*
 * Please do not include this file in generic code.  There is currently
 * no requirement for any architecture to implement anything held
 * within this file.
 *
 * Thanks. --rmk
 */

And that comment is even only about generic *KERNEL* code,
userspace is way, way more than that.

> It operates only on already exported gpiochip
> (similar to gpio_export_link()).
> It just helps exported GPIO be configured in "interrupt" and not in
> "normal" mode.

So can you explain exactly why userspace want to configure
GPIO pins in interrupt mode, when there is no way whatsoever
for userspace to handle these IRQs?

Yours,
Linus Walleij
