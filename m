Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3ABNyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:54:50 -0500
Received: from gerolde.archlinux.org ([66.211.214.132]:60731 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABNys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:54:48 -0500
From: Dave Reisner <dreisner@archlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Reisner <dreisner@archlinux.org>
Subject: [PATCH] debugfs: convert gid= argument from decimal, not octal
Date: Wed,  2 Jan 2013 08:54:37 -0500
Message-Id: <1357134877-27141-1-git-send-email-dreisner@archlinux.org>
X-Mailer: git-send-email 1.8.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch technically breaks userspace, but I suspect that anyone who
actually used this flag would have encountered this brokenness, declared
it lunacy, and already sent a patch.

Signed-off-by: Dave Reisner <dreisner@archlinux.org>
---
 fs/debugfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 153bb1e..a5f12b7 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -176,7 +176,7 @@ static int debugfs_parse_options(char *data, struct debugfs_mount_opts *opts)
 			opts->uid = uid;
 			break;
 		case Opt_gid:
-			if (match_octal(&args[0], &option))
+			if (match_int(&args[0], &option))
 				return -EINVAL;
 			gid = make_kgid(current_user_ns(), option);
 			if (!gid_valid(gid))
-- 
1.8.0.3

