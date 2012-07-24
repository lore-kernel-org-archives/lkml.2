Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2GXVq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:46:26 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61498 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2GXVqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:46:22 -0400
Date: Tue, 24 Jul 2012 15:46:20 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.6
Message-ID: <20120724214620.GD32203@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/for-3.6

for you to fetch changes up to 63b96f7baeba71966c723912c3f8f0274577f877:

  Merge branch 'pci/yinghai-pciehp-unused' into next (2012-07-18 14:08:22 -0600)

----------------------------------------------------------------

PCI changes for the 3.6 merge window:

  Host bridge hotplug
    - Add MMCONFIG support for hot-added host bridges (Jiang Liu)
  Device hotplug
    - Move fixups from __init to __devinit (Sebastian Andrzej Siewior)
    - Call FINAL fixups for hot-added devices, too (Myron Stowe)
    - Factor out generic code for P2P bridge hot-add (Yinghai Lu)
    - Remove all functions in a slot, not just those with _EJx (Amos Kong)
  Dynamic resource management
    - Track bus number allocation (struct resource tree per domain) (Yinghai Lu)
    - Make P2P bridge 1K I/O windows work with resource reassignment (Bjorn Helgaas, Yinghai Lu)
    - Disable decoding while updating 64-bit BARs (Bjorn Helgaas)
  Power management
    - Add PCIe runtime D3cold support (Huang Ying)
  Virtualization
    - Add VFIO infrastructure (ACS, DMA source ID quirks) (Alex Williamson)
    - Add quirks for devices with broken INTx masking (Jan Kiszka)
  Miscellaneous
    - Fix some PCI Express capability version issues (Myron Stowe)
    - Factor out some arch code with a weak, generic, pcibios_setup() (Myron Stowe)

----------------------------------------------------------------
Alex Williamson (6):
      PCI: add PCI DMA source ID quirk
      PCI: add ACS validation utility
      PCI: export pci_user functions for use by other drivers
      PCI: create common pcibios_err_to_errno
      PCI: misc pci_reg additions
      PCI: add Ralink RT2800 broken INTx masking quirk

Amos Kong (2):
      PCI: acpiphp: fix function 0 leak when disabling a slot
      PCI: acpiphp: remove all functions in slot, even without ACPI _EJx

Bjorn Helgaas (40):
      PCI: remove pci_bus_find_ext_capability() (unused)
      PCI: remove pci_max_busnr() (was already commented out)
      PCI/AER: use pci_is_pcie() instead of obsolete pci_dev.is_pcie
      Merge branch 'topic/yinghai-busn-alloc' into next
      Merge branch 'topic/kong-acpiphp-remove' into next
      Merge branch 'topic/bjorn-remove-unused' into next
      Merge branch 'topic/alex-vfio-prep' into next
      sparc/PCI: remove unused pcibios_assign_resource() definition
      PCI: add infrastructure for devices with broken INTx masking
      Merge branch 'topic/stowe-cap-cleanup' into next
      Merge branch 'topic/sebastian-devinit-fixups' into next
      Merge branch 'topic/jan-intx-masking' into next
      PCI: use __weak consistently
      PCI: fix upstream P2P bridge checks when enabling OBFF and LTR
      PCI: fix P2P bridge I/O port window sign extension
      PCI: shpchp: remove dead code
      PCI: acpiphp: check whether _ADR evaluation succeeded
      PCI: remove useless pcix_set_mmrbc() dev->bus check
      MAINTAINERS: correct PCI git tree address
      Merge branch 'topic/fixes-for-3.5' into next
      Merge branch 'topic/bjorn-trivial' into next
      Merge branch 'topic/jiang-mmconfig-v10' into next
      Merge branch 'topic/huang-d3cold-v7' into next
      Merge branch 'pci/myron-pcibios_setup' into next
      Merge branch 'pci/rafael-pci_set_power_state-rebase' into next
      PCI: allow P2P bridge windows starting at PCI bus address zero
      PCI: leave MEM and IO decoding disabled during 64-bit BAR sizing, too
      PCI: disable MEM decoding while updating 64-bit MEM BARs
      PCI: reimplement P2P bridge 1K I/O windows (Intel P64H2)
      Merge branch 'pci/myron-final-fixups-v2' into next
      Merge branch 'pci/bjorn-disable-decode' into next
      sparc/PCI: replace pci_cfg_fake_ranges() with pci_read_bridge_bases()
      Merge branch 'pci/bjorn-p2p-bridge-windows' into next
      Merge branch 'pci/yinghai-hotplug-cleanup' into next
      PCI: reorder __pci_assign_resource() (no change)
      Merge branch 'pci/greg-m68k' into next
      Merge branch 'pci/myron-final-fixups-v2' into next
      Merge branch 'pci/julia-return-values' into next
      Merge branch 'pci/nikhil-big-bar-fixes' into next
      Merge branch 'pci/yinghai-pciehp-unused' into next

