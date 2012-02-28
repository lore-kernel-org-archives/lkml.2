Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab2B1KDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:03:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47345 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab2B1KDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:03:42 -0500
MIME-Version: 1.0
In-Reply-To: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
References: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
Date: Tue, 28 Feb 2012 02:03:41 -0800
X-Google-Sender-Auth: eVeHCvCO7wZH2LVB-tRkAMQ9iWk
Message-ID: <CAE9FiQW12-X8Tn-2L2ko=2An3O3V9pQVFaGdmsfS6UGERGRdrQ@mail.gmail.com>
Subject: [PATCH -v8 0/23] PCI: allocate pci bus num range for unassigned
 bridge busn
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 6:09 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> Set up iobusn_resource tree, and register bus number range to it.
> Later when need to find bus range, will try to allocate from the tree
>
> Need to test on arches other than x86. esp for ia64 and powerpc that support
>  more than on peer root buses.

 could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-busn-alloc

update to v9, and will pass bus resource through resources list.

will not send to the LKML, please check for-pci-busn-alloc branch.

or you can browse them from
http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=shortlog;h=refs/heads/for-pci-busn-alloc

4d92227: PCI, pciehp: Remove not needed bus number range checking
edccefd: PCI: Double checking setting for bus register and bus struct.
d1d6372: pcmcia: remove workaround for fixing pci parent bus subordinate
5bb9418: PCI: Seperate child bus scanning to two passes overall
d0fd5ac: PCI: kill pci_fixup_parent_subordinate_busnr()
b86867f: PCI: Allocate bus range instead of use max blindly
8d0fbe4: PCI: Strict checking of valid range for bridge
8c26011: PCI: Probe safe range that we can use for unassigned bridge.
a7b217b: PCI: Add pci_bus_extend/shrink_top()
d8f54cd: PCI, parisc: Register busn_res for root buses
e02e198: PCI, powerpc: Register busn_res for root buses
d10c14b: PCI, sparc: Register busn_res for root buses
4977b59: PCI, ia64: Register busn_res for root buses
d169b44: x86, PCI: put busn resource in pci_root_info for no_crs path
c77a824: x86, PCI: put busn resource in pci_root_info for acpi path
1909435: PCI: add default res for pci_scan_bus
948a438: PCI: default busn_resource
5e2711b: PCI: checking busn_res in pci_scan_root_bus
c10e4a1: PCI: insert busn_res in pci_create_root_bus
fc176a9: PCI: release busn when removing bus
0eae1b6: PCI: Add busn_res operation functions
1e6215a: PCI: Add busn_res into struct pci_bus.
1f1fd3e: x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node


>
> need to apply to top of pci/for-linus plus pci/linux-next plus
>        [PATCH -v2] PCI: pci_host_bridge related cleanup
>
> -v2: according to Jesse, split to more small patches.
> -v3: address some request from Bjorn. like make use %pR for busn_res debug print
>        out, and move the comment change with code change.
> -v4: fixes the problem about rescan that Bjorn found.
> -v5: add /proc/iobusn that is requested by Bjorn.
>     remove old workaround from pciehp.
>     add rescan_bridge for pci bridge in /sys
> -v6: remove global iobusn_resource, and every root bus's busn_res will be root
>     of children buses' busn_res.
>     pc cardbus change is tested by pcmcia maintainter.
> -v7: remove pci_scan_root_bus_max requested by Bjorn and Jesse.
> -v8: rebase on top other patches with arch/x86/pci/bus_numa.c changes
>     also only include busn_res related changes.

 arch/ia64/include/asm/pci.h           |    1 +
 arch/ia64/pci/pci.c                   |    5 +
 arch/powerpc/include/asm/pci-bridge.h |    1 +
 arch/powerpc/kernel/pci-common.c      |   10 +-
 arch/sparc/kernel/pci.c               |    4 +
 arch/sparc/kernel/pci_impl.h          |    1 +
 arch/x86/pci/acpi.c                   |   12 +-
 arch/x86/pci/broadcom_bus.c           |    4 +-
 arch/x86/pci/bus_numa.c               |   19 +-
 arch/x86/pci/bus_numa.h               |    3 +-
 arch/x86/pci/common.c                 |   27 +--
 drivers/parisc/dino.c                 |    5 +
 drivers/parisc/lba_pci.c              |    3 +
 drivers/pci/hotplug/pciehp_pci.c      |   12 +-
 drivers/pci/probe.c                   |  458 +++++++++++++++++++++++++++------
 drivers/pci/remove.c                  |    1 +
 drivers/pcmcia/yenta_socket.c         |   75 ------
 include/linux/pci.h                   |    6 +
 18 files changed, 441 insertions(+), 206 deletions(-)
