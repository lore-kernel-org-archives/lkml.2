Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab2DPQXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:23:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2DPQOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:21 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 05/27] gfs2: Push file_update_time() into gfs2_page_mkwrite()
Date: Mon, 16 Apr 2012 18:13:43 +0200
Message-Id: <1334592845-22862-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
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
index a3d2c9e..151d667 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -376,6 +376,9 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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