Greg Ungerer (1):
      PCI: build resource code for M68K architecture

Huang Ying (3):
      ACPI/PM: specify lowest allowed state for device sleep state
      PCI: do not call pci_set_power_state with PCI_D3cold
      PCI/PM: add PCIe runtime D3cold support

Jan Kiszka (1):
      PCI: add Chelsio T310 10GbE NIC broken INTx masking quirk

Jiang Liu (13):
      x86/PCI: split out pci_mmcfg_check_reserved() for code reuse
      x86/PCI: split out pci_mmconfig_alloc() for code reuse
      x86/PCI: use RCU list to protect mmconfig list
      x86/PCI: introduce pci_mmcfg_arch_map()/pci_mmcfg_arch_unmap()
      x86/PCI: prepare pci_mmcfg_check_reserved() to be called at runtime
      x86/PCI: add pci_mmconfig_insert()/delete() for PCI root bridge hotplug
      PCI/ACPI: provide MMCONFIG address for PCI host bridges
      x86/PCI: update MMCONFIG information when hot-plugging PCI host bridges
      x86/PCI: simplify pci_mmcfg_late_insert_resources()
      x86/PCI: get rid of redundant log messages
      x86/PCI: refine __pci_mmcfg_init() for better code readability
      x86/PCI: use pr_level() to replace printk(KERN_LEVEL)
      ACPI: mark acpi_sfi_table_parse() as __init

Julia Lawall (1):
      PCI: hotplug: ensure a consistent return value in error case

Myron Stowe (28):
      PCI: make pci_ltr_supported() static
      PCI: remove redundant checking in PCI Express capability routines
      PCI: add pci_pcie_cap2() check for PCIe feature capabilities >= v2
      PCI: remove redundant capabilities checking in pci_{save, restore}_pcie_state
      PCI: pull pcibios_setup() up into core
      alpha/PCI: factor out pcibios_setup()
      cris/PCI: factor out pcibios_setup()
      ia64/PCI: factor out pcibios_setup()
      microblaze/PCI: factor out pcibios_setup()
      MIPS/PCI: factor out pcibios_setup()
      MIPS/PCI: adjust section annotations for pcibios_setup()
      parisc/PCI: factor out pcibios_setup()
      powerpc/PCI: factor out pcibios_setup()
      sh/PCI: factor out pcibios_setup()
      sh/PCI: adjust section annotations for pcibios_setup()
      sparc/PCI: factor out pcibios_setup()
      tile/PCI: factor out pcibios_setup()
      unicore32/PCI: adjust section annotations for pcibios_setup()
      x86/PCI: adjust section annotations for pcibios_setup()
      xtensa/PCI: factor out pcibios_setup()
      PCI: restructure 'pci_do_fixups()'
      PCI: release temporary reference in __nv_msi_ht_cap_quirk()
      PCI: never discard enable/suspend/resume_early/resume fixups
      MIPS/PCI: move final fixups from __init to __devinit
      x86/PCI: move final fixups from __init to __devinit
      PCI: move final fixups from __init to __devinit
      PCI: call final fixups hot-added devices
      PCI: fix undefined reference to 'pci_fixup_final_inited'

Nikhil P Rao (1):
      PCI: fix truncation of resource size to 32 bits

Rafael J. Wysocki (1):
      PCI / PM: restore the original behavior of pci_set_power_state()

Sebastian Andrzej Siewior (8):
      x86/PCI: move fixup hooks from __init to __devinit
      PCI: move fixup hooks from __init to __devinit
      alpha/PCI: move fixup hooks from __init to __devinit
      arm/PCI: move fixup hooks from __init to __devinit
      frv/PCI: move fixup hooks from __init to __devinit
      powerpc/PCI: move fixup hooks from __init to __devinit
      sh/PCI: move fixup hooks from __init to __devinit
      scripts/modpost: check for bad references in .pci.fixups area

Wanpeng Li (1):
      PCI: cleanup assign_requested_resources_sorted() kernel-doc warning

