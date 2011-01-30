Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1A3SjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 13:39:22 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:53230
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752683Ab1A3SjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 13:39:21 -0500
X-Greylist: delayed 880 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Jan 2011 13:39:20 EST
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: mchehab@redhat.com, hverkuil@xs4all.nl, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: [PATCH] Staging: usbvideo: usbvideo: fixed some coding style issues
Date: Sun, 30 Jan 2011 19:24:03 +0100
Message-Id: <1296411843-918-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.3.5
X-Null-Tag: 08f45922091c05d86eeafe1fe89d5ba3
X-Authenticated-Sender: user tvh from 86.103.153.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed coding style issues.

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/usbvideo/usbvideo.c |  170 +++++++++++++++++------------------
 1 files changed, 81 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/usbvideo/usbvideo.c b/drivers/staging/usbvideo/usbvideo.c
index f1fcf97..cd4c73a 100644
--- a/drivers/staging/usbvideo/usbvideo.c
+++ b/drivers/staging/usbvideo/usbvideo.c
@@ -24,7 +24,7 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include "usbvideo.h"
 
@@ -112,9 +112,9 @@ static void RingQueue_Allocate(struct RingQueue *rq, int rqLen)
 	assert(rq != NULL);
 	assert(rqLen > 0);
 
-	while(rqLen >> i)
+	while (rqLen >> i)
 		i++;
-	if(rqLen != 1 << (i-1))
+	if (rqLen != 1 << (i-1))
 		rqLen = 1 << i;
 
 	rq->length = rqLen;
@@ -148,15 +148,15 @@ int RingQueue_Dequeue(struct RingQueue *rq, unsigned char *dst, int len)
 	assert(dst != NULL);
 
 	rql = RingQueue_GetLength(rq);
-	if(!rql)
+	if (!rql)
 		return 0;
 
 	/* Clip requested length to available data */
-	if(len > rql)
+	if (len > rql)
 		len = rql;
 
 	toread = len;
