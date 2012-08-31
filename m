Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2HaODF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:03:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47927 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab2HaODC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:03:02 -0400
Message-ID: <5040C289.7050408@gmail.com>
Date: Fri, 31 Aug 2012 15:56:25 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/21] bfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
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
