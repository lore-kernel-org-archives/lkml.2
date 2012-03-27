Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934821Ab2C3XEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:04:23 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934808Ab2C3VFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:07 -0400
Message-Id: <201203302104.q2UL4sGo006256@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 27 Mar 2012 14:10:03 -0400
Subject: [PATCH] arch/tile: revert comment for atomic64_add_unless().
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:55.0085 (UTC) FILETIME=[C1BE2DD0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It still returns whether @v was not @u, not the the old value,
unlike __atomic_add_unless().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/atomic_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index c03349e..004d6d9 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -199,7 +199,7 @@ static inline u64 atomic64_add_return(u64 i, atomic64_t *v)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns the old value of @v.
+ * Returns non-zero if @v was not @u, and zero otherwise.
  */
 static inline u64 atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
 {
-- 
1.6.5.2

