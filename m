Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1EHSuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:50:23 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:54762 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab1EHSuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:19 -0400
Date: Sun, 8 May 2011 20:43:27 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/14] HPFS: Remove mark_inode_dirty
Message-ID: <alpine.DEB.2.00.1105082026220.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove mark_inode_dirty

HPFS doesn't use kernel's dirty inode indicator anyway because
writing an inode requires directory's mutex.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/inode.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/inode.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/inode.c	2011-05-05 01:02:47.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/inode.c	2011-05-05 01:02:49.000000000 +0200
@@ -199,8 +199,6 @@ void hpfs_write_inode(struct inode *i)
 		}
 		hpfs_write_inode_nolock(i);
 		iput(parent);
-	} else {
-		mark_inode_dirty(i);
 	}
 }
 
@@ -278,7 +276,6 @@ int hpfs_setattr(struct dentry *dentry, 
 	}
 
 	setattr_copy(inode, attr);
-	mark_inode_dirty(inode);
 
 	hpfs_write_inode(inode);
 
