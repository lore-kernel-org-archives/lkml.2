Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab2BJFuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:50:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab2BJFqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:46:45 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org
Subject: [PATCH 48/60] power: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:40:09 +0800
Message-Id: <1328852421-19678-49-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 kernel/power/snapshot.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 6a768e5..3a564ac 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1000,20 +1000,20 @@ static void copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
 	s_page = pfn_to_page(src_pfn);
 	d_page = pfn_to_page(dst_pfn);
 	if (PageHighMem(s_page)) {
-		src = kmap_atomic(s_page, KM_USER0);
-		dst = kmap_atomic(d_page, KM_USER1);
+		src = kmap_atomic(s_page);
+		dst = kmap_atomic(d_page);
 		do_copy_page(dst, src);
-		kunmap_atomic(dst, KM_USER1);
-		kunmap_atomic(src, KM_USER0);
+		kunmap_atomic(dst);
+		kunmap_atomic(src);
 	} else {
 		if (PageHighMem(d_page)) {
 			/* Page pointed to by src may contain some kernel
 			 * data modified by kmap_atomic()
 			 */
 			safe_copy_page(buffer, s_page);
-			dst = kmap_atomic(d_page, KM_USER0);
+			dst = kmap_atomic(d_page);
 			copy_page(dst, buffer);
-			kunmap_atomic(dst, KM_USER0);
+			kunmap_atomic(dst);
 		} else {
 			safe_copy_page(page_address(d_page), s_page);
 		}
@@ -1728,9 +1728,9 @@ int snapshot_read_next(struct snapshot_handle *handle)
 			 */
 			void *kaddr;
 
-			kaddr = kmap_atomic(page, KM_USER0);
+			kaddr = kmap_atomic(page);
 			copy_page(buffer, kaddr);
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 			handle->buffer = buffer;
 		} else {
 			handle->buffer = page_address(page);
@@ -2014,9 +2014,9 @@ static void copy_last_highmem_page(void)
 	if (last_highmem_page) {
 		void *dst;
 
-		dst = kmap_atomic(last_highmem_page, KM_USER0);
+		dst = kmap_atomic(last_highmem_page);
 		copy_page(dst, buffer);
-		kunmap_atomic(dst, KM_USER0);
+		kunmap_atomic(dst);
 		last_highmem_page = NULL;
 	}
 }
@@ -2309,13 +2309,13 @@ swap_two_pages_data(struct page *p1, struct page *p2, void *buf)
 {
 	void *kaddr1, *kaddr2;
 
-	kaddr1 = kmap_atomic(p1, KM_USER0);
-	kaddr2 = kmap_atomic(p2, KM_USER1);
+	kaddr1 = kmap_atomic(p1);
+	kaddr2 = kmap_atomic(p2);
 	copy_page(buf, kaddr1);
 	copy_page(kaddr1, kaddr2);
 	copy_page(kaddr2, buf);
-	kunmap_atomic(kaddr2, KM_USER1);
-	kunmap_atomic(kaddr1, KM_USER0);
+	kunmap_atomic(kaddr2);
+	kunmap_atomic(kaddr1);
 }
 
 /**
-- 
1.7.7.6

