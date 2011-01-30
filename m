Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1A3VYF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 16:24:05 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:56591
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753922Ab1A3VYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 16:24:03 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: deti@fliegl.de, tvh@informatik.uni-kiel.de, mchehab@redhat.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: dabusb: fixed coding style issues
Date: Sun, 30 Jan 2011 22:19:39 +0100
Message-Id: <1296422379-28093-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.3.5
X-Null-Tag: 5e4cec08e264c98486526a4b53b4a496
X-Authenticated-Sender: user tvh from 86.103.153.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/dabusb/dabusb.c |  338 ++++++++++++++++++++-------------------
 drivers/staging/dabusb/dabusb.h |   41 ++---
 2 files changed, 193 insertions(+), 186 deletions(-)

diff --git a/drivers/staging/dabusb/dabusb.c b/drivers/staging/dabusb/dabusb.c
index f3e25e9..21768a6 100644
--- a/drivers/staging/dabusb/dabusb.c
+++ b/drivers/staging/dabusb/dabusb.c
@@ -33,8 +33,8 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/uaccess.h>
+#include <linux/atomic.h>
 #include <linux/delay.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
@@ -66,28 +66,29 @@ static struct usb_driver dabusb_driver;
 
 /*-------------------------------------------------------------------*/
 
-static int dabusb_add_buf_tail (pdabusb_t s, struct list_head *dst, struct list_head *src)
+static int dabusb_add_buf_tail(pdabusb_t s, struct list_head *dst,
+			       struct list_head *src)
 {
 	unsigned long flags;
 	struct list_head *tmp;
 	int ret = 0;
 
-	spin_lock_irqsave (&s->lock, flags);
+	spin_lock_irqsave(&s->lock, flags);
 
-	if (list_empty (src)) {
-		// no elements in source buffer
+	if (list_empty(src)) {
+		/* no elements in source buffer */
 		ret = -1;
 		goto err;
 	}
 	tmp = src->next;
-	list_move_tail (tmp, dst);
+	list_move_tail(tmp, dst);
 
-  err:	spin_unlock_irqrestore (&s->lock, flags);
+err:	spin_unlock_irqrestore(&s->lock, flags);
 	return ret;
 }
 /*-------------------------------------------------------------------*/
 #ifdef DEBUG
-static void dump_urb (struct urb *urb)
+static void dump_urb(struct urb *urb)
 {
 	dbg("urb                   :%p", urb);
 	dbg("dev                   :%p", urb->dev);
@@ -107,26 +108,26 @@ static void dump_urb (struct urb *urb)
 }
 #endif
 /*-------------------------------------------------------------------*/
-static int dabusb_cancel_queue (pdabusb_t s, struct list_head *q)
+static int dabusb_cancel_queue(pdabusb_t s, struct list_head *q)
 {
 	unsigned long flags;
 	pbuff_t b;
 
 	dbg("dabusb_cancel_queue");
 
-	spin_lock_irqsave (&s->lock, flags);
+	spin_lock_irqsave(&s->lock, flags);
 
 	list_for_each_entry(b, q, buff_list) {
 #ifdef DEBUG
 		dump_urb(b->purb);
 #endif
-		usb_unlink_urb (b->purb);
+		usb_unlink_urb(b->purb);
 	}
-	spin_unlock_irqrestore (&s->lock, flags);
+	spin_unlock_irqrestore(&s->lock, flags);
 	return 0;
 }
 /*-------------------------------------------------------------------*/
-static int dabusb_free_queue (struct list_head *q)
+static int dabusb_free_queue(struct list_head *q)
 {
 	struct list_head *tmp;
 	struct list_head *p;
@@ -134,7 +135,7 @@ static int dabusb_free_queue (struct list_head *q)
 
 	dbg("dabusb_free_queue");
 	for (p = q->next; p != q;) {
-		b = list_entry (p, buff_t, buff_list);
+		b = list_entry(p, buff_t, buff_list);
 
 #ifdef DEBUG
 		dump_urb(b->purb);
@@ -142,23 +143,23 @@ static int dabusb_free_queue (struct list_head *q)
 		kfree(b->purb->transfer_buffer);
 		usb_free_urb(b->purb);
 		tmp = p->next;
-		list_del (p);
-		kfree (b);
+		list_del(p);
+		kfree(b);
 		p = tmp;
 	}
 
 	return 0;
 }
 /*-------------------------------------------------------------------*/
-static int dabusb_free_buffers (pdabusb_t s)
+static int dabusb_free_buffers(pdabusb_t s)
 {
 	unsigned long flags;
 	dbg("dabusb_free_buffers");
 
 	spin_lock_irqsave(&s->lock, flags);
 
-	dabusb_free_queue (&s->free_buff_list);
-	dabusb_free_queue (&s->rec_buff_list);
+	dabusb_free_queue(&s->free_buff_list);
+	dabusb_free_queue(&s->rec_buff_list);
 
 	spin_unlock_irqrestore(&s->lock, flags);
 
@@ -166,7 +167,7 @@ static int dabusb_free_buffers (pdabusb_t s)
 	return 0;
 }
 /*-------------------------------------------------------------------*/
-static void dabusb_iso_complete (struct urb *purb)
+static void dabusb_iso_complete(struct urb *purb)
 {
 	pbuff_t b = purb->context;
 	pdabusb_t s = b->s;
@@ -177,42 +178,45 @@ static void dabusb_iso_complete (struct urb *purb)
 
 	dbg("dabusb_iso_complete");
 
-	// process if URB was not killed
+	/* process if URB was not killed */
 	if (purb->status != -ENOENT) {
-		unsigned int pipe = usb_rcvisocpipe (purb->dev, _DABUSB_ISOPIPE);
-		int pipesize = usb_maxpacket (purb->dev, pipe, usb_pipeout (pipe));
+		unsigned int pipe = usb_rcvisocpipe(purb->dev, _DABUSB_ISOPIPE);
+		int pipesize = usb_maxpacket(purb->dev, pipe,
+					     usb_pipeout(pipe));
 		for (i = 0; i < purb->number_of_packets; i++)
 			if (!purb->iso_frame_desc[i].status) {
 				len = purb->iso_frame_desc[i].actual_length;
 				if (len <= pipesize) {
-					memcpy (buf + dst, buf + purb->iso_frame_desc[i].offset, len);
+					memcpy(buf + dst, buf + purb->iso_frame_desc[i].offset, len);
 					dst += len;
-				}
-				else
+				} else
 					dev_err(&purb->dev->dev,
-						"dabusb_iso_complete: invalid len %d\n", len);
-			}
-			else
-				dev_warn(&purb->dev->dev, "dabusb_iso_complete: corrupted packet status: %d\n", purb->iso_frame_desc[i].status);
+						"dabusb_iso_complete: invalid len %d\n",
+						len);
+			} else
+				dev_warn(&purb->dev->dev,
+					 "dabusb_iso_complete: corrupted packet status: %d\n",
+					 purb->iso_frame_desc[i].status);
 		if (dst != purb->actual_length)
 			dev_err(&purb->dev->dev,
 				"dst!=purb->actual_length:%d!=%d\n",
 					dst, purb->actual_length);
 	}
 
