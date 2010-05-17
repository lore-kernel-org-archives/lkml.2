Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0EQM6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab0EQM6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:16 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/11] GFS2: Fix typo
Date: Mon, 17 May 2010 13:40:25 +0100
Message-Id: <1274100025-26629-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-11-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-4-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-5-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-6-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-7-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-8-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-9-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-10-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-11-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A missing ! in a test.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 7afb62e..68d2795 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -233,7 +233,7 @@ static ssize_t demote_rq_store(struct gfs2_sbd *sdp, const char *buf, size_t len
 	glops = gfs2_glops_list[gltype];
 	if (glops == NULL)
 		return -EINVAL;
-	if (test_and_set_bit(SDF_DEMOTE, &sdp->sd_flags))
+	if (!test_and_set_bit(SDF_DEMOTE, &sdp->sd_flags))
 		fs_info(sdp, "demote interface used\n");
 	rv = gfs2_glock_get(sdp, glnum, glops, 0, &gl);
 	if (rv)
-- 
1.6.2.5

