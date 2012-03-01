Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2CASvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:51:23 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59868 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2CASvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:51:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myron.stowe@gmail.com designates 10.52.173.79 as permitted sender) smtp.mail=myron.stowe@gmail.com; dkim=pass header.i=myron.stowe@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
Date: Thu, 1 Mar 2012 11:51:19 -0700
Message-ID: <CAL-B5D0Phxhx-2ipYwoKfZCTvCfuh6bX-iqQkQS0cLmRqQHGbg@mail.gmail.com>
Subject: Re: [PATCH 00/39] PCI: pci_host_bridge related cleanup and busn_alloc
From: Myron Stowe <myron.stowe@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 4:06 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> The first 14 patches are hostbridge clean up.
> will add struct device dev into host_bridge struct.
> also will add release support to make sure allocated resource get
> freed during root bus removal including hostbridge and pci_sysdata.
>
> others 25 patches are busn_alloc related.
> Set up iobusn_resource tree, and register bus number range to it.
> Later when need to find bus range, will try to allocate from the tree
> Need to test on arches other than x86. esp for ia64 and powerpc that support
>  more than on peer root buses.

Why did you collapse these two series into one at this point?

Last I was keeping up with - there was a -v9 00/23 series related to
bus_num and a -v2 00/11 series for pci_host_bridge related cleanup.

As a distro maintainer I need to try and keep up with what is occurring
here and actions like this - coalescing multiple series - unnecessarily
complicates things.  It also masks the fact that the bus_num series is
now on -v10 within a very short time frame (which implies a lot).

Myron
>
> The patches need to apply to pci/for-linus and pci/linux-next
> because one patch that is needed only is only in pci/for-linus
>
> could get from
>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-next
>
> please put them into pci/linux-next branch for more testing.
>
> Thanks
>
> Yinghai
>
> Yinghai Lu (39):
>  PCI: Separate host_bridge code out from probe.c
>  x86, PCI: have own version for pcibios_bus_to_resource
>  x86, PCI: Fix memleak with get_current_resources
>  PCI: rename pci_host_bridge() to find_pci_root_bridge()
>  PCI: add generic device into pci_host_bridge struct
>  PCI: add host bridge release support
>  x86, PCI: break down get_current_resource()
>  x86, PCI: add host bridge resource release for using _CRS
>  x86, PCI: embed name acpi version pci_root_info struct
>  x86, PCI: embed pci_sysdata into pci_root_info on acpi path
>  x86, PCI: Allocating pci_root_info for not using _CRS path
>  x86, PCI: Merge root info printing for nocrs path
>  x86, PCI: add print all root info for nocrs path
>  x86, PCI: allocate temp range array in amd_bus pci_root_info probing
>  x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node
>  PCI: skip busn resource at first.
>  x86, PCI: put busn resource in pci_root_info for acpi path
>  PCI: default busn_resource
>  x86, PCI: put busn resource in pci_root_info for no_crs path
>  PCI: Add busn_res into struct pci_bus.
>  PCI: Add busn_res operation functions
>  PCI: release busn when removing bus
>  PCI: insert busn_res in pci_create_root_bus
>  PCI: checking busn_res in pci_scan_root_bus
>  PCI: add default res for pci_scan_bus
>  PCI, ia64: Register busn_res for root buses
>  PCI, sparc: Register busn_res for root buses
>  PCI, powerpc: Register busn_res for root buses
>  PCI, parisc: Register busn_res for root buses
>  PCI: Add pci_bus_extend/shrink_top()
>  PCI: Probe safe range that we can use for unassigned bridge.
>  PCI: Strict checking of valid range for bridge
>  PCI: Allocate bus range instead of use max blindly
>  PCI: kill pci_fixup_parent_subordinate_busnr()
>  PCI: Seperate child bus scanning to two passes overall
>  pcmcia: remove workaround for fixing pci parent bus subordinate
>  PCI: Double checking setting for bus register and bus struct.
>  PCI, pciehp: Remove not needed bus number range checking
>  x86, PCI: kill busn in acpi pci_root_info
>
>  arch/ia64/pci/pci.c                   |    2 +
>  arch/powerpc/include/asm/pci-bridge.h |    1 +
>  arch/powerpc/kernel/pci-common.c      |   10 +-
>  arch/sparc/kernel/pci.c               |    4 +
>  arch/sparc/kernel/pci_impl.h          |    1 +
>  arch/x86/pci/acpi.c                   |  121 ++++---
>  arch/x86/pci/amd_bus.c                |   88 ++----
>  arch/x86/pci/broadcom_bus.c           |   17 +-
>  arch/x86/pci/bus_numa.c               |  100 +++++--
>  arch/x86/pci/bus_numa.h               |   23 +-
>  arch/x86/pci/common.c                 |   27 +--
>  arch/x86/pci/i386.c                   |   14 +
>  drivers/parisc/dino.c                 |    5 +
>  drivers/parisc/lba_pci.c              |    3 +
>  drivers/pci/Makefile                  |    2 +-
>  drivers/pci/host-bridge.c             |   97 ++++++
>  drivers/pci/hotplug/pciehp_pci.c      |   12 +-
>  drivers/pci/probe.c                   |  601 ++++++++++++++++++++++-----------
>  drivers/pci/remove.c                  |    1 +
>  drivers/pcmcia/yenta_socket.c         |   75 ----
>  include/linux/pci.h                   |   15 +-
>  21 files changed, 767 insertions(+), 452 deletions(-)
>  create mode 100644 drivers/pci/host-bridge.c
>
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
