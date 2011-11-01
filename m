Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1KAXXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:23:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36957 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1KAXXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:23:15 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dave@archlinux.org, tom@archlinux.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] VFS: fix statfs() automounter semantics regression
Date: Tue,  1 Nov 2011 18:23:10 -0500
Message-Id: <1320189791-21634-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one in their right mind would expect statfs() to not work on a
automounter managed mount point. Fix it.

This mirrors the fix made to the quota code in 815d405ceff0d69646.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 fs/statfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index 8244924..9cf04a1 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -76,7 +76,7 @@ EXPORT_SYMBOL(vfs_statfs);
 int user_statfs(const char __user *pathname, struct kstatfs *st)
 {
 	struct path path;
-	int error = user_path(pathname, &path);
+	int error = user_path_at(AT_FDCWD, pathname, LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT, &path);
 	if (!error) {
 		error = vfs_statfs(&path, st);
 		path_put(&path);
-- 
1.7.7.1

