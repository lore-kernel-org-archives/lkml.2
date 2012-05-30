Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2E3USv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:18:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2E3USt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:18:49 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 0/7] IOMMU: Groups support
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com,
        alex.williamson@redhat.com, liuj97@gmail.com
Date: Wed, 30 May 2012 14:18:29 -0600
Message-ID: <20120530201424.31527.33142.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
 - Trickle down changes from pci_get_dma_source() to better handle
   PCI device reference counting in IOMMU driver patches

This depends on v2 PCI patches:

http://marc.info/?l=linux-kernel&m=133840870510712

Thanks,

Alex

v1:
These are the IOMMU related patches from the v2 IOMMU Groups +
VFIO series.  I've separated out PCI and VFIO to try to make
progress on the foundation we need for VFIO.  Patches 5 & 6
of this series depend on patches 1 & 2 of the PCI series found
here:

http://marc.info/?l=linux-kernel&m=133835363021384

Patch 1 adds an iommu_group pointer to struct device so that we
have a place to link a device to a specific iommu group.  GregKH
has already acked this, so it should go in with the group support
itself.  Patch 2 is the core of the IOMMU group support.  Patches
3 & 4 allow groups to be created on AMD-Vi and Intel VT-d systems.
Patches 5 & 6 make use of the additional PCI DMA quirks and ACS
support checking to make groups more secure.  Patch 7 removes the
iommu=group_mf option as ACS checking results in most multifunction
devices being grouped already.

These patches, as well as the PCI support patches and VFIO can be
found in git here:

git://github.com/awilliam/linux-vfio.git (iommu-group-vfio-next-20120529)

Please consider these for 3.5, but I'll settle for any kind of next
branch.  Thanks,

Alex

---

Alex Williamson (7):
      iommu: Remove group_mf
      intel-iommu: Make use of DMA quirks and ACS checks in IOMMU groups
      amd_iommu: Make use of DMA quirks and ACS checks in IOMMU groups
      intel-iommu: Support IOMMU groups
      amd_iommu: Support IOMMU groups
      iommu: IOMMU Groups
      driver core: Add iommu_group tracking to struct device


 .../ABI/testing/sysfs-kernel-iommu_groups          |   14 
 Documentation/kernel-parameters.txt                |    1 
 arch/ia64/include/asm/iommu.h                      |    2 
 arch/ia64/kernel/pci-dma.c                         |    1 
 arch/x86/include/asm/iommu.h                       |    1 
 arch/x86/kernel/pci-dma.c                          |   11 
 drivers/iommu/amd_iommu.c                          |   70 ++
 drivers/iommu/intel-iommu.c                        |   89 ++-
 drivers/iommu/iommu.c                              |  578 +++++++++++++++++++-
 include/linux/device.h                             |    2 
 include/linux/iommu.h                              |  104 +++-
 11 files changed, 767 insertions(+), 106 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-iommu_groups
