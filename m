Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2G3MPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:15:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34111 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2G3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:15:34 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-77-50167ae52c75
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] DMA-mapping updates for v3.6
Date: Mon, 30 Jul 2012 14:15:16 +0200
Message-id: <1343650516-15726-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jQd2nVWIBBq/ecFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mjll9jAW/JCo2zjvE2sB4Q6iLkZNDQsBEYtO350wQtpjEhXvr
	2boYuTiEBKYzSjRdXsoGkhASWM0ksXpuIIjNJmAo0fW2CywuImAk8fnFFVaQBmaB7UwSr1/+
	BkpwcAgLGEh8WysCUsMioCrxasMaRhCbV8BD4sijnYwQy+Qlnt7vY5vAyL2AkWEVo2hqQXJB
	cVJ6rqFecWJucWleul5yfu4mRrAHn0ntYFzZYHGIUYCDUYmH1/CyaIAQa2JZcWXuIUYJDmYl
	Ed5JImIBQrwpiZVVqUX58UWlOanFhxilOViUxHmNvb/6CwmkJ5akZqemFqQWwWSZODilGhjX
	x04+vdL0Zpt37jfhrGcKZkvFj0b2now5dWnLM1b2LNszp3ZtM1mpeSmE7em/jeK3lDMNvLLc
	7DSmnNY5Iztx8ots2S8tzvpznuZdsdun0vly9dZqnaSnSw1PNFnuuBmSIvfjy93fL7sj68UM
	r/965C61Yg570fmfYjdvJFgsiuHJlBBJqJZTYinOSDTUYi4qTgQAeATW69wBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling another set of DMA-mapping framework
updates for v3.6.

The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

with the top-most commit 97ef952a20853fad72087a53fa556fbec45edd8f

  ARM: dma-mapping: add support for DMA_ATTR_SKIP_CPU_SYNC attribute

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-linus-for-3.6-rc1

Those patches are continuation of my earlier works merged in commits
58bca4a8fa90 and d484864dd96e1. They contains extensions to DMA-mapping
framework to remove limitation of the current ARM implementation (like
limited total size of DMA coherent/write combine buffers), improve
performance of buffer sharing between devices (attributes to skip cpu
cache operations or creation of additional kernel mapping for some
specific use cases) as well as some unification of the common code for
dma_mmap_attrs()/dma_mmap_coherent() functions. All extensions have been
implemented and tested for ARM architecture.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (11):
      mm: vmalloc: use const void * for caller argument
      ARM: dma-mapping: remove custom consistent dma region
      ARM: dma-mapping: add more sanity checks in arm_dma_mmap()
      ARM: dma-mapping: fix error path for memory allocation failure
      common: dma-mapping: add support for generic dma_mmap_* calls
      common: DMA-mapping: add DMA_ATTR_NO_KERNEL_MAPPING attribute
      ARM: dma-mapping: add support for DMA_ATTR_NO_KERNEL_MAPPING attribute
      common: dma-mapping: introduce dma_get_sgtable() function
      ARM: dma-mapping: add support for dma_get_sgtable()
      common: DMA-mapping: add DMA_ATTR_SKIP_CPU_SYNC attribute
      ARM: dma-mapping: add support for DMA_ATTR_SKIP_CPU_SYNC attribute

Tomasz Stanislawski (1):
      scatterlist: add sg_alloc_table_from_pages function

 Documentation/DMA-attributes.txt         |   42 +++
 Documentation/kernel-parameters.txt      |    2 +-
 arch/arm/common/dmabounce.c              |    1 +
 arch/arm/include/asm/dma-mapping.h       |   24 +-
 arch/arm/mm/dma-mapping.c                |  561 ++++++++++++------------------
 arch/arm/mm/mm.h                         |    3 +
 arch/powerpc/include/asm/dma-mapping.h   |    8 +-
 arch/powerpc/kernel/dma-iommu.c          |    1 +
 arch/powerpc/kernel/dma-swiotlb.c        |    1 +
 arch/powerpc/kernel/dma.c                |   36 +-
 arch/powerpc/kernel/vio.c                |    1 +
 drivers/base/dma-mapping.c               |   49 +++
 include/asm-generic/dma-coherent.h       |    1 +
 include/asm-generic/dma-mapping-common.h |   55 +++
 include/linux/dma-attrs.h                |    2 +
 include/linux/dma-mapping.h              |    3 +
 include/linux/scatterlist.h              |    4 +
 include/linux/vmalloc.h                  |    9 +-
 lib/scatterlist.c                        |   64 ++++
 mm/vmalloc.c                             |   28 +-
 20 files changed, 505 insertions(+), 390 deletions(-)
