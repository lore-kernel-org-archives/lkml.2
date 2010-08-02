Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0HBJtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab0HBJtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:49:17 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 7/8] GFS2: Fix typo in stuffed file data copy handling
Date: Mon,  2 Aug 2010 10:27:58 +0100
Message-Id: <1280741279-6782-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
References: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

trunc_start() in bmap.c incorrectly uses sizeof(struct gfs2_inode) instead of
sizeof(struct gfs2_dinode).

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 744c29e..6f48280 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1040,7 +1040,7 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 		goto out;
 
 	if (gfs2_is_stuffed(ip)) {
-		u64 dsize = size + sizeof(struct gfs2_inode);
+		u64 dsize = size + sizeof(struct gfs2_dinode);
 		ip->i_disksize = size;
 		ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-- 
1.7.1.1

