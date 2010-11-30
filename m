Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0K3QGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:06:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59905 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab0K3QGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:06:33 -0500
Date: Tue, 30 Nov 2010 16:05:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
Message-ID: <20101130160527.GB2377@n2100.arm.linux.org.uk>
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <20101129142200.GA14941@n2100.arm.linux.org.uk> <alpine.LNX.2.00.1011291546550.12293@localhost.localdomain> <201011291657.53316.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011291657.53316.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 04:57:53PM +0100, Arnd Bergmann wrote:
> On Monday 29 November 2010, Hans Ulli Kroll wrote:
> > @@ -1164,7 +1169,7 @@ config ISA_DMA_API
> >         bool
> >  
> >  config PCI
> > -       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || 
> > ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX
> > +       bool "PCI support" if MIGHT_HAVE_PCI
> >         help
> >           Find out whether you have a PCI motherboard. PCI is the name of 
> > a
> >           bus system, i.e. the way the CPU talks to the other stuff inside
> 
> This does not solve the problem that Russell mentioned: existing platforms
> select PCI unconditionally, e.g. Iop13XX, some IXP, Orion, Shark
> and more. At the very least, these would need to also select MIGHT_HAVE_PCI
> to avoid the warning.

No, the above is correct.  What I was talking about was the difference
between these:

config PCI
	bool "PCI support" if MIGHT_HAVE_PCI

and

config PCI
	bool "PCI support"
	depends on MIGHT_HAVE_PCI

In the first instance, PCI itself does not depend on MIGHT_HAVE_PCI.
MIGHT_HAVE_PCI controls whether the user is offered the "PCI support"
option.

In the second instance, PCI depends on MIGHT_HAVE_PCI, which must be
set to 'y' to offer the option _and_ also if PCI is selected.

We want the first behaviour.  Platforms which must have PCI support can
continue to select PCI as they currently do, and leave the MIGHT_HAVE_PCI
option alone.

Platforms which may optionally have PCI support should select
MIGHT_HAVE_PCI instead.
