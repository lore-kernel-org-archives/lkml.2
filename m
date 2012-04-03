Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2DCCUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:20:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21714 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2DCCUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:20:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 00/14] IOMMU: irq-remapping and dmar hotplug support
Date: Mon,  2 Apr 2012 19:19:27 -0700
Message-Id: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F7A5E46.004C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During pci root bus hot-add, ioapic and iommu need to be parsed at first.
Using acpi_pci_driver->add to do that.

The patches need to apply to for-pci-root-bus-hotplug and for-x86-irq
and those two patches have been rebased to 3.4-rc1.

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-iommu

Thanks

Yinghai

Yinghai Lu (14):
  ACPI, PCI: Stop pci devices before acpi_pci_driver remove calling
  PCI, x86: Move pci_enable_bridges() down
  ACPI, PCI: Skip extra pci_enable_bridges for non hot-add root
  PCI: set dev_node early for pci_dev
  IOMMU: Update dmar units devices list during hotplug
  IOMMU: Fix tboot force iommu logic
  IOMMU: Don't clean handler data before free_irq()
  IOMMU: iommu_unique_seq_id()
  ACPI: Add acpi_run_dsm()
  IOMMU: Separate free_dmar_iommu from free_iommu
  IOMMU: Add init_dmar_one()
  IOMMU: Add intel_enable_irq_remapping_one()
  IOMMU: Add dmar_parse_one_drhd()
  IOMMU: Add intel iommu irq-remapping and dmar hotplug support

 arch/x86/pci/legacy.c               |    1 +
 drivers/acpi/bus.c                  |   77 +++++++
 drivers/acpi/pci_root.c             |   15 +-
 drivers/acpi/pci_root_hp.c          |    1 +
 drivers/iommu/dmar.c                |  420 +++++++++++++++++++++++++++++++++--
 drivers/iommu/intel-iommu.c         |  167 ++++++++++++--
 drivers/iommu/intel_irq_remapping.c |  172 ++++++++++++++-
 drivers/pci/probe.c                 |    2 +
 drivers/pci/remove.c                |    2 +-
 drivers/pci/setup-bus.c             |    2 -
 include/acpi/acpi_bus.h             |    1 +
 include/linux/acpi.h                |   10 +
 include/linux/dmar.h                |   59 +++++-
 include/linux/pci.h                 |    1 +
 14 files changed, 867 insertions(+), 63 deletions(-)

-- 
1.7.7

