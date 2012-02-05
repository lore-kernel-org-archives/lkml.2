Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2BEG6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 01:58:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61351 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2BEG6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:58:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v5 0/24] PCI: allocate pci bus num range for unassigned bridge busn + pci rescan cleanup
Date: Sat,  4 Feb 2012 22:57:44 -0800
Message-Id: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F2E2897.0065,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cdef5a1: PCI: clean up rescan_bus_bridge_resize
7b6deb4: PCI: make pci_rescan_bus_bridge_resize use pci_scan_bridge instead
876bd4a: PCI: Add pci_bus_add_single_device()
6e5f346: PCI, sysfs: create rescan_bridge under /sys/.../pci/devices/... for pci bridges
3c92113: PCI, sys: Use device_type and attr_groups with pci dev
e6d3c54: PCI, pciehp: Remove not needed bus number range checking
2306e31: PCI: Double checking setting for bus register and bus struct.
daddc90: pcmcia: remove workaround for fixing pci parent bus subordinate
6a88939: PCI: Seperate child bus scanning to two passes overall
60c7d94: PCI: kill pci_fixup_parent_subordinate_busnr()
e9e72be: PCI: Allocate bus range instead of use max blindly
f22af7f: PCI: Strict checking of valid range for bridge
8656ea6: PCI: Probe safe range that we can use for unassigned bridge.
4023fc3: PCI: Add pci_bus_extend/shrink_top()
a066c95: PCI, parisc: Register busn_res for root buses
d069fbb: PCI, powerpc: Register busn_res for root buses
f00e514: PCI, ia64: Register busn_res for root buses
1a203f1: PCI, x86: Register busn_res for root buses
8b1b01b: PCI: Add busn_res tracking in core
a9ccca7: PCI: add /proc/iobusn
ec1cdb3: PCI: Add busn_res operation functions
2a09fbd: Make %pR could handle bus resource with domain
9c83a59: PCI: add busn inline helper
b18cd6a: PCI: Add iobusn_resource

Set up iobusn_resource tree, and register bus number range to it.
Later when need to find bus range, will try to allocate from the tree

Need to test on arches other than x86. esp for ia64 and powerpc that support
  more than on peer root buses.

last five patches are rescan cleanup that make use busn alloc.

could be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

-v2: according to Jesse, split to more small patches.
-v3: address some request from Bjorn. like make use %pR for busn_res debug print
	out, and move the comment change with code change.
-v4: fixes the problem about rescan that Bjorn found.
-v5: add /proc/iobusn that is requested by Bjorn.
     remove old workaround from pciehp.
     add rescan_bridge for pci bridge in /sys

Thanks

Yinghai

 Documentation/ABI/testing/sysfs-bus-pci |   10 +
 arch/ia64/pci/pci.c                     |    2 +
 arch/powerpc/kernel/pci-common.c        |    7 +-
 arch/x86/include/asm/topology.h         |    3 +-
 arch/x86/pci/acpi.c                     |    8 +-
 arch/x86/pci/bus_numa.c                 |    8 +-
 arch/x86/pci/common.c                   |   11 +-
 drivers/parisc/dino.c                   |    2 +
 drivers/parisc/lba_pci.c                |    3 +
 drivers/pci/bus.c                       |   40 +++
 drivers/pci/hotplug/pciehp_pci.c        |   12 +-
 drivers/pci/pci-sysfs.c                 |   59 ++++-
 drivers/pci/pci.h                       |    1 +
 drivers/pci/probe.c                     |  460 +++++++++++++++++++++++++------
 drivers/pci/remove.c                    |    1 +
 drivers/pcmcia/yenta_socket.c           |   75 -----
 include/linux/ioport.h                  |   18 ++
 include/linux/pci.h                     |    9 +
 kernel/resource.c                       |   50 ++++
 lib/vsprintf.c                          |   29 ++-
 20 files changed, 617 insertions(+), 191 deletions(-)

