Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2GRQ7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:59:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57405 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab2GRQ7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:59:42 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] zsmalloc: s/firstpage/page in new copy map funcs
Date: Wed, 18 Jul 2012 11:55:54 -0500
Message-Id: <1342630556-28686-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071816-5806-0000-0000-0000176DF7B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

firstpage already has precedent and meaning the first page
of a zspage.  In the case of the copy mapping functions,
it is the first of a pair of pages needing to be mapped.

This patch just renames the firstpage argument to "page" to
avoid confusion.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 8b0bcb6..3c83c65 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -470,15 +470,15 @@ static struct page *find_get_zspage(struct size_class *class)
 	return page;
 }
 
-static void zs_copy_map_object(char *buf, struct page *firstpage,
+static void zs_copy_map_object(char *buf, struct page *page,
 				int off, int size)
 {
 	struct page *pages[2];
 	int sizes[2];
 	void *addr;
 
-	pages[0] = firstpage;
-	pages[1] = get_next_page(firstpage);
+	pages[0] = page;
+	pages[1] = get_next_page(page);
 	BUG_ON(!pages[1]);
 
 	sizes[0] = PAGE_SIZE - off;
@@ -493,15 +493,15 @@ static void zs_copy_map_object(char *buf, struct page *firstpage,
 	kunmap_atomic(addr);
 }
 
-static void zs_copy_unmap_object(char *buf, struct page *firstpage,
+static void zs_copy_unmap_object(char *buf, struct page *page,
 				int off, int size)
 {
 	struct page *pages[2];
 	int sizes[2];
 	void *addr;
 
-	pages[0] = firstpage;
-	pages[1] = get_next_page(firstpage);
+	pages[0] = page;
+	pages[1] = get_next_page(page);
 	BUG_ON(!pages[1]);
 
 	sizes[0] = PAGE_SIZE - off;
-- 
1.7.9.5

