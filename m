Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1DAVB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:01:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51752 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab1DAVB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:01:28 -0400
Date: Fri, 1 Apr 2011 23:00:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>, Detlef Vollmann <dv@vollmann.ch>,
        Bill Gatliff <bgat@billgatliff.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110401210036.GB30938@pengutronix.de>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <201104011659.40443.arnd@arndb.de>
 <4D95EF8E.9080902@vollmann.ch>
 <201104011750.17344.arnd@arndb.de>
 <alpine.LFD.2.00.1104011441150.28032@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1104011441150.28032@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 01, 2011 at 03:54:47PM -0400, Nicolas Pitre wrote:
> It would be more useful and scalable to simply sit down, look at the 
> current mess, and identify common patterns that can be easily factored 
> out into some shared library code, and all that would be left in the 
> board or SOC specific files eventually is the data to register with that 
> library code.  Nothing so complicated as grand plans or planification 
> that makes it look like a mountain.
> 
> Two patterns were identified so far, and they are:
> 
> 1) GPIO drivers
> 
>    As Linus observed, in the majority of the cases GPIOs are accessed 
>    through simple memory-mapped registers.  Some have absolute state 
>    registers, the others have separate clear/set registers.  Suffice to 
>    create two generic GPIO drivers each covering those two common cases, 
>    and those generic drivers would simply register with the higher level 
>    gpiolib code, and all the board code would have to do is to provide 
>    the data for those GPIOs (register offsets, number of GPIOs, etc.).  
>    Whether this data eventually comes from DT is an orthogonal issue.
> 
> 2) IRQ chip drivers
> 
>    Again, as Thomas observed, the same issue exists with the majority of 
>    the IRQ chip drivers.  Most of them follow a common simple pattern 
>    that can be abstracted in some generic library code due to their very 
>    similar mode of operation.  Writing a common driver would leave the 
>    board specific code with only a data table describing hardware 
>    registers.
> 
> A good example of such rationalization that already happened is the 
> leds-gpio driver (./drivers/leds/leds-gpio.c), or similarly the 
> gpio-keys driver (drivers/input/keyboard/gpio_keys.c).  I remember when 
> those board files were implementing their own simple drivers hooking 
> directly to the input API or the LED API.
> 
> After that let's take another identified common pattern and factorize it 
> out from board code.  That might be timers (see RMK's recent 
> sched_clock() rationalization).  That might be clocks (patches from 
> Jeremy Kerr exist and need merged). Etc.
Another one is pwm (git ls-files arch/arm | grep pwm). A general
pwm framework was already discussed on lkml and linux-embedded
(http://thread.gmane.org/gmane.linux.ports.mips.general/29037/focus=44475);
I don't know the details though.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
