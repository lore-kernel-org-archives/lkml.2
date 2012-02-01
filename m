Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab2BAWog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:44:36 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48543 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab2BAWoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:44:30 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v4 0/15] PCI: allocate pci bus num range for unassigned bridge busn
Date: Wed,  1 Feb 2012 14:43:47 -0800
Message-Id: <1328136242-17725-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F29C046.002E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

676b367: pcmcia: remove workaround for fixing pci parent bus subordinate
ddbc547: PCI: Seperate child bus scanning to two passes overall
c82fe6d: PCI: kill pci_fixup_parent_subordinate_busnr()
7bf1ff4: PCI: Allocate bus range instead of use max blindly
1e511be: PCI: Strict checking of valid range for bridge
a433d03: PCI: Probe safe range that we can use for unassigned bridge.
7f45e65: PCI: Add pci_bus_extend/shrink_top()
6e8d9f1: PCI, parisc: Register busn_res for root buses
aadaf33: PCI, powerpc: Register busn_res for root buses
10ba93b: PCI, ia64: Register busn_res for root buses
6663d7a: PCI, x86: Register busn_res for root buses
f283aa2: PCI: Add busn_res tracking in core
d20c7d9: PCI: Add busn_res operation functions
196dcc6: PCI: Add iobusn_resource
634a14b: Make %pR could handle bus resource with domain

Set up iobusn_resource tree, and register bus number range to it.
Later when need to find bus range, will try to allocate from the tree

Need to test on arches other than x86. esp for ia64 and powerpc that support
  more than on peer root buses.

could be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

-v2: according to Jesse, split to more small patches.
-v3: address some request from Bjorn. like make use %pR for busn_res debug print
	out, and move the comment change with code change.
-v4: fixes the problem about rescan that Bjorn found.

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
 drivers/pci/probe.c              |  417 ++++++++++++++++++++++++++++++--------
 drivers/pci/remove.c             |    1 +
 drivers/pcmcia/yenta_socket.c    |   75 -------
 include/linux/ioport.h           |    1 +
 include/linux/pci.h              |    8 +
 kernel/resource.c                |    8 +
 lib/vsprintf.c                   |   28 +++-
 15 files changed, 410 insertions(+), 172 deletions(-)

