Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2LXCS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 21:18:27 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53326 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2LXCO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 21:14:57 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH 12/29] xfs: rename random32() to prandom_u32()
Date: Mon, 24 Dec 2012 11:13:59 +0900
Message-Id: <1356315256-6572-13-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_alloc.c  | 2 +-
 fs/xfs/xfs_error.c  | 2 +-
 fs/xfs/xfs_ialloc.c | 2 +-
 fs/xfs/xfs_log.c    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 393055f..d2dd19d 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -842,7 +842,7 @@ xfs_alloc_ag_vextent_near(
 	 */
 	int		dofirst;	/* set to do first algorithm */
 
-	dofirst = random32() & 1;
+	dofirst = prandom_u32() & 1;
 #endif
 
 restart:
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 6104560..07bf3b9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -66,7 +66,7 @@ xfs_error_test(int error_tag, int *fsidp, char *expression,
 	int i;
 	int64_t fsid;
 
-	if (random32() % randfactor)
+	if (prandom_u32() % randfactor)
 		return 0;
 
 	memcpy(&fsid, fsidp, sizeof(xfs_fsid_t));
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index a815412..6c75865 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -373,7 +373,7 @@ xfs_ialloc_ag_alloc(
 	 * number from being easily guessable.
 	 */
 	error = xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno,
-			args.len, random32());
+			args.len, prandom_u32());
 
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 46bd9d5..92e036b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3485,7 +3485,7 @@ xlog_ticket_alloc(
 	tic->t_curr_res		= unit_bytes;
 	tic->t_cnt		= cnt;
 	tic->t_ocnt		= cnt;
-	tic->t_tid		= random32();
+	tic->t_tid		= prandom_u32();
 	tic->t_clientid		= client;
 	tic->t_flags		= XLOG_TIC_INITED;
 	tic->t_trans_type	= 0;
-- 
1.7.11.7

