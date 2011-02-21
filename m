Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1BUOiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:38:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52473 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab1BUOiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:38:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gtv8gTSUy5oUdlpS5w5RV7wC/PA5I03GqnUdvibeyX1YTyYBbI40HQYlH/tdZikT1+
         +WsG+6rMXLAKEUeonK3B3BRt9xBE8+ZNbMpsUWA6F8USRvVM3Z5UEHXp7gMAbUMSG7iP
         VJHEAs6jCZB9sTOTsg5i5N6HHD4hYXhy74qYs=
Date: Mon, 21 Feb 2011 04:39:02 -0500
From: Tracey Dent <tdent48227@gmail.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/jffs2/xattr: Fix coding style
Message-ID: <20110221093902.GA4759@linux-rdzc.hsd1.mi.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the trailing white space and get rid of the
unnessary {} on certain statements.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/jffs2/xattr.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index 4f9cc04..d66bb03 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -31,7 +31,7 @@
  *   is used to release xattr name/value pair and detach from c->xattrindex.
  * reclaim_xattr_datum(c)
  *   is used to reclaim xattr name/value pairs on the xattr name/value pair cache when
- *   memory usage by cache is over c->xdatum_mem_threshold. Currently, this threshold 
+ *   memory usage by cache is over c->xdatum_mem_threshold. Currently, this threshold
  *   is hard coded as 32KiB.
  * do_verify_xattr_datum(c, xd)
  *   is used to load the xdatum informations without name/value pair from the medium.
@@ -109,11 +109,11 @@ static void reclaim_xattr_datum(struct jffs2_sb_info *c)
 	target = c->xdatum_mem_usage * 4 / 5; /* 20% reduction */
 	for (count = 0; count < XATTRINDEX_HASHSIZE; count++) {
 		list_for_each_entry_safe(xd, _xd, &c->xattrindex[index], xindex) {
-			if (xd->flags & JFFS2_XFLAGS_HOT) {
+			if (xd->flags & JFFS2_XFLAGS_HOT)
 				xd->flags &= ~JFFS2_XFLAGS_HOT;
-			} else if (!(xd->flags & JFFS2_XFLAGS_BIND)) {
+			else if (!(xd->flags & JFFS2_XFLAGS_BIND))
 				unload_xattr_datum(c, xd);
-			}
+
 			if (c->xdatum_mem_usage <= target)
 				goto out;
 		}
@@ -1002,11 +1002,11 @@ ssize_t jffs2_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	}
 	rc = len;
  out:
-	if (!retry) {
+	if (!retry)
 		up_read(&c->xattr_sem);
-	} else {
+	else
 		up_write(&c->xattr_sem);
-	}
+
 	return rc;
 }
 
@@ -1053,22 +1053,22 @@ int do_jffs2_getxattr(struct inode *inode, int xprefix, const char *xname,
 		if (!strcmp(xname, xd->xname)) {
 			rc = xd->value_len;
 			if (buffer) {
-				if (size < rc) {
+				if (size < rc)
 					rc = -ERANGE;
-				} else {
+				else
 					memcpy(buffer, xd->xvalue, rc);
-				}
+
 			}
 			goto out;
 		}
 	}
 	rc = -ENODATA;
  out:
-	if (!retry) {
+	if (!retry)
 		up_read(&c->xattr_sem);
-	} else {
+	else
 		up_write(&c->xattr_sem);
-	}
+
 	return rc;
 }
 
-- 
1.7.4.1.48.g5673d


-- 
