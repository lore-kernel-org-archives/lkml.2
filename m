Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2IZIyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:54:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab2IZIvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:55 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/27] GFS2: Fix ->show_options() for statfs slow
Date: Wed, 26 Sep 2012 09:25:39 +0100
Message-Id: <1348647948-3219-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->show_options() function for GFS2 was not correctly displaying
the value when statfs slow in in use.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Milos Jakubicek <xjakub@fi.muni.cz>

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 3cbac68..79cac70 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1366,6 +1366,8 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 	val = sdp->sd_tune.gt_statfs_quantum;
 	if (val != 30)
 		seq_printf(s, ",statfs_quantum=%d", val);
+	else if (sdp->sd_tune.gt_statfs_slow)
+		seq_puts(s, ",statfs_quantum=0");
 	val = sdp->sd_tune.gt_quota_quantum;
 	if (val != 60)
 		seq_printf(s, ",quota_quantum=%d", val);
-- 
1.7.4

