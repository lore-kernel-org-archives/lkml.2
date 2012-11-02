Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2KBTX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:23:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25185 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897Ab2KBTX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:23:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19++4ky7V40YxDE6WmKjulW
Subject: [PATCH v5 0/6] Move rest of omap-iommu to live in drivers/iommu
To: linux-kernel@vger.kernel.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Fri, 02 Nov 2012 12:23:54 -0700
Message-ID: <20121102192221.4253.34303.stgit@muffinssi.local>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Resending again, now using the updated email address
for Joerg.

We need to move the iommu code to live under drivers
for arm common zImage support.

Regards,

Tony

---

Ido Yariv (3):
      ARM: OMAP: Merge iommu2.h into iommu.h
      ARM: OMAP2+: Move iopgtable header to drivers/iommu/
      ARM: OMAP2+: Make some definitions local

Tony Lindgren (3):
      ARM: OMAP2+: Move plat/iovmm.h to include/linux/omap-iommu.h
      ARM: OMAP2+: Move iommu2 to drivers/iommu/omap-iommu2.c
      ARM: OMAP2+: Move iommu/iovmm headers to platform_data


 arch/arm/mach-omap2/Makefile                |    2 
 arch/arm/mach-omap2/devices.c               |    2 
 arch/arm/mach-omap2/omap-iommu.c            |    2 
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c  |    2 
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c  |    2 
 arch/arm/plat-omap/include/plat/iommu2.h    |   96 -------------------
 arch/arm/plat-omap/include/plat/iovmm.h     |   89 ------------------
 drivers/iommu/Makefile                      |    1 
 drivers/iommu/omap-iommu-debug.c            |    8 +-
 drivers/iommu/omap-iommu.c                  |   39 ++++++++
 drivers/iommu/omap-iommu.h                  |  133 ++++++++++++++-------------
 drivers/iommu/omap-iommu2.c                 |   11 ++
 drivers/iommu/omap-iopgtable.h              |   22 ----
 drivers/iommu/omap-iovmm.c                  |   50 ++++++++++
 drivers/media/platform/omap3isp/isp.c       |    1 
 drivers/media/platform/omap3isp/isp.h       |    4 -
 drivers/media/platform/omap3isp/ispccdc.c   |    1 
 drivers/media/platform/omap3isp/ispstat.c   |    1 
 drivers/media/platform/omap3isp/ispvideo.c  |    3 -
 include/linux/omap-iommu.h                  |   52 +++++++++++
 include/linux/platform_data/iommu-omap.h    |   49 ++++++++++
 21 files changed, 279 insertions(+), 291 deletions(-)
 delete mode 100644 arch/arm/plat-omap/include/plat/iommu2.h
 delete mode 100644 arch/arm/plat-omap/include/plat/iovmm.h
 rename arch/arm/plat-omap/include/plat/iommu.h => drivers/iommu/omap-iommu.h (69%)
 rename arch/arm/mach-omap2/iommu2.c => drivers/iommu/omap-iommu2.c (96%)
 rename arch/arm/plat-omap/include/plat/iopgtable.h => drivers/iommu/omap-iopgtable.h (85%)
 create mode 100644 include/linux/omap-iommu.h
 create mode 100644 include/linux/platform_data/iommu-omap.h

-- 
Signature
