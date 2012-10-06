Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2JFI32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:29:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43897 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2JFI3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:29:25 -0400
Message-ID: <506FEA53.2090305@gmail.com>
Date: Sat, 06 Oct 2012 10:22:43 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 09/22] bfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/bfs/file.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index f20e8a7..4967258 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -171,8 +171,9 @@ static int bfs_write_begin(struct file *file, struct address_space *mapping,
 				bfs_get_block);
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
