Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946114Ab2CPX6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:58:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946094Ab2CPXiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:07 -0400
Message-Id: <20120316233448.268854497@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:34:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 11/38] vfs: fix double put after complete_walk()
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 097b180ca09b581ef0dc24fbcfc1b227de3875df upstream.

complete_walk() already puts nd->path, no need to do it again at cleanup time.

This would result in Oopses if triggered, apparently the codepath is not too
well exercised.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2208,7 +2208,7 @@ static struct file *do_last(struct namei
 	/* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */
 	error = complete_walk(nd);
 	if (error)
-		goto exit;
+		return ERR_PTR(error);
 	error = -EISDIR;
 	if (S_ISDIR(nd->inode->i_mode))
 		goto exit;