-	if (atomic_dec_and_test (&s->pending_io) && !s->remove_pending && s->state != _stopped) {
+	if (atomic_dec_and_test(&s->pending_io) &&
+	    !s->remove_pending && s->state != _stopped) {
 		s->overruns++;
 		dev_err(&purb->dev->dev, "overrun (%d)\n", s->overruns);
 	}
-	wake_up (&s->wait);
+	wake_up(&s->wait);
 }
 /*-------------------------------------------------------------------*/
-static int dabusb_alloc_buffers (pdabusb_t s)
+static int dabusb_alloc_buffers(pdabusb_t s)
 {
 	int transfer_len = 0;
 	pbuff_t b;
-	unsigned int pipe = usb_rcvisocpipe (s->usbdev, _DABUSB_ISOPIPE);
-	int pipesize = usb_maxpacket (s->usbdev, pipe, usb_pipeout (pipe));
+	unsigned int pipe = usb_rcvisocpipe(s->usbdev, _DABUSB_ISOPIPE);
+	int pipesize = usb_maxpacket(s->usbdev, pipe, usb_pipeout(pipe));
 	int packets = _ISOPIPESIZE / pipesize;
 	int transfer_buffer_length = packets * pipesize;
 	int i;
@@ -221,7 +225,7 @@ static int dabusb_alloc_buffers (pdabusb_t s)
 		 pipesize, packets, transfer_buffer_length);
 
 	while (transfer_len < (s->total_buffer_size << 10)) {
-		b = kzalloc(sizeof (buff_t), GFP_KERNEL);
+		b = kzalloc(sizeof(buff_t), GFP_KERNEL);
 		if (!b) {
 			dev_err(&s->usbdev->dev,
 				"kzalloc(sizeof(buff_t))==NULL\n");
@@ -231,14 +235,15 @@ static int dabusb_alloc_buffers (pdabusb_t s)
 		b->purb = usb_alloc_urb(packets, GFP_KERNEL);
 		if (!b->purb) {
 			dev_err(&s->usbdev->dev, "usb_alloc_urb == NULL\n");
-			kfree (b);
+			kfree(b);
 			goto err;
 		}
 
-		b->purb->transfer_buffer = kmalloc (transfer_buffer_length, GFP_KERNEL);
+		b->purb->transfer_buffer = kmalloc(transfer_buffer_length,
+						   GFP_KERNEL);
 		if (!b->purb->transfer_buffer) {
-			kfree (b->purb);
-			kfree (b);
+			kfree(b->purb);
+			kfree(b);
 			dev_err(&s->usbdev->dev,
 				"kmalloc(%d)==NULL\n", transfer_buffer_length);
 			goto err;
@@ -258,18 +263,18 @@ static int dabusb_alloc_buffers (pdabusb_t s)
 		}
 
 		transfer_len += transfer_buffer_length;
-		list_add_tail (&b->buff_list, &s->free_buff_list);
+		list_add_tail(&b->buff_list, &s->free_buff_list);
 	}
 	s->got_mem = transfer_len;
 
 	return 0;
 
-	err:
-	dabusb_free_buffers (s);
+err:
+	dabusb_free_buffers(s);
 	return -ENOMEM;
 }
 /*-------------------------------------------------------------------*/
