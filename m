Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1A3Jrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 04:47:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab1A3Jrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 04:47:31 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>
Subject: [PATCH 2/4] kmap_atomic: remove dead code in ieee80211 staging code
Date: Sun, 30 Jan 2011 17:46:58 +0800
Message-Id: <1296380820-8801-2-git-send-email-amwang@redhat.com>
In-Reply-To: <1296380820-8801-1-git-send-email-amwang@redhat.com>
References: <1296380820-8801-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous leaves some unused code in drivers/staging/rtl8192u/ieee80211/,
this patch removes them.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
 drivers/staging/rtl8192u/ieee80211/internal.h    |   17 -----------------
 drivers/staging/rtl8192u/ieee80211/kmap_types.h  |   20 --------------------
 drivers/staging/rtl8192u/ieee80211/scatterwalk.c |    9 ---------
 3 files changed, 0 insertions(+), 46 deletions(-)
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/kmap_types.h

diff --git a/drivers/staging/rtl8192u/ieee80211/internal.h b/drivers/staging/rtl8192u/ieee80211/internal.h
index 85571d4..bebe13a 100644
--- a/drivers/staging/rtl8192u/ieee80211/internal.h
+++ b/drivers/staging/rtl8192u/ieee80211/internal.h
@@ -23,23 +23,6 @@
 #include <asm/kmap_types.h>
 
 
-extern enum km_type crypto_km_types[];
-
-static inline enum km_type crypto_kmap_type(int out)
-{
-	return crypto_km_types[(in_softirq() ? 2 : 0) + out];
-}
-
-static inline void *crypto_kmap(struct page *page, int out)
-{
-	return kmap_atomic(page);
-}
-
-static inline void crypto_kunmap(void *vaddr, int out)
-{
-	kunmap_atomic(vaddr);
-}
-
 static inline void crypto_yield(struct crypto_tfm *tfm)
 {
 	if (!in_softirq())
diff --git a/drivers/staging/rtl8192u/ieee80211/kmap_types.h b/drivers/staging/rtl8192u/ieee80211/kmap_types.h
deleted file mode 100644
index de67bb0..0000000
--- a/drivers/staging/rtl8192u/ieee80211/kmap_types.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef __KMAP_TYPES_H
-
-#define __KMAP_TYPES_H
-
-
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BH_IRQ,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
-
-#define _ASM_KMAP_TYPES_H
-
-#endif
diff --git a/drivers/staging/rtl8192u/ieee80211/scatterwalk.c b/drivers/staging/rtl8192u/ieee80211/scatterwalk.c
index a123f95..8625045 100644
--- a/drivers/staging/rtl8192u/ieee80211/scatterwalk.c
+++ b/drivers/staging/rtl8192u/ieee80211/scatterwalk.c
@@ -13,8 +13,6 @@
  * any later version.
  *
  */
-#include "kmap_types.h"
-
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -23,13 +21,6 @@
 #include "internal.h"
 #include "scatterwalk.h"
 
-enum km_type crypto_km_types[] = {
-	KM_USER0,
-	KM_USER1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-};
-
 void *scatterwalk_whichbuf(struct scatter_walk *walk, unsigned int nbytes, void *scratch)
 {
 	if (nbytes <= walk->len_this_page &&
-- 
1.7.3.5

