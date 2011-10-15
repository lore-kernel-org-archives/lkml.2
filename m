Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab1JOUl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 16:41:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38933 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1JOUl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 16:41:58 -0400
Date: Sat, 15 Oct 2011 21:41:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] mach-ep93xx: break out GPIO driver specifics
Message-ID: <20111015204129.GZ21648@n2100.arm.linux.org.uk>
References: <1316508132-20020-1-git-send-email-linus.walleij@stericsson.com> <20111015181808.GA3128@mwesterb-mobl.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111015181808.GA3128@mwesterb-mobl.ger.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 09:18:08PM +0300, Mika Westerberg wrote:
> I just tried to compile latest linux-next and due to missing <mach/gpio.h> I
> get:
> 
> In file included from include/linux/gpio.h:18:0,
>                  from drivers/gpio/gpiolib.c:10:
> /home/westeri/devel/kernel/linux/arch/arm/include/asm/gpio.h:5:23: fatal error: mach/gpio.h: No such file or directory
> compilation terminated.
> make[2]: *** [drivers/gpio/gpiolib.o] Error 1
> 
> It looks like arch/arm/include/asm/gpio.h wants to have <mach/gpio.h>. Any idea
> how to fix this?

Hmm.  It shouldn't have been deleted - Linus' patch leaves the file
empty rather than deleting it.

However, as I had to use GNU patch to apply Linus' patch (as git apply
wouldn't because of fuzz), it doesn't understand that, so it removed it.
This is where having an /* empty */ comment avoids that kind of thing,
just like I've done for all the other mach/gpio.h which became empty.
