Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2JTMZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:25:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35828 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab2JTMZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:25:37 -0400
Message-ID: <508296B4.60508@gmail.com>
Date: Sat, 20 Oct 2012 14:19:00 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH 06/21] ocfs2: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/ocfs2/file.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 5a4ee77..eb16e44 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1172,6 +1172,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			status = -ENOSPC;
 			goto bail_unlock;
 		}
+		truncate_setsize(inode, attr->ia_size);
 	}
 
 	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
@@ -1218,24 +1219,6 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 	}
 
-	/*
-	 * This will intentionally not wind up calling truncate_setsize(),
-	 * since all the work for a size change has been done above.
-	 * Otherwise, we could get into problems with truncate as
-	 * ip_alloc_sem is used there to protect against i_size
-	 * changes.
-	 *
-	 * XXX: this means the conditional below can probably be removed.
-	 */
-	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode)) {
-		status = vmtruncate(inode, attr->ia_size);
-		if (status) {
-			mlog_errno(status);
-			goto bail_commit;
-		}
-	}
-
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
 
-- 
1.7.3.4
