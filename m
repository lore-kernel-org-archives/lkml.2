Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2HaOAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:00:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47985 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab2HaOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:00:52 -0400
Message-ID: <5040C206.40804@gmail.com>
Date: Fri, 31 Aug 2012 15:54:14 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
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

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/ocfs2/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 46a1f6d..dd95798 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1231,11 +1231,12 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	 */
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		status = vmtruncate(inode, attr->ia_size);
+		status = inode_newsize_ok(inode, attr->ia_size);
 		if (status) {
 			mlog_errno(status);
 			goto bail_commit;
 		}
+		truncate_setsize(inode, attr->ia_size);
 	}
 
 	setattr_copy(inode, attr);
-- 
1.7.3.4
