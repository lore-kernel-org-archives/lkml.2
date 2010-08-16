Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0HPQ1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:27:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50766 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab0HPQ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:27:17 -0400
Date: Mon, 16 Aug 2010 18:27:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/16] fs/fscache: Remove unnecessary error code assignment
Message-ID: <Pine.LNX.4.64.1008161826580.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, the value of ret is not used.  If an error occurs, -ENOBUFS
is returned explicitly.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/fscache/page.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 41c441c..33538ed 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -784,7 +784,6 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	if (ret < 0)
 		goto nomem_free;
 
-	ret = -ENOBUFS;
 	spin_lock(&cookie->lock);
 
 	if (hlist_empty(&cookie->backing_objects))
@@ -854,7 +853,6 @@ submit_failed:
 	radix_tree_delete(&cookie->stores, page->index);
 	spin_unlock(&cookie->stores_lock);
 	page_cache_release(page);
-	ret = -ENOBUFS;
 	goto nobufs;
 
 nobufs_unlock_obj:
