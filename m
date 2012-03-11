Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab2CKRxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:53:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55385 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2CKRxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:53:01 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Ashok Raj <ashok.raj@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenkeping@huawei.com
Subject: [RFC PATCH 0/5] PCI: introduce hotplug safe bus searching interfaces
Date: Mon, 12 Mar 2012 01:48:24 +0800
Message-Id: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on Yinghai's pci root bus hotplug v2, please refer to:
http://www.spinics.net/lists/linux-pci/msg14194.html.
The first three patches are minor bug fixes against the pci root bus hotplug
code. The forth/fifth is a proposal to introduce a series of pci hotplug safe
interfaces to search pci buses. This is aimed to solve possible race
conditions when doing pci root bus/pci bus hotplug. The proposal is here to
show the idea, and hasn't been fully tested yet. If it's on the right way,
I will refine it and do thorough tests.

Jiang Liu (5):
  Fix device reference count leakage in pci_dev_present()
  Correctly clean up pci root buses in function pci_remove_bus()
  Fix an access-after-free issue in function pci_stop_and_remove_bus()
  Introduce hotplug-safe pci bus searching interfaces
  Replace old pci bus searching function calls with hotplug safe ones

 arch/frv/mb93090-mb00/pci-vdk.c        |    2 +-
 arch/x86/pci/common.c                  |    9 +-
 arch/x86/pci/irq.c                     |    2 +-
 arch/x86/pci/legacy.c                  |    2 +-
 drivers/acpi/pci_root.c                |    2 +-
 drivers/acpi/pci_root_hp.c             |    2 +-
 drivers/acpi/pci_slot.c                |    6 +-
 drivers/acpi/reboot.c                  |    3 +-
 drivers/edac/i7core_edac.c             |    2 +-
 drivers/gpu/vga/vgaarb.c               |    3 +-
 drivers/iommu/dmar.c                   |    6 +-
 drivers/pci/bus.c                      |   20 ++++-
 drivers/pci/hotplug/cpci_hotplug_pci.c |    4 +-
 drivers/pci/hotplug/ibmphp_core.c      |    8 +-
 drivers/pci/hotplug/sgi_hotplug.c      |    3 +-
 drivers/pci/hotplug/shpchp_pci.c       |    4 +-
 drivers/pci/hotplug/shpchp_sysfs.c     |    2 +-
 drivers/pci/iov.c                      |    6 +-
 drivers/pci/pci-sysfs.c                |    2 +-
 drivers/pci/pci.c                      |    2 +-
 drivers/pci/pcie/pme.c                 |   16 +---
 drivers/pci/probe.c                    |   11 ++-
 drivers/pci/remove.c                   |   15 ++--
 drivers/pci/search.c                   |  168 ++++++++++++++++++++++++++-----
 drivers/pci/xen-pcifront.c             |    6 +-
 include/linux/pci.h                    |    8 ++
 26 files changed, 230 insertions(+), 84 deletions(-)

-- 
1.7.5.4

