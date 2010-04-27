Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0D0Mak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:30:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:41136 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab0D0Maj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:30:39 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH -mm 1/6] dma-mapping: fix dma_sync_single_range_*
Date: Tue, 27 Apr 2010 21:25:35 +0900
Message-Id: <1272371140-6085-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Apr 2010 21:26:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_sync_single_range_for_cpu and dma_sync_single_range_for_device
use a wrong address with a partial synchronization.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stable@kernel.org
---
 include/asm-generic/dma-mapping-common.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index e694263..6920695 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -131,7 +131,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 
 	} else
-		dma_sync_single_for_cpu(dev, addr, size, dir);
+		dma_sync_single_for_cpu(dev, addr + offset, size, dir);
 }
 
 static inline void dma_sync_single_range_for_device(struct device *dev,
@@ -148,7 +148,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 		debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
 
 	} else
-		dma_sync_single_for_device(dev, addr, size, dir);
+		dma_sync_single_for_device(dev, addr + offset, size, dir);
 }
 
 static inline void
-- 
1.6.5