Yinghai Lu (37):
      PCI: add busn_res in struct pci_bus
      PCI: replace struct pci_bus secondary/subordinate with busn_res
      PCI: remove secondary/subordinate in struct pci_bus
      PCI: build a bus number resource tree for every domain
      resources: allow adjust_resource() for resources with no parent
      PCI: add busn_res operation functions
      PCI: release busn_res when removing bus
      PCI: insert busn_res in pci_create_root_bus()
      PCI: checking busn_res in pci_scan_root_bus()
      PCI: add default busn_resource
      PCI: add default busn_res for pci_scan_bus()
      x86/PCI: use _CRS bus number aperture for host bridges from ACPI
      x86/PCI: put busn resource in pci_root_info for native host bridge drivers
      ia64/PCI: register busn_res for root buses
      sparc/PCI: register busn_res for root buses
      powerpc/PCI: register busn_res for root buses
      parisc/PCI: register busn_res for root buses
      tile/PCI: use pci_scan_root_bus instead pci_scan_bus
      PCI: register busn_res for iov bus
      PCI: insert busn_res for child bus
      PCI: cpci_hotplug: register busn_res
      PCI: shpchp: register busn_res
      PCI: cpqhp: register busn_res
      PCI: ibmhp: register busn_res
      PCI: sgihp: register busn_res
      PCI: add generic pci_hp_add_bridge()
      PCI: pciehp: use generic pci_hp_add_bridge()
      PCI: cpci_hotplug: use generic pci_hp_add_bridge()
      PCI: shpchp: use generic pci_hp_add_bridge()
      PCI: cpqhp: use generic pci_hp_add_bridge()
      PCI: ibmhp: use generic pci_hp_add_bridge()
      PCI: sgihp: use generic pci_hp_add_bridge()
      PCI: hotplug: remove pci_do_scan_bus()
      PCI: support sizing P2P bridge I/O windows with 1K granularity
      PCI: acpiphp: remove unused res_lock
      PCI: acpiphp: merge acpiphp_debug and debug
      PCI: pciehp: remove unused pciehp_get_max_lnk_width(), pciehp_get_cur_lnk_width()

