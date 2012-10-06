Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2JFIYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:24:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33862 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2JFIYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:24:30 -0400
Message-ID: <506FE92F.2000609@gmail.com>
Date: Sat, 06 Oct 2012 10:17:51 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 06/22] ocfs2: drop vmtruncate
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
index 5a4ee77..f0737d0 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1229,11 +1229,12 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
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
