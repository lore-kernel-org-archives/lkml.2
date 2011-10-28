Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab1J1MRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:17:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab1J1MNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:13:54 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 05/13] hypfs: remove unnecessary nlink setting
Date: Fri, 28 Oct 2011 14:13:24 +0200
Message-Id: <1319804012-16346-6-git-send-email-miklos@szeredi.hu>
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
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/hypfs/inode.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 6fe874f..7ae0d0d 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -109,8 +109,6 @@ static struct inode *hypfs_make_inode(struct super_block *sb, int mode)
 		ret->i_atime = ret->i_mtime = ret->i_ctime = CURRENT_TIME;
 		if (mode & S_IFDIR)
 			ret->i_nlink = 2;
-		else
-			ret->i_nlink = 1;
 	}
 	return ret;
 }
-- 
1.7.3.4

