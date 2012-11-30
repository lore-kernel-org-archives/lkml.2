Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2K3KSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab2K3KS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:27 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/16] GFS2: Use dirty_inode in gfs2_dir_add
Date: Fri, 30 Nov 2012 09:52:13 +0000
Message-Id: <1354269141-3311-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes the gfs2_dir_add function so that it uses
the dirty_inode function (via mark_inode_dirty) rather than manually
updating the dinode.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 259b088..9a35670 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1676,16 +1676,11 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 				be16_add_cpu(&leaf->lf_entries, 1);
 			}
 			brelse(bh);
-			error = gfs2_meta_inode_buffer(ip, &bh);
-			if (error)
-				break;
-			gfs2_trans_add_bh(ip->i_gl, bh, 1);
 			ip->i_entries++;
 			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 			if (S_ISDIR(nip->i_inode.i_mode))
 				inc_nlink(&ip->i_inode);
-			gfs2_dinode_out(ip, bh->b_data);
-			brelse(bh);
+			mark_inode_dirty(inode);
 			error = 0;
 			break;
 		}
-- 
1.7.4

