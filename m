Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab1KJEvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:51:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935437Ab1KJDcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:32:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:23 2011
Message-Id: <20111109212723.410082847@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan McGee <dpmcgee@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [227/262] VFS: fix statfs() automounter semantics regression
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan McGee <dpmcgee@gmail.com>

commit 5c8a0fbba543d9428a486f0d1282bbcf3cf1d95a upstream.

No one in their right mind would expect statfs() to not work on a
automounter managed mount point. Fix it.

[ I'm not sure about the "no one in their right mind" part.  It's not
  mounted, and you didn't ask for it to be mounted.  But nobody will
  really care, and this probably makes it match previous semantics, so..
      - Linus ]

This mirrors the fix made to the quota code in 815d405ceff0d69646.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/statfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -76,7 +76,7 @@ EXPORT_SYMBOL(vfs_statfs);
 int user_statfs(const char __user *pathname, struct kstatfs *st)
 {
 	struct path path;
-	int error = user_path(pathname, &path);
+	int error = user_path_at(AT_FDCWD, pathname, LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT, &path);
 	if (!error) {
 		error = vfs_statfs(&path, st);
 		path_put(&path);


