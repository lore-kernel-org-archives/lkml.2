Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab1EWUns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:43:48 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:57962 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757355Ab1EWUnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:43:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=D28Q3kPhqrGdzAlGOa4Cef2RPWwr5CqDscT/1zxF403wvwJisv1LyP5bZo2M+G6LDcPb+kUsy+zNxEwOwfNMcG1eEPFnVdMGaA/iZqIBvbmdQvv2ZbSYAXOZ/CEVqbZq;
Date: Mon, 23 May 2011 13:43:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes
Message-ID: <20110523134339.609508fe@jbarnes-vaio.home>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 204.16.154.129 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
2f666bcf757cb72549f360ef6da02f03620a48b6:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-04-19 18:32:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

Ok, with the recent fixes to the resource code, we ought to be able to
re-enable the code that tries to reallocate bridge resources as
needed.  As with last time we tried this, we'll keep the revert trigger
light; if this causes any problems we can't quickly root cause we'll
yank it back out.

Other than that, there are a few enabling features for PCIe 2.1
extensions here, and some support code for KVM, along with the usual
collection of fixes.

Thanks,
Jesse

Alex Williamson (4):
      PCI: Enable ASPM state clearing regardless of policy
      PCI: Track the size of each saved capability data area
      PCI: Add interfaces to store and load the device saved state
      KVM: Use pci_store/load_saved_state() around VM device usage

Chen Gong (1):
      PCI: remove unused AER functions

Greg Thelen (2):
      PCI: check pci_vpd_pci22_wait() return
      PCI: handle positive error codes

Hemant Pedanekar (1):
      PCI: Add quirk for setting valid class for TI816X Endpoint

Ian Campbell (1):
      PCI hotplug: acpiphp: assume device is in state D0 after powering on a slot.

Jan Beulich (1):
      x86/PCI: derive pcibios_last_bus from ACPI MCFG

Jean Delvare (3):
      PCI: Fix typo in ich7 quirk comment
      PCI: Use ICH6_GPIO_EN in ich6_lpc_acpi_gpio
      PCI: Don't use dmi_name_in_vendors in quirk

Jesse Barnes (3):
      PCI: add ID-based ordering enable/disable support
      PCI: add OBFF enable/disable support
      PCI: add latency tolerance reporting enable/disable support

Jordan_Hargrave@Dell.com (1):
      PCI: Set PCIE maxpayload for card during hotplug insertion

Julia Lawall (1):
      x86/PCI: Convert release_resource to release_region/release_mem_region

Rafael J. Wysocki (2):
      PCI/PM: Add kerneldoc description of pci_pm_reset()
      PCI/ACPI: Report _OSC control mask returned on failure to get control

Seth Heasley (1):
      x86/PCI: irq and pci_ids patch for Intel Panther Point DeviceIDs

Wanlong Gao (1):
      PCI: Fix uninitialized variable bug in AER injection code

Yinghai Lu (5):
      x86/PCI: Remove dma32_reserve_bootmem
      PCI/e1000e: Add and use pci_disable_link_state_locked()
      PCI: update bridge resources to get more big ranges when allocating space (again)
      PCI: add rescan to /sys/.../pci_bus/.../
      PCI/sysfs: move bus cpuaffinity to class dev_attrs

 Documentation/ABI/testing/sysfs-bus-pci |    9 +
 arch/x86/include/asm/pci.h              |    2 -
 arch/x86/kernel/pci-dma.c               |   64 -----
 arch/x86/kernel/setup.c                 |    1 -
 arch/x86/pci/direct.c                   |   17 +-
 arch/x86/pci/irq.c                      |    4 +-
 arch/x86/pci/mmconfig-shared.c          |   10 +
 drivers/acpi/pci_root.c                 |   14 +-
 drivers/net/e1000e/netdev.c             |    2 +-
 drivers/pci/access.c                    |   18 ++-
 drivers/pci/bus.c                       |    6 -
 drivers/pci/hotplug/acpiphp_glue.c      |    7 +
 drivers/pci/hotplug/pcihp_slot.c        |   45 ++++
 drivers/pci/pci-sysfs.c                 |   62 +++++
 drivers/pci/pci.c                       |  419 ++++++++++++++++++++++++++++++-
 drivers/pci/pci.h                       |    3 +-
 drivers/pci/pcie/aer/aer_inject.c       |    2 +-
 drivers/pci/pcie/aer/aerdrv.h           |    9 -
 drivers/pci/pcie/aspm.c                 |   21 ++-
 drivers/pci/probe.c                     |   43 +---
 drivers/pci/quirks.c                    |   21 ++-
 drivers/pci/remove.c                    |    2 -
 drivers/pci/setup-bus.c                 |  125 +++++++++-
 include/linux/kvm_host.h                |    1 +
 include/linux/pci-aspm.h                |    1 +
 include/linux/pci.h                     |   49 ++++-
 include/linux/pci_ids.h                 |    3 +
 include/linux/pci_regs.h                |   17 ++
 virt/kvm/assigned-dev.c                 |   18 +-
 29 files changed, 818 insertions(+), 177 deletions(-)
