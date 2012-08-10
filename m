Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2HJImE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:42:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46692 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2HJIl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:41:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120810083508.GA16251@avionic-0098.mockup.avionic-design.de>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de>
	<CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
	<20120809202054.GA24503@avionic-0098.mockup.avionic-design.de>
	<CACRpkdaSk9xBaiSAKCj4Pa2kyyfP178XN53i2Q2+CBFx=RoE0g@mail.gmail.com>
	<20120810083508.GA16251@avionic-0098.mockup.avionic-design.de>
Date: Fri, 10 Aug 2012 10:41:58 +0200
Message-ID: <CACRpkdaGWhTR3Zr40dtigQqPPkxQZ=zYqYVBfpwbnkf3P2Qhhg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 10:35 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
>> Consult the following article on LWN:
>> http://lwn.net/Articles/470820/
>>
>> Then grep your gitlog and you'll see we got rid of it from ARM.
>
> Then why is there still the following in arch/arm/include/asm/irq.h?
>
>         /*
>          * Use this value to indicate lack of interrupt
>          * capability
>          */
>         #ifndef NO_IRQ
>         #define NO_IRQ  ((unsigned int)(-1))
>         #endif

That's a question for Russell but I think it's basically there for
old platforms, on a "don't use it"-basis. (Maybe a comment could
be good.)

As you see non-sparse platforms can redefine NO_IRQS in their
<mach/irqs.h> file, but in practice things like the VIC and GIC
drivers have been switched over to using irqdomain which
in turn does *not* allow IRQ 0 to be used, so most platforms
are indirectly disallowed to use IRQ 0 anyway. In fact I think
some of them are just broken now.

>> If this driver is for some other arch like openrisc I might accept
>> it but please reconsider.
>
> There's nothing in the driver that makes it ARM specific, so it could be
> used on other platforms just as well.

The linked article makes it clear that the direction for the entire
kernel is to get rid of NO_IRQ and !irq is used all over the place.

> But as I also said in my previous
> mail, in this particular case the value for the interrupt comes from the
> call to irq_of_parse_and_map(), which will return 0 on failure,
> regardless of the architecture, so there is actually no problem.

OK cool.

Yours,
Linus Walleij
