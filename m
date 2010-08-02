Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab0HBOsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:48:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:39299 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab0HBOsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:48:12 -0400
Date: Mon, 2 Aug 2010 23:48:06 +0900
To: konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH -next] swiotlb: make io_tlb_overflow static
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100802234722U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 02 Aug 2010 23:48:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to export io_tlb_overflow_buffer. I'll remove
io_tlb_overflow_buffer completely in the long term though.

This can be applied to:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] swiotlb: make io_tlb_overflow static

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index a009055..72c382c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -78,7 +78,7 @@ static unsigned long io_tlb_nslabs;
  */
 static unsigned long io_tlb_overflow = 32*1024;
 
-void *io_tlb_overflow_buffer;
+static void *io_tlb_overflow_buffer;
 
 /*
  * This is a free list describing the number of free entries available from
-- 
1.6.5

