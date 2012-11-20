Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2KTBGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:06:08 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43423 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab2KTBGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:06:04 -0500
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ohad Ben-Cohen <ohad@wizery.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH v5 0/5] OMAP: iommu: hwmod, reset handling and runtime PM
Date: Mon, 19 Nov 2012 19:05:47 -0600
Message-Id: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are needed for remoteproc to work on OMAP4.

Introduced iommu hwmod support for OMAP3 (iva, isp) and
OMAP4 (ipu, dsp), along with the corresponding runtime PM
and routines to deassert reset lines, enable/disable clocks
and configure sysc registers.

A couple of patches were added (first two) to be clearer on
the reasons for such changes, they were previosuly bundled as part
of runtime PM changes. The last patch corresponds to a change in the
leaf clocks used and it depends on this series to work properly.

Due to single Image support, I rebased these on top of k3.7-rc5 and
DEPEND on:

[PATCH v5 0/6] Move rest of omap-iommu to live in drivers/iommu
http://thread.gmane.org/gmane.linux.kernel/1387788

Minor rebasing might be needed if these are included on top of
linux-omap, since they are affected by changes on headers being
moved to include/linux/platform_data and arch/arm/mach-omap2.

Omar Ramirez Luna (5):
  iommu/omap: remove redundant clock handling on ISR
  iommu/omap: keep mmu enabled when requested
  iommu/omap: migrate to hwmod framework
  iommu/omap: adapt to runtime pm
  ARM: OMAP4: hwmod data: ipu and dsp to use parent clocks instead of
    leaf clocks

 arch/arm/mach-omap2/clock44xx_data.c       |   22 ----
 arch/arm/mach-omap2/devices.c              |    2 +-
 arch/arm/mach-omap2/omap-iommu.c           |  167 ++++++---------------------
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    4 +-
 drivers/iommu/omap-iommu.c                 |   68 ++++++-----
 drivers/iommu/omap-iommu.h                 |    3 -
 drivers/iommu/omap-iommu2.c                |   36 ------
 include/linux/platform_data/iommu-omap.h   |    9 +-
 8 files changed, 84 insertions(+), 227 deletions(-)

-- 
1.7.4.1

