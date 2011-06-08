Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1FHIf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:35:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58874 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1FHIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:35:54 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 0/4] drivers/iommu/ relocations
Date: Wed,  8 Jun 2011 11:34:18 +0300
Message-Id: <1307522062-19273-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a dedicated iommu drivers folder, put the base iommu code there,
and move the existing IOMMU API users as well (msm-iommu, amd_iommu and
intel-iommu).

Putting all iommu drivers together will ease finding similarities
between different platforms, with the intention of solving problems once,
in a generic framework, which everyone can use.

OMAP's iommu will be moved too as soon as it's migrated.

For previous discussions on this, please see:
https://lkml.org/lkml/2011/6/2/369

Ohad Ben-Cohen (4):
  drivers: iommu: move to a dedicated folder
  msm: iommu: move to drivers/iommu/
  x86: amd_iommu: move to drivers/iommu/
  x86: intel-iommu: move to drivers/iommu/

 arch/arm/mach-msm/Kconfig                          |   15 ------
 arch/arm/mach-msm/Makefile                         |    2 +-
 arch/x86/Kconfig                                   |   40 ---------------
 arch/x86/kernel/Makefile                           |    2 +-
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/base/Makefile                              |    1 -
 drivers/iommu/Kconfig                              |   53 ++++++++++++++++++++
 drivers/iommu/Makefile                             |    4 ++
 {arch/x86/kernel => drivers/iommu}/amd_iommu.c     |    0
 drivers/{pci => iommu}/intel-iommu.c               |    1 -
 drivers/{base => iommu}/iommu.c                    |    0
 .../mach-msm/iommu.c => drivers/iommu/msm-iommu.c  |    0
 drivers/pci/Makefile                               |    2 +-
 drivers/pci/pci.h                                  |    2 -
 include/linux/pci.h                                |   11 ++++
 16 files changed, 74 insertions(+), 62 deletions(-)
 create mode 100644 drivers/iommu/Kconfig
 create mode 100644 drivers/iommu/Makefile
 rename {arch/x86/kernel => drivers/iommu}/amd_iommu.c (100%)
 rename drivers/{pci => iommu}/intel-iommu.c (99%)
 rename drivers/{base => iommu}/iommu.c (100%)
 rename arch/arm/mach-msm/iommu.c => drivers/iommu/msm-iommu.c (100%)

