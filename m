Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1EHSua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:50:30 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:51324 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1EHSuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:19 -0400
Date: Sun, 8 May 2011 20:44:00 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 8/14] HPFS: Restrict uid and gid to 16-bit values
Message-ID: <alpine.DEB.2.00.1105082028310.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restrict uid and gid to 16-bit values.

HPFS stores only 2 bytes in the EAs.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.39-rc5-fast/fs/hpfs/inode.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/inode.c	2011-05-05 01:02:49.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/inode.c	2011-05-05 01:02:53.000000000 +0200
@@ -261,6 +261,10 @@ int hpfs_setattr(struct dentry *dentry, 
 	hpfs_lock(inode->i_sb);
 	if (inode->i_ino == hpfs_sb(inode->i_sb)->sb_root)
 		goto out_unlock;
+	if ((attr->ia_valid & ATTR_UID) && attr->ia_uid >= 0x10000)
+		goto out_unlock;
+	if ((attr->ia_valid & ATTR_GID) && attr->ia_gid >= 0x10000)
+		goto out_unlock;
 	if ((attr->ia_valid & ATTR_SIZE) && attr->ia_size > inode->i_size)
 		goto out_unlock;
 
