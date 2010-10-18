Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab0JROkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:40:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab0JROhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:43 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/22] GFS2: Remove ignore_local_fs mount argument
Date: Mon, 18 Oct 2010 15:15:35 +0100
Message-Id: <1287411346-17855-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is been a no-op for a very long time now. I'm pretty sure
nobody uses it, but just in case we'll still accept it on the
command line, but ignore it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b12ca10..c8a2db1 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -416,7 +416,6 @@ struct gfs2_args {
 	char ar_locktable[GFS2_LOCKNAME_LEN];	/* Name of the Lock Table */
 	char ar_hostdata[GFS2_LOCKNAME_LEN];	/* Host specific data */
 	unsigned int ar_spectator:1;		/* Don't get a journal */
-	unsigned int ar_ignore_local_fs:1;	/* Ignore optimisations */
 	unsigned int ar_localflocks:1;		/* Let the VFS do flock|fcntl */
 	unsigned int ar_localcaching:1;		/* Local caching */
 	unsigned int ar_debug:1;		/* Oops on errors */
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index e031fa4..06a4a7e 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -159,7 +159,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			args->ar_spectator = 1;
 			break;
 		case Opt_ignore_local_fs:
-			args->ar_ignore_local_fs = 1;
+			/* Retained for backwards compat only */
 			break;
 		case Opt_localflocks:
 			args->ar_localflocks = 1;
@@ -1128,7 +1128,6 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 
 	/* Some flags must not be changed */
 	if (args_neq(&args, &sdp->sd_args, spectator) ||
-	    args_neq(&args, &sdp->sd_args, ignore_local_fs) ||
 	    args_neq(&args, &sdp->sd_args, localflocks) ||
 	    args_neq(&args, &sdp->sd_args, localcaching) ||
 	    args_neq(&args, &sdp->sd_args, meta))
@@ -1233,8 +1232,6 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",hostdata=%s", args->ar_hostdata);
 	if (args->ar_spectator)
 		seq_printf(s, ",spectator");
-	if (args->ar_ignore_local_fs)
-		seq_printf(s, ",ignore_local_fs");
 	if (args->ar_localflocks)
 		seq_printf(s, ",localflocks");
 	if (args->ar_localcaching)
-- 
1.7.1.1

