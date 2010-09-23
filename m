Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0IWWib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:38:31 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5469 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0IWWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:38:29 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 0/9] MIPS: Use dma-mapping-common.h and use swiotlb for Octeon.
Date: Thu, 23 Sep 2010 15:38:07 -0700
Message-Id: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Sep 2010 22:38:29.0221 (UTC) FILETIME=[0B2DD950:01CB5B70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Octeon family of SOCs support physical memory outside of the
32-bit addressing range.  To support 32-bit devices, we need to use
the swiotlb bounce buffer mechanism.

There are several parts to the patch set.

1 -     Set the proper dma_masks for the octeon_mgmt platform device so
        that it continues to function with the rewritten dma mapping
        code to follow.

2,3,4 - Establish a properly constrained DMA32 zone for Octeon.

5 -     Convert MIPS to use dma-mapping-common.h

6,7 -   Trivial swiotlb changes.

8 -     Get MIPS ready to use swiotlb.

9 -     Rewrite Octeon dma mapping code.

Since the only non-MIPS parts of this patch set are trivial changes to
swiotlb, I would suggest that they could all be merged via Ralf's tree
if deemed acceptable.

David Daney (9):
  MIPS: Octeon: Set dma_masks for octeon_mgmt device.
  MIPS: Allow MAX_DMA32_PFN to be overridden.
  MIPS: Octeon: Adjust top of DMA32 zone.
  MIPS: Octeon: Select ZONE_DMA32
  MIPS: Convert DMA to use dma-mapping-common.h
  swiotlb: Declare swiotlb_init_with_default_size()
  swiotlb: Make bounce buffer bounds non-static.
  MIPS: Add a platform hook for swiotlb setup.
  MIPS: Octeon: Rewrite DMA mapping functions.

 arch/mips/Kconfig                                  |    3 +
 arch/mips/cavium-octeon/Kconfig                    |   12 +
 arch/mips/cavium-octeon/dma-octeon.c               |  529 +++++++++-----------
 arch/mips/cavium-octeon/octeon-platform.c          |    5 +
 arch/mips/include/asm/bootinfo.h                   |    5 +
 arch/mips/include/asm/device.h                     |   15 +-
 arch/mips/include/asm/dma-mapping.h                |  125 ++++--
 arch/mips/include/asm/dma.h                        |    3 +
 .../asm/mach-cavium-octeon/cpu-feature-overrides.h |    6 +
 .../include/asm/mach-cavium-octeon/dma-coherence.h |   19 +-
 arch/mips/include/asm/octeon/pci-octeon.h          |   10 +
 arch/mips/kernel/setup.c                           |    5 +
 arch/mips/mm/dma-default.c                         |  179 +++----
 arch/mips/pci/pci-octeon.c                         |   60 ++-
 arch/mips/pci/pcie-octeon.c                        |    5 +
 include/linux/swiotlb.h                            |    7 +
 lib/swiotlb.c                                      |   62 ++--
 17 files changed, 571 insertions(+), 479 deletions(-)

-- 
1.7.2.2

