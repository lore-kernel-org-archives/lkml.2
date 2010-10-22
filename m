Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0JVFSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:18:01 -0400
Received: from mail.perches.com ([173.55.12.10]:3478 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab0JVFR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:17:28 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>,
        osd-dev@open-osd.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] fs/exofs: typo fix of faild to failed
Date: Thu, 21 Oct 2010 22:17:17 -0700
Message-Id: <517d9c755442feaa09d82fe484e94bc39f755507.1287724261.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1287724261.git.joe@perches.com>
References: <cover.1287724261.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/exofs/dir.c   |    4 ++--
 fs/exofs/inode.c |   14 +++++++-------
 fs/exofs/ios.c   |   10 +++++-----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
index d91e9d8..dcc941d 100644
--- a/fs/exofs/dir.c
+++ b/fs/exofs/dir.c
@@ -420,7 +420,7 @@ int exofs_set_link(struct inode *dir, struct exofs_dir_entry *de,
 	err = exofs_write_begin(NULL, page->mapping, pos, len,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
-		EXOFS_ERR("exofs_set_link: exofs_write_begin FAILD => %d\n",
+		EXOFS_ERR("exofs_set_link: exofs_write_begin FAILED => %d\n",
 			  err);
 
 	de->inode_no = cpu_to_le64(inode->i_ino);
@@ -556,7 +556,7 @@ int exofs_delete_entry(struct exofs_dir_entry *dir, struct page *page)
 	err = exofs_write_begin(NULL, page->mapping, pos, to - from, 0,
 							&page, NULL);
 	if (err)
-		EXOFS_ERR("exofs_delete_entry: exofs_write_begin FAILD => %d\n",
+		EXOFS_ERR("exofs_delete_entry: exofs_write_begin FAILED => %d\n",
 			  err);
 	if (pde)
 		pde->rec_len = cpu_to_le16(to - from);
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 3eadd97..4460275 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -511,7 +511,7 @@ static int write_exec(struct page_collect *pcol)
 
 	pcol_copy = kmalloc(sizeof(*pcol_copy), GFP_KERNEL);
 	if (!pcol_copy) {
-		EXOFS_ERR("write_exec: Faild to kmalloc(pcol)\n");
+		EXOFS_ERR("write_exec: Failed to kmalloc(pcol)\n");
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -527,7 +527,7 @@ static int write_exec(struct page_collect *pcol)
 
 	ret = exofs_oi_write(oi, ios);
 	if (unlikely(ret)) {
-		EXOFS_ERR("write_exec: exofs_oi_write() Faild\n");
+		EXOFS_ERR("write_exec: exofs_oi_write() Failed\n");
 		goto err;
 	}
 
@@ -628,7 +628,7 @@ try_again:
 		/* split the request, next loop will start again */
 		ret = write_exec(pcol);
 		if (unlikely(ret)) {
-			EXOFS_DBGMSG("write_exec faild => %d", ret);
+			EXOFS_DBGMSG("write_exec failed => %d", ret);
 			goto fail;
 		}
 
@@ -719,7 +719,7 @@ int exofs_write_begin(struct file *file, struct address_space *mapping,
 		ret = simple_write_begin(file, mapping, pos, len, flags, pagep,
 					 fsdata);
 		if (ret) {
-			EXOFS_DBGMSG("simple_write_begin faild\n");
+			EXOFS_DBGMSG("simple_write_begin failed\n");
 			goto out;
 		}
 
@@ -732,7 +732,7 @@ int exofs_write_begin(struct file *file, struct address_space *mapping,
 		if (ret) {
 			/*SetPageError was done by _readpage. Is it ok?*/
 			unlock_page(page);
-			EXOFS_DBGMSG("__readpage_filler faild\n");
+			EXOFS_DBGMSG("__readpage_filler failed\n");
 		}
 	}
 out:
@@ -1095,7 +1095,7 @@ static void create_done(struct exofs_io_state *ios, void *p)
 	atomic_dec(&sbi->s_curr_pending);
 
 	if (unlikely(ret)) {
-		EXOFS_ERR("object=0x%llx creation faild in pid=0x%llx",
+		EXOFS_ERR("object=0x%llx creation failed in pid=0x%llx",
 			  _LLU(exofs_oi_objno(oi)), _LLU(sbi->layout.s_pid));
 		/*TODO: When FS is corrupted creation can fail, object already
 		 * exist. Get rid of this asynchronous creation, if exist
@@ -1215,7 +1215,7 @@ static int exofs_update_inode(struct inode *inode, int do_sync)
 
 	args = kzalloc(sizeof(*args), GFP_KERNEL);
 	if (!args) {
-		EXOFS_DBGMSG("Faild kzalloc of args\n");
+		EXOFS_DBGMSG("Failed kzalloc of args\n");
 		return -ENOMEM;
 	}
 
diff --git a/fs/exofs/ios.c b/fs/exofs/ios.c
index 6550bf7..f74a2ec 100644
--- a/fs/exofs/ios.c
+++ b/fs/exofs/ios.c
@@ -55,7 +55,7 @@ int exofs_read_kern(struct osd_dev *od, u8 *cred, struct osd_obj_id *obj,
 
 	ret = osd_finalize_request(or, 0, cred, NULL);
 	if (unlikely(ret)) {
-		EXOFS_DBGMSG("Faild to osd_finalize_request() => %d\n", ret);
+		EXOFS_DBGMSG("Failed to osd_finalize_request() => %d\n", ret);
 		goto out;
 	}
 
@@ -79,7 +79,7 @@ int exofs_get_io_state(struct exofs_layout *layout,
 	 */
 	ios = kzalloc(exofs_io_state_size(layout->s_numdevs), GFP_KERNEL);
 	if (unlikely(!ios)) {
-		EXOFS_DBGMSG("Faild kzalloc bytes=%d\n",
+		EXOFS_DBGMSG("Failed kzalloc bytes=%d\n",
 			     exofs_io_state_size(layout->s_numdevs));
 		*pios = NULL;
 		return -ENOMEM;
@@ -172,7 +172,7 @@ static int exofs_io_execute(struct exofs_io_state *ios)
 
 		ret = osd_finalize_request(or, 0, ios->cred, NULL);
 		if (unlikely(ret)) {
-			EXOFS_DBGMSG("Faild to osd_finalize_request() => %d\n",
+			EXOFS_DBGMSG("Failed to osd_finalize_request() => %d\n",
 				     ret);
 			return ret;
 		}
@@ -361,7 +361,7 @@ static int _add_stripe_unit(struct exofs_io_state *ios,  unsigned *cur_pg,
 
 		per_dev->bio = bio_kmalloc(GFP_KERNEL, bio_size);
 		if (unlikely(!per_dev->bio)) {
-			EXOFS_DBGMSG("Faild to allocate BIO size=%u\n",
+			EXOFS_DBGMSG("Failed to allocate BIO size=%u\n",
 				     bio_size);
 			return -ENOMEM;
 		}
@@ -564,7 +564,7 @@ static int _sbi_write_mirror(struct exofs_io_state *ios, int cur_comp)
 						  master_dev->bio->bi_max_vecs);
 				if (unlikely(!bio)) {
 					EXOFS_DBGMSG(
-					      "Faild to allocate BIO size=%u\n",
+					      "Failed to allocate BIO size=%u\n",
 					      master_dev->bio->bi_max_vecs);
 					ret = -ENOMEM;
 					goto out;
-- 
1.7.3.1.g432b3.dirty

