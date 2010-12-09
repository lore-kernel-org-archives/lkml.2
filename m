Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab0LIUH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:07:28 -0500
Received: from mail.perches.com ([173.55.12.10]:2418 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab0LIUEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:14 -0500
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <trivial@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] ext2: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:04:03 -0800
Message-Id: <ab8fd6a6f1ef5c6bc6ab631f56e1187cc5de44a3.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext2/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index f8aecd2..2e1d834 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -67,7 +67,7 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
 	inode = NULL;
 	if (ino) {
 		inode = ext2_iget(dir->i_sb, ino);
-		if (unlikely(IS_ERR(inode))) {
+		if (IS_ERR(inode)) {
 			if (PTR_ERR(inode) == -ESTALE) {
 				ext2_error(dir->i_sb, __func__,
 						"deleted inode referenced: %lu",
-- 
1.7.3.3.464.gf80b6

