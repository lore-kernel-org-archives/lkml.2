Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2DUMVH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 08:21:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51624 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2DUMVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 08:21:05 -0400
Date: Sat, 21 Apr 2012 13:20:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Alexander Shiyan <shc_work@mail.ru>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] ARM clps711x: Added Cirrus Logic EP7312 CPU
	variant
Message-ID: <20120421122044.GF24211@n2100.arm.linux.org.uk>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <201204211121.49610.arnd@arndb.de> <20120421114803.GE24211@n2100.arm.linux.org.uk> <201204211211.36273.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204211211.36273.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 12:11:35PM +0000, Arnd Bergmann wrote:
> On Saturday 21 April 2012, Russell King - ARM Linux wrote:
> > That's where we used to put truely hardware dependent stuff, rather than
> > machine type stuff when the structure was first implemented.  At that time
> > we had a number of different mach-* directories wanting to share things
> > like the acorn IOC/IOMD stuff, and there's also sharing of definitions
> > between CLPS711x and EP93xx.
> > 
> > That was long before we invented the plat-* stuff - but even that doesn't
> > actually cover what asm/hardware does - eg, the SA1111 stuff shared
> > between SA11x0 and PXA.
> 
> Ah, thanks for the explanation.
> 
> Since the clps7111 based asm/hardware/*.h files are not shared with ep93xx,
> I guess it makes sense to move them to mach-clps711x/include/mach/*.h as part of
> this cleanup series, right?

Yes.

> Out of these, only the first one is used in two places outside of
> arch/arm/mach-clps711x, the serial and the fb driver, which could
> be changed to use mach/hardware.h instead.

The headers still have to end up being in an accessible place, and having
drivers include the minimum required is a good idea.  Merely moving them
into include/mach and updating the include statements as far as I'd go.
(and I've never liked the idea of mach/hardware.h being an "include the
world for this platform" header file.)
