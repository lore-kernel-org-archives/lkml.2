Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0GLUut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:49 -0400
Received: from mail.perches.com ([173.55.12.10]:1745 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab0GLUuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:44 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Hunold <michael@mihu.de>, Andy Walls <awalls@md.metrocast.net>,
        Laurent Pinchart <laurent.pinchart@skynet.be>,
        linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
Subject: [PATCH 11/36] drivers/media: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:03 -0700
Message-Id: <f607dad266e3d5c1b01aeb8420e09525f70cc1c0.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/IR/imon.c                    |    6 +++---
 drivers/media/common/saa7146_vbi.c         |    4 ++--
 drivers/media/common/saa7146_video.c       |    4 ++--
 drivers/media/dvb/bt8xx/dst_ca.c           |    2 +-
 drivers/media/video/cx18/cx18-ioctl.c      |    2 +-
 drivers/media/video/cx88/cx88-alsa.c       |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c    |    4 ++--
 drivers/media/video/mem2mem_testdev.c      |    4 ++--
 drivers/media/video/saa7134/saa7134-alsa.c |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c         |    8 ++++----
 10 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 0195dd5..65c125e 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -407,7 +407,7 @@ static int display_close(struct inode *inode, struct file *file)
 	struct imon_context *ictx = NULL;
 	int retval = 0;
 
-	ictx = (struct imon_context *)file->private_data;
+	ictx = file->private_data;
 
 	if (!ictx) {
 		err("%s: no context for device", __func__);
@@ -812,7 +812,7 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 	const unsigned char vfd_packet6[] = {
 		0x01, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF };
 
-	ictx = (struct imon_context *)file->private_data;
+	ictx = file->private_data;
 	if (!ictx) {
 		err("%s: no context for device", __func__);
 		return -ENODEV;
@@ -896,7 +896,7 @@ static ssize_t lcd_write(struct file *file, const char *buf,
 	int retval = 0;
 	struct imon_context *ictx;
 
-	ictx = (struct imon_context *)file->private_data;
+	ictx = file->private_data;
 	if (!ictx) {
 		err("%s: no context for device", __func__);
 		return -ENODEV;
diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146_vbi.c
index 74e2b56..8224c30 100644
--- a/drivers/media/common/saa7146_vbi.c
+++ b/drivers/media/common/saa7146_vbi.c
@@ -375,7 +375,7 @@ static void vbi_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 
 static int vbi_open(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 
 	u32 arbtr_ctrl	= saa7146_read(dev, PCI_BT_V1);
 	int ret = 0;
@@ -437,7 +437,7 @@ static int vbi_open(struct saa7146_dev *dev, struct file *file)
 
 static void vbi_close(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_vv *vv = dev->vv_data;
 	DEB_VBI(("dev:%p, fh:%p\n",dev,fh));
 
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index b8b2c55..a212a91 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -1370,7 +1370,7 @@ static void video_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 
 static int video_open(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_format *sfmt;
 
 	fh->video_fmt.width = 384;
@@ -1394,7 +1394,7 @@ static int video_open(struct saa7146_dev *dev, struct file *file)
 
 static void video_close(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_vv *vv = dev->vv_data;
 	struct videobuf_queue *q = &fh->video_q;
 	int err;
diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index 770243c..cf87051 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -565,7 +565,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 	int result = 0;
 
 	lock_kernel();
-	dvbdev = (struct dvb_device *)file->private_data;
+	dvbdev = file->private_data;
 	state = (struct dst_state *)dvbdev->priv;
 	p_ca_message = kmalloc(sizeof (struct ca_msg), GFP_KERNEL);
 	p_ca_slot_info = kmalloc(sizeof (struct ca_slot_info), GFP_KERNEL);
diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
index 20eaf38..d679240 100644
--- a/drivers/media/video/cx18/cx18-ioctl.c
+++ b/drivers/media/video/cx18/cx18-ioctl.c
@@ -1081,7 +1081,7 @@ long cx18_v4l2_ioctl(struct file *filp, unsigned int cmd,
 		    unsigned long arg)
 {
 	struct video_device *vfd = video_devdata(filp);
-	struct cx18_open_id *id = (struct cx18_open_id *)filp->private_data;
+	struct cx18_open_id *id = filp->private_data;
 	struct cx18 *cx = id->cx;
 	long res;
 
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 9209d5b..4f383cd 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -739,7 +739,7 @@ static int __devinit snd_cx88_create(struct snd_card *card,
 
 	pci_set_master(pci);
 
-	chip = (snd_cx88_card_t *) card->private_data;
+	chip = card->private_data;
 
 	core = cx88_core_get(pci);
 	if (NULL == core) {
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index c338f3f..4863a21 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -394,7 +394,7 @@ err:
 
 static int hdpvr_release(struct file *file)
 {
-	struct hdpvr_fh		*fh  = (struct hdpvr_fh *)file->private_data;
+	struct hdpvr_fh		*fh  = file->private_data;
 	struct hdpvr_device	*dev = fh->dev;
 
 	if (!dev)
@@ -518,7 +518,7 @@ err:
 static unsigned int hdpvr_poll(struct file *filp, poll_table *wait)
 {
 	struct hdpvr_buffer *buf = NULL;
-	struct hdpvr_fh *fh = (struct hdpvr_fh *)filp->private_data;
+	struct hdpvr_fh *fh = filp->private_data;
 	struct hdpvr_device *dev = fh->dev;
 	unsigned int mask = 0;
 
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 554eaf1..7fd54bf 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -903,14 +903,14 @@ static int m2mtest_release(struct file *file)
 static unsigned int m2mtest_poll(struct file *file,
 				 struct poll_table_struct *wait)
 {
-	struct m2mtest_ctx *ctx = (struct m2mtest_ctx *)file->private_data;
+	struct m2mtest_ctx *ctx = file->private_data;
 
 	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
 }
 
 static int m2mtest_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct m2mtest_ctx *ctx = (struct m2mtest_ctx *)file->private_data;
+	struct m2mtest_ctx *ctx = file->private_data;
 
 	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
 }
diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index 68b7e8d..10460fd 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -1080,7 +1080,7 @@ static int alsa_card_saa7134_create(struct saa7134_dev *dev, int devnum)
 	/* Card "creation" */
 
 	card->private_free = snd_saa7134_free;
-	chip = (snd_card_saa7134_t *) card->private_data;
+	chip = card->private_data;
 
 	spin_lock_init(&chip->lock);
 	spin_lock_init(&chip->mixer_lock);
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 369ce06..86db326 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -516,7 +516,7 @@ static int uvc_v4l2_open(struct file *file)
 
 static int uvc_v4l2_release(struct file *file)
 {
-	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	struct uvc_fh *handle = file->private_data;
 	struct uvc_streaming *stream = handle->stream;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_release\n");
@@ -547,7 +547,7 @@ static int uvc_v4l2_release(struct file *file)
 static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	struct uvc_fh *handle = file->private_data;
 	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_streaming *stream = handle->stream;
 	long ret = 0;
@@ -1116,7 +1116,7 @@ static const struct vm_operations_struct uvc_vm_ops = {
 
 static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	struct uvc_fh *handle = file->private_data;
 	struct uvc_streaming *stream = handle->stream;
 	struct uvc_video_queue *queue = &stream->queue;
 	struct uvc_buffer *uninitialized_var(buffer);
@@ -1171,7 +1171,7 @@ done:
 
 static unsigned int uvc_v4l2_poll(struct file *file, poll_table *wait)
 {
-	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	struct uvc_fh *handle = file->private_data;
 	struct uvc_streaming *stream = handle->stream;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_poll\n");
-- 
1.7.1.337.g6068.dirty

