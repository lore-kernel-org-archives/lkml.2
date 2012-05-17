Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966127Ab2EQMtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:49:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965946Ab2EQMtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:49:00 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/24] GFS2: Fix quota adjustment return code
Date: Thu, 17 May 2012 13:23:31 +0100
Message-Id: <1337257411-3173-25-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes function gfs2_adjust_quota so that it properly
returns a good (zero) return code on the normal path through the code.
Without this, mounting GFS2 with -o quota=account periodically gave
this error message: GFS2: fsid=cluster:fs: gfs2_quotad: sync error -5

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 45d9171..b97178e 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -744,7 +744,7 @@ get_a_page:
 		i_size_write(inode, size);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME;
 	mark_inode_dirty(inode);
-	return err;
+	return 0;
 
 unlock_out:
 	unlock_page(page);
-- 
1.7.4

