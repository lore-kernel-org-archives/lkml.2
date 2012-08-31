Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2HaOBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:01:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34998 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2HaOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:01:29 -0400
Message-ID: <5040C22C.1030508@gmail.com>
Date: Fri, 31 Aug 2012 15:54:52 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>, Luca Tettamanti <kronos.it@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/21] adfs: drop vmtruncate
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
index 1dab6a1..5d2a0e0 100644
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
