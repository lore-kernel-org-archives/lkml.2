Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760542Ab0J0DTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 23:19:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45798 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0J0DTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 23:19:38 -0400
Date: Wed, 27 Oct 2010 04:19:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: fix braino in fs: do not assign default i_ino in new_inode
Message-ID: <20101027031936.GD19804@ZenIV.linux.org.uk>
References: <20101026231725.GB19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026231725.GB19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbfs_get_inode() is something completely different...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 38f8f0f..4a830df 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -980,7 +980,7 @@ ffs_sb_make_inode(struct super_block *sb, void *data,
 	if (likely(inode)) {
 		struct timespec current_time = CURRENT_TIME;
 
-		inode->i_ino	 = usbfs_get_inode();
+		inode->i_ino	 = get_next_ino();
 		inode->i_mode    = perms->mode;
 		inode->i_uid     = perms->uid;
 		inode->i_gid     = perms->gid;
