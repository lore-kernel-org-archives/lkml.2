Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935669Ab0HFT1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:27:52 -0400
Received: from kroah.org ([198.145.64.141]:43465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab0HFT1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:27:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:14 2010
Message-Id: <20100806192114.704244045@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:19:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [03/36] NFS: Fix a typo in include/linux/nfs_fs.h
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 77a63f3d1e0a3e7ede8d10f569e8481b13ff47c5 upstream.

nfs_commit_inode() needs to be defined irrespectively of whether or not
we are supporting NFSv3 and NFSv4.

Allow the compiler to optimise away code in the NFSv2-only case by
converting it into an inlined stub function.

Reported-and-tested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c         |    5 -----
 include/linux/nfs_fs.h |    6 ++++++
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1443,11 +1443,6 @@ out_mark_dirty:
 	return ret;
 }
 #else
-int nfs_commit_inode(struct inode *inode, int how)
-{
-	return 0;
-}
-
 static int nfs_commit_unstable_pages(struct inode *inode, struct writeback_control *wbc)
 {
 	return 0;
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -482,6 +482,12 @@ extern int nfs_wb_page_cancel(struct ino
 extern int  nfs_commit_inode(struct inode *, int);
 extern struct nfs_write_data *nfs_commitdata_alloc(void);
 extern void nfs_commit_free(struct nfs_write_data *wdata);
+#else
+static inline int
+nfs_commit_inode(struct inode *inode, int how)
+{
+	return 0;
+}
 #endif
 
 static inline int


