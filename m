Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0CTNEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:04:07 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39667 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0CTNED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=JXRYhATenHEwTV1Xz0cClOlaf/MGMxhfyeafk2Kv+rTdXUpmbghQwVvHW347ljusJM
         RC+5Pl/PQvPLcrH56oCTGoVxhdUbxILBhxZ6DOix8HblFROOo6ZeAfFgP+JY4tyOtP+S
         ZfYtZFagLdY6jvZC0xyg9EfT6O59YAaz5Wr3M=
Date: Sat, 20 Mar 2010 16:01:27 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: ceph-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] ceph: cleanup: remove dead code
Message-ID: <20100320130127.GA32626@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Sage Weil <sage@newdream.net>, ceph-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"xattr" is never NULL here.  We took care of that in the previous
if statement block.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 37d6ce6..65b0e9b 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -185,12 +185,6 @@ static int __set_xattr(struct ceph_inode_info *ci,
 		ci->i_xattrs.names_size -= xattr->name_len;
 		ci->i_xattrs.vals_size -= xattr->val_len;
 	}
-	if (!xattr) {
-		pr_err("__set_xattr ENOMEM on %p %llx.%llx xattr %s=%s\n",
-		       &ci->vfs_inode, ceph_vinop(&ci->vfs_inode), name,
-		       xattr->val);
-		return -ENOMEM;
-	}
 	ci->i_xattrs.names_size += name_len;
 	ci->i_xattrs.vals_size += val_len;
 	if (val)
