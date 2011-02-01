Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1BALXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:23:07 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:65394
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752813Ab1BALXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:23:05 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: mchehab@redhat.com, d.belimov@gmail.com, stefan.ringel@arcor.de,
        michel.ludwig@gmail.com, khali@linux-fr.org,
        tvh@informatik.uni-kiel.de, c.pascoe@itee.uq.edu.au,
        ruslan@rpisarev.org.ua, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: tm6000: fixed some coding style issues
Date: Tue,  1 Feb 2011 12:22:21 +0100
Message-Id: <1296559341-24438-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4
X-Null-Tag: f5b6b635eb971478661e72515b059f51
X-Authenticated-Sender: user tvh from 86.103.159.189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all of the following coding style issues:

ERROR: return is not a function, parentheses are not required
WARNING: __func__ should be used instead of gcc specific __FUNCTION__
ERROR: trailing whitespace
ERROR: spaces required around that '=' (ctx:VxV)
WARNING: please, no space before tabs
WARNING: please, no spaces at the start of a line
ERROR: space required after that ',' (ctx:VxV)
WARNING: space prohibited between function name and open parenthesis '('
ERROR: spaces required around that '<' (ctx:VxV)
ERROR: spaces required around that '==' (ctx:VxV)

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/tm6000/tm6000-alsa.c     |    6 +++---
 drivers/staging/tm6000/tm6000-core.c     |    4 ++--
 drivers/staging/tm6000/tm6000-dvb.c      |   10 +++++-----
 drivers/staging/tm6000/tm6000-i2c.c      |    2 +-
 drivers/staging/tm6000/tm6000-regs.h     |    2 +-
 drivers/staging/tm6000/tm6000-usb-isoc.h |    2 +-
 drivers/staging/tm6000/tm6000-video.c    |   28 ++++++++++++++--------------
 drivers/staging/tm6000/tm6000.h          |    4 ++--
 8 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 184cc50..9bc1b95 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -263,7 +263,7 @@ static int tm6000_fillbuf(struct tm6000_core *core, char *buf, int size)
 			length * stride);
 
 #ifndef NO_PCM_LOCK
-       snd_pcm_stream_lock(substream);
+	snd_pcm_stream_lock(substream);
 #endif
 
 	chip->buf_pos += length;
@@ -277,7 +277,7 @@ static int tm6000_fillbuf(struct tm6000_core *core, char *buf, int size)
 	}
 
 #ifndef NO_PCM_LOCK
-       snd_pcm_stream_unlock(substream);
+	snd_pcm_stream_unlock(substream);
 #endif
 
 	if (period_elapsed)
@@ -469,7 +469,7 @@ int tm6000_audio_init(struct tm6000_core *dev)
 	if (rc < 0)
 		goto error_chip;
 
-	dprintk(1,"Registered audio driver for %s\n", card->longname);
+	dprintk(1, "Registered audio driver for %s\n", card->longname);
 
 	return 0;
 
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 96aed4a..5cbc956 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -77,7 +77,7 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 			if (req_type &  USB_DIR_IN)
 				printk("<<< (len=%d)\n", len);
 
