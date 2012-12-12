Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2LLQ23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:28:29 -0500
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56585 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2LLQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:28:27 -0500
Date: Wed, 12 Dec 2012 09:28:24 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.8
Message-ID: <20121212162824.GA18122@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ff8e59bc4ec3f31789a47dce9b6fe44bd7bc5fcc:

  PCI/portdrv: Don't create hotplug slots unless port supports hotplug (2012-11-05 16:59:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/for-3.8

for you to fetch changes up to 1cb73f8c479e66541fefd3f7fa547b1fa56cdc54:

  Merge branch 'pci/mjg-pci-roms-from-efi' into next (2012-12-10 16:20:12 -0700)

----------------------------------------------------------------

PCI changes for the v3.8 merge window:

  Host bridge hotplug:
    - Untangle _PRT from struct pci_bus (Bjorn Helgaas)
    - Request _OSC control before scanning root bus (Taku Izumi)
    - Assign resources when adding host bridge (Yinghai Lu)
    - Remove root bus when removing host bridge (Yinghai Lu)
    - Remove _PRT during hot remove (Yinghai Lu)

  SRIOV
    - Add sysfs knobs to control numVFs (Don Dutile)

  Power management
    - Notify devices when power resource turned on (Huang Ying)

  Bug fixes
    - Work around broken _SEG on HP xw9300 (Bjorn Helgaas)
    - Keep runtime PM enabled for unbound PCI devices (Huang Ying)
    - Fix Optimus dual-GPU runtime D3 suspend issue (Dave Airlie)
    - Fix xen frontend shutdown issue (David Vrabel)
    - Work around PLX PCI 9050 BAR alignment erratum (Ian Abbott)

  Miscellaneous
    - Add GPL license for drivers/pci/ioapic (Andrew Cooks)
    - Add standard PCI-X, PCIe ASPM register #defines (Bjorn Helgaas)
    - NumaChip remote PCI support (Daniel Blueman)
    - Fix PCIe Link Capabilities Supported Link Speed definition (Jingoo Han)
    - Convert dev_printk() to dev_info(), etc (Joe Perches)
    - Add support for non PCI BAR ROM data (Matthew Garrett)
    - Add x86 support for host bridge translation offset (Mike Yoknis)
    - Report success only when every driver supports AER (Vijay Pandarathil)

----------------------------------------------------------------
Andrew Cooks (1):
      PCI: Add GPL license for drivers/pci/ioapic module

Bjorn Helgaas (31):
      ACPI: Pass segment/bus to _PRT add/del so they don't depend on pci_bus
      PCI/ACPI: Add _PRT interrupt routing info before enumerating devices
      x86/PCI: Ignore _SEG on HP xw9300
      Merge branch 'pci/misc' into next
      Merge branch 'pci/yinghai-for-pci-root-bus-hotplug' into next
      Merge branch 'pci/taku-prt-cleanup' into next
      Merge branch 'pci/mike-x86-tra' into next
      PCI: Use spec names for SR-IOV capability fields
      PCI: Remove useless "!dev" tests
      Merge branch 'pci/don-sriov' into next
      Merge branch 'pci/misc' into next
      Merge branch 'for-linus' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/don-sriov' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/huang-d3cold-fixes' into next
      PCI: Add and use standard PCI-X Capability register names
      Merge branch 'pci/mjg-pci-roms-from-efi' into next
      PCI: Use standard PCIe Capability Link register field names
      PCI/portdrv: Use PCI Express Capability accessors
      PCI: Add standard PCIe Capability Link ASPM field names
      cxgb3: Use standard #defines for PCIe Capability ASPM fields
      iwlegacy: collapse wrapper for pcie_capability_read_word()
      iwlegacy: Use standard #defines for PCIe Capability ASPM fields
      iwlwifi: collapse wrapper for pcie_capability_read_word()
      iwlwifi: Use standard #defines for PCIe Capability ASPM fields
      ath9k: Use standard #defines for PCIe Capability ASPM fields
      Merge branch 'pci/bjorn-pcie-cap' into next
      Merge branch 'pci/daniel-numachip' into next
      PCI: Use phys_addr_t for physical ROM address
      Merge branch 'pci/mjg-pci-roms-from-efi' into next

Daniel J Blueman (1):
      x86/PCI: Add NumaChip remote PCI support

Dave Airlie (1):
      PCI: Don't touch card regs after runtime suspend D3

David Vrabel (1):
      xen-pcifront: Handle backend CLOSED without CLOSING

Donald Dutile (3):
      PCI: SRIOV control and status via sysfs
      PCI: Provide method to reduce the number of total VFs supported
      PCI: SRIOV control and status via sysfs (documentation)

Huang Ying (3):
      PCI/PM: Add comments for PME poll support for PCIe
      PCI/ACPI: Notify PCI devices when their power resource is turned on
      PCI/PM: Keep runtime PM enabled for unbound PCI devices

