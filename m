Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab0G3Rbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:31:55 -0400
Received: from kroah.org ([198.145.64.141]:51949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752Ab0G3RTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:33 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:09 2010
Message-Id: <20100730171509.506446496@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [109/165] ext4: check missed return value in ext4_sync_file()
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 0671e704658b9f26f85e78d51176daa861f955c7 upstream (as of v2.6.34-git13)

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/fsync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -101,7 +101,7 @@ int ext4_sync_file(struct file *file, st
 		    (journal->j_fs_dev != journal->j_dev) &&
 		    (journal->j_flags & JBD2_BARRIER))
 			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
-		jbd2_log_wait_commit(journal, commit_tid);
+		ret = jbd2_log_wait_commit(journal, commit_tid);
 	} else if (journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;


