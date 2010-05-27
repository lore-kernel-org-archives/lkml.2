Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab0E0Ns0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:48:26 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35294 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0E0NsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:48:24 -0400
Date: Thu, 27 May 2010 22:48:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Message-ID: <20100527134810.GA6407@linux-sh.org>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005252345.15685.arnd@arndb.de> <4BFDC3D1.40708@tilera.com> <201005271041.30519.arnd@arndb.de> <4BFE73DF.5090107@tilera.com> <AANLkTinTjpx6GTRidb6mzJ7At2tDlm6VeKW5dBGZZQcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinTjpx6GTRidb6mzJ7At2tDlm6VeKW5dBGZZQcc@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 03:41:44PM +0200, Geert Uytterhoeven wrote:
> On Thu, May 27, 2010 at 15:30, Chris Metcalf <cmetcalf@tilera.com> wrote:
> > On 5/27/2010 4:41 AM, Arnd Bergmann wrote:
> >> On Thursday 27 May 2010, Chris Metcalf wrote:
> >>>> +EXPORT_SYMBOL(inb);
> >>>>
> >>>> If you just remove these definitions, you get a link error for any
> >>>> driver that tries to use these, which is probably more helpful than
> >>>> the panic.
> >>>>
> >>>> OTOH, are you sure that you can't just map the PIO calls to mmio functions
> >>>> like readb plus some fixed offset? On most non-x86 architectures, the PIO
> >>>> area of the PCI bus is just mapped to a memory range somewhere.
> >>>>
> >>>>
> >>> I'll try to remove them and see if anything falls over. ??We don't have
> >>> any memory-mapped addresses in the 32-bit architecture, though that
> >>> changes with the 64-bit architecture, which introduces IO mappings. ??For
> >>> PCI we actually have to do a hypervisor transaction for reads or writes.
> >>>
> >> Ok, then I assume that PIO would also be a hypervisor call, right?
> >> If you don't have MMIO on 32 bit, you might want to not define either
> >> PIO (inb, ...) no MMIO (readb, ...) calls there and disable
> >> CONFIG_HAVE_MMIO in Kconfig.
> >>
> >
> > We don't define CONFIG_HAVE_MMIO, but drivers certainly seem to use
> > ioread/iowrite methods as well as inb/outb without guarding them with
> > any particular tests, so we have to provide definitions of some kind for
> > all of them. ??I'll confer with our PCI developer to see if we can clean
> > up the set of definitions in io.h.
> 
> It's CONFIG_NO_IOMEM (cfr. s390 and um), which is inverted and turned into
> CONFIG_HAS_IOMEM, to be checked by drivers.
> 
Likewise for CONFIG_NO_IOPORT for disabling PIO, although you'll probably
want to conditionalize this on PCI I/O.
