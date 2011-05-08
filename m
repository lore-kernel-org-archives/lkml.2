Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1EHSu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:50:26 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:44598 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab1EHSuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:19 -0400
Date: Sun, 8 May 2011 20:44:19 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 10/14] HPFS: Implement fsync for hpfs
Message-ID: <alpine.DEB.2.00.1105082029340.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement fsync for hpfs.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/file.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/file.c	2011-05-05 01:02:43.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/file.c	2011-05-05 01:02:56.000000000 +0200
@@ -20,8 +20,8 @@ static int hpfs_file_release(struct inod
 
 int hpfs_file_fsync(struct file *file, int datasync)
 {
-	/*return file_fsync(file, datasync);*/
-	return 0; /* Don't fsync :-) */
+	struct inode *inode = file->f_mapping->host;
+	return sync_blockdev(inode->i_sb->s_bdev);
 }
 
 /*
