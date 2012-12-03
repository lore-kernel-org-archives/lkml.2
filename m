Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2LCCxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:53:22 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:38329 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2LCCxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:53:12 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 0/2] vfio on power: yet another try
Date: Mon,  3 Dec 2012 13:52:56 +1100
Message-Id: <1354503178-2602-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353661396-14374-1-git-send-email-aik@ozlabs.ru>
References: <1353661396-14374-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The set includes 2 patches.

The first one adds necessary support for VFIO IOMMU support,
the second one adds a SPAPR TCE IOMMU driver to VFIO.

At the moment we have decided to get rid of DMA64 window
properties because we need more API than just 2 properties
(such as dynamic window allocation) but have not decided
about its actual design yet.

Alexey Kardashevskiy (2):
  vfio powerpc: enabled on powernv platform
  vfio powerpc: implemented IOMMU driver for VFIO

 arch/powerpc/include/asm/iommu.h     |    9 +
 arch/powerpc/kernel/iommu.c          |  186 ++++++++++++++++++
 arch/powerpc/platforms/powernv/pci.c |  135 +++++++++++++
 drivers/iommu/Kconfig                |    8 +
 drivers/vfio/Kconfig                 |    6 +
 drivers/vfio/Makefile                |    1 +
 drivers/vfio/vfio_iommu_spapr_tce.c  |  350 ++++++++++++++++++++++++++++++++++
 include/linux/vfio.h                 |   26 +++
 8 files changed, 721 insertions(+)
 create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c

-- 
1.7.10.4

