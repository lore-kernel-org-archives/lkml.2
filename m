Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966094Ab2EQMuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:50:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761872Ab2EQMsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:53 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/24] GFS2: Remove redundant metadata block type check
Date: Thu, 17 May 2012 13:23:26 +0100
Message-Id: <1337257411-3173-20-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch removes a redundant metadata block check. See description below.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index cd3e6fb..4bdcf37 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -378,11 +378,6 @@ int gfs2_inode_refresh(struct gfs2_inode *ip)
 	if (error)
 		return error;
 
-	if (gfs2_metatype_check(GFS2_SB(&ip->i_inode), dibh, GFS2_METATYPE_DI)) {
-		brelse(dibh);
-		return -EIO;
-	}
-
 	error = gfs2_dinode_in(ip, dibh->b_data);
 	brelse(dibh);
 	clear_bit(GIF_INVALID, &ip->i_flags);
-- 
1.7.4

