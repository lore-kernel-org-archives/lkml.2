Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2EURFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:05:43 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:62875 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2EURFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:05:42 -0400
Date: Mon, 21 May 2012 11:05:39 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [GIT PULL] PCI updates for 3.5 merge window
Message-ID: <20120521170539.GA13635@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the signed tag "pci-for-3.5" to get these PCI changes for the
v3.5 merge window.  I'm a newbie, so don't hesitate to help me improve my
pull requests :)

The changes include:
  - Host bridge cleanups from Yinghai
  - Disable Bus Master bit on PCI device shutdown (kexec-related)
  - Stratus ftServer fix
  - pci_dev_reset() locking fix
  - IvyBridge graphics erratum workaround

Bjorn


The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next

Bjorn Helgaas (6):
      PCI: work around Stratus ftServer broken PCIe hierarchy
      Merge branch 'topic/yinghai-hostbridge-cleanup' into next
      MAINTAINERS: update PCI git tree and patchwork
      Merge branch 'topic/stratus' into next
      x86/PCI: only check for spinlock being held in SMP kernels
      microblaze/PCI: fix "io_offset undeclared" error

Chunhe Lan (1):
      PCI: fix uninitialized variable 'cap_mask'

Khalid Aziz (1):
      PCI: disable Bus Master on PCI device shutdown

Konrad Rzeszutek Wilk (1):
      PCI: move mutex locking out of pci_dev_reset function

Wei Yang (1):
      resources: add resource_overlaps()

Xudong Hao (1):
      PCI: work around IvyBridge internal graphics FLR erratum

Yinghai Lu (12):
      PCI: move host bridge-related code to host-bridge.c
      x86/PCI: fix memleak with get_current_resources()
      PCI: rename pci_host_bridge() to find_pci_root_bridge()
      PCI: add generic device into pci_host_bridge struct
      PCI: add host bridge release support
      x86/PCI: refactor get_current_resources()
      x86/PCI: add host bridge resource release for _CRS path
      x86/PCI: embed name into pci_root_info struct
      x86/PCI: embed pci_sysdata into pci_root_info on ACPI path
      x86/PCI: dynamically allocate pci_root_info for native host bridge drivers
      x86/PCI: merge pcibios_scan_root() and pci_scan_bus_on_node()
      x86/PCI: fix unused variable warning in amd_bus.c

 Documentation/kernel-parameters.txt |    3 +
 MAINTAINERS                         |   10 +--
 arch/microblaze/pci/pci-common.c    |    1 +
 arch/x86/pci/acpi.c                 |  128 ++++++++++++++++-------------
 arch/x86/pci/amd_bus.c              |   91 +++++++++------------
 arch/x86/pci/broadcom_bus.c         |   12 +--
 arch/x86/pci/bus_numa.c             |   69 +++++++++++-----
 arch/x86/pci/bus_numa.h             |   18 +++--
 arch/x86/pci/common.c               |   43 +++++-----
 arch/x86/pci/i386.c                 |    2 +-
 drivers/pci/Makefile                |    2 +-
 drivers/pci/host-bridge.c           |   96 ++++++++++++++++++++++
 drivers/pci/pci-driver.c            |    6 ++
 drivers/pci/pci.c                   |   30 +++++---
 drivers/pci/pcie/portdrv_core.c     |    2 +-
 drivers/pci/probe.c                 |  154 ++++++++++-------------------------
 drivers/pci/quirks.c                |   58 +++++++++++++
 include/asm-generic/pci-bridge.h    |    6 ++
 include/linux/ioport.h              |    7 ++
 include/linux/pci.h                 |    9 ++-
 20 files changed, 442 insertions(+), 305 deletions(-)
 create mode 100644 drivers/pci/host-bridge.c
