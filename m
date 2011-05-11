Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1EKWZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:25:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34724 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab1EKWZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:25:08 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] pseries/iommu: bug-fixes and cleanups for dynamic dma windows
Date: Wed, 11 May 2011 15:24:56 -0700
Message-Id: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches attempts to cleanup and fix some bugs related to
dynamic dma windows and kexec/kdump. They build on the three patches I
have submitted most recently:

powerpc: fix kexec with dynamic dma windows
	http://patchwork.ozlabs.org/patch/94445/
pseries/iommu: restore iommu table pointer when restoring iommu ops
	http://patchwork.ozlabs.org/patch/94909/
pseries/iommu: use correct return type in dupe_ddw_if_already_created
	http://patchwork.ozlabs.org/patch/95184/

The full series has been successfully tested with kdump/kexec on pseries
machine.

Milton Miller (8):
  pseries/iommu: add additional checks when changing iommu mask
  pseries/iommu: remove ddw property when destroying window
  pseries/iommu: find windows after kexec during boot
  pseries/iommu: cleanup ddw naming
  powerpc: override dma_get_required_mask by platform hook and ops
  dma-mapping: add get_required_mask if arch overrides default
  powerpc: use the newly added get_required_mask dma_map_ops hook
  powerpc: tidy up dma_map_ops after adding new hook

 arch/powerpc/include/asm/device.h       |    2 +
 arch/powerpc/include/asm/machdep.h      |    3 +-
 arch/powerpc/kernel/dma-iommu.c         |   28 +++++--
 arch/powerpc/kernel/dma-swiotlb.c       |   16 ++++
 arch/powerpc/kernel/dma.c               |   44 ++++++++--
 arch/powerpc/kernel/ibmebus.c           |   22 +++--
 arch/powerpc/kernel/vio.c               |   21 +++--
 arch/powerpc/platforms/cell/iommu.c     |   21 +++++
 arch/powerpc/platforms/ps3/system-bus.c |    7 ++
 arch/powerpc/platforms/pseries/iommu.c  |  142 +++++++++++++++++++------------
 include/linux/dma-mapping.h             |    3 +
 11 files changed, 224 insertions(+), 85 deletions(-)

-- 
1.7.4.1

