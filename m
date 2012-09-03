Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2ICLAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:00:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16210 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab2ICLAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:00:39 -0400
X-AuditID: cbfee61b-b7f056d000002c30-73-50448dd66547
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] DMA-mapping fixes for v3.6
Date: Mon, 03 Sep 2012 13:00:24 +0200
Message-id: <1346670024-504-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd1rvS4BBnNOy1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Ma/ulC74IVtx9+pWxgXELXxcjJ4eEgInE3MXbWSFsMYkL99az
	dTFycQgJLGKUaNmyHMpZzSRxYs4zNpAqNgFDia63XWC2iICRxOcXV1hBipgFupgkvl2YwwiS
	EBbQk5h4Zzs7iM0ioCrxa+pusAZeATeJFW+eM0Gsk5d4er+PbQIj9wJGhlWMoqkFyQXFSem5
	RnrFibnFpXnpesn5uZsYwT58Jr2DcVWDxSFGAQ5GJR7elR+cA4RYE8uKK3MPMUpwMCuJ8L5t
	dgkQ4k1JrKxKLcqPLyrNSS0+xCjNwaIkzut0zi5ASCA9sSQ1OzW1ILUIJsvEwSnVwKgTm/Wh
	jfXUuQh/lf832dWW/px6rba69FFN6eTQqjurjy9cM4n/V3/p/jdHdJjCny1WSZh+RqDkv0gh
	+/G8KilFmYn/vu8w+fdEtbeX8+X3i7GK0jYtV/kbTBL/5V8VahBa13Tr6EqTY5PMSmbtOOy/
	JSwj0rrqjaV0zK8ncx8fuTv/bD1H4i8lluKMREMt5qLiRACt041z3QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling another set of fixes for ARM dma-mapping
subsystem. Commit e9da6e9905e6 replaced custom consistent buffer
remapping code with generic vmalloc areas. It however introduced some
regressions caused by limited support for allocations in atomic context.
This series contains fixes for those regressions. For some subplatforms
the default, pre-allocated pool for atomic allocations turned out to be
too small, so a function for setting its size has been added. Another
set of patches adds support for atomic allocations to IOMMU-aware
DMA-mapping implementation. The last part of this pull request contains
two fixes for Contiguous Memory Allocator, which relax too strict
requirements.

The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

   fixes-for-3.6

for you to fetch changes up to 479ed93a4b98eef03fd8260f7ddc00019221c450:

  ARM: dma-mapping: IOMMU allocates pages from atomic_pool with GFP_ATOMIC (2012-08-28 21:01:07 +0200)

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center

----------------------------------------------------------------
Patch summary:

Hiroshi Doyu (4):
      ARM: dma-mapping: atomic_pool with struct page **pages
      ARM: dma-mapping: Refactor out to introduce __in_atomic_pool
      ARM: dma-mapping: Introduce __atomic_get_pages() for __iommu_get_pages()
      ARM: dma-mapping: IOMMU allocates pages from atomic_pool with GFP_ATOMIC

Marek Szyprowski (5):
      mm: cma: fix alignment requirements for contiguous regions
      ARM: relax conditions required for enabling Contiguous Memory Allocator
      ARM: DMA-Mapping: add function for setting coherent pool size from platform code
      ARM: DMA-Mapping: print warning when atomic coherent allocation fails
      ARM: Kirkwood: increase atomic coherent pool size

 arch/arm/Kconfig                   |    2 +-
 arch/arm/include/asm/dma-mapping.h |    7 ++
 arch/arm/mach-kirkwood/common.c    |    7 ++
 arch/arm/mm/dma-mapping.c          |  114 ++++++++++++++++++++++++++++++++---
 drivers/base/dma-contiguous.c      |    2 +-
 5 files changed, 120 insertions(+), 12 deletions(-)
