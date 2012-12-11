Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2LKK0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:26:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47490 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2LKK0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:26:46 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-1e-50c70a64b5f3
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] CMA and DMA-mapping updates for v3.8
Date: Tue, 11 Dec 2012 11:26:28 +0100
Message-id: <1355221589-26538-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t9jAd0UruMBBp9PqFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M61PXsRUc4a6YcSmmgXETZxcjB4eEgInEzh9sXYycQKaYxIV7
	64FsLg4hgUWMEk+PbWCBcFYwSTTfXcACUsUmYCjR9bYLrENEwEji84srrCBFzAK7GSVW7J7I
	CpIQFrCQOPVyHTuIzSKgKvF901+wOK+Ah8ScOb8ZITYrSMyZZDOBkXsBI8MqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjGD/PZPawbiyweIQowAHoxIPr4bWsQAh1sSy4srcQ4wSHMxKIryl
	uUAh3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJJanZqakFqUUwWSYOTqkGxtU5rHdj
	C3g7TC4ufhIdr33TYYrqn4ftz4KnOr0p83oWO1Hw4eozArm7k1UWe65ovfln8r9TPZvEErZs
	a1rRX7evfo7wZK2n6/JdFr30U1a+m6P6vThwB5fQJ9amwO3pPhZ7fBdqnXz/8OQyUykB4zO6
	alUVM2QV3N4nx/Fsesd3f8O617eKBJVYijMSDbWYi4oTAXuoS4vbAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling another set of Contiguous Memory Allocator and
DMA-mapping framework updates for v3.8.

The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:

  Linux 3.7 (2012-12-10 19:30:57 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.8

for you to fetch changes up to 4009793e15d44469da1547a46ab129cc08ffa503:

  drivers: cma: represent physical addresses as phys_addr_t (2012-12-11 09:28:09 +0100)

----------------------------------------------------------------

This pull request consists only of two patches. First fixes long standing
issue with dmapools (the code predates current GIT history), which forced all
allocations to use GFP_ATOMIC flag, ignoring the flags passed by the caller.
The second patch changes CMA code to correctly use phys_addr_t type what
enables support for LPAE systems.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (1):
      mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls

Vitaly Andrianov (1):
      drivers: cma: represent physical addresses as phys_addr_t

 drivers/base/dma-contiguous.c  |   24 ++++++++++--------------
 include/linux/dma-contiguous.h |    4 ++--
 mm/dmapool.c                   |   31 +++++++------------------------
 3 files changed, 19 insertions(+), 40 deletions(-)
