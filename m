Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab1CATjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:39:31 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52545 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab1CAThY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:24 -0500
Message-Id: <201103011934.p21JYePw010309@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 15:51:25 -0500
Subject: [PATCH] arch/tile: export some additional module symbols
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:40.0310 (UTC) FILETIME=[B51DD560:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a grab bag of symbols that have been missing for
various modules.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/exports.c |    7 +++++++
 arch/tile/mm/init.c     |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index ce5dbf5..49284fa 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -29,6 +29,9 @@ EXPORT_SYMBOL(__put_user_8);
 EXPORT_SYMBOL(strnlen_user_asm);
 EXPORT_SYMBOL(strncpy_from_user_asm);
 EXPORT_SYMBOL(clear_user_asm);
+EXPORT_SYMBOL(flush_user_asm);
+EXPORT_SYMBOL(inv_user_asm);
+EXPORT_SYMBOL(finv_user_asm);
 
 /* arch/tile/kernel/entry.S */
 #include <linux/kernel.h>
@@ -82,4 +85,8 @@ int64_t __muldi3(int64_t, int64_t);
 EXPORT_SYMBOL(__muldi3);
 uint64_t __lshrdi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__lshrdi3);
+uint64_t __ashrdi3(uint64_t, unsigned int);
+EXPORT_SYMBOL(__ashrdi3);
+uint64_t __ashldi3(uint64_t, unsigned int);
+EXPORT_SYMBOL(__ashldi3);
 #endif
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 2ef9ce5..f89ed5d 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -69,6 +69,7 @@
 
 #ifndef __tilegx__
 unsigned long VMALLOC_RESERVE = CONFIG_VMALLOC_RESERVE;
+EXPORT_SYMBOL(VMALLOC_RESERVE);
 #endif
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-- 
1.6.5.2

