Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab1KJDab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:30:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934722Ab1KJDaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:16 2011
Message-Id: <20111109212716.602614843@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Darrick J. Wong" <djwong@us.ibm.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [159/262] ext4: ext4_mkdir should dirty dir_block with newly created directory inode
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@us.ibm.com>

commit f9287c1f2d329f4d78a3bbc9cf0db0ebae6f146a upstream.

ext4_mkdir calls ext4_handle_dirty_metadata with dir_block and the inode "dir".
Unfortunately, dir_block belongs to the newly created directory (which is
"inode"), not the parent directory (which is "dir").  Fix the incorrect
association.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1866,7 +1866,7 @@ retry:
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	inode->i_nlink = 2;
 	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
+	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
 	if (err)
 		goto out_clear_inode;
 	err = ext4_mark_inode_dirty(handle, inode);


