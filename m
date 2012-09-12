Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2ILVhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:37:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60723 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2ILVfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:35:13 -0400
Message-Id: <20120912213507.350516233@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Sep 2012 01:29:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 2/7] fs, exportfs: Escape nil dereference if no s_export_op present
References: <20120912212906.407242774@openvz.org>
Content-Disposition: inline; filename=fs-exportfs-add-null-check
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This routine will be used to generate a file handle in fdinfo
output for inotify subsystem, where if no s_export_op present
the general export_encode_fh should be used. Thus add
a test if s_export_op present inside exportfs_encode_fh itself.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/exportfs/expfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.git.orig/fs/exportfs/expfs.c
+++ linux-2.6.git/fs/exportfs/expfs.c
@@ -357,7 +357,7 @@ int exportfs_encode_fh(struct dentry *de
 		 */
 		parent = p->d_inode;
 	}
-	if (nop->encode_fh)
+	if (nop && nop->encode_fh)
 		error = nop->encode_fh(inode, fid->raw, max_len, parent);
 	else
 		error = export_encode_fh(inode, fid, max_len, parent);

