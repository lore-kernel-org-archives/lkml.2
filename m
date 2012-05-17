Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967794Ab2EQWUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:20:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59335 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967174Ab2EQWUQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 17 May 2012 16:19:53 -0600
Message-ID: <CAErSpo6OZYXz-M=C9r154MY7kwC7LRR3ZnQe3pnmVJY2uoWeRw@mail.gmail.com>
Subject: Re: [PATCH 00/21] PCI: use busn_res to replace bus secondary/subordinate
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 2:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> struct pci_bus will take busn_res instead. and those busn_res will be in
> domain busn_res tree.
>
> This could be base of busn_res allocation patchset.
>
> The patches need to apply to pci-next and
>        for-pci-hotplug cleanup

Sigh.  You previously said we should do this order:

        for-pci-hostbridge-cleanup
        for-pci-busn-alloc
        for-pci-res-alloc
        for-pci-root-bus-hotplug
        for-pci-for-each-res-addon

I merged for-pci-hostbridge-cleanup already.  I was about to start
merging for-pci-busn-alloc.

But now you added for-pci-hotplug-cleanup and made for-pci-busn-alloc
depend on it.  I have some comments on for-pci-hotplug-cleanup, so I'm
not ready to merge it quite yet.  Can you please just go back to the
original order and put the new hotplug cleanup stuff at the *end*?

> could be found at:
>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn_res
>
> Bjorn Helgaas (1):
>  PCI: print conflicting entry in busn_res inserting
>
> Yinghai Lu (20):
>  PCI: add busn_res into struct pci_bus.
>  PCI: replace secondary/subordinate with busn_res
>  PCI: Remove secondary/subordinate in struct ci_bus
>  PCI: Add busn_res for pci domain.
>  resource: adjust_resource handle resource without parent
>  PCI: Add busn_res operation functions
>  PCI: release busn_res when removing bus
>  PCI: Insert busn_res in pci_create_root_bus()
>  PCI: checking busn_res in pci_scan_root_bus()
>  PCI: Add default busn_resource
>  PCI: Add default busn_res for pci_scan_bus()
>  x86/PCI: add busn_res into resources list for ACPI path
>  x86/PCI: put busn resource in pci_root_info for native host bridge
>    drivers
>  ia64/PCI: register busn_res for root buses
>  sparc/PCI: register busn_res for root buses
>  powerpc/PCI: register busn_res for root buses
>  parisc/PCI: register busn_res for root buses
>  tile/PCI: Use pci_scan_root_bus instead pci_scan_bus
>  PCI: Register busn_res for iov bus
>  PCI: insert busn_res for child bus
>
>  arch/alpha/kernel/pci.c                    |    2 +-
>  arch/arm/kernel/bios32.c                   |    2 +-
>  arch/ia64/pci/pci.c                        |    4 +-
>  arch/microblaze/pci/pci-common.c           |    4 +-
>  arch/mips/pci/pci.c                        |    2 +-
>  arch/powerpc/include/asm/pci-bridge.h      |    1 +
>  arch/powerpc/kernel/pci-common.c           |   17 ++-
>  arch/powerpc/kernel/pci_64.c               |    2 +-
>  arch/powerpc/kernel/pci_of_scan.c          |    2 +-
>  arch/powerpc/platforms/powernv/pci-ioda.c  |    8 +-
>  arch/powerpc/platforms/pseries/pci_dlpar.c |    2 +-
>  arch/sh/drivers/pci/pci.c                  |    2 +-
>  arch/sparc/kernel/pci.c                    |    8 +-
>  arch/sparc/kernel/pci_impl.h               |    1 +
>  arch/tile/kernel/pci.c                     |    9 +-
>  arch/x86/pci/acpi.c                        |    9 +-
>  arch/x86/pci/amd_bus.c                     |    7 +-
>  arch/x86/pci/bus_numa.c                    |   22 +++-
>  arch/x86/pci/bus_numa.h                    |    3 +-
>  arch/xtensa/kernel/pci.c                   |    2 +-
>  drivers/iommu/intel-iommu.c                |    2 +-
>  drivers/net/ethernet/broadcom/tg3.c        |    4 +-
>  drivers/parisc/dino.c                      |   16 ++-
>  drivers/parisc/iosapic.c                   |    2 +-
>  drivers/parisc/lba_pci.c                   |   26 ++--
>  drivers/pci/hotplug-pci.c                  |    4 +-
>  drivers/pci/hotplug/acpiphp_glue.c         |    8 +-
>  drivers/pci/hotplug/shpchp_sysfs.c         |    6 +-
>  drivers/pci/iov.c                          |    4 +-
>  drivers/pci/pci.c                          |    2 +-
>  drivers/pci/probe.c                        |  191 +++++++++++++++++++++++-----
>  drivers/pci/remove.c                       |    1 +
>  drivers/pci/setup-bus.c                    |   24 ++--
>  drivers/pcmcia/cardbus.c                   |    2 +-
>  drivers/pcmcia/yenta_socket.c              |   26 ++--
>  include/linux/pci.h                        |    8 +-
>  kernel/resource.c                          |   13 +-
>  37 files changed, 313 insertions(+), 135 deletions(-)
>
> --
> 1.7.7
>
