Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2FYIr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:47:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31760 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2FYIrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:47:55 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-6e-4fe825b70896
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
Subject: [PATCHv4 0/2] ARM: replace custom consistent dma region with vmalloc
Date: Mon, 25 Jun 2012 10:47:25 +0200
Message-id: <1340614047-5824-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd0dqi/8DS5sYbS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZV17fYS44z1dxefdSlgbGM9xdjJwcEgImEhsfnGOHsMUkLtxb
	z9bFyMUhJDCdUWLf+Z+sEM5qJokfU38wgVSxCRhKdL3tAqri4BARqJGYN4MRpIZZYC6zxL2d
	P8EmCQv4Srx8/5kNxGYRUJX4eKWVEcTmFXCXuLZvERPENnmJp/f72CYwci9gZFjFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJEezDZ9I7GFc1WBxiFOBgVOLhVVN64S/EmlhWXJl7iFGCg1lJ
	hJeDESjEm5JYWZValB9fVJqTWnyIUZqDRUmct8n6gr+QQHpiSWp2ampBahFMlomDU6qBcf7K
	3W/We7wKzImdzH3K+3LeUUVrnqc7L6yP137xU+vuk0CLdQ+L5djtHmTfOL3oQyDf85Dllj/z
	7HSWf7uVE7hOeZJT6VZtxcg+F40NPvExm2zav0smXX9vGBcc35d//P/0V74H6jmz63ht1oQW
	W9lx6G3SUD2yN8DXhJFJtoWzrmWJC99ZJZbijERDLeai4kQAdwhZA90BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This quick update on the patchset which replaces custom consistent dma
regions usage in dma-mapping framework in favour of generic vmalloc
areas created on demand for each allocation. The main purpose for this
patchset is to remove 2MiB limit of dma coherent/writecombine
allocations.

In this version arch-independent VM_DMA flag has been replaced with
ARM-specific VM_ARM_DMA_CONSISTENT flag.

This patch is based on vanilla v3.5-rc4 release.

Best regards
Marek Szyprowski
Samsung Poland R&D Center

Changelog:

v4:
- replaced arch-independent VM_DMA flag with ARM-specific
  VM_ARM_DMA_CONSISTENT flag

v3: http://thread.gmane.org/gmane.linux.kernel.mm/80028/
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
 arch/arm/mm/dma-mapping.c           |  505 +++++++++++++----------------------
 arch/arm/mm/mm.h                    |    3 +
 include/linux/vmalloc.h             |    9 +-
 mm/vmalloc.c                        |   28 ++-
 6 files changed, 207 insertions(+), 342 deletions(-)

-- 
1.7.1.569.g6f426

