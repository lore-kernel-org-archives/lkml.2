Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0DEPpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:45:54 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46454 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab0DEPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Rd44fk/jO7JIxpTO3GDf1SzOmkVZa9h4M5RRbVl1P6MuHM5qOajsq8HS8Zjv8HDo1Y
         6RPgelLGaZqEz7p3GBlj1DDUN3ynXU2CuCk9nx2J3Z65AchScqgh+ykftgtAP9AeXm0i
         WBs4cEhFFyRJKRplnJObdcY7XtPXe+b3JLIA8=
Subject: [PATCH 1/2] ntfs : Clean up ntfs_attr_extend_initialized
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Altaparmakov <aia21@cantab.net>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Jiri Kosina <jkosina@suse.cz>,
       linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 00:45:35 +0900
Message-ID: <1270482335.1814.136.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cached_page and lru_pvec have not been used.
Let's remove the arguments.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 fs/ntfs/file.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index b681c71..41ffdcc 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -97,9 +97,6 @@ static int ntfs_file_open(struct inode *vi, struct file *filp)
  * the page at all.  For a more detailed explanation see ntfs_truncate() in
  * fs/ntfs/inode.c.
  *
- * @cached_page and @lru_pvec are just optimizations for dealing with multiple
- * pages.
- *
  * Return 0 on success and -errno on error.  In the case that an error is
  * encountered it is possible that the initialized size will already have been
  * incremented some way towards @new_init_size but it is guaranteed that if
@@ -109,8 +106,7 @@ static int ntfs_file_open(struct inode *vi, struct file *filp)
  * Locking: i_mutex on the vfs inode corrseponsind to the ntfs inode @ni must be
  *	    held by the caller.
  */
-static int ntfs_attr_extend_initialized(ntfs_inode *ni, const s64 new_init_size,
-		struct page **cached_page, struct pagevec *lru_pvec)
+static int ntfs_attr_extend_initialized(ntfs_inode *ni, const s64 new_init_size)
 {
 	s64 old_init_size;
 	loff_t old_i_size;
@@ -1924,8 +1920,7 @@ static ssize_t ntfs_file_buffered_write(struct kiocb *iocb,
 	ll = ni->initialized_size;
 	read_unlock_irqrestore(&ni->size_lock, flags);
 	if (pos > ll) {
-		err = ntfs_attr_extend_initialized(ni, pos, &cached_page,
-				&lru_pvec);
+		err = ntfs_attr_extend_initialized(ni, pos);
 		if (err < 0) {
 			ntfs_error(vol->sb, "Cannot perform write to inode "
 					"0x%lx, attribute type 0x%x, because "
-- 
1.6.5



-- 
Kind regards,
Minchan Kim


