Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161906Ab2CSFtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:49:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31192 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161752Ab2CSFta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 00/26] PCI, x86: Add for_each_res and addon resource support
Date: Sun, 18 Mar 2012 22:48:23 -0700
Message-Id: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F66C8E6.009A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make device resource loop easier and readable.
Also add addon_resource support about non-stanard resources.

The patches need to apply to pci/for-linus and pci/linux-next
        [PATCH -v3] PCI: pci_host_bridge related cleanup
        [PATCH -v11] PCI: allocate pci bus num range for unassigned bridge busn
	[PATCH -v3] PCI, x86: pci root bus hotplug support

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-for-each-res-addon

-v2: Split to small patches.

Thanks

Yinghai

Yinghai Lu (26):
  PCI: Add pci_dev_resource_n()
  PCI: Add for_each_resource helpers to make resource loop easier.
  PCI: Add pci_dev_resource_idx()
  PCI: Update pci_resource_start to use pci_dev_resource_n()
  x86, PCI: Use for_each_res with pci_allocate_bridge_resources
  x86, PCI: Use for_each_res with pci_allocate_dev_resources
  PCI: Use for_each_res with IOV releated funcs
  PCI, acpiphp: Use for_each_pci_dev_resource helper
  PCI, pciehp: Use for_each_pci_dev_resource helper
  PCI: Use for_each_pci_dev_resource pci_enable_dev
  PCI: Use for_each_pci_dev_resource pci_reassigndev
  PCI: Use for_each_res with pci bar reassign funcs
  PCI: Use for_each_res pci_assign_resource
  PCI: Use for_each_res with noassign_bars
  PCI: Use for_each_res pci bases pci_dev_driver()
  PCI: Use for_each_res pci release release
  PCI: Use for_each_res pci bases reading
  PCI: Use for_each_res with mrs
  PCI: Use for_each_res with xen pci
  PCI: Add addon_resource support for pci_dev
  PCI: Add helpers for add addon_resource
  PCI: Update pci_resource_bar() to support addon_resource
  PCI: Make assign/update resource to support addon_res
  PCI: Make piix4 quirk to use addon_resource support
  PCI: Make quirk_io_region to use addon_resource support
  PCI: Use addon_fixed_resource with ati fixed resource

 arch/x86/pci/common.c              |    3 +-
 arch/x86/pci/i386.c                |   57 +++-----
 arch/x86/pci/mrst.c                |    7 +-
 drivers/pci/hotplug/acpiphp_glue.c |    4 +-
 drivers/pci/hotplug/pciehp_hpc.c   |    5 +-
 drivers/pci/iov.c                  |   31 ++---
 drivers/pci/pci-driver.c           |    6 +-
 drivers/pci/pci.c                  |   28 +++--
 drivers/pci/probe.c                |  114 ++++++++++++++++-
 drivers/pci/quirks.c               |  256 +++++++++++++++++++++---------------
 drivers/pci/remove.c               |    5 +-
 drivers/pci/setup-bus.c            |   28 ++---
 drivers/pci/setup-res.c            |   38 ++++--
 drivers/pci/xen-pcifront.c         |    4 +-
 include/linux/pci.h                |   79 +++++++++++-
 15 files changed, 446 insertions(+), 219 deletions(-)

-- 
1.7.7

