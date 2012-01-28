Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2A1Ct6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 21:49:58 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26475 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2A1Ctz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 21:49:55 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 0/13] PCI: allocate pci bus num range for unassigned bridge busn
Date: Fri, 27 Jan 2012 18:49:18 -0800
Message-Id: <1327718971-9598-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F23624D.002A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

82b166c: PCI: Seperate child bus scanning to two passes overall
dd174b3: PCI: kill pci_fixup_parent_subordinate_busnr()
6184c18: PCI: Allocate bus range instead of use max blindly
11525b2: PCI: Strict checking of valid range for bridge
05c754e: PCI: Probe safe range that we can use for unassigned bridge.
8bb27f2: PCI: Add pci_bus_extend/shrink_top()
76bb4b4: PCI, parisc: Register busn_res for root buses
36042e6: PCI, powerpc: Register busn_res for root buses
53472fe: PCI, ia64: Register busn_res for root buses
740a84d: PCI, x86: Register busn_res for root buses
a5ddf08: PCI: Add busn_res tracking in core
3810f01: PCI: Add busn_res operation functions
bd3ab8d: PCI: Add iobusn_resource

Set up iobusn_resource tree, and register bus number range to it.
Later when need to find bus range, will try to allocate from the tree

Need to test on arches other than x86. esp for ia64 and powerpc that support
  more than on peer root buses.

could be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

-v2: according to Jesse, split to more small patches.

Thanks

Yinghai

 arch/ia64/pci/pci.c              |    2 +
 arch/powerpc/kernel/pci-common.c |    7 +-
 arch/x86/include/asm/topology.h  |    3 +-
 arch/x86/pci/acpi.c              |    8 +-
 arch/x86/pci/bus_numa.c          |    8 +-
 arch/x86/pci/common.c            |   11 +-
 drivers/parisc/dino.c            |    2 +
 drivers/parisc/lba_pci.c         |    3 +
 drivers/pci/probe.c              |  427 ++++++++++++++++++++++++++++++--------
 drivers/pci/remove.c             |    1 +
 include/linux/ioport.h           |    1 +
 include/linux/pci.h              |    8 +
 kernel/resource.c                |    8 +
 13 files changed, 395 insertions(+), 94 deletions(-)

