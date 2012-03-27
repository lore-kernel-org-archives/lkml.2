Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936720Ab2C3XDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:03:54 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934818Ab2C3VFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:09 -0400
Message-Id: <201203302104.q2UL4t9E006257@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 27 Mar 2012 14:17:05 -0400
Subject: [PATCH] arch/tile: fix gcc 4.6 warnings in <asm/bitops_64.h>
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:55.0241 (UTC) FILETIME=[C1D5FB90:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some signedness and variable usage warnings in change_bit()
and test_and_change_bit().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/bitops_64.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/tile/include/asm/bitops_64.h b/arch/tile/include/asm/bitops_64.h
index e9c8e38..161a381 100644
--- a/arch/tile/include/asm/bitops_64.h
+++ b/arch/tile/include/asm/bitops_64.h
@@ -39,10 +39,10 @@ static inline void clear_bit(unsigned nr, volatile unsigned long *addr)
 
 static inline void change_bit(unsigned nr, volatile unsigned long *addr)
 {
-	unsigned long old, mask = (1UL << (nr % BITS_PER_LONG));
-	long guess, oldval;
+	unsigned long mask = (1UL << (nr % BITS_PER_LONG));
+	unsigned long guess, oldval;
 	addr += nr / BITS_PER_LONG;
-	old = *addr;
+	oldval = *addr;
 	do {
 		guess = oldval;
 		oldval = atomic64_cmpxchg((atomic64_t *)addr,
@@ -86,7 +86,7 @@ static inline int test_and_change_bit(unsigned nr,
 				      volatile unsigned long *addr)
 {
 	unsigned long mask = (1UL << (nr % BITS_PER_LONG));
-	long guess, oldval = *addr;
+	unsigned long guess, oldval;
 	addr += nr / BITS_PER_LONG;
 	oldval = *addr;
 	do {
-- 
1.6.5.2

