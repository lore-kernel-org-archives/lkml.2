Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab0J1RJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:09:23 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:46042 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933952Ab0J1RJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:09:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=V49+j3gnFFhNjsUAIS3MheefnYGICAdOlIF6RXF7WYUKpqguvFf5ogZNCeAKH/BC8HHLBLdIxgfHIbvjpksk0sVz99l8cCkKmbYo91xj9vs5WYxbMr6iWcnmQxhCQkqy;
Date: Thu, 28 Oct 2010 10:09:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes for 2.6.37
Message-ID: <20101028100918.539d8dc9@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
8fd01d6cfbf75465d84a4e533ed70c5f57b3ff51:

  Export dump_{write,seek} to binary loader modules (2010-10-14 19:15:28 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

Probably the most exciting changes here are the ones from Bjorn to
adjust our resource allocation preferences.  He's been doing a lot of
bug fixing and found a few ways to make our allocations better match
what platforms expect (i.e. the way Windows does them).  I don't think
we're done figuring that out yet (in particular SR-IOV BAR handling is
still a problem for us), but these changes do fix some bad behavior on
many machines, and can save us from having to blacklist and quirk
things all over the place.

Anders Wallin (1):
      PCI: add PCI vendor id for STmicroelectronics

Arnd Bergmann (1):
      PCI: kill BKL in /proc/pci

Bill Pemberton (1):
      PCI: aerdrv: fix uninitialized variable warning

Bjorn Helgaas (12):
      PCI: log vendor/device ID always
      PCI: fix message typo
      x86/PCI: MMCONFIG: fix region end calculation
      resources: add a default alignf to simplify find_resource()
      resources: factor out resource_clip() to simplify find_resource()
      resources: ensure callback doesn't allocate outside available space
      resources: handle overflow when aligning start of available area
      resources: support allocating space within a region from the top down
      PCI: allocate bus resources from the top down
      x86/PCI: allocate space from the end of a region, not the beginning
      x86: update iomem_resource end based on CPU physical address capabilities
      x86: allocate space within a region top-down

Daniel Drake (1):
      PCI: OLPC: Only enable PCI configuration type override on XO-1

Hidetoshi Seto (1):
      PCI: add PCI_MSIX_TABLE/PBA defines

Julia Lawall (1):
      PCI: Adjust confusing if indentation in pcie_get_readrq

Matthew Garrett (2):
      PCI: Export some PCI PM functionality
      PCI: Add support for polling PME state on suspended legacy PCI devices

Neil Horman (1):
      PCI: add quirk for non-symmetric-mode irq routing to versions 0 and 4 of the MCP55 northbridge

Rafael J. Wysocki (1):
      PCI/PCIe/AER: Disable native AER service if BIOS has precedence

Seth Heasley (2):
      x86/PCI: irq and pci_ids patch for Intel Patsburg DeviceIDs
      PCI: update Intel chipset names and defines

Stephen Hemminger (1):
      PCI: pci_driver make name const

Thomas Gleixner (1):
      PCI hotplug: ibmphp-hpc: semaphore cleanup

matt mooney (1):
      PCI: use new ccflags variable in Makefile

 Documentation/kernel-parameters.txt |    5 +
 arch/x86/Kconfig                    |    2 +-
 arch/x86/kernel/olpc.c              |    6 +-
 arch/x86/kernel/setup.c             |    2 +
 arch/x86/pci/i386.c                 |   17 +++--
 arch/x86/pci/irq.c                  |   11 ++-
 arch/x86/pci/mmconfig-shared.c      |    4 +-
 arch/x86/pci/olpc.c                 |    2 +-
 drivers/i2c/busses/Kconfig          |    4 +-
 drivers/i2c/busses/i2c-i801.c       |   10 +-
 drivers/pci/Makefile                |    4 +-
 drivers/pci/bus.c                   |   53 +++++++++++-
 drivers/pci/hotplug/ibmphp_hpc.c    |    4 +-
 drivers/pci/msi.h                   |    4 +-
 drivers/pci/pci.c                   |   79 ++++++++++++++++++-
 drivers/pci/pci.h                   |    3 -
 drivers/pci/pcie/aer/aerdrv.c       |    2 +-
 drivers/pci/pcie/aer/aerdrv.h       |    3 +
 drivers/pci/pcie/aer/aerdrv_acpi.c  |   34 ++++++++
 drivers/pci/pcie/aer/aerdrv_core.c  |    2 +-
 drivers/pci/pcie/portdrv_acpi.c     |    2 +-
 drivers/pci/probe.c                 |    4 +-
 drivers/pci/proc.c                  |    4 +-
 drivers/pci/quirks.c                |   31 +++++++
 drivers/pci/setup-res.c             |    2 +-
 include/linux/ioport.h              |    1 +
 include/linux/pci.h                 |    5 +-
 include/linux/pci_ids.h             |   21 +++--
 include/linux/pci_regs.h            |    6 +-
 kernel/resource.c                   |  151 +++++++++++++++++++++++++++++++----
 30 files changed, 401 insertions(+), 77 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center
