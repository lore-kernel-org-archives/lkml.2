Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab1JQL26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:28:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56423 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1JQL24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:28:56 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v4 0/7] iommu: split mapping to page sizes as supported by the hardware
Date: Mon, 17 Oct 2011 13:27:19 +0200
Message-Id: <1318850846-16066-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3->v4:
- simplify splitter logic (Joerg)
- declare supported page-sizes in the iommu_ops, without extending iommu_register (Joerg)
- iommu_unmap should now return bytes too (Joerg)
- don't cache min_pgsize anymore (Joerg)
- handle cases when ->unmap() actually unmaps more than requested (Joerg)
- unroll iommu_unmap completely in case it fails (KyongHo)
- use size_t for size parameters (KyongHo)
- add a patch to remove the bytes->order->bytes conversion we had
- rabase to master branch of the iommu tree (Joerg)

v2->v3:
- s/KB/KiB/ (David W)

v1->v2:
- split to patches (by keeping the old code around until all drivers are converted) (Joerg)

Tested with OMAP3 (omap3isp) and OMAP4 (rpmsg/remoteproc).
Compile tested with X86_64.

Ohad Ben-Cohen (7):
  iommu/core: stop converting bytes to page order back and forth
  iommu/core: split mapping to page sizes as supported by the hardware
  iommu/omap: announce supported page sizes
  iommu/msm: announce supported page sizes
  iommu/amd: announce supported page sizes
  iommu/intel: announce supported page sizes
  iommu/core: remove the temporary pgsize settings

 drivers/iommu/amd_iommu.c   |   32 +++++++++---
 drivers/iommu/intel-iommu.c |   30 ++++++++---
 drivers/iommu/iommu.c       |  119 ++++++++++++++++++++++++++++++++++++++----
 drivers/iommu/msm_iommu.c   |   25 ++++-----
 drivers/iommu/omap-iommu.c  |   18 +++---
 drivers/iommu/omap-iovmm.c  |   17 ++----
 include/linux/iommu.h       |   26 +++++++--
 virt/kvm/iommu.c            |    8 ++--
 8 files changed, 205 insertions(+), 70 deletions(-)

-- 
1.7.4.1

