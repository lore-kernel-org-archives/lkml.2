Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1ARQUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:20:37 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:57138 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1ARQUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:20:36 -0500
Date: Tue, 18 Jan 2011 17:20:34 +0100
From: Lennert Buijtenhek <buytenh@wantstofly.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Sven Neumann <s.neumann@raumfeld.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH] pxa3xx: fix PXA GPIO IRQ handling
Message-ID: <20110118162034.GM29224@mail.wantstofly.org>
References: <1295338561.2003.3.camel@sven> <1295338738-4129-1-git-send-email-s.neumann@raumfeld.com> <4D357DC0.2030006@metafoo.de> <AANLkTi=gGDZHukdSuupg22Gb9te+Vk_rsu6-vREeQRVE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=gGDZHukdSuupg22Gb9te+Vk_rsu6-vREeQRVE@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 08:15:22AM -0800, Eric Miao wrote:

> >> Set the "set_wake" field of the irq_chip struct before calling
> >> set_irq_chip() for all of the IRQs, so that the compat handler
> >> actually gets installed.
> 
> Not really sure if this is necessary. Lennert has done the transition to
> irq_data to those _set_wake() functions as well, so it should be OK
> that compat handler doesn't get installed.

Yeah, this has been dealt with upstream, and this patch won't apply.


> >> diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
> >> index 1beb40f..a5b42a7 100644
> >> --- a/arch/arm/mach-pxa/irq.c
> >> +++ b/arch/arm/mach-pxa/irq.c
> >> @@ -111,13 +111,13 @@ static void __init pxa_init_low_gpio_irq(set_wake_t fn)
> >>       GRER0 &= ~0x3;
> >>       GEDR0 = 0x3;
> >>
> >> +     pxa_low_gpio_chip.set_wake = fn;
> >> +
> >>       for (irq = IRQ_GPIO0; irq <= IRQ_GPIO1; irq++) {
> >>               set_irq_chip(irq, &pxa_low_gpio_chip);
> >>               set_irq_handler(irq, handle_edge_irq);
> >>               set_irq_flags(irq, IRQF_VALID);
> >>       }
> >> -
> >> -     pxa_low_gpio_chip.set_wake = fn;

Upstream has:

        pxa_low_gpio_chip.irq_set_wake = fn;
