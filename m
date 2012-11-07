Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2KGKnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:43:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab2KGKmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:42:01 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Andrew Price <anprice@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/7] GFS2: Clean up some unused assignments
Date: Wed,  7 Nov 2012 10:15:55 +0000
Message-Id: <1352283359-3314-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
References: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Price <anprice@redhat.com>

Cleans up two cases where variables were assigned values but then never
used again.

Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 0def050..377a68d 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -677,10 +677,8 @@ static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	size_t writesize = iov_length(iov, nr_segs);
 	struct dentry *dentry = file->f_dentry;
 	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
-	struct gfs2_sbd *sdp;
 	int ret;
 
-	sdp = GFS2_SB(file->f_mapping->host);
 	ret = gfs2_rs_alloc(ip);
 	if (ret)
 		return ret;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 8ff95a2..01e444b 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -621,7 +621,6 @@ static void revoke_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 
 static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 {
-	struct gfs2_log_descriptor *ld;
 	struct gfs2_meta_header *mh;
 	unsigned int offset;
 	struct list_head *head = &sdp->sd_log_le_revoke;
@@ -634,7 +633,6 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 
 	length = gfs2_struct2blk(sdp, sdp->sd_log_num_revoke, sizeof(u64));
 	page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_REVOKE, length, sdp->sd_log_num_revoke);
-	ld = page_address(page);
 	offset = sizeof(struct gfs2_log_descriptor);
 
 	list_for_each_entry(bd, head, bd_list) {
-- 
1.7.4

