Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab1ANRCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:02:02 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:47039 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757553Ab1ANRBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:01:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uP4IxovS2aPiRUaD7suNApdmGJZmlmGTcv9LXG8oA6V2CgY1CBYR9clkQELUPcon4ZY+pgJmHaHr8KIwIZQ15Ot9gRCqWSh988UXgdWAxiawTQi1FUYBf+k+7nkUM3Kd;
Date: Fri, 14 Jan 2011 09:01:50 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes
Message-ID: <20110114090150.0a212030@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
e819eb8687767cefca7b6abf5ac6d5efcf581eeb:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-12-22 19:47:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

NOTE!  You may notice this has been recently rebased; that's because I
had to drop a patch that didn't get a fix in time.  It was an
independent change to our sysfs label code though, so I don't think
dropping it invalidates any testing already done or time in linux-next.

There's nothing in here as exciting as last time (i.e. no real resource
changes), mostly just a collection of fixes and relatively small
changes.

Alex Williamson (1):
      PCI: sysfs: Update ROM to include default owner write access

Bjorn Helgaas (2):
      x86/PCI: don't use native Broadcom CNB20LE driver when ACPI is available
      x86/PCI: make Broadcom CNB20LE driver EMBEDDED and EXPERIMENTAL

Jon Mason (1):
      PCI: make pci_restore_state return void

Matthew Garrett (1):
      PCI: Disable ASPM if BIOS asks us to

Narendra_K@Dell.com (1):
      PCI: enable pci=bfsort by default on future Dell systems

Rafael J. Wysocki (5):
      PCI hotplug: Fix unexpected driver unregister in pciehp_acpi.c
      PCI/PCIe: Clear Root PME Status bits early during system resume
      PCI/ACPI: Request _OSC control once for each root bridge (v3)
      PCI/PM: Use pm_wakeup_event() directly for reporting wakeup events
      PCI/PM: Report wakeup events before resuming devices

Randy Dunlap (1):
      PCI: fix __pci_device_probe kernel-doc warning

Seth Heasley (1):
      x86/PCI: irq and pci_ids patch for Intel Patsburg

Sheng Yang (2):
      PCI: MSI: Move MSI-X entry definition to pci_regs.h
      PCI: Add mask bit definition for MSI-X table

Tejun Heo (1):
      PCI: pci-stub: ignore zero-length id parameters

Yinghai Lu (1):
      PCI: Skip id checking if no id is passed

 arch/x86/Kconfig                        |   10 ++++++-
 arch/x86/pci/broadcom_bus.c             |   11 +++++---
 arch/x86/pci/common.c                   |   41 +++++++++++++++++++++++++++++++
 arch/x86/pci/irq.c                      |    3 +-
 drivers/acpi/apei/hest.c                |   22 +++++++----------
 drivers/acpi/pci_root.c                 |   35 ++++++++++++++++++++++++++
 drivers/media/video/cafe_ccic.c         |    4 +--
 drivers/net/myri10ge/myri10ge.c         |    4 +--
 drivers/net/sfc/falcon.c                |   25 ++++---------------
 drivers/net/skge.c                      |    4 +--
 drivers/net/sky2.c                      |    5 +---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    4 +-
 drivers/pci/hotplug/pciehp_acpi.c       |    3 +-
 drivers/pci/msi.c                       |    5 ++-
 drivers/pci/msi.h                       |    6 ----
 drivers/pci/pci-acpi.c                  |    3 +-
 drivers/pci/pci-driver.c                |    5 ++-
 drivers/pci/pci-stub.c                  |    7 +++++
 drivers/pci/pci-sysfs.c                 |    2 +-
 drivers/pci/pci.c                       |   25 ++----------------
 drivers/pci/pci.h                       |   14 ++++------
 drivers/pci/pcie/aer/aerdrv.c           |    1 +
 drivers/pci/pcie/aer/aerdrv.h           |    3 --
 drivers/pci/pcie/aspm.c                 |   21 +++++++++++++---
 drivers/pci/pcie/pme.c                  |   31 ++++-------------------
 drivers/pci/pcie/portdrv.h              |    5 +--
 drivers/pci/pcie/portdrv_acpi.c         |   23 +++--------------
 drivers/pci/pcie/portdrv_core.c         |   25 ++++++++++--------
 drivers/pci/pcie/portdrv_pci.c          |   37 +++++++++++++++++++++++++---
 drivers/scsi/ipr.c                      |    8 +-----
 drivers/scsi/pmcraid.c                  |    7 +----
 drivers/staging/sm7xx/smtcfb.c          |    2 +-
 include/acpi/apei.h                     |    6 ++++
 include/linux/pci-acpi.h                |    6 ++++
 include/linux/pci-aspm.h                |    5 +++-
 include/linux/pci.h                     |   20 ++++++++++----
 include/linux/pci_ids.h                 |    3 +-
 include/linux/pci_regs.h                |   10 +++++++
 sound/pci/cs5535audio/cs5535audio_pm.c  |    7 +----
 39 files changed, 263 insertions(+), 195 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
