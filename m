Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161256Ab2KNPXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:23:42 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:35444 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161058Ab2KNPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:22:49 -0500
Message-Id: <20121114152239.758426995@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Nov 2012 19:19:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 5/7] fs, exportfs: Escape nil dereference if no s_export_op present
References: <20121114151937.344922058@openvz.org>
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
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
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

