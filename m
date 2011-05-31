Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1EaAsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:48:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47184 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1EaAsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=XPy8zmXWErFgdOzmMl2imsZk4ElNykQGo90q7N4N1G7snbctx34hSbEjNgsbr5rb+d
         pzGxRP3FrMYquWKxvcLA==
Date: Mon, 30 May 2011 17:48:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 9/14] mm: cleanup descriptions of filler arg
In-Reply-To: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105301747050.5482@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The often-NULL data arg to read_cache_page() and read_mapping_page()
functions is misdescribed as "destination for read data": no, it's the
first arg to the filler function, often struct file * to ->readpage().
And satisfy checkpatch.pl on those filler prototypes.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/filemap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux.orig/mm/filemap.c	2011-05-30 13:56:10.260797344 -0700
+++ linux/mm/filemap.c	2011-05-30 14:26:54.097940438 -0700
@@ -1795,7 +1795,7 @@ EXPORT_SYMBOL(generic_file_readonly_mmap
 
 static struct page *__read_cache_page(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data,
 				gfp_t gfp)
 {
@@ -1826,7 +1826,7 @@ repeat:
 
 static struct page *do_read_cache_page(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data,
 				gfp_t gfp)
 
@@ -1866,7 +1866,7 @@ out:
  * @mapping:	the page's address_space
  * @index:	the page index
  * @filler:	function to perform the read
- * @data:	destination for read data
+ * @data:	first arg to filler(data, page) function, often left as NULL
  *
  * Same as read_cache_page, but don't wait for page to become unlocked
  * after submitting it to the filler.
@@ -1878,7 +1878,7 @@ out:
  */
 struct page *read_cache_page_async(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data)
 {
 	return do_read_cache_page(mapping, index, filler, data, mapping_gfp_mask(mapping));
@@ -1926,7 +1926,7 @@ EXPORT_SYMBOL(read_cache_page_gfp);
  * @mapping:	the page's address_space
  * @index:	the page index
  * @filler:	function to perform the read
- * @data:	destination for read data
+ * @data:	first arg to filler(data, page) function, often left as NULL
  *
  * Read into the page cache. If a page already exists, and PageUptodate() is
  * not set, try to fill the page then wait for it to become unlocked.
@@ -1935,7 +1935,7 @@ EXPORT_SYMBOL(read_cache_page_gfp);
  */
 struct page *read_cache_page(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data)
 {
 	return wait_on_page_read(read_cache_page_async(mapping, index, filler, data));