-			printk("%s: Error #%d\n", __FUNCTION__, ret);
+			printk("%s: Error #%d\n", __func, ret);
 		} else if (req_type &  USB_DIR_IN) {
 			printk("<<< ");
 			for (i = 0; i < len; i++)
@@ -299,7 +299,7 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 	 * FIXME: This is a hack! xc3028 "sleeps" when no channel is detected
 	 * for more than a few seconds. Not sure why, as this behavior does
 	 * not happen on other devices with xc3028. So, I suspect that it
-	 * is yet another bug at tm6000. After start sleeping, decoding 
+	 * is yet another bug at tm6000. After start sleeping, decoding
 	 * doesn't start automatically. Instead, it requires some
 	 * I2C commands to wake it up. As we want to have image at the
 	 * beginning, we needed to add this hack. The better would be to
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index ff04c89..feb53aa 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -98,7 +98,7 @@ static void tm6000_urb_received(struct urb *urb)
 	if (dev->dvb->streams > 0) {
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
 		if (ret < 0) {
-			printk(KERN_ERR "tm6000:  error %s\n", __FUNCTION__);
+			printk(KERN_ERR "tm6000:  error %s\n", __func);
 			kfree(urb->transfer_buffer);
 			usb_free_urb(urb);
 		}
@@ -111,7 +111,7 @@ int tm6000_start_stream(struct tm6000_core *dev)
 	unsigned int pipe, size;
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	printk(KERN_INFO "tm6000: got start stream request %s\n", __FUNCTION__);
+	printk(KERN_INFO "tm6000: got start stream request %s\n", __func);
 
 	if (dev->mode != TM6000_MODE_DIGITAL) {
 		tm6000_init_digital_mode(dev);
@@ -145,7 +145,7 @@ int tm6000_start_stream(struct tm6000_core *dev)
 	ret = usb_clear_halt(dev->udev, pipe);
 	if (ret < 0) {
 		printk(KERN_ERR "tm6000: error %i in %s during pipe reset\n",
-							ret, __FUNCTION__);
+							ret, __func);
 		return ret;
 	} else
 		printk(KERN_ERR "tm6000: pipe resetted\n");
@@ -185,7 +185,7 @@ int tm6000_start_feed(struct dvb_demux_feed *feed)
 	struct dvb_demux *demux = feed->demux;
 	struct tm6000_core *dev = demux->priv;
 	struct tm6000_dvb *dvb = dev->dvb;
-	printk(KERN_INFO "tm6000: got start feed request %s\n", __FUNCTION__);
+	printk(KERN_INFO "tm6000: got start feed request %s\n", __func);
 
 	mutex_lock(&dvb->mutex);
 	if (dvb->streams == 0) {
@@ -205,7 +205,7 @@ int tm6000_stop_feed(struct dvb_demux_feed *feed)
 	struct tm6000_core *dev = demux->priv;
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	printk(KERN_INFO "tm6000: got stop feed request %s\n", __FUNCTION__);
+	printk(KERN_INFO "tm6000: got stop feed request %s\n", __func);
 
 	mutex_lock(&dvb->mutex);
 
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 18de474..c7b5834 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -40,7 +40,7 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 
 #define i2c_dprintk(lvl, fmt, args...) if (i2c_debug >= lvl) do { \
 			printk(KERN_DEBUG "%s at %s: " fmt, \
-			dev->name, __FUNCTION__ , ##args); } while (0)
+			dev->name, __func , ##args); } while (0)
 
 static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
 				__u8 reg, char *buf, int len)
diff --git a/drivers/staging/tm6000/tm6000-regs.h b/drivers/staging/tm6000/tm6000-regs.h
index 1f0ced8..b4349b5 100644
--- a/drivers/staging/tm6000/tm6000-regs.h
+++ b/drivers/staging/tm6000/tm6000-regs.h
@@ -90,7 +90,7 @@
  */
 
 enum {
-	TM6000_URB_MSG_VIDEO=1,
+	TM6000_URB_MSG_VIDEO = 1,
 	TM6000_URB_MSG_AUDIO,
 	TM6000_URB_MSG_VBI,
 	TM6000_URB_MSG_PTS,
diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
index a9e61d9..3b2ffb6 100644
--- a/drivers/staging/tm6000/tm6000-usb-isoc.h
+++ b/drivers/staging/tm6000/tm6000-usb-isoc.h
@@ -46,5 +46,5 @@ struct usb_isoc_ctl {
 	int				tmp_buf_len;
 
 		/* Stores already requested buffers */
-	struct tm6000_buffer    	*buf;
+	struct tm6000_buffer	*buf;
 };
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 8fe017c..6b17099 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1003,12 +1003,12 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 
 	if (!res_get(dev, fh, false))
 		return -EBUSY;
-	return (videobuf_streamon(&fh->vb_vidq));
+	return videobuf_streamon(&fh->vb_vidq);
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh *fh = priv;
 	struct tm6000_core *dev    = fh->dev;
 
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -1017,15 +1017,15 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 		return -EINVAL;
 
 	videobuf_streamoff(&fh->vb_vidq);
-	res_free(dev,fh);
+	res_free(dev, fh);
 
 	return (0);
 }
 
-static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
-	int rc=0;
-	struct tm6000_fh   *fh=priv;
+	int rc = 0;
+	struct tm6000_fh   *fh = priv;
 	struct tm6000_core *dev = fh->dev;
 
 	dev->norm = *norm;
@@ -1034,7 +1034,7 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	fh->width  = dev->width;
 	fh->height = dev->height;
 
-	if (rc<0)
+	if (rc < 0)
 		return rc;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
@@ -1290,18 +1290,18 @@ static int tm6000_open(struct file *file)
 
 	fh->fmt      = format_by_fourcc(dev->fourcc);
 
-	tm6000_get_std_res (dev);
+	tm6000_get_std_res(dev);
 
 	fh->width    = dev->width;
 	fh->height   = dev->height;
 
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: fh=0x%08lx, dev=0x%08lx, "
 						"dev->vidq=0x%08lx\n",
-		(unsigned long)fh,(unsigned long)dev,(unsigned long)&dev->vidq);
+		(unsigned long)fh, (unsigned long)dev, (unsigned long)&dev->vidq);
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"queued=%d\n",list_empty(&dev->vidq.queued));
+				"queued=%d\n", list_empty(&dev->vidq.queued));
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"active=%d\n",list_empty(&dev->vidq.active));
+				"active=%d\n", list_empty(&dev->vidq.active));
 
 	/* initialize hardware on analog mode */
 	rc = tm6000_init_analog_mode(dev);
