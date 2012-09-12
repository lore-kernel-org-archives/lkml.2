Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2ILTqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:46:01 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57246 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2ILTp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:45:58 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v2 0/9] OMAP: iommu: hwmod, reset handling and runtime PM
Date: Wed, 12 Sep 2012 14:45:43 -0500
Message-Id: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are needed for remoteproc to work on OMAP4.

Introduced iommu hwmod support for OMAP3 (iva, isp) and
OMAP4 (ipu, dsp), along with the corresponding runtime PM
and routines to deassert reset lines, enable/disable clocks
and configure sysc registers.

Due to compatibility an ifdef needs to be propagated (previously
on iommu resource info) to hwmod data in OMAP3, so users of iommu
and tidspbridge can avoid issues of two modules managing mmu
data/irqs/resets; this until tidspbridge can be safely migrated
to iommu framework.

Although IOMMU hwmod patches were already submitted in the past,
this series adds few more changes, like:
- New reset handling, based on a series that was accepted
  but *NOT YET* in mainline.

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg73111.html
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg75105.html

- Fix for compile break if IOMMU_API is not selected.
- Save and restore context code rework.
- Device tree bindings for OMAP3 and OMAP4.

Previous work can be found at:
[v1]
  http://www.mail-archive.com/linux-omap@vger.kernel.org/msg70447.html

[old iteration without reset, save/restore and device tree]
  http://www.mail-archive.com/linux-omap@vger.kernel.org/msg60133.html

Omar Ramirez Luna (9):
  ARM: OMAP: iommu: fix including iommu.h without IOMMU_API selected
  ARM: OMAP3: hwmod data: add mmu data for iva and isp
  ARM: OMAP4: hwmod data: add mmu hwmod for ipu and dsp
  ARM: OMAP3/4: iommu: migrate to hwmod framework
  ARM: OMAP3/4: iommu: adapt to runtime pm
  ARM: OMAP: iommu: pm runtime save and restore context
  ARM: OMAP: iommu: optimize save and restore routines
  ARM: OMAP: iommu: add device tree support
  arm/dts: OMAP3/4: Add iommu nodes

 .../devicetree/bindings/arm/omap/iommu.txt         |   10 ++
 arch/arm/boot/dts/omap3.dtsi                       |   12 +-
 arch/arm/boot/dts/omap4.dtsi                       |   17 +-
 arch/arm/mach-omap2/devices.c                      |    2 +-
 arch/arm/mach-omap2/iommu2.c                       |   74 +++------
 arch/arm/mach-omap2/omap-iommu.c                   |  168 +++++---------------
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  121 ++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  136 +++++++++++++++-
 arch/arm/plat-omap/include/plat/iommu.h            |   35 +++-
 arch/arm/plat-omap/include/plat/iommu2.h           |    4 -
 drivers/iommu/omap-iommu.c                         |  163 +++++++++++++++----
 11 files changed, 511 insertions(+), 231 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/iommu.txt

-- 
1.7.9.5

