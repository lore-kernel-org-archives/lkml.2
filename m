Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2LOK5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 05:57:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43754 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab2LOK5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 05:57:10 -0500
Message-ID: <50CC55EC.2050605@gmail.com>
Date: Sat, 15 Dec 2012 11:50:20 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
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
 fs/ocfs2/file.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index dda0898..9366d32 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1218,24 +1218,6 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
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
