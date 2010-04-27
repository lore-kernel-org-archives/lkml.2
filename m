Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0D0M0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:26:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:37050 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab0D0M0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:26:13 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/6] remove unnecessary sync_single_range_* in dma_map_ops
Date: Tue, 27 Apr 2010 21:25:34 +0900
Message-Id: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Apr 2010 21:26:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes useless sync_single_range_for_cpu and
sync_single_range_for_device hooks in dma_map_ops. These hooks were
for dma_sync_single_range_* DMA API, however, the API became obsolete
(the description in DMA API docs was removed too). Architecutres
should use sync_single_for_cpu and sync_single_for_device hooks
instead (as DMA API docs say, they need to support a partial sync).

We could remove dma_sync_single_range_* DMA API completely (no user in
-mm) but the API had been until 2.6.34-rc so I guess that it might be
better to leave it alone for some time.

The first patch is a bug fix and might be 2.6.34-rc material however
the API is not so popular (only net/b44.c uses) and we are already in
-rc5. I guess that it would be fine to merge it in the next merge
window.

=
 arch/ia64/kernel/pci-swiotlb.c           |    2 -
 arch/powerpc/kernel/dma-swiotlb.c        |    4 +-
 arch/powerpc/kernel/dma.c                |   12 +++++-----
 arch/x86/kernel/pci-swiotlb.c            |    2 -
 include/asm-generic/dma-mapping-common.h |   20 +-----------------
 include/linux/dma-mapping.h              |   10 ---------
 include/linux/swiotlb.h                  |   10 ---------
 lib/swiotlb.c                            |   31 ------------------------------
 8 files changed, 10 insertions(+), 81 deletions(-)

