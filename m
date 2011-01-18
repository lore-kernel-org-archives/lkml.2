Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab1ARMd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 07:33:27 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48404 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1ARMd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 07:33:26 -0500
Message-Id: <20110118123311.235754758@szeredi.hu>
References: <20110118123233.712697250@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 18 Jan 2011 13:32:34 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/4] vfs: ignore error on forced remount
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
--- linux-2.6.orig/fs/super.c	2011-01-17 09:33:44.000000000 +0100
+++ linux-2.6/fs/super.c	2011-01-18 12:36:02.000000000 +0100
@@ -580,7 +580,8 @@ int do_remount_sb(struct super_block *sb
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval)
+		/* If forced remount, go ahead despite any errors */
+		if (retval && !force)
 			return retval;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);

-- 
