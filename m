Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2CFHOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:14:39 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16478 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab2CFHOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:14:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/23] PCI, x86: pci root bus hotplug support
Date: Mon,  5 Mar 2012 23:13:37 -0800
Message-Id: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090202.4F55B95C.0017,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will add pci_stop_and_remove_bus() to support remove bus in
/sys/devices/pci.../pci_bus/...

it support pci root bus removal.

To rescan root, need to
echo 1 > /sys/bus/pci/rescan_root

this patcheset include some IOMM and dmar and pnpacpi fix with device refcount leaking.

The patches need to apply to pci/for-linus and pci/linux-next
and [PATCH 00/36] PCI: pci_host_bridge related cleanup and busn_alloc

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug

Thanks

Yinghai

Yinghai Lu (23):
  PCI, sys: Use device_type and attr_groups with pci dev
  PCI, sysfs: create rescan_bridge under /sys/.../pci/devices/... for pci bridges
  PCI: Add pci_bus_add_single_device()
  PCI: make pci_rescan_bus_bridge_resize use pci_scan_bridge instead
  PCI: clean up rescan_bus_bridge_resize
  PCI: rescan with bus or bridge using callback method too
  pci, dmar: Update dmar units devices list during hotplug
  PNPACPI: Fix device ref leaking in acpi_pnp_match
  IOMMU: Fix tboot force iommu logic
  PCI, x86: Fix non acpi path pci_sysdata leaking with release_fn
  PCI: separate out pci_assign_unassigned_bus_resources()
  PCI: Move back pci_rescan_bus()
  PCI: move pci_stop_and_remove_behind_bridge down
  PCI: add __pci_remove_bus_devices()
  PCI: add pci_stop_and_remove_bus()
  PCI: add pci bus removal through /sys/.../pci_bus/.../remove
  PCI, ACPI: make acpi_pci_root_remove remove pci root bus too
  PCI, ACPI: add acpi_pci_root_rescan()
  PCI: add /sys/bus/pci/rescan_root
  PCI: add __pci_scan_root_bus() that can skip bus_add
  x86, PCI: add __pci_scan_root_bus_on_node() that can skip bus_add
  x86, PCI: add __pcibios_scan_specific_bus that can skip bus_add
  x86, PCI: add pcibios_root_rescan

 Documentation/ABI/testing/sysfs-bus-pci |   27 +++++
 arch/x86/include/asm/pci.h              |    2 +
 arch/x86/pci/common.c                   |   28 +++--
 arch/x86/pci/legacy.c                   |   44 ++++++-
 drivers/acpi/pci_root.c                 |   66 +++++++++++
 drivers/iommu/intel-iommu.c             |  193 ++++++++++++++++++++++++++++--
 drivers/pci/bus.c                       |   39 ++++++
 drivers/pci/pci-sysfs.c                 |  137 ++++++++++++++++++++--
 drivers/pci/pci.h                       |    1 +
 drivers/pci/probe.c                     |   43 ++++++-
 drivers/pci/remove.c                    |   77 ++++++++-----
 drivers/pci/setup-bus.c                 |   20 +---
 drivers/pnp/pnpacpi/core.c              |    7 +-
 include/linux/dmar.h                    |    4 +
 include/linux/pci.h                     |    6 +
 15 files changed, 604 insertions(+), 90 deletions(-)

-- 
1.7.7

