Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab0GLU52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:57:28 -0400
Received: from mail.perches.com ([173.55.12.10]:1727 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab0GLUui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:38 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH 08/36] drivers/ieee1394: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:00 -0700
Message-Id: <e7f254831d031e2d847f7fcf0ecdf992abfad40d.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ieee1394/dv1394.c    |    4 ++--
 drivers/ieee1394/raw1394.c   |    4 ++--
 drivers/ieee1394/video1394.c |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index f8fcbd0..c5a031b 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -172,7 +172,7 @@ static DEFINE_SPINLOCK(dv1394_cards_lock);
 
 static inline struct video_card* file_to_video_card(struct file *file)
 {
-	return (struct video_card*) file->private_data;
+	return file->private_data;
 }
 
 /*** FRAME METHODS *********************************************************/
@@ -1783,7 +1783,7 @@ static int dv1394_open(struct inode *inode, struct file *file)
 	struct video_card *video = NULL;
 
 	if (file->private_data) {
-		video = (struct video_card*) file->private_data;
+		video = file->private_data;
 
 	} else {
 		/* look up the card by ID */
diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index 2c417ae..f340142 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -440,7 +440,7 @@ static struct pending_request *next_complete_req(struct file_info *fi)
 static ssize_t raw1394_read(struct file *file, char __user * buffer,
 			    size_t count, loff_t * offset_is_ignored)
 {
-	struct file_info *fi = (struct file_info *)file->private_data;
+	struct file_info *fi = file->private_data;
 	struct pending_request *req;
 	ssize_t ret;
 
@@ -2244,7 +2244,7 @@ static int state_connected(struct file_info *fi, struct pending_request *req)
 static ssize_t raw1394_write(struct file *file, const char __user * buffer,
 			     size_t count, loff_t * offset_is_ignored)
 {
-	struct file_info *fi = (struct file_info *)file->private_data;
+	struct file_info *fi = file->private_data;
 	struct pending_request *req;
 	ssize_t retval = -EBADFD;
 
diff --git a/drivers/ieee1394/video1394.c b/drivers/ieee1394/video1394.c
index a77483b..5c74f79 100644
--- a/drivers/ieee1394/video1394.c
+++ b/drivers/ieee1394/video1394.c
@@ -720,7 +720,7 @@ static inline unsigned video1394_buffer_state(struct dma_iso_ctx *d,
 static long video1394_ioctl(struct file *file,
 			    unsigned int cmd, unsigned long arg)
 {
-	struct file_ctx *ctx = (struct file_ctx *)file->private_data;
+	struct file_ctx *ctx = file->private_data;
 	struct ti_ohci *ohci = ctx->ohci;
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
@@ -1172,7 +1172,7 @@ static long video1394_ioctl(struct file *file,
 
 static int video1394_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct file_ctx *ctx = (struct file_ctx *)file->private_data;
+	struct file_ctx *ctx = file->private_data;
 
 	if (ctx->current_ctx == NULL) {
 		PRINT(KERN_ERR, ctx->ohci->host->id,
@@ -1239,7 +1239,7 @@ static int video1394_open(struct inode *inode, struct file *file)
 
 static int video1394_release(struct inode *inode, struct file *file)
 {
-	struct file_ctx *ctx = (struct file_ctx *)file->private_data;
+	struct file_ctx *ctx = file->private_data;
 	struct ti_ohci *ohci = ctx->ohci;
 	struct list_head *lh, *next;
 	u64 mask;
-- 
1.7.1.337.g6068.dirty

