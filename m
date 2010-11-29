Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0K2OW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:22:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56991 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0K2OW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:22:27 -0500
Date: Mon, 29 Nov 2010 14:22:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
Message-ID: <20101129142200.GA14941@n2100.arm.linux.org.uk>
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <alpine.LNX.2.00.1011271306420.7659@localhost.localdomain> <AANLkTinbAVFE+HZrx+9KUwx8=MKFHPqrhpOpAWAEQFv-@mail.gmail.com> <201011271639.21694.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201011271639.21694.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 04:39:21PM +0100, Arnd Bergmann wrote:
> On Saturday 27 November 2010 14:01:20 Michał Mirosław wrote:
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index db524e7..74ea522 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1164,7 +1164,7 @@ config ISA_DMA_API
> >         bool
> > 
> >  config PCI
> > -       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB ||
> > ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX
> > +       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB ||
> > ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX ||
> > ARCH_GEMINI
> >         help
> >           Find out whether you have a PCI motherboard. PCI is the name of a
> >           bus system, i.e. the way the CPU talks to the other stuff inside
> > 
> 
> This approach really does not scale as we add more boards to the list.
> 
> Better make a new CONFIG_HAVE_PCI option that you can select from the
> individual boards, and make that the only dependency that CONFIG_PCI has.

Be careful.  There are two things going on here:

1. those which PCI support is configurable
2. those which always have PCI support

Making PCI "depend on HAVE_PCI" is wrong, and will throw up lots of
Kconfig warnings, as those platforms which always have PCI support
won't select HAVE_PCI - and making them do so such that "PCI support"
gets offered to them - with the only possible value being 'Y' is
silly.

So, rather than HAVE_PCI, it should be MIGHT_HAVE_PCI, and that
symbol needs to control whether the "PCI support" prompt is offered
to the user, not whether PCI is available or not.
