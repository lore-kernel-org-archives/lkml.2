Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0GLUuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:54 -0400
Received: from mail.perches.com ([173.55.12.10]:1760 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab0GLUut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:49 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 15/36] drivers/s390: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:07 -0700
Message-Id: <4450e89c24fcd49ba08ea585ab1d145f8ebf1f06.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/block/dasd_eer.c  |    6 +++---
 drivers/s390/char/tape_block.c |    4 ++--
 drivers/s390/char/tape_char.c  |    8 ++++----
 drivers/s390/char/vmcp.c       |    6 +++---
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index dd88803..75688af 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -572,7 +572,7 @@ static int dasd_eer_close(struct inode *inp, struct file *filp)
 	struct eerbuffer *eerb;
 	unsigned long flags;
 
-	eerb = (struct eerbuffer *) filp->private_data;
+	eerb = filp->private_data;
 	spin_lock_irqsave(&bufferlock, flags);
 	list_del(&eerb->list);
 	spin_unlock_irqrestore(&bufferlock, flags);
@@ -591,7 +591,7 @@ static ssize_t dasd_eer_read(struct file *filp, char __user *buf,
         unsigned long flags;
 	struct eerbuffer *eerb;
 
-	eerb = (struct eerbuffer *) filp->private_data;
+	eerb = filp->private_data;
 	if (mutex_lock_interruptible(&readbuffer_mutex))
 		return -ERESTARTSYS;
 
@@ -653,7 +653,7 @@ static unsigned int dasd_eer_poll(struct file *filp, poll_table *ptable)
 	unsigned long flags;
 	struct eerbuffer *eerb;
 
-	eerb = (struct eerbuffer *) filp->private_data;
+	eerb = filp->private_data;
 	poll_wait(filp, &dasd_eer_read_wait_queue, ptable);
 	spin_lock_irqsave(&bufferlock, flags);
 	if (eerb->head != eerb->tail)
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index b7de025..d448fe5 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -296,7 +296,7 @@ tapeblock_revalidate_disk(struct gendisk *disk)
 	unsigned int		nr_of_blks;
 	int			rc;
 
-	device = (struct tape_device *) disk->private_data;
+	device = disk->private_data;
 	BUG_ON(!device);
 
 	if (!device->blk_data.medium_changed)
@@ -345,7 +345,7 @@ tapeblock_medium_changed(struct gendisk *disk)
 {
 	struct tape_device *device;
 
-	device = (struct tape_device *) disk->private_data;
+	device = disk->private_data;
 	DBF_LH(6, "tapeblock_medium_changed(%p) = %d\n",
 		device, device->blk_data.medium_changed);
 
diff --git a/drivers/s390/char/tape_char.c b/drivers/s390/char/tape_char.c
index 539045a..bd037d2 100644
--- a/drivers/s390/char/tape_char.c
+++ b/drivers/s390/char/tape_char.c
@@ -134,7 +134,7 @@ tapechar_read(struct file *filp, char __user *data, size_t count, loff_t *ppos)
 	int rc;
 
 	DBF_EVENT(6, "TCHAR:read\n");
-	device = (struct tape_device *) filp->private_data;
+	device = filp->private_data;
 
 	/*
 	 * If the tape isn't terminated yet, do it now. And since we then
@@ -199,7 +199,7 @@ tapechar_write(struct file *filp, const char __user *data, size_t count, loff_t
 	int i, rc;
 
 	DBF_EVENT(6, "TCHAR:write\n");
-	device = (struct tape_device *) filp->private_data;
+	device = filp->private_data;
 	/* Find out block size and number of blocks */
 	if (device->char_data.block_size != 0) {
 		if (count < device->char_data.block_size) {
@@ -317,7 +317,7 @@ tapechar_release(struct inode *inode, struct file *filp)
 	struct tape_device *device;
 
 	DBF_EVENT(6, "TCHAR:release: %x\n", iminor(inode));
-	device = (struct tape_device *) filp->private_data;
+	device = filp->private_data;
 
 	/*
 	 * If this is the rewinding tape minor then rewind. In that case we
@@ -454,7 +454,7 @@ tapechar_ioctl(struct file *filp, unsigned int no, unsigned long data)
 
 	DBF_EVENT(6, "TCHAR:ioct\n");
 
-	device = (struct tape_device *) filp->private_data;
+	device = filp->private_data;
 	mutex_lock(&device->mutex);
 	rc = __tapechar_ioctl(device, no, data);
 	mutex_unlock(&device->mutex);
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 04e532e..19a14d9 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -47,7 +47,7 @@ static int vmcp_release(struct inode *inode, struct file *file)
 {
 	struct vmcp_session *session;
 
-	session = (struct vmcp_session *)file->private_data;
+	session = file->private_data;
 	file->private_data = NULL;
 	free_pages((unsigned long)session->response, get_order(session->bufsize));
 	kfree(session);
@@ -94,7 +94,7 @@ vmcp_write(struct file *file, const char __user *buff, size_t count,
 		return -EFAULT;
 	}
 	cmd[count] = '\0';
-	session = (struct vmcp_session *)file->private_data;
+	session = file->private_data;
 	if (mutex_lock_interruptible(&session->mutex)) {
 		kfree(cmd);
 		return -ERESTARTSYS;
@@ -136,7 +136,7 @@ static long vmcp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int __user *argp;
 	int temp;
 
-	session = (struct vmcp_session *)file->private_data;
+	session = file->private_data;
 	if (is_compat_task())
 		argp = compat_ptr(arg);
 	else
-- 
1.7.1.337.g6068.dirty

