Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab0IRTYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:24:44 -0400
Received: from kroah.org ([198.145.64.141]:43681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab0IRTPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:49 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:04 2010
Message-Id: <20100918191304.622629345@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [085/129] minix: fix regression in minix_mkdir()
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jorge Boncompte [DTI2] <jorge@dti2.net>

commit eee743fd7eac9f2ea69ad06d093dfb5a12538fe5 upstream.

Commit 9eed1fb721c ("minix: replace inode uid,gid,mode init with helper")
broke directory creation on minix filesystems.

Fix it by passing the needed mode flag to inode init helper.

Signed-off-by: Jorge Boncompte [DTI2] <jorge@dti2.net>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/minix/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -115,7 +115,7 @@ static int minix_mkdir(struct inode * di
 
 	inode_inc_link_count(dir);
 
-	inode = minix_new_inode(dir, mode, &err);
+	inode = minix_new_inode(dir, S_IFDIR | mode, &err);
 	if (!inode)
 		goto out_dir;
 


