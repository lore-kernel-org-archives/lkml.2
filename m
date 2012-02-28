Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab2B1CLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:11:21 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:48872 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2B1CLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:11:17 -0500
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
Subject: [PATCH -v8 0/18] PCI: allocate pci bus num range for unassigned bridge busn
Date: Mon, 27 Feb 2012 18:09:51 -0800
Message-Id: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020206.4F4C37BC.00EF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

be1ba9d: PCI, pciehp: Remove not needed bus number range checking
131d47a: PCI: Double checking setting for bus register and bus struct.
5932e47: pcmcia: remove workaround for fixing pci parent bus subordinate
ea33b11: PCI: Seperate child bus scanning to two passes overall
00ca2e7: PCI: kill pci_fixup_parent_subordinate_busnr()
596d4a6: PCI: Allocate bus range instead of use max blindly
64bfcda: PCI: Strict checking of valid range for bridge
d4ed872: PCI: Probe safe range that we can use for unassigned bridge.
31e4760: PCI: Add pci_bus_extend/shrink_top()
74b8f25: PCI, parisc: Register busn_res for root buses
de71ada: PCI, powerpc: Register busn_res for root buses
e810285: PCI, sparc: Register busn_res for root buses
8912504: PCI, ia64: Register busn_res for root buses
82de8a8: PCI, x86: Register busn_res for root buses
2e8d3bf: PCI: Add busn_res tracking in core
a9a5832: PCI: Add busn_res operation functions
6122ad8: PCI: Add busn_res into struct pci_bus.
b362780: x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node

Set up iobusn_resource tree, and register bus number range to it.
Later when need to find bus range, will try to allocate from the tree

Need to test on arches other than x86. esp for ia64 and powerpc that support
  more than on peer root buses.

could be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

need to apply to top of pci/for-linus plus pci/linux-next plus
	[PATCH -v2] PCI: pci_host_bridge related cleanup

-v2: according to Jesse, split to more small patches.
-v3: address some request from Bjorn. like make use %pR for busn_res debug print
	out, and move the comment change with code change.
-v4: fixes the problem about rescan that Bjorn found.
-v5: add /proc/iobusn that is requested by Bjorn.
     remove old workaround from pciehp.
     add rescan_bridge for pci bridge in /sys
-v6: remove global iobusn_resource, and every root bus's busn_res will be root
     of children buses' busn_res.
     pc cardbus change is tested by pcmcia maintainter.
-v7: remove pci_scan_root_bus_max requested by Bjorn and Jesse.
-v8: rebase on top other patches with arch/x86/pci/bus_numa.c changes
     also only include busn_res related changes.

Thanks

Yinghai

 arch/ia64/pci/pci.c              |    2 +
 arch/powerpc/kernel/pci-common.c |    7 +-
 arch/sparc/kernel/pci.c          |    1 +
 arch/x86/include/asm/topology.h  |    3 +-
 arch/x86/pci/acpi.c              |    8 +-
 arch/x86/pci/bus_numa.c          |    9 +-
 arch/x86/pci/common.c            |   37 +---
 drivers/parisc/dino.c            |    2 +
 drivers/parisc/lba_pci.c         |    3 +
 drivers/pci/hotplug/pciehp_pci.c |   12 +-
 drivers/pci/probe.c              |  430 +++++++++++++++++++++++++++++++-------
 drivers/pci/remove.c             |    1 +
 drivers/pcmcia/yenta_socket.c    |   75 -------
 include/linux/pci.h              |    4 +
 14 files changed, 396 insertions(+), 198 deletions(-)

