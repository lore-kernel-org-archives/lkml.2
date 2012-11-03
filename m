Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2KCJhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:37:09 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52530 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab2KCJhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:37:07 -0400
Message-ID: <5094E437.2050607@gmail.com>
Date: Sat, 03 Nov 2012 10:30:31 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
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
