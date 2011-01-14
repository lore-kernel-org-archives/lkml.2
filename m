Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab1ANCK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:10:59 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:44561 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1ANCKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 21:10:52 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: vfs-scale, nd->inode after __do_follow_link()
Date: Fri, 14 Jan 2011 11:10:49 +0900
Message-ID: <7352.1294971049@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Isn't it path.dentry->d_inode instead of nd.inode?

J. R. Okajima

diff --git a/fs/namei.c b/fs/namei.c
index 5bb7588..1df3bee 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2356,8 +2374,9 @@ reval:
 			goto exit_dput;
 		error = __do_follow_link(&path, &nd, &cookie);
 		if (unlikely(error)) {
-			if (!IS_ERR(cookie) && nd.inode->i_op->put_link)
-				nd.inode->i_op->put_link(path.dentry, &nd, cookie);
+			struct dentry *i = path.dentry->d_inode;
+			if (!IS_ERR(cookie) && i->i_op->put_link)
+				i->i_op->put_link(path.dentry, &nd, cookie);
 			/* nd.path had been dropped */
 			nd.path = path;
 			goto out_path;
