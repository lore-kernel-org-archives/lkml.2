Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab2FWKFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:05:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab2FWKFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:13 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: [PATCH 06/12] asm-generic: remove km_type definitions
Date: Sat, 23 Jun 2012 18:04:17 +0800
Message-Id: <1340445863-16111-7-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 include/asm-generic/kmap_types.h |   34 ++--------------------------------
 1 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/include/asm-generic/kmap_types.h b/include/asm-generic/kmap_types.h
index 0232ccb..90f99c7 100644
--- a/include/asm-generic/kmap_types.h
+++ b/include/asm-generic/kmap_types.h
@@ -2,39 +2,9 @@
 #define _ASM_GENERIC_KMAP_TYPES_H
 
 #ifdef __WITH_KM_FENCE
-# define KMAP_D(n) __KM_FENCE_##n ,
+# define KM_TYPE_NR 41
 #else
-# define KMAP_D(n)
+# define KM_TYPE_NR 20
 #endif
 
-enum km_type {
-KMAP_D(0)	KM_BOUNCE_READ,
-KMAP_D(1)	KM_SKB_SUNRPC_DATA,
-KMAP_D(2)	KM_SKB_DATA_SOFTIRQ,
-KMAP_D(3)	KM_USER0,
-KMAP_D(4)	KM_USER1,
-KMAP_D(5)	KM_BIO_SRC_IRQ,
-KMAP_D(6)	KM_BIO_DST_IRQ,
-KMAP_D(7)	KM_PTE0,
-KMAP_D(8)	KM_PTE1,
-KMAP_D(9)	KM_IRQ0,
-KMAP_D(10)	KM_IRQ1,
-KMAP_D(11)	KM_SOFTIRQ0,
-KMAP_D(12)	KM_SOFTIRQ1,
-KMAP_D(13)	KM_SYNC_ICACHE,
-KMAP_D(14)	KM_SYNC_DCACHE,
-/* UML specific, for copy_*_user - used in do_op_one_page */
-KMAP_D(15)	KM_UML_USERCOPY,
-KMAP_D(16)	KM_IRQ_PTE,
-KMAP_D(17)	KM_NMI,
-KMAP_D(18)	KM_NMI_PTE,
-KMAP_D(19)	KM_KDB,
-/*
- * Remember to update debug_kmap_atomic() when adding new kmap types!
- */
-KMAP_D(20)	KM_TYPE_NR
-};
-
-#undef KMAP_D
-
 #endif
-- 
1.7.7.6

