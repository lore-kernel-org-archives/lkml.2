Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab2FZSy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:54:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36468 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab2FZSyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:54:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v12 00/15] PCI: allocate pci bus num range for unassigned bridge busn
Date: Tue, 26 Jun 2012 11:53:54 -0700
Message-Id: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

busn_res already in next. and this patchset will
will try to allocate busn range from the tree

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

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
-v9: Add busn into pci_root_info, and add it to resources list and pass it
     to pci_create_root_bus.
-v11: convert busn_res probe to generic probe_resource with resource lock holding
     add more strict checking about not scaned peer bridges.
-v12: updated after busn_resource changes.

Yinghai Lu (15):
  resources: Split out __allocate_resource()
  resources: Add probe_resource()
  resources: Replace registered resource in tree.
  PCI: Add pci_bus_extend/shrink_top()
  PCI: Probe safe range that we can use for unassigned bridge.
  PCI: Add pci_bus_replace_busn_res()
  PCI: Allocate bus range instead of use max blindly
  PCI: Strict checking of valid range for bridge
  PCI: Kill pci_fixup_parent_subordinate_busnr()
  PCI: Seperate child bus scanning to two passes overall
  pcmcia: Remove workaround for fixing pci parent bus subordinate
  PCI: Double checking setting for bus register and bus struct.
  PCI, pciehp: Remove not needed bus number range checking
  PCI: More strict checking of valid range for bridge
  PCI: Don't shrink too much for hotplug bridge

 drivers/pci/hotplug-pci.c     |   12 +--
 drivers/pci/probe.c           |  351 +++++++++++++++++++++++++++++++----------
 drivers/pcmcia/yenta_socket.c |   75 ---------
 include/linux/ioport.h        |    8 +
 kernel/resource.c             |  200 +++++++++++++++++++++++-
 5 files changed, 472 insertions(+), 174 deletions(-)

-- 
1.7.7

