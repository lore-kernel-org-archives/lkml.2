Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab0HaPtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:49:11 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:34257 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757675Ab0HaPtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:49:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MCR0+zpfXd9GbxlU0U9ORNIi3AcgQQVcUDQts3e4PSYi/Ty/eTYLOc5p174FhsKi9hapV5X3Jb2s/YT7329grb3aHza/Jw0UEpyFH0naDvhl1UUmKz+VKOhYoTW1MCba;
Date: Tue, 31 Aug 2010 08:49:11 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20100831084911.40ee44ca@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
502adf5778f4151dcba3f64dd6ed322151f3712c:

  Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-08-24 12:21:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

As promised, here are the changes from Rafael and Kenji-san that fix up
our OSC handling to conform much better to what platforms expect.  The
patchset does include some cleanups, but overall I'd consider it a
major bugfix.  However if you'd like me to refactor things, I can.

Dave Airlie (1):
      PCI: provide stub pci_domain_nr function for !CONFIG_PCI configs

Jesse Barnes (1):
      x86/PCI: only define pci_domain_nr if PCI and PCI_DOMAINS are set

Kenji Kaneshige (1):
      PCI: PCIe: Remove the port driver module exit routine

Rafael J. Wysocki (10):
      PCI: PCIe AER: Introduce pci_aer_available()
      PCI: PCIe: Introduce commad line switch for disabling port services
      ACPI/PCI: Reorder checks in acpi_pci_osc_control_set()
      ACPI/PCI: Make acpi_pci_query_osc() return control bits
      ACPI/PCI: Do not preserve _OSC control bits returned by a query
      ACPI/PCI: Negotiate _OSC control bits before requesting them
      PCI: PCIe: Ask BIOS for control of all native services at once
      PCI: PCIe: Disable PCIe port services during port initialization
      PCI: PCIe: Move PCIe PME code to the pcie directory
      PCI hotplug: Fix build with CONFIG_ACPI unset

 Documentation/kernel-parameters.txt        |   17 +++--
 arch/x86/include/asm/pci.h                 |    6 +-
 drivers/acpi/pci_root.c                    |   97 ++++++++++++++++------------
 drivers/pci/hotplug/acpi_pcihp.c           |    6 +-
 drivers/pci/hotplug/pciehp.h               |   16 +----
 drivers/pci/hotplug/pciehp_acpi.c          |    4 +-
 drivers/pci/hotplug/pciehp_core.c          |    4 +-
 drivers/pci/pci.h                          |    2 +
 drivers/pci/pcie/Makefile                  |    3 +-
 drivers/pci/pcie/aer/aerdrv.c              |    9 ++-
 drivers/pci/pcie/aer/aerdrv_acpi.c         |   36 ----------
 drivers/pci/pcie/aer/aerdrv_core.c         |   14 +----
 drivers/pci/pcie/{pme/pcie_pme.c => pme.c} |   66 ++-----------------
 drivers/pci/pcie/pme/Makefile              |    8 --
 drivers/pci/pcie/pme/pcie_pme.h            |   28 --------
 drivers/pci/pcie/pme/pcie_pme_acpi.c       |   54 ---------------
 drivers/pci/pcie/portdrv.h                 |   22 ++++++
 drivers/pci/pcie/portdrv_acpi.c            |   77 ++++++++++++++++++++++
 drivers/pci/pcie/portdrv_core.c            |   53 ++++++++++++++-
 drivers/pci/pcie/portdrv_pci.c             |   38 +++++++++--
 include/acpi/acpi_bus.h                    |    3 -
 include/linux/acpi.h                       |    4 +-
 include/linux/pci.h                        |    3 +
 23 files changed, 280 insertions(+), 290 deletions(-)
 rename drivers/pci/pcie/{pme/pcie_pme.c => pme.c} (83%)
 delete mode 100644 drivers/pci/pcie/pme/Makefile
 delete mode 100644 drivers/pci/pcie/pme/pcie_pme.h
 delete mode 100644 drivers/pci/pcie/pme/pcie_pme_acpi.c
 create mode 100644 drivers/pci/pcie/portdrv_acpi.c

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
