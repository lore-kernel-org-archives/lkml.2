Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab1J1MQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:16:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab1J1MN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:13:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz,
        Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 07/13] ocfs2: remove unnecessary nlink setting
Date: Fri, 28 Oct 2011 14:13:26 +0200
Message-Id: <1319804012-16346-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
References: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

alloc_inode() initializes i_nlink to 1.  Remove unnecessary
re-initialization.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Joel Becker <jlbec@evilplan.org>
CC: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/namei.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 53aa41e..0181f63 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -200,8 +200,6 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, int mode)
 	 * callers. */
 	if (S_ISDIR(mode))
 		inode->i_nlink = 2;
-	else
-		inode->i_nlink = 1;
 	inode_init_owner(inode, dir, mode);
 	dquot_initialize(inode);
 	return inode;
-- 
1.7.3.4

