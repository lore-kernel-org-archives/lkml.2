Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab0HETwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:52:50 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:41394 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932192Ab0HETwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:52:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GbMObqatC0+AHGHKWrG+u470Biy+k0gI5Cz88gRDINLXS68jpbhNfJfPLkLhREnfIN305Kcs+uv1vdKjsSsEbTQ09ZQeMZB0aihISFfZFYSoeFNyQBVA1LxM/qnbJIQC;
Date: Thu, 5 Aug 2010 12:52:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes
Message-ID: <20100805125239.48a83f73@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
a2dccdb2055abeb8a7ce8e45e5f83de9c980a00c:

  Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6 (2010-07-29 15:23:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

Mostly small changes spread out across PCI this time around, with one
significant change to the way we do probing.  This pull includes the "disable
while probing" patch we've talked about for awhile, though the new logic
excludes host bridges and has a blacklist infrastructure should we end up
needing it.

There are a few more ACPI related fixes coming from Rafael, but they're not
quite baked yet (lots of review comments and such, which is good).

Thanks,
--
Jesse Barnes, Intel Open Source Technology Center

Alan Stern (1):
      PCI: change device runtime PM settings for probe and remove

Alex Williamson (1):
      PCI: Allow read/write access to sysfs I/O port resources

Ben Hutchings (2):
      PCI: MSI: Remove unsafe and unnecessary hardware access
      PCI: MSI: Restore read_msi_msg_desc(); add get_cached_msi_msg_desc()

Bjorn Helgaas (1):
      x86/PCI: use host bridge _CRS info on ASRock ALiveSATA2-GLAN

Clemens Ladisch (1):
      PCI quirk: AMD 780: work around wrong vendor ID on APC bridge

Dan Carpenter (1):
      PCI: hotplug/shpchp_hpc: add parenthesis in SLOT_REG_RSVDZ_MASK

FUJITA Tomonori (1):
      PCI: remove unused HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_{SIZE|BOUNDARY}

Jacob Pan (1):
      PCI: disable mmio during bar sizing

Jiri Slaby (1):
      x86/PCI: pci, fix section mismatch

Junchang Wang (1):
      PCI: check return value of pci_enable_device() when enabling bridges

Kenji Kaneshige (2):
      PCI: fix wrong memory address handling in MSI-X
      PCI: kernel oops on access to pci proc file while hot-removal

Kulikov Vasiliy (3):
      PCI: pci-sysfs: remove casts from void*
      PCI: use for_each_pci_dev()
      x86/PCI: use for_each_pci_dev()

Linus Torvalds (1):
      PCI aerdrv: fix annoying warnings

Matthew Garrett (3):
      PCI: Don't enable aspm before drivers have had a chance to veto it
      ACPI: Disable ASPM if the platform won't provide _OSC control for PCIe
      PCI: Default PCIe ASPM control to on and require !EMBEDDED to disable

Mike Habeck (1):
      x86/PCI: Add option to not assign BAR's if not already assigned

Narendra K (2):
      PCI: export SMBIOS provided firmware instance and label to sysfs
      PCI: Fix warnings when CONFIG_DMI unset

Praveen Kalamegham (2):
      PCI hotplug: pciehp: Fixed return value sign for pciehp_unconfigure_device
      PCI hotplug: shpchp: Removed check for hotplug of display devices

Rafael J. Wysocki (1):
      PCI: Do not run NVidia quirks related to MSI with MSI disabled

Stephen Hemminger (1):
      PCI: sparse warning (trivial)

Stephen Rothwell (1):
      PCI: update for owner removal from struct device_attribute

Tejun Heo (1):
      PCI: disable MSI on VIA K8M800

Yinghai Lu (1):
      PCI hotplug: make sure child bridges are enabled at hotplug time

 Documentation/ABI/testing/sysfs-bus-pci |   27 ++++++
 Documentation/filesystems/sysfs-pci.txt |    7 +-
 Documentation/kernel-parameters.txt     |    2 +
 arch/ia64/kernel/msi_ia64.c             |    2 +-
 arch/ia64/sn/kernel/msi_sn.c            |    2 +-
 arch/x86/include/asm/pci_x86.h          |    1 +
 arch/x86/kernel/apic/io_apic.c          |    2 +-
 arch/x86/pci/acpi.c                     |    9 ++
 arch/x86/pci/common.c                   |   20 +++++
 arch/x86/pci/irq.c                      |    6 +-
 arch/x86/pci/legacy.c                   |    2 +-
 drivers/acpi/pci_root.c                 |    9 ++
 drivers/firmware/dmi_scan.c             |   25 ++++++
 drivers/net/e1000e/netdev.c             |   16 +---
 drivers/net/r8169.c                     |   16 +---
 drivers/pci/Makefile                    |    3 +
 drivers/pci/bus.c                       |    4 +-
 drivers/pci/hotplug/fakephp.c           |    2 +-
 drivers/pci/hotplug/pciehp_pci.c        |    2 +-
 drivers/pci/hotplug/shpchp_hpc.c        |    2 +-
 drivers/pci/hotplug/shpchp_pci.c        |   19 +---
 drivers/pci/msi.c                       |   29 ++++++-
 drivers/pci/pci-driver.c                |   32 ++++++-
 drivers/pci/pci-label.c                 |  143 +++++++++++++++++++++++++++++++
 drivers/pci/pci-sysfs.c                 |   75 ++++++++++++++++-
 drivers/pci/pci.c                       |    4 -
 drivers/pci/pci.h                       |    9 ++
 drivers/pci/pcie/Kconfig                |   20 +++--
 drivers/pci/pcie/aer/aerdrv_core.c      |   17 ++--
 drivers/pci/pcie/aspm.c                 |   16 +++-
 drivers/pci/probe.c                     |   10 ++
 drivers/pci/proc.c                      |    6 +-
 drivers/pci/quirks.c                    |   42 ++++++++-
 drivers/pci/search.c                    |    2 +-
 drivers/pci/setup-bus.c                 |   12 ++-
 drivers/pci/setup-irq.c                 |    3 +-
 include/linux/dmi.h                     |    9 ++
 include/linux/msi.h                     |    2 +
 include/linux/pci.h                     |    2 +
 39 files changed, 517 insertions(+), 94 deletions(-)
 create mode 100644 drivers/pci/pci-label.c
