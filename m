Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2JNO4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:56:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46551 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754668Ab2JNOna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:30 -0400
Message-Id: <20121014143542.903014076@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 067/147] ext4: always set i_op in ext4_mknod()
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

commit 6a08f447facb4f9e29fcc30fb68060bb5a0d21c2 upstream.

ext4_special_inode_operations have their own ifdef CONFIG_EXT4_FS_XATTR
to mask those methods. And ext4_iget also always sets it, so there is
an inconsistency.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/namei.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8f4bda7..bd87b7a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2156,9 +2156,7 @@ retry:
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
-#ifdef CONFIG_EXT4_FS_XATTR
 		inode->i_op = &ext4_special_inode_operations;
-#endif
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
 	ext4_journal_stop(handle);