Zheng Yan (1):
      PCI/PM: add runtime PM support to PCIe port

 MAINTAINERS                                |   2 +-
 arch/alpha/kernel/pci.c                    |  17 +-
 arch/arm/kernel/bios32.c                   |   4 +-
 arch/cris/arch-v32/drivers/pci/bios.c      |   5 -
 arch/frv/mb93090-mb00/pci-vdk.c            |   4 +-
 arch/ia64/pci/pci.c                        |  13 +-
 arch/microblaze/pci/pci-common.c           |   9 +-
 arch/mips/mti-malta/malta-pci.c            |   2 +-
 arch/mips/pci/ops-tx4927.c                 |   2 +-
 arch/mips/pci/pci.c                        |   6 +-
 arch/mips/pmc-sierra/yosemite/ht.c         |  11 -
 arch/mips/txx9/generic/pci.c               |   8 +-
 arch/parisc/kernel/pci.c                   |   5 -
 arch/powerpc/include/asm/pci-bridge.h      |   1 +
 arch/powerpc/kernel/pci-common.c           |  22 +-
 arch/powerpc/kernel/pci_64.c               |   2 +-
 arch/powerpc/kernel/pci_of_scan.c          |   2 +-
 arch/powerpc/platforms/85xx/tqm85xx.c      |   2 +-
 arch/powerpc/platforms/86xx/gef_ppc9a.c    |   2 +-
 arch/powerpc/platforms/86xx/gef_sbc310.c   |   2 +-
 arch/powerpc/platforms/86xx/gef_sbc610.c   |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c  |   8 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c |   2 +-
 arch/powerpc/sysdev/fsl_pci.c              |   2 +-
 arch/powerpc/sysdev/mv64x60_pci.c          |   2 +-
 arch/sh/drivers/pci/fixups-dreamcast.c     |   2 +-
 arch/sh/drivers/pci/fixups-sdk7786.c       |   4 +-
 arch/sh/drivers/pci/pci.c                  |   7 +-
 arch/sparc/kernel/leon_pci.c               |   8 -
 arch/sparc/kernel/pci.c                    | 102 +------
 arch/sparc/kernel/pci_impl.h               |   1 +
 arch/sparc/kernel/pcic.c                   |  13 -
 arch/tile/kernel/pci.c                     |  19 +-
 arch/unicore32/kernel/pci.c                |   2 +-
 arch/x86/include/asm/pci_x86.h             |   7 +
 arch/x86/kernel/quirks.c                   |   2 +-
 arch/x86/pci/acpi.c                        | 109 +++++++-
 arch/x86/pci/amd_bus.c                     |   7 +-
 arch/x86/pci/bus_numa.c                    |  22 +-
 arch/x86/pci/bus_numa.h                    |   3 +-
 arch/x86/pci/common.c                      |   2 +-
 arch/x86/pci/mmconfig-shared.c             | 372 ++++++++++++++++---------
 arch/x86/pci/mmconfig_32.c                 |  30 +-
 arch/x86/pci/mmconfig_64.c                 |  52 +++-
 arch/x86/pci/mrst.c                        |   2 +-
 arch/xtensa/kernel/pci.c                   |   8 +-
 drivers/acpi/pci_root.c                    |   2 +
 drivers/acpi/sleep.c                       |  24 +-
 drivers/iommu/intel-iommu.c                |   2 +-
 drivers/misc/cb710/core.c                  |   2 +-
 drivers/net/ethernet/broadcom/tg3.c        |   4 +-
 drivers/parisc/dino.c                      |  16 +-
 drivers/parisc/iosapic.c                   |   2 +-
 drivers/parisc/lba_pci.c                   |  26 +-
 drivers/pci/Makefile                       |   1 +
 drivers/pci/access.c                       |   6 +-
 drivers/pci/bus.c                          |   2 +
 drivers/pci/hotplug-pci.c                  |  30 +-
 drivers/pci/hotplug/acpiphp.h              |   4 +-
 drivers/pci/hotplug/acpiphp_core.c         |   7 +-
 drivers/pci/hotplug/acpiphp_glue.c         |  67 +++--
 drivers/pci/hotplug/cpci_hotplug_core.c    |  14 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c     |  35 +--
 drivers/pci/hotplug/cpqphp_core.c          |  14 +-
 drivers/pci/hotplug/cpqphp_pci.c           |   8 +-
 drivers/pci/hotplug/ibmphp_core.c          |   8 +-
 drivers/pci/hotplug/pciehp.h               |   4 -
 drivers/pci/hotplug/pciehp_hpc.c           | 101 -------
 drivers/pci/hotplug/pciehp_pci.c           |  28 +-
 drivers/pci/hotplug/pcihp_skeleton.c       |  14 +-
 drivers/pci/hotplug/sgi_hotplug.c          |  12 +-
 drivers/pci/hotplug/shpchp_core.c          |  14 +-
 drivers/pci/hotplug/shpchp_ctrl.c          |   3 -
 drivers/pci/hotplug/shpchp_pci.c           |  45 +--
 drivers/pci/hotplug/shpchp_sysfs.c         |   6 +-
 drivers/pci/iov.c                          |   4 +-
 drivers/pci/pci-acpi.c                     |  36 ++-
 drivers/pci/pci-driver.c                   |  24 +-
 drivers/pci/pci-sysfs.c                    |  31 ++-
 drivers/pci/pci.c                          | 424 ++++++++++++++++++++---------
 drivers/pci/pci.h                          |  11 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c         |   2 +-
 drivers/pci/pcie/portdrv_pci.c             |  60 ++++
 drivers/pci/probe.c                        | 246 +++++++++++++----
 drivers/pci/quirks.c                       | 242 ++++++++++------
 drivers/pci/remove.c                       |   1 +
 drivers/pci/search.c                       |   2 +
 drivers/pci/setup-bus.c                    |  65 +++--
 drivers/pci/setup-res.c                    | 125 +++++----
 drivers/pcmcia/cardbus.c                   |   2 +-
 drivers/pcmcia/yenta_socket.c              |  26 +-
 drivers/pnp/pnpacpi/core.c                 |   4 +-
 drivers/xen/xen-pciback/conf_space.c       |   6 +-
 include/acpi/acnames.h                     |   1 +
 include/acpi/acpi_bus.h                    |   7 +-
 include/linux/pci-acpi.h                   |   1 +
 include/linux/pci.h                        |  82 +++++-
 include/linux/pci_regs.h                   | 122 ++++++++-
 include/linux/sfi_acpi.h                   |   4 +-
 kernel/resource.c                          |  13 +-
 scripts/mod/modpost.c                      |  11 +
 101 files changed, 1850 insertions(+), 1114 deletions(-)
