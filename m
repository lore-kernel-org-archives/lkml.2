Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab0EXXJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:09:20 -0400
Received: from kroah.org ([198.145.64.141]:36382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758820Ab0EXXJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:18 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:49 2010
Message-Id: <20100524230349.792538291@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:59:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [05/34] dma-mapping: fix dma_sync_single_range_*
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit f33d7e2d2d113a63772bbc993cdec3b5327f0ef1 upstream.

dma_sync_single_range_for_cpu() and dma_sync_single_range_for_device() use
a wrong address with a partial synchronization.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-generic/dma-mapping-common.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -131,7 +131,7 @@ static inline void dma_sync_single_range
 		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 
 	} else
-		dma_sync_single_for_cpu(dev, addr, size, dir);
+		dma_sync_single_for_cpu(dev, addr + offset, size, dir);
 }
 
 static inline void dma_sync_single_range_for_device(struct device *dev,
@@ -148,7 +148,7 @@ static inline void dma_sync_single_range
 		debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
 
 	} else
-		dma_sync_single_for_device(dev, addr, size, dir);
+		dma_sync_single_for_device(dev, addr + offset, size, dir);
 }
 
 static inline void


