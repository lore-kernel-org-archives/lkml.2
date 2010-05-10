Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab0EJXEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:04:39 -0400
Received: from kroah.org ([198.145.64.141]:45371 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab0EJW6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:31 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:41 2010
Message-Id: <20100510223541.776043632@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>, James Morris <jmorris@namei.org>
Subject: [82/98] security: testing the wrong variable in create_by_name()
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit b338cc8207eae46640a8d534738fda7b5e48511d upstream.

There is a typo here.  We should be testing "*dentry" instead of
"dentry".  If "*dentry" is an ERR_PTR, it gets dereferenced in either
mkdir() or create() which would cause an OOPs.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/inode.c
+++ b/security/inode.c
@@ -168,13 +168,13 @@ static int create_by_name(const char *na
 
 	mutex_lock(&parent->d_inode->i_mutex);
 	*dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry)) {
+	if (!IS_ERR(*dentry)) {
 		if ((mode & S_IFMT) == S_IFDIR)
 			error = mkdir(parent->d_inode, *dentry, mode);
 		else
 			error = create(parent->d_inode, *dentry, mode);
 	} else
-		error = PTR_ERR(dentry);
+		error = PTR_ERR(*dentry);
 	mutex_unlock(&parent->d_inode->i_mutex);
 
 	return error;


