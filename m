Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2DMOGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:06:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54511 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2DMOGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:06:05 -0400
Date: Fri, 13 Apr 2012 16:05:46 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 0/4] ARM: replace custom consistent dma region with vmalloc
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Subash Patel <subashrp@gmail.com>
Message-id: <1334325950-7881-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Recent changes to ioremap and unification of vmalloc regions on ARM
significantly reduces the possible size of the consistent dma region and
limited allowed dma coherent/writecombine allocations.

This experimental patch series replaces custom consistent dma regions
usage in dma-mapping framework in favour of generic vmalloc areas
created on demand for each coherent and writecombine allocations.

This patch is based on vanilla v3.4-rc2 release.

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (4):
  mm: vmalloc: use const void * for caller argument
  mm: vmalloc: export find_vm_area() function
  mm: vmalloc: add VM_DMA flag to indicate areas used by dma-mapping
    framework
  ARM: remove consistent dma region and use common vmalloc range for
    dma allocations

 arch/arm/include/asm/dma-mapping.h |    2 +-
 arch/arm/mm/dma-mapping.c          |  220 +++++++-----------------------------
 include/linux/vmalloc.h            |   10 +-
 mm/vmalloc.c                       |   31 ++++--
 4 files changed, 67 insertions(+), 196 deletions(-)

-- 
1.7.1.569.g6f426