@@ -1330,7 +1330,7 @@ tm6000_read(struct file *file, char __user *data, size_t count, loff_t *pos)
 {
 	struct tm6000_fh        *fh = file->private_data;
 
-	if (fh->type==V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		if (!res_get(fh->dev, fh, true))
 			return -EBUSY;
 
@@ -1356,7 +1356,7 @@ tm6000_poll(struct file *file, struct poll_table_struct *wait)
 		/* streaming capture */
 		if (list_empty(&fh->vb_vidq.stream))
 			return POLLERR;
-		buf = list_entry(fh->vb_vidq.stream.next,struct tm6000_buffer,vb.stream);
+		buf = list_entry(fh->vb_vidq.stream.next, struct tm6000_buffer, vb.stream);
 	} else {
 		/* read() capture */
 		return videobuf_poll_stream(file, &fh->vb_vidq,
@@ -1456,7 +1456,7 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	struct video_device *vfd;
 
 	vfd = video_device_alloc();
-	if(!vfd) {
+	if (!vfd) {
 		return -ENOMEM;
 	}
 	dev->vfd = vfd;
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index bf11eee..bf01130 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -343,7 +343,7 @@ extern int tm6000_debug;
 #define dprintk(dev, level, fmt, arg...) do {\
 	if (tm6000_debug & level) \
 		printk(KERN_INFO "(%lu) %s %s :"fmt, jiffies, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func , ##arg); } while (0)
 
 #define V4L2_DEBUG_REG		0x0004
 #define V4L2_DEBUG_I2C		0x0008
@@ -354,4 +354,4 @@ extern int tm6000_debug;
 
 #define tm6000_err(fmt, arg...) do {\
 	printk(KERN_ERR "tm6000 %s :"fmt, \
-		__FUNCTION__ , ##arg); } while (0)
+		__func , ##arg); } while (0)
-- 
1.7.4

