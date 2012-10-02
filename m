Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2JBITI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:19:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14838 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab2JBITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:19:05 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-25-506aa3764606
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] CMA and DMA-mapping updates for v3.7
Date: Tue, 02 Oct 2012 10:18:46 +0200
Message-id: <1349165926-12097-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd2yxVkBBuvm6Vhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M650H2QtuClVcXDWLpYHxJW8XIyeHhICJxOq/rewQtpjEhXvr
	2boYuTiEBKYzSsw+uoAdwlnBJNE/8w4zSBWbgKFE19suNhBbRMBI4vOLK6wgRcwCXUwS3y7M
	YQRJCAtYSJz6PgGsgUVAVeLU9RNgDbwCHhKf+88D2RxA6xQk5kyymcDIvYCRYRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGsA+fSe1gXNlgcYhRgINRiYd358nMACHWxLLiytxDjBIczEoi
	vOfmZgUI8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhPLEnNTk0tSC2CyTJxcEo1MLru
	NfXNEdOW/qBcmPv71LO3KQFG/8KmTtP8enHWhpVrBJb+9L2Q1lwoc3E1a9cPIW7bWUGb1mVs
	WHPebCGzcKntv4VyEguCJ+huFw6zYXbt2mr+bPEBUTWN2+znSiZdn3/zj1sq82tDW9tdikL7
	k6//qjARtTzqsHpzOfP3le0zFkjPYU3Oma/EUpyRaKjFXFScCAAsEjY/3QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling another set of CMA and DMA-mapping framework
updates for v3.7.

The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

  Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.7

for you to fetch changes up to 461b6f0d3d7d4e556035463b531136b034b7433e:

  Merge branch 'next-cleanup' into for-v3.7 (2012-10-02 09:24:24 +0200)

----------------------------------------------------------------

This time the pull request is rather small, because the further redesign
patches were not ready on time.

This pull request consists of the patches which extend ARM DMA-mapping
subsystem with support for CPU coherent (ACP) DMA busses. The first
client of the new version is HighBank SATA driver. The second part of
the pull request includes various cleanup for both CMA common code and
ARM DMA-mapping subsystem.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Hiroshi Doyu (3):
      ARM: dma-mapping: Small logical clean up
      ARM: dma-mapping: Refrain noisy console message
      ARM: dma-mapping: Remove unsed var at arm_coherent_iommu_unmap_page

Marek Szyprowski (1):
      Merge branch 'next-cleanup' into for-v3.7

Michal Nazarewicz (1):
      drivers: dma-contiguous: refactor dma_alloc_from_contiguous()

Rob Herring (4):
      ARM: add coherent dma ops
      ARM: add coherent iommu dma ops
      ARM: kill off arch_is_coherent
      ARM: highbank: add coherent DMA setup

 .../devicetree/bindings/ata/ahci-platform.txt      |    3 +
 .../devicetree/bindings/dma/arm-pl330.txt          |    3 +
 .../devicetree/bindings/net/calxeda-xgmac.txt      |    3 +
 arch/arm/boot/dts/highbank.dts                     |    1 +
 arch/arm/include/asm/barrier.h                     |    7 +-
 arch/arm/include/asm/dma-mapping.h                 |    1 +
 arch/arm/include/asm/memory.h                      |    8 -
 arch/arm/mach-highbank/highbank.c                  |   52 ++++
 arch/arm/mm/dma-mapping.c                          |  264 +++++++++++++++-----
 arch/arm/mm/mmu.c                                  |   17 +-
 drivers/base/dma-contiguous.c                      |   18 +-
 11 files changed, 283 insertions(+), 94 deletions(-)
