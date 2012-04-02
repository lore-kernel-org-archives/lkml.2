Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2DBVOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:14:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2DBVOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:14:51 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 0/3] IOMMU groups
To: david@gibson.dropbear.id.au, dwmw2@infradead.org
Cc: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        qemu-devel@nongnu.org, joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 02 Apr 2012 15:14:32 -0600
Message-ID: <20120402203721.28977.95285.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series attempts to make IOMMU device grouping a slightly more
integral part of the device model.  iommu_device_groups were originally
introduced to support the VFIO user space driver interface which needs
to understand the granularity of device isolation in order to ensure
security of devices when assigned for user access.  This information
was provided via a simple group identifier from the IOMMU driver allowing
VFIO to walk devices and assemble groups itself.

The feedback received from this was that groups should be the effective
unit of work for the IOMMU API.  The existing model of allowing domains
to be created and individual devices attached ignores many of the
restrictions of the IOMMU, whether by design, by topology or by defective
devices.  Additionally we should be able to use the grouping information
at the dma ops layer for managing domains and quirking devices.

This series is a sketch at implementing only those aspects and leaving
everything else about the multifaceted hairball of Isolation groups for
another API.  Please comment and let me know if this seems like the
direction we should be headed.  Thanks,

Alex


---

Alex Williamson (3):
      iommu: Create attach/detach group interface
      iommu: Create basic group infrastructure and update AMD-Vi & Intel VT-d
      iommu: Introduce iommu_group


 drivers/iommu/amd_iommu.c   |   50 ++++++----
 drivers/iommu/intel-iommu.c |   76 ++++++++--------
 drivers/iommu/iommu.c       |  210 ++++++++++++++++++++++++++++++++++++++-----
 include/linux/device.h      |    2 
 include/linux/iommu.h       |   43 +++++++++
 5 files changed, 301 insertions(+), 80 deletions(-)
