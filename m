Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2HFGj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 02:39:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49700 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2HFGjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 02:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120806051144.GA12642@avionic-0098.mockup.avionic-design.de>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de>
	<CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
	<20120730074714.GC15245@avionic-0098.mockup.avionic-design.de>
	<CACRpkdbrdWw_HR91r72aB_S2+vxiaSBKHwW+Tsmi8pKk9VsgFg@mail.gmail.com>
	<20120806051144.GA12642@avionic-0098.mockup.avionic-design.de>
Date: Mon, 6 Aug 2012 08:39:24 +0200
Message-ID: <CACRpkdZDQLRDzxmkcrMQX+ZGwSgMwtBsD4sPr_S2jOyft1L37Q@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 7:11 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Sun, Aug 05, 2012 at 12:50:54PM +0200, Linus Walleij wrote:

>> We're working on a goal of a "single zImage" (one unified ARM
>> kernel) which means your platform must be able to handle the
>> case where this is turned on anyway, so I would suggest you
>> drop the optional compile-time IRQ support, just make it
>> optional at runtime instead.
>
> I don't quite understand. Do you want me to add a module parameter to
> make it optional at runtime? Since the driver is now OF only I suppose I
> could make it optional on the interrupt-controller property as well.

No, no module parameter. Just don't register the IRQ domain if there
are not IRQ resources in the device tree, if the interrupt-controller
property is not present I guess?

>> OK but atleast find a way to move this to the probe() function,
>> what happens if the debugfs file is browsed and you run out
>> of memory? Not nice, and you were using this to debug as
>> well...
>
> Alright, I can do that. Alternatively I could probably drop the
> allocations altogether and use local variables within the second loop to
> store the variables:
>
>         for (i = 0; i < num_regs; i++) {
>                 u8 ddr, plr, ier, isr, ptr;
>
>                 err = adnp_read(gpio, GPIO_DDR(gpio) + i, &ddr);
>                 if (err < 0)
>                         goto out;
>
>                 ...
>         }
>
> With the proper locking this shouldn't be a problem. The reason why I
> used the block-wise approach in the first place was that the register
> accesses were more "atomic". Of course without locking this is non-
> sense.

Either approach works, the above seems more elegant though!

Yours,
Linus Walleij
