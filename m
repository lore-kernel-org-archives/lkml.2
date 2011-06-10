Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab1FJV5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:57:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41520 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1FJV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:57:18 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 0/4] drivers/iommu/ relocations
Date: Sat, 11 Jun 2011 00:55:43 +0300
Message-Id: <1307742947-32118-1-git-send-email-ohad@wizery.com>
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

v1->v2

* move intel's iova, intr_remapping and dmar too (David Woodhouse)
* move msm's iommu_dev as well (David Brown)
* dmar: depend on x86/ia64, fix ia64 Kconfig, drop EXPERIMENTAL (Chris Wright)

Ohad Ben-Cohen (4):
  drivers: iommu: move to a dedicated folder
  msm: iommu: move to drivers/iommu/
  x86: amd_iommu: move to drivers/iommu/
  x86/ia64: intel-iommu: move to drivers/iommu/

 arch/arm/mach-msm/Kconfig                          |   19 ----
 arch/arm/mach-msm/Makefile                         |    2 +-
 arch/ia64/Kconfig                                  |   24 -----
 arch/x86/Kconfig                                   |   79 ----------------
 arch/x86/kernel/Makefile                           |    2 +-
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/base/Makefile                              |    1 -
 drivers/iommu/Kconfig                              |   97 ++++++++++++++++++++
 drivers/iommu/Makefile                             |    5 +
 {arch/x86/kernel => drivers/iommu}/amd_iommu.c     |    0
 drivers/{pci => iommu}/dmar.c                      |    0
 drivers/{pci => iommu}/intel-iommu.c               |    1 -
 drivers/{pci => iommu}/intr_remapping.c            |    1 -
 drivers/{pci => iommu}/intr_remapping.h            |    0
 drivers/{base => iommu}/iommu.c                    |    0
 drivers/{pci => iommu}/iova.c                      |    0
 .../mach-msm/iommu.c => drivers/iommu/msm_iommu.c  |    0
 .../iommu_dev.c => drivers/iommu/msm_iommu_dev.c   |    0
 drivers/pci/Makefile                               |    5 -
 drivers/pci/pci.h                                  |    2 -
 include/linux/pci.h                                |   11 ++
 22 files changed, 118 insertions(+), 134 deletions(-)
 create mode 100644 drivers/iommu/Kconfig
 create mode 100644 drivers/iommu/Makefile
 rename {arch/x86/kernel => drivers/iommu}/amd_iommu.c (100%)
 rename drivers/{pci => iommu}/dmar.c (100%)
 rename drivers/{pci => iommu}/intel-iommu.c (99%)
 rename drivers/{pci => iommu}/intr_remapping.c (99%)
 rename drivers/{pci => iommu}/intr_remapping.h (100%)
 rename drivers/{base => iommu}/iommu.c (100%)
 rename drivers/{pci => iommu}/iova.c (100%)
 rename arch/arm/mach-msm/iommu.c => drivers/iommu/msm_iommu.c (100%)
 rename arch/arm/mach-msm/iommu_dev.c => drivers/iommu/msm_iommu_dev.c (100%)

