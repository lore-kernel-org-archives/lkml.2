Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab2JTMcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:32:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41084 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab2JTMcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:32:15 -0400
Message-ID: <50829841.6020003@gmail.com>
Date: Sat, 20 Oct 2012 14:25:37 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/21] ncpfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/ncpfs/inode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index d7e9fe7..1acdad7 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -976,9 +976,7 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
 			goto out;
 
 		if (attr->ia_size != i_size_read(inode)) {
-			result = vmtruncate(inode, attr->ia_size);
-			if (result)
-				goto out;
+			truncate_setsize(inode, attr->ia_size);
 			mark_inode_dirty(inode);
 		}
 	}
-- 
1.7.3.4
