Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab0JZORU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:17:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35241 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0JZORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:17:19 -0400
Message-Id: <20101026141655.948348106@szeredi.hu>
References: <20101026141641.315420064@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 26 Oct 2010 16:16:42 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] vfs: ignore error on forced remount
Content-Disposition: inline; filename=vfs-fix-force-remount-readonly.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

On emergency remount we want to force MS_RDONLY on the super block
even if ->remount_fs() failed for some reason.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-10-26 14:26:57.000000000 +0200
+++ linux-2.6/fs/super.c	2010-10-26 14:27:01.000000000 +0200
@@ -579,7 +579,8 @@ int do_remount_sb(struct super_block *sb
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval)
+		/* If forced remount, go ahead despite any errors */
+		if (retval && !force)
 			return retval;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);

-- 
