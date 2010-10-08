Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab0JHRdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:33:22 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48403 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101Ab0JHRdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:33:21 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [RFC PATCH 00/11] ppc: enable dynamic dma window support
Date: Fri,  8 Oct 2010 10:33:01 -0700
Message-Id: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series, which builds upon the series of cleanups I posted
on 9/15 as "ppc iommu cleanups", enables the pseries firmware feature
dynamic dma windows. This feature will allow future devices to have a
64-bit DMA mapping covering all memory, coexisting with a smaller IOMMU
window in 32-bit PCI space.

Comments requested and welcome!

Nishanth Aravamudan (11):
  macio: ensure all dma routines get copied over
  ppc: allow direct and iommu to coexist
  ppc: Create ops to choose between direct window and iommu based on
    device mask
  ppc: add memory_hotplug_max
  ppc: do not search for dma-window property on dlpar remove
  ppc: checking for pdn->parent is redundant
  ppc/iommu: do not need to check for dma_window == NULL
  ppc/iommu: remove unneeded pci_dma_bus_setup_pSeriesLP
  ppc/iommu: pass phb only to iommu_table_setparms_lpar
  ppc/iommu: add routines to pseries iommu to map tces 1-1
  ppc: add dynamic dma window support

 arch/powerpc/include/asm/device.h      |   20 +-
 arch/powerpc/include/asm/dma-mapping.h |    6 +-
 arch/powerpc/include/asm/iommu.h       |    6 +-
 arch/powerpc/include/asm/mmzone.h      |    5 +
 arch/powerpc/kernel/Makefile           |    2 +-
 arch/powerpc/kernel/dma-choose64.c     |  167 +++++++++++
 arch/powerpc/mm/numa.c                 |   26 ++
 arch/powerpc/platforms/pseries/iommu.c |  475 +++++++++++++++++++++++++++----
 drivers/macintosh/macio_asic.c         |    7 +-
 9 files changed, 635 insertions(+), 79 deletions(-)
 create mode 100644 arch/powerpc/kernel/dma-choose64.c

