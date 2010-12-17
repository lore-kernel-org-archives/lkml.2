Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0LQMqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0LQMqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:14 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/15] GFS2: fs/gfs2/glock.h: Add __attribute__((format(printf,2,3)) to gfs2_print_dbg
Date: Fri, 17 Dec 2010 12:24:12 +0000
Message-Id: <1292588661-14350-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Functions that use printf formatting, especially
those that use %pV, should have their uses of
printf format and arguments checked by the compiler.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index db1c26d..a12d117 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -212,6 +212,8 @@ int gfs2_glock_nq_num(struct gfs2_sbd *sdp,
 int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs);
+
+__attribute__ ((format(printf, 2, 3)))
 void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...);
 
 /**
-- 
1.7.3.3

