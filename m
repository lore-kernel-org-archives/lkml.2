Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2AWXHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:07:22 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:32204 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab2AWXHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:07:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/4] PCI: allocate pci bus num range for unassigned bridge busn
Date: Mon, 23 Jan 2012 15:06:54 -0800
Message-Id: <1327360018-10929-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F1DE820.0022,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5cb2147: PCI: Seperate child bus scanning to two passes overall
0cfebdb: PCI: kill pci_fixup_parent_subordinate_busnr()
cd03e86: PCI: Allocate bus range instead of use max blindly
e3edd5b: PCI: Add iobusn_resource and insert root bus range to that tree.

Set up iobusn_resource tree, and register bus number range to it.
Later when need to find bus range, will try to allocate from the tree

Need to test on arches other than x86. esp for ia64 and powerpc that support
  more than on peer root buses.

could be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

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


