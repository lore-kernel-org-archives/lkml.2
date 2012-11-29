Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2K2GAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:00:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50967 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2K2GAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:00:45 -0500
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 3/6] fs: 9p pass NULL as second parameter for set_anon_super
Date: Thu, 29 Nov 2012 11:29:38 +0530
Message-Id: <1354168778-11975-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_anon_super does not use the second parameter in its implementation. 
So there is no need to pass on the second parameter.

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 fs/9p/vfs_super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 137d503..132db90 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -61,7 +61,7 @@ static const struct super_operations v9fs_super_ops, v9fs_super_ops_dotl;
 static int v9fs_set_super(struct super_block *s, void *data)
 {
 	s->s_fs_info = data;
-	return set_anon_super(s, data);
+	return set_anon_super(s, NULL);
 }
 
 /**
-- 
1.7.7.6

