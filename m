Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1IBRdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:33:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39734 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1IBRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:32:59 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH/RFC 0/7] iommu: fixes & extensions
Date: Fri,  2 Sep 2011 20:32:29 +0300
Message-Id: <1314984756-4400-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5 first patches are relatively small iommu fixes/cleanups.

2 last patches are proposals for core iommu extensions:
- Add fault report mechanism, needed for recovery of remote processors
  trying to access unmapped addresses.
- Add splitting of memory regions to pages in the iommu core itself
  (according to hardware capabilities as advertised by the iommu drivers).
  This is needed to prevent duplication of this logic by
  the iommu users/drivers themselves.

The patches are based on Joerg's arm/omap branch.

Tested with OMAP3 (omap3isp) + OMAP4 (rpmsg/remoteproc).

Laurent Pinchart (1):
  iommu/omap-iovmm: support non page-aligned buffers in iommu_vmap

Ohad Ben-Cohen (6):
  iommu/omap: cleanup: remove a redundant 'return' statement
  iommu/core: use the existing IS_ALIGNED macro
  iommu/omap: ->unmap() should return order of unmapped page
  iommu/msm: ->unmap() should return order of unmapped page
  iommu/core: add fault reporting
  iommu/core: split mapping to page sizes as supported by the hardware

 arch/arm/plat-omap/include/plat/iommu.h |    3 +-
 drivers/iommu/iommu.c                   |  142 +++++++++++++++++++++++++++----
 drivers/iommu/msm_iommu.c               |   15 +++-
 drivers/iommu/omap-iommu.c              |   56 +++---------
 drivers/iommu/omap-iovmm.c              |   50 +++++++-----
 drivers/media/video/omap3isp/isp.c      |    2 +-
 include/linux/iommu.h                   |   67 ++++++++++++++-
 virt/kvm/iommu.c                        |    6 +-
 8 files changed, 251 insertions(+), 90 deletions(-)

-- 
1.7.4.1

