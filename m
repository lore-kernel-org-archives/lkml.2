Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892Ab2CEOzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:55:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab2CEOy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:54:28 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 5/7] gfs2: Push file_update_time() into gfs2_page_mkwrite()
Date: Mon,  5 Mar 2012 15:54:16 +0100
Message-Id: <1330959258-23211-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330959258-23211-1-git-send-email-jack@suse.cz>
References: <1330959258-23211-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Steven Whitehouse <swhiteho@redhat.com>
CC: cluster-devel@redhat.com
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/file.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index c5fb359..1f03531 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -375,6 +375,9 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
+	/* Update file times before taking page lock */
+	file_update_time(vma->vm_file);
+
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	ret = gfs2_glock_nq(&gh);
 	if (ret)
-- 
1.7.1