-	if(rq->ri > rq->wi) {
+	if (rq->ri > rq->wi) {
 		/* Read data from tail */
 		int read = (toread < (rq->length - rq->ri)) ? toread : rq->length - rq->ri;
 		memcpy(dst, rq->queue + rq->ri, read);
@@ -164,7 +164,7 @@ int RingQueue_Dequeue(struct RingQueue *rq, unsigned char *dst, int len)
 		dst += read;
 		rq->ri = (rq->ri + read) & (rq->length-1);
 	}
-	if(toread) {
+	if (toread) {
 		/* Read data from head */
 		memcpy(dst, rq->queue + rq->ri, toread);
 		rq->ri = (rq->ri + toread) & (rq->length-1);
@@ -292,12 +292,11 @@ static void usbvideo_OverlayChar(struct uvd *uvd, struct usbvideo_frame *frame,
 		return;
 	digit = digits[value];
 
-	for (iy=0; iy < 5; iy++) {
-		for (ix=0; ix < 3; ix++) {
+	for (iy = 0; iy < 5; iy++) {
+		for (ix = 0; ix < 3; ix++) {
 			if (digit & 0x8000) {
-				if (uvd->paletteBits & (1L << VIDEO_PALETTE_RGB24)) {
+				if (uvd->paletteBits & (1L << VIDEO_PALETTE_RGB24))
 /* TODO */				RGB24_PUTPIXEL(frame, x+ix, y+iy, 0xFF, 0xFF, 0xFF);
-				}
 			}
 			digit = digit << 1;
 		}
@@ -332,7 +331,7 @@ static void usbvideo_OverlayStats(struct uvd *uvd, struct usbvideo_frame *frame)
 {
 	const int y_diff = 8;
 	char tmp[16];
-	int x = 10, y=10;
+	int x = 10, y = 10;
 	long i, j, barLength;
 	const int qi_x1 = 60, qi_y1 = 10;
 	const int qi_x2 = VIDEOSIZE_X(frame->request) - 10, qi_h = 10;
@@ -375,8 +374,8 @@ static void usbvideo_OverlayStats(struct uvd *uvd, struct usbvideo_frame *frame)
 		m_lo = (u_lo > 0) ? (qi_x1 + ((barLength * u_lo) / uvd->dp.length)) : -1;
 		m_hi = qi_x1 + ((barLength * u_hi) / uvd->dp.length);
 
-		for (j=qi_y1; j < (qi_y1 + qi_h); j++) {
-			for (i=qi_x1; i < qi_x2; i++) {
+		for (j = qi_y1; j < (qi_y1 + qi_h); j++) {
+			for (i = qi_x1; i < qi_x2; i++) {
 				/* Draw border lines */
 				if ((j == qi_y1) || (j == (qi_y1 + qi_h - 1)) ||
 				    (i == qi_x1) || (i == (qi_x2 - 1))) {
@@ -384,11 +383,11 @@ static void usbvideo_OverlayStats(struct uvd *uvd, struct usbvideo_frame *frame)
 					continue;
 				}
 				/* For all other points the Y coordinate does not matter */
-				if ((i >= m_ri) && (i <= (m_ri + 3))) {
+				if ((i >= m_ri) && (i <= (m_ri + 3)))
 					RGB24_PUTPIXEL(frame, i, j, 0x00, 0xFF, 0x00);
-				} else if ((i >= m_wi) && (i <= (m_wi + 3))) {
+				else if ((i >= m_wi) && (i <= (m_wi + 3)))
 					RGB24_PUTPIXEL(frame, i, j, 0xFF, 0x00, 0x00);
-				} else if ((i < m_lo) || ((i > m_ri) && (i < m_hi)))
+				else if ((i < m_lo) || ((i > m_ri) && (i < m_hi)))
 					RGB24_PUTPIXEL(frame, i, j, 0x00, 0x00, 0xFF);
 			}
 		}
@@ -551,8 +550,8 @@ void usbvideo_TestPattern(struct uvd *uvd, int fullframe, int pmode)
 		int i;
 		unsigned char *f = frame->data +
 			(VIDEOSIZE_X(frame->request) * V4L_BYTES_PER_PIXEL * frame->curline);
-		for (i=0; i < VIDEOSIZE_X(frame->request); i++) {
-			unsigned char cb=0x80;
+		for (i = 0; i < VIDEOSIZE_X(frame->request); i++) {
+			unsigned char cb = 0x80;
 			unsigned char cg = 0;
 			unsigned char cr = 0;
 
@@ -605,10 +604,10 @@ void usbvideo_HexDump(const unsigned char *data, int len)
 	char tmp[128]; /* 32*3 + 5 */
 	int i, k;
 
-	for (i=k=0; len > 0; i++, len--) {
+	for (i = k = 0; len > 0; i++, len--) {
 		if (i > 0 && ((i % bytes_per_line) == 0)) {
 			printk("%s\n", tmp);
-			k=0;
+			k = 0;
 		}
 		if ((i % bytes_per_line) == 0)
 			k += sprintf(&tmp[k], "%04x: ", i);
@@ -787,7 +786,7 @@ void usbvideo_Deregister(struct usbvideo **pCams)
 	usb_deregister(&cams->usbdrv);
 
 	dbg("%s: Deallocating cams=$%p (%d. cameras)", __func__, cams, cams->num_cameras);
-	for (i=0; i < cams->num_cameras; i++) {
+	for (i = 0; i < cams->num_cameras; i++) {
 		struct uvd *up = &cams->cam[i];
 		int warning = 0;
 
@@ -840,7 +839,7 @@ EXPORT_SYMBOL(usbvideo_Deregister);
  */
 static void usbvideo_Disconnect(struct usb_interface *intf)
 {
-	struct uvd *uvd = usb_get_intfdata (intf);
+	struct uvd *uvd = usb_get_intfdata(intf);
 	int i;
 
 	if (uvd == NULL) {
@@ -848,7 +847,7 @@ static void usbvideo_Disconnect(struct usb_interface *intf)
 		return;
 	}
 
-	usb_set_intfdata (intf, NULL);
+	usb_set_intfdata(intf, NULL);
 
 	usbvideo_ClientIncModCount(uvd);
 	if (uvd->debug > 0)
@@ -860,11 +859,11 @@ static void usbvideo_Disconnect(struct usb_interface *intf)
 	/* At this time we ask to cancel outstanding URBs */
 	GET_CALLBACK(uvd, stopDataPump)(uvd);
 
-	for (i=0; i < USBVIDEO_NUMSBUF; i++)
+	for (i = 0; i < USBVIDEO_NUMSBUF; i++)
 		usb_free_urb(uvd->sbuf[i].urb);
 
 	usb_put_dev(uvd->dev);
-	uvd->dev = NULL;    	    /* USB device is no more */
+	uvd->dev = NULL;	    /* USB device is no more */
 
 	video_unregister_device(&uvd->vdev);
 	if (uvd->debug > 0)
@@ -925,8 +924,7 @@ static int usbvideo_find_struct(struct usbvideo *cams)
 	mutex_lock(&cams->lock);
 	for (u = 0; u < cams->num_cameras; u++) {
 		struct uvd *uvd = &cams->cam[u];
-		if (!uvd->uvd_used) /* This one is free */
-		{
+		if (!uvd->uvd_used) { /* This one is free */
 			uvd->uvd_used = 1;	/* In use now */
 			mutex_init(&uvd->lock);	/* to 1 == available */
 			uvd->dev = NULL;
@@ -941,10 +939,10 @@ static int usbvideo_find_struct(struct usbvideo *cams)
 static const struct v4l2_file_operations usbvideo_fops = {
 	.owner =  THIS_MODULE,
 	.open =   usbvideo_v4l_open,
-	.release =usbvideo_v4l_close,
-	.read =   usbvideo_v4l_read,
-	.mmap =   usbvideo_v4l_mmap,
-	.ioctl =  usbvideo_v4l_ioctl,
+	.release = usbvideo_v4l_close,
+	.read =    usbvideo_v4l_read,
+	.mmap =    usbvideo_v4l_mmap,
+	.ioctl =   usbvideo_v4l_ioctl,
 };
 static const struct video_device usbvideo_template = {
 	.fops =       &usbvideo_fops,
@@ -972,7 +970,7 @@ struct uvd *usbvideo_AllocateDevice(struct usbvideo *cams)
 	usbvideo_ClientIncModCount(uvd);
 
 	mutex_lock(&uvd->lock);
-	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
+	for (i = 0; i < USBVIDEO_NUMSBUF; i++) {
 		uvd->sbuf[i].urb = usb_alloc_urb(FRAMES_PER_DESC, GFP_KERNEL);
 		if (uvd->sbuf[i].urb == NULL) {
 			err("usb_alloc_urb(%d.) failed.", FRAMES_PER_DESC);
@@ -981,7 +979,7 @@ struct uvd *usbvideo_AllocateDevice(struct usbvideo *cams)
 			goto allocate_done;
 		}
 	}
-	uvd->user=0;
+	uvd->user = 0;
 	uvd->remove_pending = 0;
 	uvd->last_error = 0;
 	RingQueue_Initialize(&uvd->dp);
@@ -1127,7 +1125,7 @@ static int usbvideo_v4l_open(struct file *file)
 		memset(&uvd->stats, 0, sizeof(uvd->stats));
 
 		/* Clean pointers so we know if we allocated something */
-		for (i=0; i < USBVIDEO_NUMSBUF; i++)
+		for (i = 0; i < USBVIDEO_NUMSBUF; i++)
 			uvd->sbuf[i].data = NULL;
 
 		/* Allocate memory for the frame buffers */
@@ -1140,7 +1138,7 @@ static int usbvideo_v4l_open(struct file *file)
 			errCode = -ENOMEM;
 		} else {
 			/* Allocate all buffers */
-			for (i=0; i < USBVIDEO_NUMFRAMES; i++) {
+			for (i = 0; i < USBVIDEO_NUMFRAMES; i++) {
 				uvd->frame[i].frameState = FrameState_Unused;
 				uvd->frame[i].data = uvd->fbuf + i*(uvd->max_frame_size);
 				/*
@@ -1150,7 +1148,7 @@ static int usbvideo_v4l_open(struct file *file)
 				uvd->frame[i].canvas = uvd->canvas;
 				uvd->frame[i].seqRead_Index = 0;
 			}
-			for (i=0; i < USBVIDEO_NUMSBUF; i++) {
+			for (i = 0; i < USBVIDEO_NUMSBUF; i++) {
 				uvd->sbuf[i].data = kmalloc(sb_size, GFP_KERNEL);
 				if (uvd->sbuf[i].data == NULL) {
 					errCode = -ENOMEM;
@@ -1165,7 +1163,7 @@ static int usbvideo_v4l_open(struct file *file)
 				uvd->fbuf = NULL;
 			}
 			RingQueue_Free(&uvd->dp);
-			for (i=0; i < USBVIDEO_NUMSBUF; i++) {
+			for (i = 0; i < USBVIDEO_NUMSBUF; i++) {
 				kfree(uvd->sbuf[i].data);
 				uvd->sbuf[i].data = NULL;
 			}
@@ -1240,7 +1238,7 @@ static int usbvideo_v4l_close(struct file *file)
 	uvd->fbuf = NULL;
 	RingQueue_Free(&uvd->dp);
 
-	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
+	for (i = 0; i < USBVIDEO_NUMSBUF; i++) {
 		kfree(uvd->sbuf[i].data);
 		uvd->sbuf[i].data = NULL;
 	}
@@ -1281,32 +1279,32 @@ static long usbvideo_v4l_do_ioctl(struct file *file, unsigned int cmd, void *arg
 		return -EIO;
 
 	switch (cmd) {
-		case VIDIOCGCAP:
+	case VIDIOCGCAP:
 		{
 			struct video_capability *b = arg;
 			*b = uvd->vcap;
 			return 0;
 		}
-		case VIDIOCGCHAN:
+	case VIDIOCGCHAN:
 		{
 			struct video_channel *v = arg;
 			*v = uvd->vchan;
 			return 0;
 		}
-		case VIDIOCSCHAN:
+	case VIDIOCSCHAN:
 		{
 			struct video_channel *v = arg;
 			if (v->channel != 0)
 				return -EINVAL;
 			return 0;
 		}
-		case VIDIOCGPICT:
+	case VIDIOCGPICT:
 		{
 			struct video_picture *pic = arg;
 			*pic = uvd->vpic;
 			return 0;
 		}
-		case VIDIOCSPICT:
+	case VIDIOCSPICT:
 		{
 			struct video_picture *pic = arg;
 			/*
@@ -1321,13 +1319,12 @@ static long usbvideo_v4l_do_ioctl(struct file *file, unsigned int cmd, void *arg
 			uvd->settingsAdjusted = 0;	/* Will force new settings */
 			return 0;
 		}
-		case VIDIOCSWIN:
+	case VIDIOCSWIN:
 		{
 			struct video_window *vw = arg;
 
-			if(VALID_CALLBACK(uvd, setVideoMode)) {
+			if (VALID_CALLBACK(uvd, setVideoMode))
 				return GET_CALLBACK(uvd, setVideoMode)(uvd, vw);
-			}
 
 			if (vw->flags)
 				return -EINVAL;
@@ -1340,7 +1337,7 @@ static long usbvideo_v4l_do_ioctl(struct file *file, unsigned int cmd, void *arg
 
 			return 0;
 		}
-		case VIDIOCGWIN:
+	case VIDIOCGWIN:
 		{
 			struct video_window *vw = arg;
 
@@ -1355,7 +1352,7 @@ static long usbvideo_v4l_do_ioctl(struct file *file, unsigned int cmd, void *arg
 				vw->flags = 10; /* FIXME: do better! */
 			return 0;
 		}
-		case VIDIOCGMBUF:
+	case VIDIOCGMBUF:
 		{
 			struct video_mbuf *vm = arg;
 			int i;
@@ -1363,12 +1360,12 @@ static long usbvideo_v4l_do_ioctl(struct file *file, unsigned int cmd, void *arg
 			memset(vm, 0, sizeof(*vm));
 			vm->size = uvd->max_frame_size * USBVIDEO_NUMFRAMES;
 			vm->frames = USBVIDEO_NUMFRAMES;
-			for(i = 0; i < USBVIDEO_NUMFRAMES; i++)
-			  vm->offsets[i] = i * uvd->max_frame_size;
+			for (i = 0; i < USBVIDEO_NUMFRAMES; i++)
+				vm->offsets[i] = i * uvd->max_frame_size;
 
 			return 0;
 		}
-		case VIDIOCMCAPTURE:
+	case VIDIOCMCAPTURE:
 		{
 			struct video_mmap *vm = arg;
 
@@ -1429,7 +1426,7 @@ static long usbvideo_v4l_do_ioctl(struct file *file, unsigned int cmd, void *arg
 
 			return usbvideo_NewFrame(uvd, vm->frame);
 		}
-		case VIDIOCSYNC:
+	case VIDIOCSYNC:
 		{
 			int *frameNum = arg;
 			int ret;
@@ -1445,9 +1442,8 @@ static long usbvideo_v4l_do_ioctl(struct file *file, unsigned int cmd, void *arg
 				ret = usbvideo_GetFrame(uvd, *frameNum);
 			else if (VALID_CALLBACK(uvd, getFrame)) {
 				ret = GET_CALLBACK(uvd, getFrame)(uvd, *frameNum);
-				if ((ret < 0) && (uvd->debug >= 1)) {
+				if ((ret < 0) && (uvd->debug >= 1))
 					err("VIDIOCSYNC: getFrame() returned %d.", ret);
-				}
 			} else {
 				err("VIDIOCSYNC: getFrame is not set");
 				ret = -EFAULT;
@@ -1462,33 +1458,33 @@ static long usbvideo_v4l_do_ioctl(struct file *file, unsigned int cmd, void *arg
 			uvd->frame[*frameNum].frameState = FrameState_Unused;
 			return ret;
 		}
-		case VIDIOCGFBUF:
+	case VIDIOCGFBUF:
 		{
 			struct video_buffer *vb = arg;
 
 			memset(vb, 0, sizeof(*vb));
 			return 0;
 		}
-		case VIDIOCKEY:
-			return 0;
+	case VIDIOCKEY:
+		return 0;
 
-		case VIDIOCCAPTURE:
-			return -EINVAL;
+	case VIDIOCCAPTURE:
+		return -EINVAL;
 
-		case VIDIOCSFBUF:
+	case VIDIOCSFBUF:
 
-		case VIDIOCGTUNER:
-		case VIDIOCSTUNER:
+	case VIDIOCGTUNER:
+	case VIDIOCSTUNER:
 
-		case VIDIOCGFREQ:
-		case VIDIOCSFREQ:
+	case VIDIOCGFREQ:
+	case VIDIOCSFREQ:
 
-		case VIDIOCGAUDIO:
-		case VIDIOCSAUDIO:
-			return -EINVAL;
+	case VIDIOCGAUDIO:
+	case VIDIOCSAUDIO:
+		return -EINVAL;
 
-		default:
-			return -ENOIOCTLCMD;
+	default:
+		return -ENOIOCTLCMD;
 	}
 	return 0;
 }
@@ -1529,7 +1525,7 @@ static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
 	mutex_lock(&uvd->lock);
 
 	/* See if a frame is completed, then use it. */
-	for(i = 0; i < USBVIDEO_NUMFRAMES; i++) {
+	for (i = 0; i < USBVIDEO_NUMFRAMES; i++) {
 		if ((uvd->frame[i].frameState == FrameState_Done) ||
 		    (uvd->frame[i].frameState == FrameState_Done_Hold) ||
 		    (uvd->frame[i].frameState == FrameState_Error)) {
@@ -1550,7 +1546,7 @@ static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
 	 * We will need to wait until it becomes cooked, of course.
 	 */
 	if (frmx == -1) {
-		for(i = 0; i < USBVIDEO_NUMFRAMES; i++) {
+		for (i = 0; i < USBVIDEO_NUMFRAMES; i++) {
 			if (uvd->frame[i].frameState == FrameState_Grabbing) {
 				frmx = i;
 				break;
@@ -1653,9 +1649,8 @@ static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
 
 		/* Mark it as available to be used again. */
 		uvd->frame[frmx].frameState = FrameState_Unused;
-		if (usbvideo_NewFrame(uvd, (frmx + 1) % USBVIDEO_NUMFRAMES)) {
+		if (usbvideo_NewFrame(uvd, (frmx + 1) % USBVIDEO_NUMFRAMES))
 			err("%s: usbvideo_NewFrame failed.", __func__);
-		}
 	}
 read_done:
 	mutex_unlock(&uvd->lock);
@@ -1744,8 +1739,8 @@ urb_done_with:
 	}
 	urb->status = 0;
 	urb->dev = uvd->dev;
-	ret = usb_submit_urb (urb, GFP_KERNEL);
-	if(ret)
+	ret = usb_submit_urb(urb, GFP_KERNEL);
+	if (ret)
 		err("usb_submit_urb error (%d)", ret);
 	return;
 }
@@ -1785,7 +1780,7 @@ static int usbvideo_StartDataPump(struct uvd *uvd)
 		err("%s: videoStart not set", __func__);
 
 	/* We double buffer the Iso lists */
-	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
+	for (i = 0; i < USBVIDEO_NUMSBUF; i++) {
 		int j, k;
 		struct urb *urb = uvd->sbuf[i].urb;
 		urb->dev = dev;
@@ -1797,14 +1792,14 @@ static int usbvideo_StartDataPump(struct uvd *uvd)
 		urb->complete = usbvideo_IsocIrq;
 		urb->number_of_packets = FRAMES_PER_DESC;
 		urb->transfer_buffer_length = uvd->iso_packet_len * FRAMES_PER_DESC;
-		for (j=k=0; j < FRAMES_PER_DESC; j++, k += uvd->iso_packet_len) {
+		for (j = k = 0; j < FRAMES_PER_DESC; j++, k += uvd->iso_packet_len) {
 			urb->iso_frame_desc[j].offset = k;
 			urb->iso_frame_desc[j].length = uvd->iso_packet_len;
 		}
 	}
 
 	/* Submit all URBs */
-	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
+	for (i = 0; i < USBVIDEO_NUMSBUF; i++) {
 		errFlag = usb_submit_urb(uvd->sbuf[i].urb, GFP_KERNEL);
 		if (errFlag)
 			err("%s: usb_submit_isoc(%d) ret %d", __func__, i, errFlag);
@@ -1839,9 +1834,8 @@ static void usbvideo_StopDataPump(struct uvd *uvd)
 		dev_info(&uvd->dev->dev, "%s($%p)\n", __func__, uvd);
 
 	/* Unschedule all of the iso td's */
-	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
+	for (i = 0; i < USBVIDEO_NUMSBUF; i++)
 		usb_kill_urb(uvd->sbuf[i].urb);
-	}
 	if (uvd->debug > 1)
 		dev_info(&uvd->dev->dev, "%s: streaming=0\n", __func__);
 	uvd->streaming = 0;
@@ -1995,7 +1989,7 @@ static int usbvideo_GetFrame(struct uvd *uvd, int frameNum)
 	case FrameState_Error:
 	{
 		int ntries, signalPending;
-	redo:
+redo:
 		if (!CAMERA_IS_OPERATIONAL(uvd)) {
 			if (uvd->debug >= 2)
 				dev_info(&uvd->dev->dev,
@@ -2133,8 +2127,7 @@ void usbvideo_DeinterlaceFrame(struct uvd *uvd, struct usbvideo_frame *frame)
 		return;
 
 	if ((frame->deinterlace == Deinterlace_FillEvenLines) ||
-	    (frame->deinterlace == Deinterlace_FillOddLines))
-	{
+	    (frame->deinterlace == Deinterlace_FillOddLines)) {
 		const int v4l_linesize = VIDEOSIZE_X(frame->request) * V4L_BYTES_PER_PIXEL;
 		int i = (frame->deinterlace == Deinterlace_FillEvenLines) ? 0 : 1;
 
@@ -2160,8 +2153,7 @@ void usbvideo_DeinterlaceFrame(struct uvd *uvd, struct usbvideo_frame *frame)
 			/* Sanity check */
 			if ((ip < 0) || (in < 0) ||
 			    (ip >= VIDEOSIZE_Y(frame->request)) ||
-			    (in >= VIDEOSIZE_Y(frame->request)))
-			{
+			    (in >= VIDEOSIZE_Y(frame->request))) {
 				err("Error: ip=%d. in=%d. req.height=%ld.",
 				    ip, in, VIDEOSIZE_Y(frame->request));
 				break;
@@ -2173,7 +2165,7 @@ void usbvideo_DeinterlaceFrame(struct uvd *uvd, struct usbvideo_frame *frame)
 			fd = frame->data + (v4l_linesize * i);
 
 			/* Average lines around destination */
-			for (j=0; j < v4l_linesize; j++) {
+			for (j = 0; j < v4l_linesize; j++) {
 				fd[j] = (unsigned char)((((unsigned) fs1[j]) +
 							 ((unsigned)fs2[j])) >> 1);
 			}
@@ -2215,9 +2207,9 @@ static void usbvideo_SoftwareContrastAdjustment(struct uvd *uvd,
 		return;
 	}
 	v4l_linesize = VIDEOSIZE_X(frame->request) * V4L_BYTES_PER_PIXEL;
-	for (i=0; i < VIDEOSIZE_Y(frame->request); i++) {
+	for (i = 0; i < VIDEOSIZE_Y(frame->request); i++) {
 		unsigned char *fd = frame->data + (v4l_linesize * i);
-		for (j=0; j < v4l_linesize; j++) {
+		for (j = 0; j < v4l_linesize; j++) {
 			signed long v = (signed long) fd[j];
 			/* Magnify up to 2 times, reduce down to zero */
 			v = 128 + ((ccm + adj) * (v - 128)) / ccm;
-- 
1.7.3.5

