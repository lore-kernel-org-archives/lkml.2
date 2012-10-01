Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2JAR2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:28:42 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40164 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2JAR2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:28:39 -0400
Date: Mon, 1 Oct 2012 11:28:38 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.7
Message-ID: <20121001172838.GA5205@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 55d512e245bc7699a8800e23df1a24195dd08217:

  Linux 3.6-rc5 (2012-09-08 16:43:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/for-3.7

for you to fetch changes up to 78c8f84302ce007aedcfa11912fd4aacf22727ab:

  Merge branch 'pci/yinghai-misc' into next (2012-09-24 17:24:11 -0600)

----------------------------------------------------------------

PCI changes for the 3.7 merge window:

  Host bridge hotplug
    - Protect acpi_pci_drivers and acpi_pci_roots (Taku Izumi)
    - Clear host bridge resource info to avoid issue when releasing (Yinghai Lu)
    - Notify acpi_pci_drivers when hot-plugging host bridges (Jiang Liu)
    - Use standard list ops for acpi_pci_drivers (Jiang Liu)

  Device hotplug
    - Use pci_get_domain_bus_and_slot() to close hotplug races (Jiang Liu)
    - Remove fakephp driver (Bjorn Helgaas)
    - Fix VGA ref count in hotplug remove path (Yinghai Lu)
    - Allow acpiphp to handle PCIe ports without native hotplug (Jiang Liu)
    - Implement resume regardless of pciehp_force param (Oliver Neukum)
    - Make pci_fixup_irqs() work after init (Thierry Reding)

  Miscellaneous
    - Add pci_pcie_type(dev) and remove pci_dev.pcie_type (Yijing Wang)
    - Factor out PCI Express Capability accessors (Jiang Liu)
    - Add pcibios_window_alignment() so powerpc EEH can use generic resource assignment (Gavin Shan)
    - Make pci_error_handlers const (Stephen Hemminger)
    - Cleanup drivers/pci/remove.c (Bjorn Helgaas)
    - Improve Vendor-Specific Extended Capability support (Bjorn Helgaas)
    - Use standard list ops for bus->devices (Bjorn Helgaas)
    - Avoid kmalloc in pci_get_subsys() and pci_get_class() (Feng Tang)
    - Reassign invalid bus number ranges (Intel DP43BF workaround) (Yinghai Lu)

----------------------------------------------------------------
Alan Cox (1):
      PCI: cpqphp: Remove unreachable path

Bjorn Helgaas (41):
      PCI: acpiphp: Stop disabling bridges on remove
      PCI: acpiphp: Use common pci_stop_and_remove_bus_device()
      pcmcia: Use common pci_stop_and_remove_bus_device()
      PCI: Don't export stop_bus_device and remove_bus_device interfaces
      PCI: Remove pci_stop_and_remove_behind_bridge()
      PCI: Use list_for_each_entry() for bus->devices traversal
      PCI: Fold stop and remove helpers into their callers
      PCI: Stop and remove devices in one pass
      PCI: Remove unused, commented-out, code
      PCI: Rename local variables to conventional names
      PCI: Leave normal LIST_POISON in deleted list entries
      frv/PCI: Use list_for_each_entry() for bus->devices traversal
      parisc/PCI: Enable PERR/SERR on all devices
      parisc/PCI: Use list_for_each_entry() for bus->devices traversal
      sgi-agp: Use list_for_each_entry() for bus->devices traversal
      PCI: Remove unused pci_dev_b()
      PCI: Add pci_find_next_ext_capability()
      PCI: Add Vendor-Specific Extended Capability header info
      PCI: Wait for pending transactions to complete before 82599 FLR
      r8169: Preserve other Device Control bits when setting NOSNOOP_EN
      Merge branch 'pci/jiang-pcie-cap' into next
      Merge branch 'pci/bjorn-find-next-ext-cap' into next
      Merge branch 'pci/bjorn-cleanup-remove' into next
      PCI: Remove the fakephp driver
      PCI: Remove bus number resource debug messages
      Merge branch 'pci/bjorn-remove-fakephp' into next
      Merge branch 'pci/feng-avoid-kmalloc' into next
      Merge branch 'pci/oliver-pciehp-resume' into next
      Merge branch 'pci/shengzhou-irq' into next
      Merge branch 'pci/gavin-window-alignment' into next
      Merge branch 'pci/stephen-const' into next
      Merge commit 'v3.6-rc5' into next
      Merge branch 'pci/trivial' into next
      Merge branch 'pci/jiang-get-domain-bus-slot' into next
      Merge branch 'pci/konstantin-sysfs' into next
      Merge branch 'pci/thierry-fixup-irqs' into next
      Revert "PCI: Use hotplug-safe pci_get_domain_bus_and_slot()"
      Merge branch 'pci/yinghai-revert-pci_find_bus-and-remove-cleanup' into next
      Merge branch 'pci/taku-acpi-pci-host-bridge-v3' into next
      Merge branch 'pci/jiang-acpiphp' into next
      Merge branch 'pci/yinghai-misc' into next

Feng Tang (2):
      PCI: Use pci_device_id on stack for pci_get_subsys/class() to avoid kmalloc
      PCI: Remove the obsolete no_pci_devices() check

Gavin Shan (5):
      PCI: Add weak pcibios_window_alignment() interface
      PCI: Align P2P windows using pcibios_window_alignment()
      PCI: Refactor pbus_size_mem()
      powerpc/PCI: Override pcibios_window_alignment()
      powerpc/powernv: I/O and memory alignment for P2P bridges

Jan Beulich (1):
      PCI: Drop bogus default from ARCH_SUPPORTS_MSI

Jiang Liu (43):
      PCI: Add accessors for PCI Express Capability
      PCI/core: Use PCI Express Capability accessors
      PCI/hotplug: Use PCI Express Capability accessors
      PCI/portdrv: Use PCI Express Capability accessors
      PCI/pciehp: Use PCI Express Capability accessors
      PCI/PME: Use PCI Express Capability accessors
      PCI/AER: Use PCI Express Capability accessors
      PCI/ASPM: Use PCI Express Capability accessors
      ARM: PCI: Use PCI Express Capability accessors
      MIPS: PCI: Use PCI Express Capability accessors
      tile: PCI: Use PCI Express Capability accessors
      r8169: Use PCI Express Capability accessors
      bnx2x: Use PCI Express Capability accessors
      tg3: Use PCI Express Capability accessors
      e1000e: Use PCI Express Capability accessors
      igb: Use PCI Express Capability accessors
      vxge: Use PCI Express Capability accessors
      mlx4: Use PCI Express Capability accessors
      niu: Use PCI Express Capability accessors
      myri10ge: Use PCI Express Capability accessors
      cxgb3: Use PCI Express Capability accessors
      cxgb4: Use PCI Express Capability accessors
      atl1c: Use PCI Express Capability accessors
      ath9k: Use PCI Express Capability accessors
      iwlegacy: Use PCI Express Capability accessors
      iwlwifi: Use PCI Express Capability accessors
      rtlwifi: Use PCI Express Capability accessors
      IB/mthca: Use PCI Express Capability accessors
      IB/qib: Use PCI Express Capability accessors
      [SCSI] qla4xxx: Use PCI Express Capability accessors
      [SCSI] qla4xxx: Use PCI Express Capability accessors
      drm/radeon: Use PCI Express Capability accessors
      rapdio/tsi721: Use PCI Express Capability accessors
      et131x: Use PCI Express Capability accessors
      rtl8192e: Use PCI Express Capability accessors
      ia64/PCI: Use hotplug-safe pci_get_domain_bus_and_slot()
      PCI/vga: Use hotplug-safe pci_get_domain_bus_and_slot()
      PCI/cpcihp: Use hotplug-safe pci_get_domain_bus_and_slot()
      PCI: Use hotplug-safe pci_get_domain_bus_and_slot()
      xen-pcifront: Use hotplug-safe pci_get_domain_bus_and_slot()
      PCI/ACPI: Use normal list for struct acpi_pci_driver
      PCI/ACPI: Notify acpi_pci_drivers when hot-plugging PCI root bridges
      PCI: acpiphp: Handle PCIe ports without native hotplug capability

Konstantin Khlebnikov (1):
      PCI: Convert "new_id"/"remove_id" into generic pci_bus driver attributes

Lance Ortiz (1):
      PCI/AER: Print completion message at KERN_INFO to match starting message

Mathias Krause (1):
      PCI: Drop duplicate const in DECLARE_PCI_FIXUP_SECTION

Oliver Neukum (1):
      PCI: pciehp: Always implement resume, regardless of pciehp_force param

Randy Dunlap (1):
      PCI: Fix drivers/pci/pci.c kernel-doc warnings

Shengzhou Liu (1):
      PCI: Use dev->irq instead of dev->pin to enable non MSI/INTx interrupt

Stephen Hemminger (4):
      PCI: Make pci_error_handlers const
      netdev: make pci_error_handlers const
      scsi: make pci error handlers const
      make drivers with pci error handlers const

Taku Izumi (5):
      PCI/ACPI: Protect acpi_pci_drivers list with mutex
      PCI/ACPI: Pass acpi_pci_root to acpi_pci_drivers' add/remove interface
      PCI/ACPI: Use acpi_pci_root info rather than looking it up again
      PCI/ACPI: Protect acpi_pci_roots list with mutex
      PCI/ACPI: Use acpi_driver_data() rather than searching acpi_pci_roots

Thierry Reding (2):
      PCI: Discard __init annotations for pci_fixup_irqs() and related functions
      PCI: Provide a default pcibios_update_irq()

Yijing Wang (3):
      PCI: Add pcie_flags_reg to cache PCIe capabilities register
      PCI: Introduce pci_pcie_type(dev) to replace pci_dev->pcie_type
      PCI: Remove unused field pcie_type from struct pci_dev

Yinghai Lu (7):
      PCI: Check P2P bridge for invalid secondary/subordinate range
      PCI: Use correct type when freeing bus resource list
      PCI: Stop all children first, before removing all children
      x86/PCI: Clear host bridge aperture struct resource
      ia64/PCI: Clear host bridge aperture struct resource
      PCI: Fix default vga ref_count
      PCI/ACPI: Use DEVICE_ACPI_HANDLE rather than searching acpi_pci_roots

 Documentation/feature-removal-schedule.txt         |  32 --
 arch/alpha/kernel/pci.c                            |   6 -
 arch/arm/kernel/bios32.c                           |   9 -
 arch/arm/mach-tegra/pcie.c                         |  12 +-
 arch/frv/mb93090-mb00/pci-vdk.c                    |   4 +-
 arch/ia64/pci/pci.c                                |  11 +-
 arch/ia64/sn/kernel/io_common.c                    |   4 +-
 arch/m68k/kernel/pcibios.c                         |   5 -
 arch/mips/pci/pci-octeon.c                         |  15 +-
 arch/mips/pci/pci.c                                |   6 -
 arch/powerpc/include/asm/machdep.h                 |   3 +
 arch/powerpc/kernel/pci-common.c                   |  20 ++
 arch/powerpc/platforms/powernv/pci-ioda.c          |  41 ++-
 arch/sh/drivers/pci/pci.c                          |   5 -
 arch/sparc/kernel/leon_pci.c                       |   9 -
 arch/sparc/kernel/pci.c                            |   4 -
 arch/tile/kernel/pci.c                             |  34 +-
 arch/tile/kernel/pci_gx.c                          |   8 -
 arch/unicore32/kernel/pci.c                        |   8 -
 arch/x86/pci/acpi.c                                |   3 +-
 arch/x86/pci/visws.c                               |   5 -
 arch/xtensa/kernel/pci.c                           |   8 -
 drivers/acpi/pci_root.c                            | 101 +++---
 drivers/acpi/pci_slot.c                            |  44 +--
 drivers/block/nvme.c                               |   2 +-
 drivers/char/agp/sgi-agp.c                         |   5 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  10 +-
 drivers/gpu/vga/vgaarb.c                           |  29 +-
 drivers/infiniband/hw/mthca/mthca_reset.c          |   8 +-
 drivers/infiniband/hw/qib/qib.h                    |   2 +-
 drivers/infiniband/hw/qib/qib_pcie.c               |  40 +--
 drivers/iommu/intel-iommu.c                        |   6 +-
 drivers/media/dvb/ngene/ngene-cards.c              |   2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   4 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   2 +-
 drivers/net/ethernet/broadcom/bnx2.c               |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  20 +-
 drivers/net/ethernet/broadcom/tg3.c                |  52 +--
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c         |  22 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  12 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   6 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   2 +-
 drivers/net/ethernet/intel/e100.c                  |   2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  29 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  14 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   4 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   2 +-
 drivers/net/ethernet/mellanox/mlx4/reset.c         |   8 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  31 +-
 drivers/net/ethernet/neterion/s2io.c               |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c   |   4 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   2 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |   4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   2 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |   2 +-
 drivers/net/ethernet/realtek/r8169.c               |  44 +--
 drivers/net/ethernet/sun/niu.c                     |  19 +-
 drivers/net/wireless/ath/ath9k/pci.c               |  21 +-
 drivers/net/wireless/iwlegacy/common.h             |   4 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   7 +-
 drivers/net/wireless/rtlwifi/pci.c                 |   8 +-
 drivers/parisc/dino.c                              |  10 +-
 drivers/parisc/lba_pci.c                           |   7 +-
 drivers/pci/Kconfig                                |   1 -
 drivers/pci/access.c                               | 202 ++++++++++++
 drivers/pci/bus.c                                  |   6 +-
 drivers/pci/hotplug/Kconfig                        |  24 +-
 drivers/pci/hotplug/Makefile                       |   3 -
 drivers/pci/hotplug/acpiphp_glue.c                 |  99 +++---
 drivers/pci/hotplug/cpcihp_generic.c               |   8 +-
 drivers/pci/hotplug/cpqphp_ctrl.c                  |  21 +-
 drivers/pci/hotplug/fakephp.c                      | 164 ----------
 drivers/pci/hotplug/pciehp_acpi.c                  |   6 +-
 drivers/pci/hotplug/pciehp_core.c                  |  28 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |  12 +-
 drivers/pci/hotplug/pcihp_slot.c                   |  20 +-
 drivers/pci/iov.c                                  |   6 +-
 drivers/pci/pci-driver.c                           |  57 +---
 drivers/pci/pci.c                                  | 358 ++++++---------------
 drivers/pci/pcie/aer/aer_inject.c                  |   2 +-
 drivers/pci/pcie/aer/aerdrv.c                      |  26 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c                 |   2 +-
 drivers/pci/pcie/aer/aerdrv_core.c                 |  67 +---
 drivers/pci/pcie/aspm.c                            | 119 +++----
 drivers/pci/pcie/pme.c                             |  29 +-
 drivers/pci/pcie/portdrv_bus.c                     |   2 +-
 drivers/pci/pcie/portdrv_core.c                    |  34 +-
 drivers/pci/pcie/portdrv_pci.c                     |  27 +-
 drivers/pci/probe.c                                |  39 +--
 drivers/pci/proc.c                                 |  19 --
 drivers/pci/quirks.c                               |  31 +-
 drivers/pci/remove.c                               | 156 +++------
 drivers/pci/rom.c                                  |  59 ----
 drivers/pci/search.c                               |  63 ++--
 drivers/pci/setup-bus.c                            |  81 +++--
 drivers/pci/setup-irq.c                            |   9 +-
 drivers/pci/xen-pcifront.c                         |  10 +-
 drivers/pcmcia/cardbus.c                           |  15 +-
 drivers/rapidio/devices/tsi721.c                   |  18 +-
 drivers/scsi/ipr.c                                 |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |   2 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |   8 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   2 +-
 drivers/scsi/qla4xxx/ql4_nx.c                      |   4 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |   2 +-
 drivers/staging/et131x/et131x.c                    |  19 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.c        |   8 +-
 drivers/tty/serial/8250/8250_pci.c                 |   2 +-
 drivers/tty/serial/jsm/jsm_driver.c                |   2 +-
 drivers/xen/xen-pciback/pci_stub.c                 |   2 +-
 include/linux/acpi.h                               |   6 +-
 include/linux/pci-acpi.h                           |  17 +-
 include/linux/pci.h                                |  55 +++-
 include/linux/pci_regs.h                           |   7 +
 include/linux/pcieport_if.h                        |   2 +-
 123 files changed, 1078 insertions(+), 1750 deletions(-)
 delete mode 100644 drivers/pci/hotplug/fakephp.c