Ian Abbott (2):
      PCI: Add workaround for PLX PCI 9050 BAR alignment erratum
      PCI: Add PLX PCI 9050 workaround for some Meilhaus DAQ cards

Jingoo Han (1):
      PCI: Fix bit definitions of PCI_EXP_LNKCAP2 register

Joe Perches (1):
      PCI: Convert dev_printk(KERN_<LEVEL> to dev_<level>(

Matthew Garrett (4):
      EFI: Stash ROMs if they're not in the PCI BAR
      PCI: Add pcibios_add_device
      PCI: Add support for non-BAR ROMs
      x86: Use PCI setup data

Mike Yoknis (1):
      x86/PCI: Allow x86 platforms to use translation offsets

Taku Izumi (2):
      PCI: Don't pass pci_dev to pci_ext_cfg_avail()
      PCI/ACPI: Request _OSC control before scanning PCI root bus

Vijay Mohan Pandarathil (1):
      PCI/AER: Report success only when every device has AER-aware driver

Yinghai Lu (10):
      PCI: Separate out pci_assign_unassigned_bus_resources()
      PCI: Move pci_rescan_bus() back to probe.c
      PCI: Move out pci_enable_bridges out of assign_unsigned_bus_res
      PCI/ACPI: Assign unassigned resource for hot-added root bus
      PCI: Add pci_stop_and_remove_root_bus()
      PCI/ACPI: Make acpi_pci_root_remove() stop/remove pci root bus
      PCI/ACPI: Delete host bridge _PRT during hot remove path
      PCI/ACPI: Remove acpi_root_driver in reverse order
      PCI: Add pci_device_type to pdev's device struct
      PCI: Use is_visible() with boot_vga attribute for pci_dev

 Documentation/ABI/testing/sysfs-bus-pci    |  34 ++++++
 Documentation/PCI/pci-iov-howto.txt        |  48 +++++++-
 arch/x86/Kconfig                           |   1 +
 arch/x86/boot/compressed/eboot.c           | 118 ++++++++++++++++++++
 arch/x86/include/asm/bootparam.h           |   1 +
 arch/x86/include/asm/numachip/numachip.h   |  19 ++++
 arch/x86/include/asm/pci.h                 |  12 ++
 arch/x86/kernel/apic/apic_numachip.c       |   2 +
 arch/x86/kernel/setup.c                    |   4 -
 arch/x86/pci/Makefile                      |   1 +
 arch/x86/pci/acpi.c                        |  46 +++++++-
 arch/x86/pci/common.c                      |  32 +++++-
 arch/x86/pci/numachip.c                    | 129 ++++++++++++++++++++++
 drivers/acpi/pci_bind.c                    |  12 +-
 drivers/acpi/pci_irq.c                     |  17 ++-
 drivers/acpi/pci_root.c                    | 165 +++++++++++++++------------
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c |   2 +-
 drivers/net/wireless/ath/ath9k/pci.c       |   8 +-
 drivers/net/wireless/iwlegacy/4965.h       |   4 -
 drivers/net/wireless/iwlegacy/common.c     |  10 +-
 drivers/net/wireless/iwlegacy/common.h     |  12 --
 drivers/net/wireless/iwlwifi/pcie/trans.c  |  20 +---
 drivers/pci/bus.c                          |   5 +
 drivers/pci/ioapic.c                       |   2 +
 drivers/pci/iov.c                          |  87 +++++++++++----
 drivers/pci/irq.c                          |  10 +-
 drivers/pci/pci-driver.c                   |  73 +++++++-----
 drivers/pci/pci-stub.c                     |   2 +-
 drivers/pci/pci-sysfs.c                    | 172 +++++++++++++++++++++++++++--
 drivers/pci/pci.c                          |  48 ++++++--
 drivers/pci/pci.h                          |   8 +-
 drivers/pci/pcie/aer/aerdrv.h              |   5 +-
 drivers/pci/pcie/aer/aerdrv_core.c         |  22 +++-
 drivers/pci/pcie/aspm.c                    |  18 ++-
 drivers/pci/pcie/portdrv_core.c            |   3 +-
 drivers/pci/probe.c                        |  42 +++++--
 drivers/pci/quirks.c                       |  39 +++++++
 drivers/pci/remove.c                       |  36 ++++++
 drivers/pci/rom.c                          |  11 +-
 drivers/pci/setup-bus.c                    |  22 +---
 drivers/pci/xen-pcifront.c                 |   5 +-
 include/acpi/acpi_drivers.h                |   4 +-
 include/linux/efi.h                        |  71 ++++++++++++
 include/linux/pci.h                        |  22 +++-
 include/uapi/linux/pci_regs.h              |  23 +++-
 45 files changed, 1150 insertions(+), 277 deletions(-)
 create mode 100644 arch/x86/include/asm/numachip/numachip.h
 create mode 100644 arch/x86/pci/numachip.c
