Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2GJPyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:54:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61396 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2GJPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:54:38 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [RFC PATCH 00/14] improve PCIe capabilities registers handling
Date: Tue, 10 Jul 2012 23:54:01 +0800
Message-Id: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

As suggested by Bjorn Helgaas and Don Dutile in threads
http://www.spinics.net/lists/linux-pci/msg15663.html, we could improve access
to PCIe capabilities register in to way:
1) cache content of PCIe Capabilities Register into struct pce_dev to avoid
   repeatedly reading this register because it's read only.
2) provide access functions for PCIe Capabilities registers to hide differences
   among PCIe base specifications, so the caller don't need to handle those
   differences.

This patch set applies to
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci-next

These patch set is still RFC. It provides the new interfaces and has made the
major changes to adopt those new interfaces. But there are still several device
drivers left untouched. Any comments about the new interfaces are welcomed,
especially about function names:). Once we reach an agreement, I will send out
a formal version with all needed work done.

Jiang Liu (11):
  PCI: refine and move pcie_cap_has_*() macros to include/linux/pci.h
  PCI: add access functions for PCIe capabilities to hide PCIe spec
    differences
  PCI: use PCIe cap access functions to simplify PCI core
    implementation
  hotplug/PCI: use PCIe cap access functions to simplify implementation
  portdrv/PCI: use PCIe cap access functions to simplify implementation
  pciehp/PCI: use PCIe cap access functions to simplify implementation
  PME/PCI: use PCIe cap access functions to simplify implementation
  AER/PCI: use PCIe cap access functions to simplify implementation
  ASPM/PCI: use PCIe cap access functions to simplify implementation
  r8169/PCI: use PCIe cap access functions to simplify implementation
  qib/PCI: use PCIe cap access functions to simplify implementation

Yijing Wang (1):
  PCI: add pcie_flags into struct pci_dev to cache PCIe capabilities
    register
  PCI: introduce pci_pcie_type(dev) to replace pci_dev->pcie_type
  PCI: remove unused field pcie_type from struct pci_dev

 arch/powerpc/platforms/powernv/pci-ioda.c          |    2 +-
 drivers/infiniband/hw/qib/qib_pcie.c               |   34 ++-
 drivers/iommu/intel-iommu.c                        |    6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 +-
 drivers/net/ethernet/realtek/r8169.c               |   38 +--
 drivers/pci/access.c                               |   88 +++++++
 drivers/pci/hotplug/pciehp_acpi.c                  |    5 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |    8 +-
 drivers/pci/hotplug/pcihp_slot.c                   |   17 +-
 drivers/pci/iov.c                                  |    6 +-
 drivers/pci/pci.c                                  |  265 +++++---------------
 drivers/pci/pcie/aer/aer_inject.c                  |    2 +-
 drivers/pci/pcie/aer/aerdrv.c                      |   23 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c                 |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c                 |   47 ++--
 drivers/pci/pcie/aspm.c                            |  110 ++++----
 drivers/pci/pcie/pme.c                             |   23 +-
 drivers/pci/pcie/portdrv_bus.c                     |    2 +-
 drivers/pci/pcie/portdrv_core.c                    |   24 +-
 drivers/pci/pcie/portdrv_pci.c                     |   15 +-
 drivers/pci/probe.c                                |   30 +--
 drivers/pci/quirks.c                               |    8 +-
 drivers/pci/search.c                               |    2 +-
 include/linux/pci.h                                |   65 ++++-
 include/linux/pci_regs.h                           |   19 +-
 26 files changed, 401 insertions(+), 444 deletions(-)

-- 
1.7.9.5

