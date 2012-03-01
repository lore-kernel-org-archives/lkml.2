Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030743Ab2CALnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:43:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966094Ab2CALlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:41:55 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        dchinner@redhat.com, Jan Kara <jack@suse.cz>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net
Subject: [PATCH 6/9] fuse: Push file_update_time() into fuse_page_mkwrite()
Date: Thu,  1 Mar 2012 12:41:40 +0100
Message-Id: <1330602103-8851-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330602103-8851-1-git-send-email-jack@suse.cz>
References: <1330602103-8851-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fuse/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4a199fd..eade72e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1323,6 +1323,7 @@ static int fuse_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	struct inode *inode = vma->vm_file->f_mapping->host;
 
+	file_update_time(vma->vm_file);
 	fuse_wait_on_page_writeback(inode, page->index);
 	return 0;
 }
-- 
1.7.1

