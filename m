Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1AGUel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:34:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:56192 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1AGUej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:34:39 -0500
Subject: Re: [GIT] Networking
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <benh@debian.org>, David Miller <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikwrHoOY4wvUp1qn-OT=EjZesSNR29US1ERc0o2@mail.gmail.com>
References: <20110106.122003.233698077.davem@davemloft.net>
	 <AANLkTi=7=_FyVsjA3vKEpg8RwfC=m-8QGfqa6ctxQday@mail.gmail.com>
	 <20110107190656.GQ3702@decadent.org.uk>
	 <AANLkTikwrHoOY4wvUp1qn-OT=EjZesSNR29US1ERc0o2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 20:34:28 +0000
Message-ID: <1294432468.2520.24.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 11:49 -0800, Linus Torvalds wrote:
> [ Apart from the annoyance of also having to manually copying the
> firmware files: why the heck doesn't that firmware tree even have a
> "make firmware-install" makefile or something? The kernel has a "make
> firmware-install" thing, why doesn't the firmware tree itself have
> that?

Yeah, the main reason I haven't yet submitted a patch to remove the
legacy firmware/ directory from the kernel source, as discussed at the
Kernel Summit, is because I need to implement some makefiles for the
firmware tree first.

I'll do a 'make install' for the firmware tree which installs it all,
and lets you specify min/max kernel versions so you can omit stuff that
*really* isn't relevant.

I also want to preserve the CONFIG_FIRMWARE_IN_KERNEL option, but that
can't easily be based on the hardcoded knowledge of the config options;
it wants to be based on the MODULE_FIRMWARE tags of the built-in
drivers. And once we're enumerating those, it should be relatively
simple to warn about missing firmwares in the non-FIRMWARE_IN_KERNEL
case too.

I didn't find the time to do that for the 2.6.38 merge window, but I
should get it done for 2.6.39.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

