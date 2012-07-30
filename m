Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2G3I2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:28:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13923 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2G3I2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:28:34 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-d0-501645af399d
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Subash Patel <subashrp@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCHv6 0/2] ARM: replace custom consistent dma region with vmalloc
Date: Mon, 30 Jul 2012 10:28:17 +0200
Message-id: <1343636899-19508-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd31rmIBBl8miVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M9oaNTAW7BCt+dJ9ib2D8wdvFyMkhIWAisfX9LTYIW0ziwr31
	QDYXh5DAdEaJy40TWSCc1UwSHV2vmUGq2AQMJbredgFVcXCICNRIzJvBCFLDLDCXWeLezp/s
	IDXCAr4ShyeuA5vKIqAqcaRzGyOIzSvgIbFv+SwmiG3yEk/v97FNYORewMiwilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyPYh8+kdjCubLA4xCjAwajEw2t4WTRAiDWxrLgy9xCjBAezkgjv
	JBGxACHelMTKqtSi/Pii0pzU4kOM0hwsSuK8xt5f/YUE0hNLUrNTUwtSi2CyTBycUg2Mc43W
	nT3pdWE2g/zcAnaFSwZnxUPSU8O2nite13pa/2jPg2i7NaaOv+9fOWxUp9AuOu2QaFdbv2Bo
	6h6fYxpzz2nySy95HC/nHytedpt5v+G2yuPHToQWHZc4rf7pT6GQYD2rSBBzXu0tx7/H7G8I
	Spmem/tdXWXuJJuHXouOrmjICRKZZbhBiaU4I9FQi7moOBEAoV+Jpd0BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This is yet another quick update on the patchset which replaces custom 
consistent dma regions usage in dma-mapping framework in favour of
generic vmalloc areas created on demand for each allocation. The main
purpose for this patchset is to remove 2MiB limit of dma
coherent/writecombine allocations.

This version addresses a few more cleanups pointed by Minchan Kim.

This patch is based on vanilla v3.5 release.

Best regards
Marek Szyprowski
Samsung Poland R&D Center

Changelog:

v6:
- more cleanups of minor issues pointed by Minchan Kim, moved
  arm_dma_mmap() changes into separate patch

v5: http://thread.gmane.org/gmane.linux.kernel.mm/83096
- fixed another minor issues pointed by Minchan Kim: added more comments
  here and there, changed pr_err() + stack_dump() to WARN(), added a fix
  for no-MMU systems

v4: http://thread.gmane.org/gmane.linux.kernel.mm/80906
- replaced arch-independent VM_DMA flag with ARM-specific
  VM_ARM_DMA_CONSISTENT flag

v3: http://thread.gmane.org/gmane.linux.kernel.mm/80028
- rebased onto v3.4-rc2: added support for IOMMU-aware implementation 
  of dma-mapping calls, unified with CMA coherent dma pool
- implemented changes requested by Minchan Kim: added more checks for
  vmarea->flags & VM_DMA, renamed some variables, removed obsole locks,
  squashed find_vm_area() exporting patch into the main redesign patch 

v2: http://thread.gmane.org/gmane.linux.kernel.mm/78563
- added support for atomic allocations (served from preallocated pool)
- minor cleanup here and there
- rebased onto v3.4-rc7

v1: http://thread.gmane.org/gmane.linux.kernel.mm/76703
- initial version

Patch summary:

Marek Szyprowski (2):
  mm: vmalloc: use const void * for caller argument
  ARM: dma-mapping: remove custom consistent dma region

 Documentation/kernel-parameters.txt |    2 +-
 arch/arm/include/asm/dma-mapping.h  |    2 +-
 arch/arm/mm/dma-mapping.c           |  486 ++++++++++++-----------------------
 arch/arm/mm/mm.h                    |    3 +
 include/linux/vmalloc.h             |    9 +-
 mm/vmalloc.c                        |   28 ++-
 6 files changed, 194 insertions(+), 336 deletions(-)

-- 
1.7.1.569.g6f426

