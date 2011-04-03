Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1DCWTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 18:19:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:50118 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab1DCWTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 18:19:15 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Detlef Vollmann <dv@vollmann.ch>
Cc: Arnd Bergmann <arnd@arndb.de>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4D95E112.4020400@vollmann.ch>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	 <8ya39m2mv65.fsf@huya.qualcomm.com> <20110401074519.GC7594@elte.hu>
	 <201104011554.07924.arnd@arndb.de>  <4D95E112.4020400@vollmann.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 08:18:17 +1000
Message-ID: <1301869097.2549.36.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 16:28 +0200, Detlef Vollmann wrote:
> >   * No board files
> Where do you put code that needs to run very early (e.g. pinging the
> watchdog)? 

Even on powerpc I keep board files :-)

The main thing is:

- The generic -> board linkage must not be hard (ie, no
platform_restart, but a board_ops.restart() etc....)

- An average board file is a few hundreds line long, that's it, mostly
it hooks up to generically provided functions, tho it gets the choice of
_which_ ones to hookup.

- It can still quirk/fixup a thing or two if needed, I thinkt it's
useful to keep that around, as long as such "quirks" remain small and
few. At the end of the day, if dealing with one board special case gives
you the choice between changing a ton of infrastructure/core to
introduce a new abstraction to deal with -that- special case vs. having
a one liner fixup in the platform code, the later is the most sensible
option. The hard part of course is to have sensible maintainers to make
sure this doesn't grow back to the old mess.

Cheers,
Ben.


