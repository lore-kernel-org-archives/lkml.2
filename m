Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0EJXAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:00:13 -0400
Received: from kroah.org ([198.145.64.141]:51690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858Ab0EJW5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:49 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:37 2010
Message-Id: <20100510223537.027223166@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joel Becker <joel.becker@oracle.com>
Subject: [29/98] ocfs2_dlmfs: Fix math error when reading LVB.
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joel Becker <joel.becker@oracle.com>

commit a36d515c7a2dfacebcf41729f6812dbc424ebcf0 upstream.

When asked for a partial read of the LVB in a dlmfs file, we can
accidentally calculate a negative count.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/dlm/dlmfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -205,7 +205,7 @@ static ssize_t dlmfs_file_read(struct fi
 	if ((count + *ppos) > i_size_read(inode))
 		readlen = i_size_read(inode) - *ppos;
 	else
-		readlen = count - *ppos;
+		readlen = count;
 
 	lvb_buf = kmalloc(readlen, GFP_NOFS);
 	if (!lvb_buf)


