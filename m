Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1DBC73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 22:59:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33584 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab1DBC7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 22:59:25 -0400
Date: Sat, 2 Apr 2011 03:59:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Detlef Vollmann <dv@vollmann.ch>,
        Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110402025901.GB13341@sirena.org.uk>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104011659.40443.arnd@arndb.de> <4D95EF8E.9080902@vollmann.ch> <201104011750.17344.arnd@arndb.de> <alpine.LFD.2.00.1104011441150.28032@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104011441150.28032@xanadu.home>
X-Cookie: On the eighth day, God created FORTRAN.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 03:54:47PM -0400, Nicolas Pitre wrote:

> 1) GPIO drivers

>    As Linus observed, in the majority of the cases GPIOs are accessed 
>    through simple memory-mapped registers.  Some have absolute state 
>    registers, the others have separate clear/set registers.  Suffice to 
>    create two generic GPIO drivers each covering those two common cases, 
>    and those generic drivers would simply register with the higher level 
>    gpiolib code, and all the board code would have to do is to provide 
>    the data for those GPIOs (register offsets, number of GPIOs, etc.).  
>    Whether this data eventually comes from DT is an orthogonal issue.

For this case we actually already have the basic_mmio_gpio driver in
tree, we should be pushing for wider usage of that.
