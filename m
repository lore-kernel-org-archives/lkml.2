Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1GGIAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:00:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51910 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1GGIAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:00:19 -0400
Date: Thu, 7 Jul 2011 08:59:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Alexey Charkov <alchark@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v8] ARM: Add basic architecture support for
	VIA/WonderMedia 85xx SoC's
Message-ID: <20110707075954.GF8286@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <20110706123417.GA25400@n2100.arm.linux.org.uk> <CABjd4Yxc_jRi563CHg+G7ekTHT40sTxgRUoL68bSke7oh8JVpg@mail.gmail.com> <201107070954.00419.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107070954.00419.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 09:54:00AM +0200, Arnd Bergmann wrote:
> On Thursday 07 July 2011 09:13:26 Alexey Charkov wrote:
> > >> diff --git a/arch/arm/mach-vt8500/include/mach/io.h b/arch/arm/mach-vt8500/include/mach/io.h
> > >> new file mode 100644
> > >> index 0000000..8dd55c8
> > >> --- /dev/null
> > >> +++ b/arch/arm/mach-vt8500/include/mach/io.h
> > >> +#ifndef __ASM_ARM_ARCH_IO_H
> > >> +#define __ASM_ARM_ARCH_IO_H
> > >> +
> > >> +#define IO_SPACE_LIMIT 0xffff
> > >> +
> > >> +#define __io(a)              ((void __iomem *)((a) + 0xf0000000))
> > >> +#define __mem_pci(a) (a)
> > >
> > > Can you explain why you seem to have PCI IO space, yet don't have CONFIG_PCI
> > > selected?  Do you have any drivers which use this space without CONFIG_PCI=y?
> > 
> > We have not yet created support for the PCI bridge (or even verified
> > its existence on the chip). These numbers are derived bit by bit from
> > vendor-published kernel sources and rather intended as a reference in
> > case somebody wishes to try and implement PCI support.
> > 
> > All the peripherals on these chips that I know of are statically
> > mapped platform devices programmed via MMIO registers. There may be
> > some boards which have support for external PCI devices, but I haven't
> > seen them.
> 
> Actually, we did discuss this when I first reviewed your patches. FWIW,
> WM8505, WM8510 and VT8500 don't seem to have PCI, but VT8430 has PCI,
> according to the data sheet and the patch provided by VIA.
> 
> What made this a little hard to understand is the way that VIA provided
> an emulated PCI bus even on those platforms that didn't have the hardware,
> apparently because it didn't occur to them to add platform device
> support to the network driver (via velocity, iirc). They just faked a
> configuration space for the USB and network devices to make them work
> with the regular PCI drivers.

Ok, so it can use the default value I've created for IO_SPACE_LIMIT
based on whether CONFIG_PCI is enabled or not.

Thanks.
