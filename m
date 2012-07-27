Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab2G0MEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:04:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61675 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2G0MEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:04:09 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-ab-501283b7b879
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
Subject: [PATCHv5 0/2] ARM: replace custom consistent dma region with vmalloc
Date: Fri, 27 Jul 2012 14:03:37 +0200
Message-id: <1343390619-20456-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jQd0dzUIBBjcdLC7vmsPmwOjxeZNc
	AGMUl01Kak5mWWqRvl0CV8aztjcsBZMFKloXNjE1ML7g6WLk5JAQMJFY/O0AI4QtJnHh3nq2
	LkYuDiGB6YwSv07cZYdwVjNJXFq9HqyKTcBQouttF1AVB4eIQI3EvBmMIDXMAnOZJe7t/MkO
	UiMs4CvRuHECC4jNIqAqMX/BLVYQm1fAQ+L18zXMENvkJZ7e72ObwMi9gJFhFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkawB59J7WBc2WBxiFGAg1GJh3cir1CAEGtiWXFl7iFGCQ5mJRHe
	r7ZAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzG3l/9hQTSE0tSs1NTC1KLYLJMHJxSDYylUpd3
	fI9fIny+nctwbddp13e+Jb8XPPp46JLuvK8/kzdk/XVbM/u60VnD/QE/9m4+eWV+IBuj4Uwr
	5Q9TvyfnNhku3T2pWKWn78Kyn/onq02OerJv+c109b79jC2r70ZcWt66sbLiaddUu/zdlxyZ
	D/WlONyeY/Puj9T+7sOO9dYXA6ekPv65TImlOCPRUIu5qDgRAG/30OfcAQAA
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

This version addresses a few minor issues pointed by Minchan Kim.

This patch is based on vanilla v3.5 release.

Best regards
Marek Szyprowski
Samsung Poland R&D Center

Changelog:

v5:
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
 arch/arm/mm/dma-mapping.c           |  511 +++++++++++++----------------------
 arch/arm/mm/mm.h                    |    3 +
 include/linux/vmalloc.h             |    9 +-
 mm/vmalloc.c                        |   28 ++-
 6 files changed, 210 insertions(+), 345 deletions(-)

-- 
1.7.1.569.g6f426

