Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966163Ab2EQMvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761851Ab2EQMst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/24] GFS2: Eliminate vestigial sd_log_le_rg
Date: Thu, 17 May 2012 13:23:23 +0100
Message-Id: <1337257411-3173-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch eliminates gfs2 superblock variable sd_log_le_rg which
is no longer used.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index e773fbc..f1189a2 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -690,7 +690,6 @@ struct gfs2_sbd {
 
 	struct list_head sd_log_le_buf;
 	struct list_head sd_log_le_revoke;
-	struct list_head sd_log_le_rg;
 	struct list_head sd_log_le_databuf;
 	struct list_head sd_log_le_ordered;
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6f3a18f..c5871ae 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -99,7 +99,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	atomic_set(&sdp->sd_log_pinned, 0);
 	INIT_LIST_HEAD(&sdp->sd_log_le_buf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_revoke);
-	INIT_LIST_HEAD(&sdp->sd_log_le_rg);
 	INIT_LIST_HEAD(&sdp->sd_log_le_databuf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_ordered);
 
-- 
1.7.4

