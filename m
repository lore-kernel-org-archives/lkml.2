Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab2E3FKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab2E3FKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:10:19 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/7] IOMMU: Groups support
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com,
        alex.williamson@redhat.com
Date: Tue, 29 May 2012 23:10:01 -0600
Message-ID: <20120530045150.1543.73660.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/iommu/amd_iommu.c                          |   62 +-
 drivers/iommu/intel-iommu.c                        |   82 ++-
 drivers/iommu/iommu.c                              |  578 +++++++++++++++++++-
 include/linux/device.h                             |    2 
 include/linux/iommu.h                              |  104 +++-
 11 files changed, 751 insertions(+), 107 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-iommu_groups
