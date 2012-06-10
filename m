Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab2FJKwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:52:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59515 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2FJKuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:50:03 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v3 01/10] mm: frontswap: remove casting from function calls through ops structure
Date: Sun, 10 Jun 2012 12:50:59 +0200
Message-Id: <1339325468-30614-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes unneeded casts.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index e250255..557e8af4 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -111,7 +111,7 @@ void __frontswap_init(unsigned type)
 	if (sis->frontswap_map == NULL)
 		return;
 	if (frontswap_enabled)
-		(*frontswap_ops.init)(type);
+		frontswap_ops.init(type);
 }
 EXPORT_SYMBOL(__frontswap_init);
 
@@ -134,7 +134,7 @@ int __frontswap_store(struct page *page)
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
 		dup = 1;
-	ret = (*frontswap_ops.store)(type, offset, page);
+	ret = frontswap_ops.store(type, offset, page);
 	if (ret == 0) {
 		frontswap_set(sis, offset);
 		inc_frontswap_succ_stores();
@@ -173,7 +173,7 @@ int __frontswap_load(struct page *page)
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
-		ret = (*frontswap_ops.load)(type, offset, page);
+		ret = frontswap_ops.load(type, offset, page);
 	if (ret == 0)
 		inc_frontswap_loads();
 	return ret;
@@ -190,7 +190,7 @@ void __frontswap_invalidate_page(unsigned type, pgoff_t offset)
 
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset)) {
-		(*frontswap_ops.invalidate_page)(type, offset);
+		frontswap_ops.invalidate_page(type, offset);
 		atomic_dec(&sis->frontswap_pages);
 		frontswap_clear(sis, offset);
 		inc_frontswap_invalidates();
@@ -209,7 +209,7 @@ void __frontswap_invalidate_area(unsigned type)
 	BUG_ON(sis == NULL);
 	if (sis->frontswap_map == NULL)
 		return;
-	(*frontswap_ops.invalidate_area)(type);
+	frontswap_ops.invalidate_area(type);
 	atomic_set(&sis->frontswap_pages, 0);
 	memset(sis->frontswap_map, 0, sis->max / sizeof(long));
 }
-- 
1.7.8.6

