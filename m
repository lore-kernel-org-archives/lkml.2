Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2IZIvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab2IZIvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:43 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/27] GFS2: change function gfs2_direct_IO to use a normal gfs2_glock_dq
Date: Wed, 26 Sep 2012 09:25:31 +0100
Message-Id: <1348647948-3219-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes function gfs2_direct_IO so that it uses a normal
call to gfs2_glock_dq rather than a call to a multiple-dq of one item.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 00eaa83..01c4975 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1024,7 +1024,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 				  offset, nr_segs, gfs2_get_block_direct,
 				  NULL, NULL, 0);
 out:
-	gfs2_glock_dq_m(1, &gh);
+	gfs2_glock_dq(&gh);
 	gfs2_holder_uninit(&gh);
 	return rv;
 }
-- 
1.7.4

