Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1JUT4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 15:56:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab1JUT4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 15:56:34 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/4] iommu: iommu_ops group interface
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        dwg@au1.ibm.com, scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org, alex.williamson@redhat.com
Date: Fri, 21 Oct 2011 13:55:58 -0600
Message-ID: <20111021195412.8438.9951.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMUs can't always distiguish transactions from each individual
device in a system.  Sometimes this is by design (such as powerpc
partitionable endpoints), other times by topology (PCIe-to-PCI
bridges masking downstream devices).  We call these sets of
indistinguishable devices "groups".

In order to support secure userspace drivers, like vfio, we need
an interface to expose the device-to-group relationship.  This
allows us to create policies ensuring that userspace controls all
of the devices in the group before allowing individual device
access.

This series implements the iommu_ops API interface and sysfs
interface for exposing groups to userspace.  This also includes
the intel-iommu and amd-iommu backend implementations.  It's
intended that the vfio driver will make use of these interfaces
to support generic device assignment for virtual machines.  See
git://github.com/awilliam/linux-vfio.git (vfio-ng) for a working
example using this interface.

Patches based on Joerg's next branch to support per-bus iommu_ops.

Note the amd-iommu is untested, I'm still working on setting up
an AMD-Vi capable system.  Thanks,

Alex

---

Alex Williamson (4):
      iommu: Add option to group multi-function devices
      amd-iommu: Implement iommu_device_group
      intel-iommu: Implement iommu_device_group
      iommu: Add iommu_device_group callback and iommu_group sysfs entry


 Documentation/kernel-parameters.txt |    4 ++
 arch/ia64/include/asm/iommu.h       |    2 +
 arch/ia64/kernel/pci-dma.c          |    1 +
 arch/x86/include/asm/iommu.h        |    1 +
 arch/x86/kernel/pci-dma.c           |   11 ++++++
 drivers/iommu/amd_iommu.c           |   21 ++++++++++++
 drivers/iommu/intel-iommu.c         |   47 +++++++++++++++++++++++++++
 drivers/iommu/iommu.c               |   61 +++++++++++++++++++++++++++++++++++
 include/linux/iommu.h               |    7 ++++
 9 files changed, 154 insertions(+), 1 deletions(-)
