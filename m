Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2BNH2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:28:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38904 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab2BNH2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:28:38 -0500
From: Yang Bai <hamo.by@gmail.com>
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Yang Bai <hamo.by@gmail.com>
Subject: [PATCH] slab: warning if total alloc size overflow
Date: Tue, 14 Feb 2012 15:28:19 +0800
Message-Id: <1329204499-2671-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before, if the total alloc size is overflow,
we just return NULL like alloc fail. But they
are two different type problems. The former looks
more like a programming problem. So add a warning
here.

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 include/linux/slab.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 573c809..5865237 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -242,8 +242,10 @@ size_t ksize(const void *);
  */
 static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
 {
-	if (size != 0 && n > ULONG_MAX / size)
+	if (size != 0 && n > ULONG_MAX / size) {
+		WARN(1, "Alloc memory size (%lu * %lu) overflow.", n, size);
 		return NULL;
+	}
 	return __kmalloc(n * size, flags | __GFP_ZERO);
 }
 
-- 
1.7.9

