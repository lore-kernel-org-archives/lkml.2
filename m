Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab0JROhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab0JROhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:48 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/22] GFS2: Fix journal check for spectator mounts
Date: Mon, 18 Oct 2010 15:15:38 +0100
Message-Id: <1287411346-17855-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking journals for spectator mounts, we cannot rely on the
journal being locked, whatever its jid might be. This patch
ensures that we always get the journal locks when checking
journals for a spectator mount.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index f7f89a9..666548e 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -456,7 +456,8 @@ void gfs2_recover_func(struct work_struct *work)
 	unsigned int pass;
 	int error;
 
-	if (jd->jd_jid != sdp->sd_lockstruct.ls_jid) {
+	if (sdp->sd_args.ar_spectator ||
+	    (jd->jd_jid != sdp->sd_lockstruct.ls_jid)) {
 		fs_info(sdp, "jid=%u: Trying to acquire journal lock...\n",
 			jd->jd_jid);
 
-- 
1.7.1.1