-static int dabusb_bulk (pdabusb_t s, pbulk_transfer_t pb)
+static int dabusb_bulk(pdabusb_t s, pbulk_transfer_t pb)
 {
 	int ret;
 	unsigned int pipe;
@@ -278,25 +283,26 @@ static int dabusb_bulk (pdabusb_t s, pbulk_transfer_t pb)
 	dbg("dabusb_bulk");
 
 	if (!pb->pipe)
-		pipe = usb_rcvbulkpipe (s->usbdev, 2);
+		pipe = usb_rcvbulkpipe(s->usbdev, 2);
 	else
-		pipe = usb_sndbulkpipe (s->usbdev, 2);
+		pipe = usb_sndbulkpipe(s->usbdev, 2);
 
-	ret=usb_bulk_msg(s->usbdev, pipe, pb->data, pb->size, &actual_length, 100);
-	if(ret<0) {
+	ret = usb_bulk_msg(s->usbdev, pipe, pb->data,
+			   pb->size, &actual_length, 100);
+	if (ret < 0) {
 		dev_err(&s->usbdev->dev,
 			"usb_bulk_msg failed(%d)\n", ret);
 
-		if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
+		if (usb_set_interface(s->usbdev, _DABUSB_IF, 1) < 0) {
 			dev_err(&s->usbdev->dev, "set_interface failed\n");
 			return -EINVAL;
 		}
 
 	}
 
-	if( ret == -EPIPE ) {
+	if (ret == -EPIPE) {
 		dev_warn(&s->usbdev->dev, "CLEAR_FEATURE request to remove STALL condition.\n");
-		if(usb_clear_halt(s->usbdev, usb_pipeendpoint(pipe)))
+		if (usb_clear_halt(s->usbdev, usb_pipeendpoint(pipe)))
 			dev_err(&s->usbdev->dev, "request failed\n");
 	}
 
@@ -304,11 +310,11 @@ static int dabusb_bulk (pdabusb_t s, pbulk_transfer_t pb)
 	return ret;
 }
 /* --------------------------------------------------------------------- */
-static int dabusb_writemem (pdabusb_t s, int pos, const unsigned char *data,
+static int dabusb_writemem(pdabusb_t s, int pos, const unsigned char *data,
 			    int len)
 {
 	int ret;
-	unsigned char *transfer_buffer =  kmalloc (len, GFP_KERNEL);
+	unsigned char *transfer_buffer =  kmalloc(len, GFP_KERNEL);
 
 	if (!transfer_buffer) {
 		dev_err(&s->usbdev->dev,
@@ -316,21 +322,22 @@ static int dabusb_writemem (pdabusb_t s, int pos, const unsigned char *data,
 		return -ENOMEM;
 	}
 
-	memcpy (transfer_buffer, data, len);
+	memcpy(transfer_buffer, data, len);
 
-	ret=usb_control_msg(s->usbdev, usb_sndctrlpipe( s->usbdev, 0 ), 0xa0, 0x40, pos, 0, transfer_buffer, len, 300);
+	ret = usb_control_msg(s->usbdev, usb_sndctrlpipe(s->usbdev, 0),
+			      0xa0, 0x40, pos, 0, transfer_buffer, len, 300);
 
-	kfree (transfer_buffer);
+	kfree(transfer_buffer);
 	return ret;
 }
 /* --------------------------------------------------------------------- */
-static int dabusb_8051_reset (pdabusb_t s, unsigned char reset_bit)
+static int dabusb_8051_reset(pdabusb_t s, unsigned char reset_bit)
 {
-	dbg("dabusb_8051_reset: %d",reset_bit);
-	return dabusb_writemem (s, CPUCS_REG, &reset_bit, 1);
+	dbg("dabusb_8051_reset: %d", reset_bit);
+	return dabusb_writemem(s, CPUCS_REG, &reset_bit, 1);
 }
 /* --------------------------------------------------------------------- */
-static int dabusb_loadmem (pdabusb_t s, const char *fname)
+static int dabusb_loadmem(pdabusb_t s, const char *fname)
 {
 	int ret;
 	const struct ihex_binrec *rec;
@@ -344,7 +351,7 @@ static int dabusb_loadmem (pdabusb_t s, const char *fname)
 			"Failed to load \"dabusb/firmware.fw\": %d\n", ret);
 		goto out;
 	}
-	ret = dabusb_8051_reset (s, 1);
+	ret = dabusb_8051_reset(s, 1);
 
 	for (rec = (const struct ihex_binrec *)fw->data; rec;
 	     rec = ihex_next_binrec(rec)) {
@@ -361,7 +368,7 @@ static int dabusb_loadmem (pdabusb_t s, const char *fname)
 			break;
 		}
 	}
-	ret = dabusb_8051_reset (s, 0);
+	ret = dabusb_8051_reset(s, 0);
 	release_firmware(fw);
  out:
 	dbg("dabusb_loadmem: exit");
@@ -369,7 +376,7 @@ static int dabusb_loadmem (pdabusb_t s, const char *fname)
 	return ret;
 }
 /* --------------------------------------------------------------------- */
-static int dabusb_fpga_clear (pdabusb_t s, pbulk_transfer_t b)
+static int dabusb_fpga_clear(pdabusb_t s, pbulk_transfer_t b)
 {
 	b->size = 4;
 	b->data[0] = 0x2a;
@@ -379,10 +386,10 @@ static int dabusb_fpga_clear (pdabusb_t s, pbulk_transfer_t b)
 
 	dbg("dabusb_fpga_clear");
 
-	return dabusb_bulk (s, b);
+	return dabusb_bulk(s, b);
 }
 /* --------------------------------------------------------------------- */
-static int dabusb_fpga_init (pdabusb_t s, pbulk_transfer_t b)
+static int dabusb_fpga_init(pdabusb_t s, pbulk_transfer_t b)
 {
 	b->size = 4;
 	b->data[0] = 0x2c;
@@ -392,12 +399,12 @@ static int dabusb_fpga_init (pdabusb_t s, pbulk_transfer_t b)
 
 	dbg("dabusb_fpga_init");
 
-	return dabusb_bulk (s, b);
+	return dabusb_bulk(s, b);
 }
 /* --------------------------------------------------------------------- */
-static int dabusb_fpga_download (pdabusb_t s, const char *fname)
+static int dabusb_fpga_download(pdabusb_t s, const char *fname)
 {
-	pbulk_transfer_t b = kmalloc (sizeof (bulk_transfer_t), GFP_KERNEL);
+	pbulk_transfer_t b = kmalloc(sizeof(bulk_transfer_t), GFP_KERNEL);
 	const struct firmware *fw;
 	unsigned int blen, n;
 	int ret;
@@ -419,8 +426,8 @@ static int dabusb_fpga_download (pdabusb_t s, const char *fname)
 	}
 
 	b->pipe = 1;
-	ret = dabusb_fpga_clear (s, b);
-	mdelay (10);
+	ret = dabusb_fpga_clear(s, b);
+	mdelay(10);
 	blen = fw->data[73] + (fw->data[72] << 8);
 
 	dbg("Bitstream len: %i", blen);
@@ -431,19 +438,19 @@ static int dabusb_fpga_download (pdabusb_t s, const char *fname)
 	b->data[3] = 60;
 
 	for (n = 0; n <= blen + 60; n += 60) {
-		// some cclks for startup
+		/* some cclks for startup */
 		b->size = 64;
-		memcpy (b->data + 4, fw->data + 74 + n, 60);
-		ret = dabusb_bulk (s, b);
+		memcpy(b->data + 4, fw->data + 74 + n, 60);
+		ret = dabusb_bulk(s, b);
 		if (ret < 0) {
 			dev_err(&s->usbdev->dev, "dabusb_bulk failed.\n");
 			break;
 		}
-		mdelay (1);
+		mdelay(1);
 	}
 
-	ret = dabusb_fpga_init (s, b);
-	kfree (b);
+	ret = dabusb_fpga_init(s, b);
+	kfree(b);
 	release_firmware(fw);
 
 	dbg("exit dabusb_fpga_download");
@@ -451,12 +458,12 @@ static int dabusb_fpga_download (pdabusb_t s, const char *fname)
 	return ret;
 }
 
-static int dabusb_stop (pdabusb_t s)
+static int dabusb_stop(pdabusb_t s)
 {
 	dbg("dabusb_stop");
 
 	s->state = _stopped;
-	dabusb_cancel_queue (s, &s->rec_buff_list);
+	dabusb_cancel_queue(s, &s->rec_buff_list);
 
 	dbg("pending_io: %d", s->pending_io.counter);
 
@@ -464,50 +471,53 @@ static int dabusb_stop (pdabusb_t s)
 	return 0;
 }
 
-static int dabusb_startrek (pdabusb_t s)
+static int dabusb_startrek(pdabusb_t s)
 {
 	if (!s->got_mem && s->state != _started) {
 
 		dbg("dabusb_startrek");
 
-		if (dabusb_alloc_buffers (s) < 0)
+		if (dabusb_alloc_buffers(s) < 0)
 			return -ENOMEM;
-		dabusb_stop (s);
+		dabusb_stop(s);
 		s->state = _started;
 		s->readptr = 0;
 	}
 
-	if (!list_empty (&s->free_buff_list)) {
+	if (!list_empty(&s->free_buff_list)) {
 		pbuff_t end;
 		int ret;
 
-	while (!dabusb_add_buf_tail (s, &s->rec_buff_list, &s->free_buff_list)) {
+	while (!dabusb_add_buf_tail(s, &s->rec_buff_list, &s->free_buff_list)) {
 
-			dbg("submitting: end:%p s->rec_buff_list:%p", s->rec_buff_list.prev, &s->rec_buff_list);
+			dbg("submitting: end:%p s->rec_buff_list:%p",
+			    s->rec_buff_list.prev, &s->rec_buff_list);
 
-			end = list_entry (s->rec_buff_list.prev, buff_t, buff_list);
+			end = list_entry(s->rec_buff_list.prev,
+					 buff_t, buff_list);
 
-			ret = usb_submit_urb (end->purb, GFP_KERNEL);
+			ret = usb_submit_urb(end->purb, GFP_KERNEL);
 			if (ret) {
 				dev_err(&s->usbdev->dev,
 					"usb_submit_urb returned:%d\n", ret);
-				if (dabusb_add_buf_tail (s, &s->free_buff_list, &s->rec_buff_list))
+				if (dabusb_add_buf_tail(s, &s->free_buff_list,
+							&s->rec_buff_list))
 					dev_err(&s->usbdev->dev,
 						"startrek: dabusb_add_buf_tail failed\n");
 				break;
-			}
-			else
-				atomic_inc (&s->pending_io);
+			} else
+				atomic_inc(&s->pending_io);
 		}
-		dbg("pending_io: %d",s->pending_io.counter);
+		dbg("pending_io: %d", s->pending_io.counter);
 	}
 
 	return 0;
 }
 
-static ssize_t dabusb_read (struct file *file, char __user *buf, size_t count, loff_t * ppos)
+static ssize_t dabusb_read(struct file *file, char __user *buf,
+			   size_t count, loff_t *ppos)
 {
-	pdabusb_t s = (pdabusb_t) file->private_data;
+	pdabusb_t s = (pdabusb_t)file->private_data;
 	unsigned long flags;
 	unsigned ret = 0;
 	int rem;
@@ -528,11 +538,11 @@ static ssize_t dabusb_read (struct file *file, char __user *buf, size_t count, l
 		return -EIO;
 
 	while (count > 0) {
-		dabusb_startrek (s);
+		dabusb_startrek(s);
 
-		spin_lock_irqsave (&s->lock, flags);
+		spin_lock_irqsave(&s->lock, flags);
 
-		if (list_empty (&s->rec_buff_list)) {
+		if (list_empty(&s->rec_buff_list)) {
 
 			spin_unlock_irqrestore(&s->lock, flags);
 
@@ -541,30 +551,30 @@ static ssize_t dabusb_read (struct file *file, char __user *buf, size_t count, l
 			goto err;
 		}
 
-		b = list_entry (s->rec_buff_list.next, buff_t, buff_list);
+		b = list_entry(s->rec_buff_list.next, buff_t, buff_list);
 		purb = b->purb;
 
 		spin_unlock_irqrestore(&s->lock, flags);
 
 		if (purb->status == -EINPROGRESS) {
-			if (file->f_flags & O_NONBLOCK)		// return nonblocking
-			 {
+			/* return nonblocking */
+			if (file->f_flags & O_NONBLOCK) {
 				if (!ret)
 					ret = -EAGAIN;
 				goto err;
 			}
 
-			interruptible_sleep_on (&s->wait);
+			interruptible_sleep_on(&s->wait);
 
-			if (signal_pending (current)) {
+			if (signal_pending(current)) {
 				if (!ret)
 					ret = -ERESTARTSYS;
 				goto err;
 			}
 
-			spin_lock_irqsave (&s->lock, flags);
+			spin_lock_irqsave(&s->lock, flags);
 
-			if (list_empty (&s->rec_buff_list)) {
+			if (list_empty(&s->rec_buff_list)) {
 				spin_unlock_irqrestore(&s->lock, flags);
 				dev_err(&s->usbdev->dev,
 					"error: still no buffer available.\n");
@@ -578,16 +588,20 @@ static ssize_t dabusb_read (struct file *file, char __user *buf, size_t count, l
 			goto err;
 		}
 
-		rem = purb->actual_length - s->readptr;		// set remaining bytes to copy
+		/* set remaining bytes to copy */
+		rem = purb->actual_length - s->readptr;
 
 		if (count >= rem)
 			cnt = rem;
 		else
 			cnt = count;
 
-		dbg("copy_to_user:%p %p %d",buf, purb->transfer_buffer + s->readptr, cnt);
+		dbg("copy_to_user:%p %p %d", buf,
+		    purb->transfer_buffer + s->readptr, cnt);
 
-		if (copy_to_user (buf, purb->transfer_buffer + s->readptr, cnt)) {
+		if (copy_to_user(buf,
+				purb->transfer_buffer + s->readptr,
+				cnt)) {
 			dev_err(&s->usbdev->dev, "read: copy_to_user failed\n");
 			if (!ret)
 				ret = -EFAULT;
@@ -600,18 +614,19 @@ static ssize_t dabusb_read (struct file *file, char __user *buf, size_t count, l
 		ret += cnt;
 
 		if (s->readptr == purb->actual_length) {
-			// finished, take next buffer
-			if (dabusb_add_buf_tail (s, &s->free_buff_list, &s->rec_buff_list))
+			/* finished, take next buffer */
+			if (dabusb_add_buf_tail(s, &s->free_buff_list,
+						&s->rec_buff_list))
 				dev_err(&s->usbdev->dev,
 					"read: dabusb_add_buf_tail failed\n");
 			s->readptr = 0;
 		}
 	}
-      err:			//mutex_unlock(&s->mutex);
+err:			/*mutex_unlock(&s->mutex);*/
 	return ret;
 }
 
-static int dabusb_open (struct inode *inode, struct file *file)
+static int dabusb_open(struct inode *inode, struct file *file)
 {
 	int devnum = iminor(inode);
 	pdabusb_t s;
@@ -632,11 +647,11 @@ static int dabusb_open (struct inode *inode, struct file *file)
 			return -EBUSY;
 		msleep_interruptible(500);
 
-		if (signal_pending (current))
+		if (signal_pending(current))
 			return -EAGAIN;
 		mutex_lock(&s->mutex);
 	}
-	if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
+	if (usb_set_interface(s->usbdev, _DABUSB_IF, 1) < 0) {
 		mutex_unlock(&s->mutex);
 		dev_err(&s->usbdev->dev, "set_interface failed\n");
 		return -EINVAL;
@@ -651,31 +666,30 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	return r;
 }
 
-static int dabusb_release (struct inode *inode, struct file *file)
+static int dabusb_release(struct inode *inode, struct file *file)
 {
-	pdabusb_t s = (pdabusb_t) file->private_data;
+	pdabusb_t s = (pdabusb_t)file->private_data;
 
 	dbg("dabusb_release");
 
 	mutex_lock(&s->mutex);
-	dabusb_stop (s);
-	dabusb_free_buffers (s);
+	dabusb_stop(s);
+	dabusb_free_buffers(s);
 	mutex_unlock(&s->mutex);
 
 	if (!s->remove_pending) {
-		if (usb_set_interface (s->usbdev, _DABUSB_IF, 0) < 0)
+		if (usb_set_interface(s->usbdev, _DABUSB_IF, 0) < 0)
 			dev_err(&s->usbdev->dev, "set_interface failed\n");
-	}
-	else
-		wake_up (&s->remove_ok);
+	} else
+		wake_up(&s->remove_ok);
 
 	s->opened = 0;
 	return 0;
 }
 
-static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
+static long dabusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	pdabusb_t s = (pdabusb_t) file->private_data;
+	pdabusb_t s = (pdabusb_t)file->private_data;
 	pbulk_transfer_t pbulk;
 	int ret = 0;
 	int version = DABUSB_VERSION;
@@ -703,20 +717,20 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 			break;
 		}
 
-		ret=dabusb_bulk (s, pbulk);
-		if(ret==0)
+		ret = dabusb_bulk(s, pbulk);
+		if (ret == 0)
 			if (copy_to_user((void __user *)arg, pbulk,
 					 sizeof(bulk_transfer_t)))
 				ret = -EFAULT;
-		kfree (pbulk);
+		kfree(pbulk);
 		break;
 
 	case IOCTL_DAB_OVERRUNS:
-		ret = put_user (s->overruns, (unsigned int __user *) arg);
+		ret = put_user(s->overruns, (unsigned int __user *) arg);
 		break;
 
 	case IOCTL_DAB_VERSION:
-		ret = put_user (version, (unsigned int __user *) arg);
+		ret = put_user(version, (unsigned int __user *) arg);
 		break;
 
 	default:
@@ -727,8 +741,7 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 	return ret;
 }
 
-static const struct file_operations dabusb_fops =
-{
+static const struct file_operations dabusb_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.read =		dabusb_read,
@@ -751,7 +764,7 @@ static struct usb_class_driver dabusb_class = {
 
 
 /* --------------------------------------------------------------------- */
-static int dabusb_probe (struct usb_interface *intf,
+static int dabusb_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
 	struct usb_device *usbdev = interface_to_usbdev(intf);
@@ -780,54 +793,53 @@ static int dabusb_probe (struct usb_interface *intf,
 	s->usbdev = usbdev;
 	s->devnum = intf->minor;
 
-	if (usb_reset_configuration (usbdev) < 0) {
+	if (usb_reset_configuration(usbdev) < 0) {
 		dev_err(&intf->dev, "reset_configuration failed\n");
 		goto reject;
 	}
 	if (le16_to_cpu(usbdev->descriptor.idProduct) == 0x2131) {
-		dabusb_loadmem (s, NULL);
+		dabusb_loadmem(s, NULL);
 		goto reject;
-	}
-	else {
-		dabusb_fpga_download (s, NULL);
+	} else {
+		dabusb_fpga_download(s, NULL);
 
-		if (usb_set_interface (s->usbdev, _DABUSB_IF, 0) < 0) {
+		if (usb_set_interface(s->usbdev, _DABUSB_IF, 0) < 0) {
 			dev_err(&intf->dev, "set_interface failed\n");
 			goto reject;
 		}
 	}
 	dbg("bound to interface: %d", intf->altsetting->desc.bInterfaceNumber);
-	usb_set_intfdata (intf, s);
+	usb_set_intfdata(intf, s);
 	mutex_unlock(&s->mutex);
 
 	retval = usb_register_dev(intf, &dabusb_class);
 	if (retval) {
-		usb_set_intfdata (intf, NULL);
+		usb_set_intfdata(intf, NULL);
 		return -ENOMEM;
 	}
 
 	return 0;
 
-      reject:
+reject:
 	mutex_unlock(&s->mutex);
 	s->usbdev = NULL;
 	return -ENODEV;
 }
 
-static void dabusb_disconnect (struct usb_interface *intf)
+static void dabusb_disconnect(struct usb_interface *intf)
 {
 	wait_queue_t __wait;
-	pdabusb_t s = usb_get_intfdata (intf);
+	pdabusb_t s = usb_get_intfdata(intf);
 
 	dbg("dabusb_disconnect");
 
 	init_waitqueue_entry(&__wait, current);
 
-	usb_set_intfdata (intf, NULL);
+	usb_set_intfdata(intf, NULL);
 	if (s) {
-		usb_deregister_dev (intf, &dabusb_class);
+		usb_deregister_dev(intf, &dabusb_class);
 		s->remove_pending = 1;
-		wake_up (&s->wait);
+		wake_up(&s->wait);
 		add_wait_queue(&s->remove_ok, &__wait);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (s->state == _started)
@@ -840,13 +852,13 @@ static void dabusb_disconnect (struct usb_interface *intf)
 	}
 }
 
-static struct usb_device_id dabusb_ids [] = {
-	// { USB_DEVICE(0x0547, 0x2131) },	/* An2131 chip, no boot ROM */
+static struct usb_device_id dabusb_ids[] = {
+	/* { USB_DEVICE(0x0547, 0x2131) },*/	/* An2131 chip, no boot ROM */
 	{ USB_DEVICE(0x0547, 0x9999) },
 	{ }						/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, dabusb_ids);
+MODULE_DEVICE_TABLE(usb, dabusb_ids);
 
 static struct usb_driver dabusb_driver = {
 	.name =		"dabusb",
@@ -857,7 +869,7 @@ static struct usb_driver dabusb_driver = {
 
 /* --------------------------------------------------------------------- */
 
-static int __init dabusb_init (void)
+static int __init dabusb_init(void)
 {
 	int retval;
 	unsigned u;
@@ -865,15 +877,15 @@ static int __init dabusb_init (void)
 	/* initialize struct */
 	for (u = 0; u < NRDABUSB; u++) {
 		pdabusb_t s = &dabusb[u];
-		memset (s, 0, sizeof (dabusb_t));
-		mutex_init (&s->mutex);
+		memset(s, 0, sizeof(dabusb_t));
+		mutex_init(&s->mutex);
 		s->usbdev = NULL;
 		s->total_buffer_size = buffers;
-		init_waitqueue_head (&s->wait);
-		init_waitqueue_head (&s->remove_ok);
-		spin_lock_init (&s->lock);
-		INIT_LIST_HEAD (&s->free_buff_list);
-		INIT_LIST_HEAD (&s->rec_buff_list);
+		init_waitqueue_head(&s->wait);
+		init_waitqueue_head(&s->remove_ok);
+		spin_lock_init(&s->lock);
+		INIT_LIST_HEAD(&s->free_buff_list);
+		INIT_LIST_HEAD(&s->rec_buff_list);
 	}
 
 	/* register misc device */
@@ -890,25 +902,25 @@ out:
 	return retval;
 }
 
-static void __exit dabusb_cleanup (void)
+static void __exit dabusb_cleanup(void)
 {
 	dbg("dabusb_cleanup");
 
-	usb_deregister (&dabusb_driver);
+	usb_deregister(&dabusb_driver);
 }
 
 /* --------------------------------------------------------------------- */
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE("dabusb/firmware.fw");
 MODULE_FIRMWARE("dabusb/bitstream.bin");
 
 module_param(buffers, int, 0);
-MODULE_PARM_DESC (buffers, "Number of buffers (default=256)");
+MODULE_PARM_DESC(buffers, "Number of buffers (default=256)");
 
-module_init (dabusb_init);
-module_exit (dabusb_cleanup);
+module_init(dabusb_init);
+module_exit(dabusb_cleanup);
 
 /* --------------------------------------------------------------------- */
diff --git a/drivers/staging/dabusb/dabusb.h b/drivers/staging/dabusb/dabusb.h
index 00eb34c..c1772ef 100644
--- a/drivers/staging/dabusb/dabusb.h
+++ b/drivers/staging/dabusb/dabusb.h
@@ -1,10 +1,9 @@
 #define _BULK_DATA_LEN 64
-typedef struct
-{
+typedef struct {
 	unsigned char data[_BULK_DATA_LEN];
 	unsigned int size;
 	unsigned int pipe;
-}bulk_transfer_t,*pbulk_transfer_t;
+} bulk_transfer_t, *pbulk_transfer_t;
 
 #define DABUSB_MINOR 240		/* some unassigned USB minor */
 #define DABUSB_VERSION 0x1000
@@ -14,10 +13,9 @@ typedef struct
 
 #ifdef __KERNEL__
 
-typedef enum { _stopped=0, _started } driver_state_t;
+typedef enum { _stopped = 0, _started } driver_state_t;
 
-typedef struct
-{
+typedef struct {
 	struct mutex mutex;
 	struct usb_device *usbdev;
 	wait_queue_head_t wait;
@@ -34,17 +32,15 @@ typedef struct
 	int devnum;
 	struct list_head free_buff_list;
 	struct list_head rec_buff_list;
-} dabusb_t,*pdabusb_t;
+} dabusb_t, *pdabusb_t;
 
-typedef struct
-{
+typedef struct {
 	pdabusb_t s;
 	struct urb *purb;
 	struct list_head buff_list;
-} buff_t,*pbuff_t;
+} buff_t, *pbuff_t;
 
-typedef struct
-{
+typedef struct {
 	wait_queue_head_t wait;
 } bulk_completion_context_t, *pbulk_completion_context_t;
 
@@ -54,11 +50,11 @@ typedef struct
 #define _ISOPIPESIZE	16384
 
 #define _BULK_DATA_LEN 64
-// Vendor specific request code for Anchor Upload/Download
-// This one is implemented in the core
+/* Vendor specific request code for Anchor Upload/Download
+ *This one is implemented in the core */
 #define ANCHOR_LOAD_INTERNAL  0xA0
 
-// EZ-USB Control and Status Register.  Bit 0 controls 8051 reset
+/* EZ-USB Control and Status Register.  Bit 0 controls 8051 reset */
 #define CPUCS_REG    0x7F92
 #define _TOTAL_BUFFERS 384
 
@@ -67,19 +63,18 @@ typedef struct
 #ifndef _BYTE_DEFINED
 #define _BYTE_DEFINED
 typedef unsigned char BYTE;
-#endif // !_BYTE_DEFINED
+#endif /* !_BYTE_DEFINED */
 
 #ifndef _WORD_DEFINED
 #define _WORD_DEFINED
 typedef unsigned short WORD;
-#endif // !_WORD_DEFINED
+#endif /* !_WORD_DEFINED */
 
-typedef struct _INTEL_HEX_RECORD
-{
-   BYTE  Length;
-   WORD  Address;
-   BYTE  Type;
-   BYTE  Data[MAX_INTEL_HEX_RECORD_LENGTH];
+typedef struct _INTEL_HEX_RECORD {
+	BYTE  Length;
+	WORD  Address;
+	BYTE  Type;
+	BYTE  Data[MAX_INTEL_HEX_RECORD_LENGTH];
 } INTEL_HEX_RECORD, *PINTEL_HEX_RECORD;
 
 #endif
-- 
1.7.3.5

