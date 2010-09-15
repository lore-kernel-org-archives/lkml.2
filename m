Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0IORlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:41:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65369 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0IORlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:41:19 -0400
Date: Wed, 15 Sep 2010 10:41:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: ab8500: update kconfig for ab8500 core driver
Message-Id: <20100915104105.e77dfe8c.randy.dunlap@oracle.com>
In-Reply-To: <F45880696056844FA6A73F415B568C69532D96AA36@EXDCVYMBSTM006.EQ1STM.local>
References: <1284549823-6246-1-git-send-email-arun.murthy@stericsson.com>
	<20100915082014.99d702e4.randy.dunlap@oracle.com>
	<F45880696056844FA6A73F415B568C69532D96AA36@EXDCVYMBSTM006.EQ1STM.local>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 19:12:33 +0200 Arun MURTHY wrote:

[resending, first time bounced for some reason]

> Hi Randy,
> 
> > On Wed, 15 Sep 2010 16:53:43 +0530 Arun Murthy wrote:
> > 
> > > This patch add a dependancy for ab8500-core driver so as to depend on
> > > u8500 platform.
> > >
> > > This patch also fixes the build issues(powerpc_allyesconfig) for the
> > > patch 03f582a93ecca6e9584b622570022abf08ed03ec (misc: Add ab8500 pwm
> > > driver)
> > 
> > Please list build errors/warnings that are fixed in your patch
> > description.
> > 
> Please find the build error log below (http://www.spinics.net/lists/kernel/msg1083549.html)
> 
> drivers/mfd/built-in.o: In function `__crc_pwm_free':
> (*ABS*+0x24ba6d1e): multiple definition of `__crc_pwm_free'
> drivers/mfd/built-in.o: In function `.pwm_free':
> (.text+0x1ab3c): multiple definition of `.pwm_free'
> drivers/misc/built-in.o:(.text+0x2620c): first defined here
> drivers/mfd/built-in.o: In function `__crc_pwm_request':
> (*ABS*+0xc1f4ec93): multiple definition of `__crc_pwm_request'
> drivers/mfd/built-in.o: In function `__crc_pwm_enable':
> (*ABS*+0x9d09808d): multiple definition of `__crc_pwm_enable'
> drivers/mfd/built-in.o: In function `.pwm_enable':
> (.text+0x1abc8): multiple definition of `.pwm_enable'
> drivers/misc/built-in.o:(.text+0x26278): first defined here
> drivers/mfd/built-in.o: In function `.pwm_request':
> (.text+0x1a774): multiple definition of `.pwm_request'
> drivers/misc/built-in.o:(.text+0x2604c): first defined here
> drivers/mfd/built-in.o: In function `pwm_config':
> (.opd+0x1ce0): multiple definition of `pwm_config'
> drivers/misc/built-in.o:(.opd+0x3000): first defined here
> drivers/mfd/built-in.o: In function `pwm_free':
> (.opd+0x1d28): multiple definition of `pwm_free'
> drivers/misc/built-in.o:(.opd+0x2fd0): first defined here
> drivers/mfd/built-in.o: In function `pwm_request':
> (.opd+0x1cf8): multiple definition of `pwm_request'
> drivers/misc/built-in.o:(.opd+0x2f58): first defined here
> drivers/mfd/built-in.o: In function `__crc_pwm_disable':
> (*ABS*+0xb0493b18): multiple definition of `__crc_pwm_disable'
> drivers/mfd/built-in.o: In function `.pwm_disable':
> (.text+0x1aa24): multiple definition of `.pwm_disable'
> drivers/misc/built-in.o:(.text+0x2613c): first defined here
> drivers/mfd/built-in.o: In function `pwm_enable':
> (.opd+0x1d40): multiple definition of `pwm_enable'
> drivers/misc/built-in.o:(.opd+0x2fe8): first defined here
> drivers/mfd/built-in.o: In function `.pwm_config':
> (.text+0x1a648): multiple definition of `.pwm_config'
> drivers/misc/built-in.o:(.text+0x26358): first defined here
> drivers/mfd/built-in.o: In function `pwm_disable':
> (.opd+0x1d10): multiple definition of `pwm_disable'
> drivers/misc/built-in.o:(.opd+0x2fb8): first defined here
> drivers/mfd/built-in.o: In function `__crc_pwm_config':
> (*ABS*+0xc23f5b9): multiple definition of `__crc_pwm_config

I don't know what the __crc_* symbols are (I can't find them anywhere).

The other functions (pwm_config, pwm_free, pwm_request, pwm_disable,
pwm_enable) exist in multiple places.  This is not good.
They are very generically named.  The instances of these that are
provided by platform code are OK (these):

./include/linux/pwm.h:19:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
./arch/arm/plat-pxa/pwm.c:64:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
./arch/arm/plat-pxa/pwm.c:101:EXPORT_SYMBOL(pwm_config);
./arch/arm/plat-samsung/pwm.c:194:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
./arch/arm/plat-samsung/pwm.c:281:EXPORT_SYMBOL(pwm_config);
./arch/arm/plat-mxc/pwm.c:55:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
./arch/arm/plat-mxc/pwm.c:114:EXPORT_SYMBOL(pwm_config);
./arch/mips/jz4740/pwm.c:94:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)

but the instances of these that are defined in
drivers/mfd/twl6030-pwm.c should not be named so generically.

Changing (Fixing) the function names in twl6030-pwm.c should fix the build problem
that you reported, I think.  And it will still allow the ab8500 driver to be
built on other platforms, which is what we prefer when that is possible.




> > This patch will certainly keep i386 builds from failing, like I saw
> > yesterday.  However, since this driver uses some spi_*() functions,
> > it should also depend on SPI_MASTER IMO.
> > See this patch:  http://lkml.org/lkml/2010/9/14/412
> > 
> I saw your patch for fixing the same @ (http://www.spinics.net/lists/kernel/msg1083970.html)
> Hence I have'nt included this.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
