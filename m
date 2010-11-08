Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0KHQBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:01:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55345 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab0KHQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:cc:subject:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PlKI7SKBLOlcpEXlZFRq8slmW/zawf9j16tiCpCVSqGnU8nIPff2Ia2liwuM30u9Bj
         ONjMpkVuk9eHWajI8scGMQTbFU/DXLn6Z0hF77ZBrNG090GoI3gt5Lkj4V9Dit7BAYjP
         XI1XU67b3pH/JlcMMF/wyoZvAlBsqegUk8NpY=
Message-ID: <4CD81E7E.20308@gmail.com>
Date: Mon, 08 Nov 2010 21:29:58 +0530
From: Atul Sowani <sowani@gmail.com>
Reply-To: sowani@gmail.com
Organization: Digital Reality Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
CC: raven@themaw.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, autofs@linux.kernel.org,
        linux-afs@lists.infradead.org
Subject: Subject: [PATCH 2.6.36 1/1] autofs4: fix for root.c compiler warnings.
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added conditional compilation with CONFIG_COMPAT to avoid compiler warning:
fs/autofs4/root.c:31: warning: autofs4_root_compat_ioctl declared static but never defined

Signed-off-by: Atul Sowani <sowani@gmail.com>
---
diff -uprN a/fs/autofs4/root.c b/fs/autofs4/root.c
--- a/fs/autofs4/root.c	2010-10-21 02:00:22.000000000 +0530
+++ b/fs/autofs4/root.c	2010-11-08 09:37:47.675766134 +0530
@@ -28,7 +28,9 @@ static int autofs4_dir_unlink(struct ino
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
 static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
+#ifdef CONFIG_COMPAT
 static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
+#endif
 static int autofs4_dir_open(struct inode *inode, struct file *file);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
-- 
Atul Sowani (sowani@gmail.com)
http://savannah.gnu.org/users/atul
------------------------------------------------------------------------
