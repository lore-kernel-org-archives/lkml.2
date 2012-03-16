Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946153Ab2CPX6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:58:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49074 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945934Ab2CPXiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:03 -0400
Message-Id: <20120316233448.179551053@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:34:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 10/38] vfs: fix return value from do_last()
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 7f6c7e62fcc123e6bd9206da99a2163fe3facc31 upstream.

complete_walk() returns either ECHILD or ESTALE.  do_last() turns this into
ECHILD unconditionally.  If not in RCU mode, this error will reach userspace
which is complete nonsense.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2109,7 +2109,7 @@ static struct file *do_last(struct namei
 		/* sayonara */
 		error = complete_walk(nd);
 		if (error)
-			return ERR_PTR(-ECHILD);
+			return ERR_PTR(error);
 
 		error = -ENOTDIR;
 		if (nd->flags & LOOKUP_DIRECTORY) {


