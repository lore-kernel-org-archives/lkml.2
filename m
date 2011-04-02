Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1DBD1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 23:27:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55686 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1DBD1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 23:27:42 -0400
Date: Sat, 2 Apr 2011 04:27:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110402032733.GC13341@sirena.org.uk>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104011554.07924.arnd@arndb.de> <1301671655.28467.52.camel@e102144-lin.cambridge.arm.com> <201104011755.57412.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104011755.57412.arnd@arndb.de>
X-Cookie: On the eighth day, God created FORTRAN.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 05:55:57PM +0200, Arnd Bergmann wrote:
> On Friday 01 April 2011, Will Deacon wrote:

> > I don't understand how you can handle `early quirks' without board
> > files. Does this follow on from Linus' suggestion about moving code out
> > of the kernel and into the bootloader?

> There are multiple ways of dealing with this. One way would be to
> mandate that the boot loader does the quirks, ideally as little
> as possible.

Though we then get into the issues with bootloader quality and risk 

> Another option is to have a boot wrapper with board specific code,
> which gets run between the regular boot loader and the common
> kernel entry point. We might need such a wrapper anyway to pass the
> device tree to the kernel.

This sounds an awful lot like a board file which doesn't get to use any
of the in-kernel infrastructure like bus controller drivers or chip
drivers to help which feels retrograde.  I understand where you're
coming from on this but an absolute ban feels overly restrictive here,
it seems like we'd be better off allowing board files but pushing back
strongly on anything that should be data...

> > Realistically, I don't think you will ever get away from board files.
> > The trick is probably to make them as small as possible and common to as
> > many boards as possible (like the platforms directory for PowerPC).

> Perhaps. But we can start out with strict rules and add exceptions
> later when we run out of options.

...which is pretty much what you're saying here.
