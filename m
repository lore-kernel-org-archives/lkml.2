Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162307Ab1FAI4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:56:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:44185 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162155Ab1FAISi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:38 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:13 2011
Message-Id: <20110601081112.745416977@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:10 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Erez Zadok <ezk@cs.sunysb.edu>, Miklos Szeredi <mszeredi@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [040/165] VFS: move BUG_ON test for symlink nd->depth after
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 current->link_count test
Content-Length: 1009
Lines: 37

From: Erez Zadok <ezk@fsl.cs.sunysb.edu>

commit 1a4022f88d40e1255920b017556092ab926d7f66 upstream.

This solves a serious VFS-level bug in nested_symlink (which was
rewritten from do_follow_link), and follows the order of depth tests
that existed before.

The bug triggers a BUG_ON in fs/namei.c:1381, when running racer with
symlink and rename ops.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1378,12 +1378,12 @@ static inline int nested_symlink(struct
 {
 	int res;
 
-	BUG_ON(nd->depth >= MAX_NESTED_LINKS);
 	if (unlikely(current->link_count >= MAX_NESTED_LINKS)) {
 		path_put_conditional(path, nd);
 		path_put(&nd->path);
 		return -ELOOP;
 	}
+	BUG_ON(nd->depth >= MAX_NESTED_LINKS);
 
 	nd->depth++;
 	current->link_count++;


