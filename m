Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2BPIm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 03:42:28 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:38244 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755940Ab2BPIm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 03:42:26 -0500
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <529380705.15452@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: Li Wang <liwang@nudt.edu.cn>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: <ecryptfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Li Wang <liwang@nudt.edu.cn>
Subject: [PATCH 2/3] eCryptfs: Remove redundant IF statement
Date: Fri, 17 Feb 2012 00:36:49 +0800
Message-Id: <1329410210-2712-2-git-send-email-liwang@nudt.edu.cn>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329410210-2712-1-git-send-email-liwang@nudt.edu.cn>
References: <1329410210-2712-1-git-send-email-liwang@nudt.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ecryptfs_write_begin(mmap.c)
1  ...
2  if (index != 0) {
3	if (prev_page_end_size > i_size_read(page->mapping->host)) {
4		...
5	}
6	...
7  }
The IF statement in line 2 is redundant since the IF statement in line
3 deduces that.

Signed-off-by: Li Wang <liwang@nudt.edu.cn>
---
 fs/ecryptfs/mmap.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 27c0da8..59a8e57 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -368,8 +368,7 @@ static int ecryptfs_write_begin(struct file *file,
 	}
 	/* If creating a page or more of holes, zero them out via truncate.
 	 * Note, this will increase i_size. */
-	if (index != 0) {
-		if (prev_page_end_size > i_size_read(page->mapping->host)) {
+	if (prev_page_end_size > i_size_read(page->mapping->host)) {
 			rc = ecryptfs_truncate(file->f_path.dentry,
 					       prev_page_end_size);
 			if (rc) {
@@ -379,7 +378,6 @@ static int ecryptfs_write_begin(struct file *file,
 				       prev_page_end_size, rc);
 				goto out;
 			}
-		}
 	}
 out:
 	if (unlikely(rc)) {
-- 
1.7.6.5

