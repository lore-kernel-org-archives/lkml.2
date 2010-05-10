Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0EJW7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:59:52 -0400
Received: from kroah.org ([198.145.64.141]:51661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749Ab0EJW5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:46 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:36 2010
Message-Id: <20100510223536.761858914@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tao Ma <tao.ma@oracle.com>, Joel Becker <joel.becker@oracle.com>
Subject: [26/98] ocfs2: Update VFS inodes id info after reflink.
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tao Ma <tao.ma@oracle.com>

commit c21a534e2f24968cf74976a4e721ac194db30ded upstream.

In reflink we update the id info on the disk but forgot to update
the corresponding information in the VFS inode.  Update them
accordingly when we want to preserve the attributes.

Reported-by: Jeff Liu <jeff.liu@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/refcounttree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3995,6 +3995,9 @@ static int ocfs2_complete_reflink(struct
 	di->i_attr = s_di->i_attr;
 
 	if (preserve) {
+		t_inode->i_uid = s_inode->i_uid;
+		t_inode->i_gid = s_inode->i_gid;
+		t_inode->i_mode = s_inode->i_mode;
 		di->i_uid = s_di->i_uid;
 		di->i_gid = s_di->i_gid;
 		di->i_mode = s_di->i_mode;


