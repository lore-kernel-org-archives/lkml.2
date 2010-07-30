Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280Ab0G3S5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:57:32 -0400
Received: from kroah.org ([198.145.64.141]:51862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594Ab0G3RTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:21 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:08 2010
Message-Id: <20100730171508.488657533@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [098/165] ext4: explicitly remove inode from orphan list after failed direct io
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit da1dafca84413145f5ac59998b4cdd06fb89f721 upstream (as of v2.6.33-git11)

Otherwise non-empty orphan list will be triggered on umount.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3480,6 +3480,9 @@ retry:
 			 * but cannot extend i_size. Bail out and pretend
 			 * the write failed... */
 			ret = PTR_ERR(handle);
+			if (inode->i_nlink)
+				ext4_orphan_del(NULL, inode);
+
 			goto out;
 		}
 		if (inode->i_nlink)


