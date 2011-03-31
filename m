Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab1CaSXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:23:25 -0400
Received: from relais.videotron.ca ([24.201.245.36]:56586 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab1CaSXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:23:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 31 Mar 2011 14:23:13 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <alpine.LFD.2.00.1103311826070.22418@localhost6.localdomain6>
Message-id: <alpine.LFD.2.00.1103311400190.28032@xanadu.home>
References: <201103301906.42429.arnd@arndb.de>
 <alpine.LFD.2.00.1103311359320.22418@localhost6.localdomain6>
 <87d3l7jqpr.fsf@ti.com> <201103311723.02301.arnd@arndb.de>
 <alpine.LFD.2.00.1103311826070.22418@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Thomas Gleixner wrote:

> Start off with such a trivial, but immense effective cleanup and see
> what it helps to share code even accross SoC vendors. They all glue
> together random IP blocks from the market and there are not soo many
> sources which are relevant. This makes sense in all aspects:
> 
>       1) less and better code
>       2) faster setup for new SoCs
>       3) shared benefit for all vendors

If this was always true.  Someone commented on the fact that the IP 
block providing USB on OMAP is shared with a couple other platforms.  
But about 2600 lines of pure glue is still necessary around the common 
driver to make it work for everyone.  I'm not saying that separate 
drivers are called for here, simply that hardware people _will_ screw it 
up, especially when they are hooking it up to a non-standard 
SOC-specific bus.

Another example: there used to be many different IP blocks providing 
MMC/SD/SDIO support that people were adding to their SOCs.  Each SOC 
would have its own reinvention of the wheel but they were all different 
but simple wheels, and drivers for them were obvious and straight 
forward.  Then came the SDHCI "standard".  At first few implementation 
existed so the sdhci driver was, too, rather straight forward.  But 
hardware manufacturers thought (rightfully) that this would be a good 
idea to use that standard instead of using their custom simple wheel.  
And so they did, releasing new SOC revision with the old wheel replaced 
by a square implementation of the sdhci one.  Today the sdhci driver is 
literally bastardized by all the quirks needed to work around all the 
different and creative bugs or even standard misinterpretation of the 
standard out there in the field.  And in many cases the sdhci version is 
even _less_ functional than the custom and already supported 
implementation it replaced.

And what would the hardware guys tell you?  That software is cheap.


Nicolas
