Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1FXTFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:05:50 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33471 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab1FXTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:05:49 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
Subject: [PATCH 0/4] pseries/iommu bug-fixes and cleanups for dynamic dma windows
Date: Fri, 24 Jun 2011 12:05:21 -0700
Message-Id: <1308942325-4813-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my last submission, 5/8 wasn't sent to Ben, so he only picked up 1-4.
Re-sending 5-8, as such.

Milton Miller (4):
  powerpc: override dma_get_required_mask by platform hook and ops
  dma-mapping: add get_required_mask if arch overrides default
  powerpc: use the newly added get_required_mask dma_map_ops hook
  powerpc: tidy up dma_map_ops after adding new hook

Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org

 arch/powerpc/include/asm/device.h       |    2 +
 arch/powerpc/include/asm/machdep.h      |    3 +-
 arch/powerpc/kernel/dma-iommu.c         |   28 ++++++++++++++-----
 arch/powerpc/kernel/dma-swiotlb.c       |   16 +++++++++++
 arch/powerpc/kernel/dma.c               |   44 ++++++++++++++++++++++++++-----
 arch/powerpc/kernel/ibmebus.c           |   22 ++++++++++-----
 arch/powerpc/kernel/vio.c               |   21 +++++++++-----
 arch/powerpc/platforms/cell/iommu.c     |   21 ++++++++++++++
 arch/powerpc/platforms/ps3/system-bus.c |    7 +++++
 arch/powerpc/platforms/pseries/iommu.c  |   27 +++++++++++++++++++
 include/linux/dma-mapping.h             |    3 ++
 11 files changed, 163 insertions(+), 31 deletions(-)

-- 
1.7.4.1

