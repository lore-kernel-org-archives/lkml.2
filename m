Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2JFIZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:25:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36923 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab2JFIZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:25:11 -0400
Message-ID: <506FE958.4070005@gmail.com>
Date: Sat, 06 Oct 2012 10:18:32 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 07/22] adfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/adfs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
index e9bad50..81de375 100644
--- a/fs/adfs/inode.c
+++ b/fs/adfs/inode.c
@@ -57,8 +57,9 @@ static int adfs_write_begin(struct file *file, struct address_space *mapping,
 				&ADFS_I(mapping->host)->mmu_private);
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
