Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab2FFKyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:54:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45499 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2FFKyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:54:15 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: konrad.wilk@oracle.com, dan.magenheimer@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 01/11] mm: frontswap: remove casting from function calls through ops structure
Date: Wed,  6 Jun 2012 12:55:05 +0200
Message-Id: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes unneeded casts.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 15b79fb..07c0eee 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -90,7 +90,7 @@ void __frontswap_init(unsigned type)
 	if (sis->frontswap_map == NULL)
 		return;
 	if (frontswap_enabled)
-		(*frontswap_ops.init)(type);
+		frontswap_ops.init(type);
 }
 EXPORT_SYMBOL(__frontswap_init);
 
@@ -113,7 +113,7 @@ int __frontswap_put_page(struct page *page)
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
 		dup = 1;
-	ret = (*frontswap_ops.put_page)(type, offset, page);
+	ret = frontswap_ops.put_page(type, offset, page);
 	if (ret == 0) {
 		frontswap_set(sis, offset);
 		frontswap_succ_puts++;
@@ -152,7 +152,7 @@ int __frontswap_get_page(struct page *page)
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
-		ret = (*frontswap_ops.get_page)(type, offset, page);
+		ret = frontswap_ops.get_page(type, offset, page);
 	if (ret == 0)
 		frontswap_gets++;
 	return ret;
@@ -169,7 +169,7 @@ void __frontswap_invalidate_page(unsigned type, pgoff_t offset)
 
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset)) {
-		(*frontswap_ops.invalidate_page)(type, offset);
+		frontswap_ops.invalidate_page(type, offset);
 		atomic_dec(&sis->frontswap_pages);
 		frontswap_clear(sis, offset);
 		frontswap_invalidates++;
@@ -188,7 +188,7 @@ void __frontswap_invalidate_area(unsigned type)
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

