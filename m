Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2HAPzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:55:03 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33161 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab2HAPy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:54:59 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 00/32] provide interfaces to access PCIe capabilities registers
Date: Wed,  1 Aug 2012 23:54:05 +0800
Message-Id: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
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

And you could pull the change set from
https://github.com/jiangliu/linux.git topic/pcie-cap

v2: 1) change return value to 0 when the register is not implemented by
       V1 PCIe devices.
    2) Change all driver in the source tree to use the new interfaces.

v3: 1) be more aggresive to remoce if (pci_is_pcie(dev)) check according to
       Don's suggestion.
    2) Don't cache MSI/MSI-x information in PCIe capabilities flag register
       according to Kenji's suggestion.
    3) add new pci_pcie_capability_change_word/dword() to reduce duplicated
       code.

Jiang Liu (29):
  PCI: add PCIe capabilities access functions to hide differences among
    PCIe specs
  PCI/core: use PCIe capabilities access functions to simplify
    implementation
  PCI/hotplug: use PCIe capabilities access functions to simplify
    implementation
  PCI/portdrv: use PCIe capabilities access functions to simplify
    implementation
  PCI/pciehp: use PCIe capabilities access functions to simplify
    implementation
  PCI/PME: use PCIe capabilities access functions to simplify
    implementation
  PCI/AER: use PCIe capabilities access functions to simplify
    implementation
  PCI/ASPM: use PCIe capabilities access functions to simplify
    implementation
  PCI/ARM: use PCIe capabilities access functions to simplify
    implementation
  PCI/MIPS: use PCIe capabilities access functions to simplify
    implementation
  PCI/tile: use PCIe capabilities access functions to simplify
    implementation
  PCI/r8169: use PCIe capabilities access functions to simplify
    implementation
  PCI/broadcom: use PCIe capabilities access functions to simplify
    implementation
  PCI/igb: use PCIe capabilities access functions to simplify
    implementation
  PCI/vxge: use PCIe capabilities access functions to simplify
    implementation
  PCI/mlx4: use PCIe capabilities access functions to simplify
    implementation
  PCI/niu: use PCIe capabilities access functions to simplify
    implementation
  PCI/myri10ge: use PCIe capabilities access functions to simplify
    implementation
  PCI/chelsio: use PCIe capabilities access functions to simplify
    implementation
  PCI/atl1c: use PCIe capabilities access functions to simplify
    implementation
  PCI/ath9k: use PCIe capabilities access functions to simplify
    implementation
  PCI/iwl: use PCIe capabilities access functions to simplify
    implementation
  PCI/mthca: use PCIe capabilities access functions to simplify
    implementation
  PCI/qib: use PCIe capabilities access functions to simplify
    implementation
  PCI/qla: use PCIe capabilities access functions to simplify
    implementation
  PCI/radeon: use PCIe capabilities access functions to simplify
    implementation
  PCI/tsi721: use PCIe capabilities access functions to simplify
    implementation
  PCI/et131x: use PCIe capabilities access functions to simplify
    implementation
  PCI/rtl8192e: use PCIe capabilities access functions to simplify
    implementation

Yijing Wang (3):
  PCI: add pcie_flags_reg into struct pci_dev to cache PCIe
    capabilities register
  PCI: introduce pci_pcie_type(dev) to replace pci_dev->pcie_type
  PCI: remove unused field pcie_type from struct pci_dev

 arch/arm/mach-tegra/pcie.c                         |   13 +-
 arch/mips/pci/pci-octeon.c                         |   15 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |    2 +-
 arch/tile/kernel/pci.c                             |   25 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   10 +-
 drivers/infiniband/hw/mthca/mthca_reset.c          |    8 +-
 drivers/infiniband/hw/qib/qib_pcie.c               |   40 +--
 drivers/iommu/intel-iommu.c                        |    6 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   25 +-
 drivers/net/ethernet/broadcom/tg3.c                |   60 ++--
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c         |   19 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   11 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   10 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   27 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    2 +-
 drivers/net/ethernet/mellanox/mlx4/reset.c         |    8 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   39 +--
 drivers/net/ethernet/neterion/vxge/vxge-config.c   |    4 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 +-
 drivers/net/ethernet/realtek/r8169.c               |   44 +--
 drivers/net/ethernet/sun/niu.c                     |   18 +-
 drivers/net/wireless/ath/ath9k/pci.c               |   21 +-
 drivers/net/wireless/iwlegacy/common.h             |    5 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |    4 +-
 drivers/net/wireless/rtlwifi/pci.c                 |    8 +-
 drivers/pci/access.c                               |  195 ++++++++++++
 drivers/pci/hotplug/pciehp_acpi.c                  |    6 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   12 +-
 drivers/pci/hotplug/pcihp_slot.c                   |   20 +-
 drivers/pci/iov.c                                  |    6 +-
 drivers/pci/pci.c                                  |  324 ++++----------------
 drivers/pci/pcie/aer/aer_inject.c                  |    2 +-
 drivers/pci/pcie/aer/aerdrv.c                      |   24 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c                 |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c                 |   47 +--
 drivers/pci/pcie/aspm.c                            |  111 +++----
 drivers/pci/pcie/pme.c                             |   28 +-
 drivers/pci/pcie/portdrv_bus.c                     |    2 +-
 drivers/pci/pcie/portdrv_core.c                    |   19 +-
 drivers/pci/pcie/portdrv_pci.c                     |   18 +-
 drivers/pci/probe.c                                |   29 +-
 drivers/pci/quirks.c                               |    9 +-
 drivers/pci/search.c                               |    2 +-
 drivers/rapidio/devices/tsi721.c                   |   19 +-
 drivers/scsi/qla2xxx/qla_init.c                    |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |    8 +-
 drivers/scsi/qla4xxx/ql4_nx.c                      |    4 +-
 drivers/staging/et131x/et131x.c                    |   19 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.c        |    8 +-
 include/linux/pci.h                                |   21 +-
 include/linux/pci_regs.h                           |    2 +
 53 files changed, 553 insertions(+), 828 deletions(-)

-- 
1.7.9.5

