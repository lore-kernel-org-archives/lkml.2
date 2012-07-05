Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2GEVdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:33:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50913 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2GEVdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Jul 2012 15:33:16 -0600
Message-ID: <CAErSpo7ynY7vmG1SJFZ9KZxt5cGpWchzAMEhHE7+TCTEHPGCtA@mail.gmail.com>
Subject: Re: [PATCH 00/16] PCI: Re-factor 'pcibios_setup()'
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, linux@arm.linux.org.uk, starvik@axis.com,
        jesper.nilsson@axis.com, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chris@zankel.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 9:30 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> Currently, all of the architectures implement their own 'pcibios_setup()'
> routine.  Most of the implementations do nothing so this patch introduces
> a generic (__weak) routine into PCI's core that can be used by all
> architectures as a default.  If necessary, it can then be over-ridden by
> architecture-specific code.
>
> This series also cleans up 'pcibios_setup()' as necessary to consistently
> use the "__init" section annotation.
>
> Suggested by Bjorn Helgaas -
> http://marc.info/?l=linux-kernel&m=134023745124680&w=2
>
>
> It looks as if there is a bug in the CRIS architecture's version of
> 'pcibios_setup()'.  It implements pcibios_setup() such that pci_setup()
> doesn't look for any generic options.  I included the fix for this in this
> series.  If this ends up not being correct - i.e. PCI support for CRIS
> should be dropped - then that specific patch (which I included last in the
> series) can be dropped.
>
> Note: I do not have a cross-compile environment so I have only tested x86.
> ---
>
> Myron Stowe (16):
>       cris/PCI: Factor 'pcibios_setup()' out of cris
>       xtensa/PCI: Factor 'pcibios_setup()' out of xtensa
>       x86/PCI: adjust section annotations for 'pcibios_setup()'
>       unicore32/PCI: adjust section annotations for 'pcibios_setup()'
>       tile/PCI: Factor 'pcibios_setup()' out of tile
>       sparc/PCI: Factor 'pcibios_setup()' out of sparc
>       sh/PCI: adjust section annotations for 'pcibios_setup()'
>       sh/PCI: Factor 'pcibios_setup()' out of sh
>       powerpc/PCI: Factor 'pcibios_setup()' out of powerpc
>       parisc/PCI: Factor 'pcibios_setup()' out of parisc
>       MIPS/PCI: adjust section annotations for 'pcibios_setup()'
>       MIPS/PCI: Factor 'pcibios_setup()' out of MIPS/pmc-sierra
>       microblaze/PCI: Factor 'pcibios_setup()' out of microblaze
>       ia64/PCI: Factor 'pcibios_setup' out of ia64
>       alpha/PCI: Factor 'pcibios_setup()' out of alpha
>       PCI: Pull 'pcibios_setup' up into PCI's core
>
>
>  arch/alpha/kernel/pci.c               |    6 ------
>  arch/cris/arch-v32/drivers/pci/bios.c |    5 -----
>  arch/ia64/pci/pci.c                   |    9 ---------
>  arch/microblaze/pci/pci-common.c      |    5 -----
>  arch/mips/pci/pci.c                   |    4 ++--
>  arch/mips/pmc-sierra/yosemite/ht.c    |   11 -----------
>  arch/mips/txx9/generic/pci.c          |    4 ++--
>  arch/parisc/kernel/pci.c              |    5 -----
>  arch/powerpc/kernel/pci-common.c      |    5 -----
>  arch/sh/drivers/pci/fixups-sdk7786.c  |    4 ++--
>  arch/sh/drivers/pci/pci.c             |    5 -----
>  arch/sparc/kernel/leon_pci.c          |    8 --------
>  arch/sparc/kernel/pci.c               |    5 -----
>  arch/sparc/kernel/pcic.c              |    8 --------
>  arch/tile/kernel/pci.c                |   10 ----------
>  arch/unicore32/kernel/pci.c           |    2 +-
>  arch/x86/pci/common.c                 |    2 +-
>  arch/xtensa/kernel/pci.c              |    6 ------
>  drivers/pci/pci.c                     |   12 ++++++++++++
>  include/linux/pci.h                   |    1 +
>  20 files changed, 21 insertions(+), 96 deletions(-)

I pushed these to my -next branch, for inclusion in 3.6.  Thanks for
the cleanups!

Bjorn
