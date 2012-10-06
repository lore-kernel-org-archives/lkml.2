Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2JFIR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:17:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43509 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2JFIRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:17:25 -0400
Message-ID: <506FE786.1030507@gmail.com>
Date: Sat, 06 Oct 2012 10:10:46 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 01/22] ufs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/ufs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index eb6d0b7..2b43ce9 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -536,8 +536,9 @@ static int ufs_write_begin(struct file *file, struct address_space *mapping,
 				ufs_getfrag_block);
 	if (unlikely(ret)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0)
+			truncate_setsize(mapping->host, isize);
 	}
 
 	return ret;
-- 
1.7.3.4
