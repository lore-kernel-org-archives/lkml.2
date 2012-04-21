Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2DUVt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 17:49:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53797 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2DUVt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 17:49:56 -0400
From: Sasikanth V <sasikanth.v19@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasikanth V <sasikanth.v19@gmail.com>
Subject: [PATCH] fs: uselib - Set error on do_filp_open failure only
Date: Sun, 22 Apr 2012 03:19:43 +0530
Message-Id: <1335044983-2908-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present "error" is set irrespective of do_filp_open failed or not.
Setting error to PTR_ERR(file) on do_filp_open failure only.

Signed-off-by: Sasikanth V <sasikanth.v19@gmail.com>
---
 fs/exec.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b1fd202..cb43367 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -129,9 +129,10 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 
 	file = do_filp_open(AT_FDCWD, tmp, &uselib_flags, LOOKUP_FOLLOW);
 	putname(tmp);
-	error = PTR_ERR(file);
-	if (IS_ERR(file))
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
 		goto out;
+	}
 
 	error = -EINVAL;
 	if (!S_ISREG(file->f_path.dentry->d_inode->i_mode))
-- 
1.7.3.4

