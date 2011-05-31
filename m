Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1EaL2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 07:28:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:44299 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1EaL2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 07:28:51 -0400
Message-ID: <4DE4D0EE.20907@linutronix.de>
Date: Tue, 31 May 2011 13:28:46 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH 07/11] x86, olpc-xo1-sci: Add GPE handler and ebook switch
 functionality
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>	<1304166750-31125-8-git-send-email-dsd@laptop.org>	<20110516090813.GA26487@linutronix.de> <BANLkTimpFYMpQFY9J7pa0NygGoQ8dLdArA@mail.gmail.com>
In-Reply-To: <BANLkTimpFYMpQFY9J7pa0NygGoQ8dLdArA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> I looked into irq_chip alongside the CS5535 docs. Initially this
> looked like a good suggestion - any CS5535 GPIO can be mapped to one
> of 8 PIC-level interrupts, which seems like a good match for irq_chip.
> 
> However, this isn't what we're doing here.
> 
> CS5535 GPIOs can either be mapped to interrupts, *or* to a Power
> Management Event (PME). A PME is a CS5535-specific concept; its an
> event that will bring the system out of suspend if it is sleeping. In
> this case, we are mapping a GPIO to a PME. I'm not aware of any
> appropriate Linux abstraction for this. Thats all done in
> cs5535_gpio_setup_event().

Is this something like pin multiplexing? So it is either a GPIO pin with 
interrupt ability _or_ that PME thingy.
If so, would it make sense to hide it behind enable_irq_wake()? That call
could fail if you have already gpio_request() users for instance.

> The CS5535 also has a highly programmable PIC, with loads of possible
> input and mapping options. The call to cs5535_gpio_set_irq() then
> programs the PIC to map PME input to an IRQ line. This function is
> both misnamed and misplaced; it is unrelated to GPIOs and is simply
> one of the many generic knobs on the PIC. If there was one, this
> function should belong in a cs5535-pic driver, named something
> according to "IRQ Mapper Unrestricted Z Select High".

And once that is done, you can not use as a GPIO anymore, right?

> Thanks,
> Daniel

Sebastian
