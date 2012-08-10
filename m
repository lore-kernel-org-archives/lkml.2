Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2HJJQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:16:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59468 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2HJJQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:16:08 -0400
Date: Fri, 10 Aug 2012 10:15:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
Message-ID: <20120810091555.GX18957@n2100.arm.linux.org.uk>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de> <CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com> <20120809202054.GA24503@avionic-0098.mockup.avionic-design.de> <CACRpkdaSk9xBaiSAKCj4Pa2kyyfP178XN53i2Q2+CBFx=RoE0g@mail.gmail.com> <20120810083508.GA16251@avionic-0098.mockup.avionic-design.de> <CACRpkdaGWhTR3Zr40dtigQqPPkxQZ=zYqYVBfpwbnkf3P2Qhhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaGWhTR3Zr40dtigQqPPkxQZ=zYqYVBfpwbnkf3P2Qhhg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 10:41:58AM +0200, Linus Walleij wrote:
> On Fri, Aug 10, 2012 at 10:35 AM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> >> Consult the following article on LWN:
> >> http://lwn.net/Articles/470820/
> >>
> >> Then grep your gitlog and you'll see we got rid of it from ARM.
> >
> > Then why is there still the following in arch/arm/include/asm/irq.h?
> >
> >         /*
> >          * Use this value to indicate lack of interrupt
> >          * capability
> >          */
> >         #ifndef NO_IRQ
> >         #define NO_IRQ  ((unsigned int)(-1))
> >         #endif
> 
> That's a question for Russell but I think it's basically there for
> old platforms, on a "don't use it"-basis. (Maybe a comment could
> be good.)

Just don't use it.  It's there for old stuff which still needs fixing.

New code should not use it, and should test for one of:

	irq <= 0
	irq == 0

And new code should set irq = 0 to indicate a lack of interrupt.
