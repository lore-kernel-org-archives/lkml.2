Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab0J1Pcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:32:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab0J1Pcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Kc93WSzeX3uTxDn7ECQjzXIP8feAMPfOuF0Nv2QZqtMf9hmGYUdw5FzIS8+m40u7cx
         t8sJMjNhu7bVVNPwmekD3e0gKcLywSzhiKqQTeg7fHBlN5qMBZnfDuQGorVB7rmxLrS0
         MWLyC0KrtVUiD3bS6Mo1FH1sYYvVFsfKWBGfw=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2 6/7] USB: gadget: f_mass_storage: code style clean ups
Date: Thu, 28 Oct 2010 17:31:23 +0200
Message-Id: <ef904cdc698b2b3e3b53cf31fa37b7b288436753.1288256118.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
References: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit is purely style clean ups.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |  458 +++++++++++++++++++----------------
 drivers/usb/gadget/mass_storage.c   |    2 +-
 2 files changed, 249 insertions(+), 211 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 365f1b3..b5dbb23 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -37,7 +37,6 @@
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-
 /*
  * The Mass Storage Function acts as a USB Mass Storage device,
  * appearing to the host as a disk drive or as a CD-ROM drive.  In
@@ -185,7 +184,6 @@
  * <http://www.usb.org/developers/devclass_docs/usbmass-ufi10.pdf>.
  */
 
-
 /*
  *				Driver Design
  *
@@ -275,7 +273,6 @@
 /* #define VERBOSE_DEBUG */
 /* #define DUMP_MSGS */
 
-
 #include <linux/blkdev.h>
 #include <linux/completion.h>
 #include <linux/dcache.h>
@@ -300,7 +297,6 @@
 #include "gadget_chips.h"
 
 
-
 /*------------------------------------------------------------------------*/
 
 #define FSG_DRIVER_DESC		"Mass Storage Function"
@@ -308,7 +304,6 @@
 
 static const char fsg_string_interface[] = "Mass Storage";
 
-
 #define FSG_NO_INTR_EP 1
 #define FSG_NO_DEVICE_STRINGS    1
 #define FSG_NO_OTG               1
@@ -324,25 +319,30 @@ struct fsg_common;
 
 /* FSF callback functions */
 struct fsg_operations {
-	/* Callback function to call when thread exits.  If no
+	/*
+	 * Callback function to call when thread exits.  If no
 	 * callback is set or it returns value lower then zero MSF
 	 * will force eject all LUNs it operates on (including those
 	 * marked as non-removable or with prevent_medium_removal flag
-	 * set). */
+	 * set).
+	 */
 	int (*thread_exits)(struct fsg_common *common);
 
-	/* Called prior to ejection.  Negative return means error,
+	/*
+	 * Called prior to ejection.  Negative return means error,
 	 * zero means to continue with ejection, positive means not to
-	 * eject. */
+	 * eject.
+	 */
 	int (*pre_eject)(struct fsg_common *common,
 			 struct fsg_lun *lun, int num);
-	/* Called after ejection.  Negative return means error, zero
-	 * or positive is just a success. */
+	/*
+	 * Called after ejection.  Negative return means error, zero
+	 * or positive is just a success.
+	 */
 	int (*post_eject)(struct fsg_common *common,
 			  struct fsg_lun *lun, int num);
 };
 
-
 /* Data shared by all the FSG instances. */
 struct fsg_common {
 	struct usb_gadget	*gadget;
@@ -398,14 +398,15 @@ struct fsg_common {
 	/* Gadget's private data. */
 	void			*private_data;
 
-	/* Vendor (8 chars), product (16 chars), release (4
-	 * hexadecimal digits) and NUL byte */
+	/*
+	 * Vendor (8 chars), product (16 chars), release (4
+	 * hexadecimal digits) and NUL byte
+	 */
 	char inquiry_string[8 + 16 + 4 + 1];
 
 	struct kref		ref;
 };
 
-
 struct fsg_config {
 	unsigned nluns;
 	struct fsg_lun_config {
@@ -431,7 +432,6 @@ struct fsg_config {
 	char			can_stall;
 };
 
-
 struct fsg_dev {
 	struct usb_function	function;
 	struct usb_gadget	*gadget;	/* Copy of cdev->gadget */
@@ -449,7 +449,6 @@ struct fsg_dev {
 	struct usb_ep		*bulk_out;
 };
 
-
 static inline int __fsg_is_set(struct fsg_common *common,
 			       const char *func, unsigned line)
 {
@@ -462,13 +461,11 @@ static inline int __fsg_is_set(struct fsg_common *common,
 
 #define fsg_is_set(common) likely(__fsg_is_set(common, __func__, __LINE__))
 
-
 static inline struct fsg_dev *fsg_from_func(struct usb_function *f)
 {
 	return container_of(f, struct fsg_dev, function);
 }
 
-
 typedef void (*fsg_routine_t)(struct fsg_dev *);
 
 static int exception_in_progress(struct fsg_common *common)
@@ -478,7 +475,7 @@ static int exception_in_progress(struct fsg_common *common)
 
 /* Make bulk-out requests be divisible by the maxpacket size */
 static void set_bulk_out_req_length(struct fsg_common *common,
-		struct fsg_buffhd *bh, unsigned int length)
+				    struct fsg_buffhd *bh, unsigned int length)
 {
 	unsigned int	rem;
 
@@ -489,6 +486,7 @@ static void set_bulk_out_req_length(struct fsg_common *common,
 	bh->outreq->length = length;
 }
 
+
 /*-------------------------------------------------------------------------*/
 
 static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
@@ -519,14 +517,15 @@ static void wakeup_thread(struct fsg_common *common)
 		wake_up_process(common->thread_task);
 }
 
-
 static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
 {
 	unsigned long		flags;
 
-	/* Do nothing if a higher-priority exception is already in progress.
+	/*
+	 * Do nothing if a higher-priority exception is already in progress.
 	 * If a lower-or-equal priority exception is in progress, preempt it
-	 * and notify the main thread by sending it a signal. */
+	 * and notify the main thread by sending it a signal.
+	 */
 	spin_lock_irqsave(&common->lock, flags);
 	if (common->state <= new_state) {
 		common->exception_req_tag = common->ep0_req_tag;
@@ -555,10 +554,10 @@ static int ep0_queue(struct fsg_common *common)
 	return rc;
 }
 
+
 /*-------------------------------------------------------------------------*/
 
-/* Bulk and interrupt endpoint completion handlers.
- * These always run in_irq. */
+/* Completion handlers. These always run in_irq. */
 
 static void bulk_in_complete(struct usb_ep *ep, struct usb_request *req)
 {
@@ -567,7 +566,7 @@ static void bulk_in_complete(struct usb_ep *ep, struct usb_request *req)
 
 	if (req->status || req->actual != req->length)
 		DBG(common, "%s --> %d, %u/%u\n", __func__,
-				req->status, req->actual, req->length);
+		    req->status, req->actual, req->length);
 	if (req->status == -ECONNRESET)		/* Request was cancelled */
 		usb_ep_fifo_flush(ep);
 
@@ -588,8 +587,7 @@ static void bulk_out_complete(struct usb_ep *ep, struct usb_request *req)
 	dump_msg(common, "bulk-out", req->buf, req->actual);
 	if (req->status || req->actual != bh->bulk_out_intended_length)
 		DBG(common, "%s --> %d, %u/%u\n", __func__,
-				req->status, req->actual,
-				bh->bulk_out_intended_length);
+		    req->status, req->actual, bh->bulk_out_intended_length);
 	if (req->status == -ECONNRESET)		/* Request was cancelled */
 		usb_ep_fifo_flush(ep);
 
@@ -602,13 +600,8 @@ static void bulk_out_complete(struct usb_ep *ep, struct usb_request *req)
 	spin_unlock(&common->lock);
 }
 
-
-/*-------------------------------------------------------------------------*/
-
-/* Ep0 class-specific handlers.  These always run in_irq. */
-
 static int fsg_setup(struct usb_function *f,
-		const struct usb_ctrlrequest *ctrl)
+		     const struct usb_ctrlrequest *ctrl)
 {
 	struct fsg_dev		*fsg = fsg_from_func(f);
 	struct usb_request	*req = fsg->common->ep0req;
@@ -628,8 +621,10 @@ static int fsg_setup(struct usb_function *f,
 		if (w_index != fsg->interface_number || w_value != 0)
 			return -EDOM;
 
-		/* Raise an exception to stop the current operation
-		 * and reinitialize our state. */
+		/*
+		 * Raise an exception to stop the current operation
+		 * and reinitialize our state.
+		 */
 		DBG(fsg, "bulk reset request\n");
 		raise_exception(fsg->common, FSG_STATE_RESET);
 		return DELAYED_STATUS;
@@ -641,7 +636,7 @@ static int fsg_setup(struct usb_function *f,
 		if (w_index != fsg->interface_number || w_value != 0)
 			return -EDOM;
 		VDBG(fsg, "get max LUN\n");
-		*(u8 *) req->buf = fsg->common->nluns - 1;
+		*(u8 *)req->buf = fsg->common->nluns - 1;
 
 		/* Respond with data/status */
 		req->length = min((u16)1, w_length);
@@ -649,8 +644,7 @@ static int fsg_setup(struct usb_function *f,
 	}
 
 	VDBG(fsg,
-	     "unknown class-specific control req "
-	     "%02x.%02x v%04x i%04x l%u\n",
+	     "unknown class-specific control req %02x.%02x v%04x i%04x l%u\n",
 	     ctrl->bRequestType, ctrl->bRequest,
 	     le16_to_cpu(ctrl->wValue), w_index, w_length);
 	return -EOPNOTSUPP;
@@ -661,11 +655,10 @@ static int fsg_setup(struct usb_function *f,
 
 /* All the following routines run in process context */
 
-
 /* Use this for bulk or interrupt transfers, not ep0 */
 static void start_transfer(struct fsg_dev *fsg, struct usb_ep *ep,
-		struct usb_request *req, int *pbusy,
-		enum fsg_buffer_state *state)
+			   struct usb_request *req, int *pbusy,
+			   enum fsg_buffer_state *state)
 {
 	int	rc;
 
@@ -683,12 +676,14 @@ static void start_transfer(struct fsg_dev *fsg, struct usb_ep *ep,
 
 		/* We can't do much more than wait for a reset */
 
-		/* Note: currently the net2280 driver fails zero-length
-		 * submissions if DMA is enabled. */
-		if (rc != -ESHUTDOWN && !(rc == -EOPNOTSUPP &&
-						req->length == 0))
+		/*
+		 * Note: currently the net2280 driver fails zero-length
+		 * submissions if DMA is enabled.
+		 */
+		if (rc != -ESHUTDOWN &&
+		    !(rc == -EOPNOTSUPP && req->length == 0))
 			WARNING(fsg, "error in submission: %s --> %d\n",
-					ep->name, rc);
+				ep->name, rc);
 	}
 }
 
@@ -746,16 +741,20 @@ static int do_read(struct fsg_common *common)
 	unsigned int		partial_page;
 	ssize_t			nread;
 
-	/* Get the starting Logical Block Address and check that it's
-	 * not too big */
+	/*
+	 * Get the starting Logical Block Address and check that it's
+	 * not too big.
+	 */
 	if (common->cmnd[0] == READ_6)
 		lba = get_unaligned_be24(&common->cmnd[1]);
 	else {
 		lba = get_unaligned_be32(&common->cmnd[2]);
 
-		/* We allow DPO (Disable Page Out = don't save data in the
+		/*
+		 * We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = don't read from the
-		 * cache), but we don't implement them. */
+		 * cache), but we don't implement them.
+		 */
 		if ((common->cmnd[1] & ~0x18) != 0) {
 			curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 			return -EINVAL;
@@ -773,22 +772,23 @@ static int do_read(struct fsg_common *common)
 		return -EIO;		/* No default reply */
 
 	for (;;) {
-
-		/* Figure out how much we need to read:
+		/*
+		 * Figure out how much we need to read:
 		 * Try to read the remaining amount.
 		 * But don't read more than the buffer size.
 		 * And don't try to read past the end of the file.
 		 * Finally, if we're not at a page boundary, don't read past
 		 *	the next page.
 		 * If this means reading 0 then we were asked to read past
-		 *	the end of file. */
+		 *	the end of file.
+		 */
 		amount = min(amount_left, FSG_BUFLEN);
-		amount = min((loff_t) amount,
-				curlun->file_length - file_offset);
+		amount = min((loff_t)amount,
+			     curlun->file_length - file_offset);
 		partial_page = file_offset & (PAGE_CACHE_SIZE - 1);
 		if (partial_page > 0)
-			amount = min(amount, (unsigned int) PAGE_CACHE_SIZE -
-					partial_page);
+			amount = min(amount, (unsigned int)PAGE_CACHE_SIZE -
+					     partial_page);
 
 		/* Wait for the next buffer to become available */
 		bh = common->next_buffhd_to_fill;
@@ -798,8 +798,10 @@ static int do_read(struct fsg_common *common)
 				return rc;
 		}
 
-		/* If we were asked to read past the end of file,
-		 * end with an empty buffer. */
+		/*
+		 * If we were asked to read past the end of file,
+		 * end with an empty buffer.
+		 */
 		if (amount == 0) {
 			curlun->sense_data =
 					SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
@@ -813,21 +815,19 @@ static int do_read(struct fsg_common *common)
 		/* Perform the read */
 		file_offset_tmp = file_offset;
 		nread = vfs_read(curlun->filp,
-				(char __user *) bh->buf,
-				amount, &file_offset_tmp);
+				 (char __user *)bh->buf,
+				 amount, &file_offset_tmp);
 		VLDBG(curlun, "file read %u @ %llu -> %d\n", amount,
-				(unsigned long long) file_offset,
-				(int) nread);
+		      (unsigned long long)file_offset, (int)nread);
 		if (signal_pending(current))
 			return -EINTR;
 
 		if (nread < 0) {
-			LDBG(curlun, "error in file read: %d\n",
-					(int) nread);
+			LDBG(curlun, "error in file read: %d\n", (int)nread);
 			nread = 0;
 		} else if (nread < amount) {
 			LDBG(curlun, "partial file read: %d/%u\n",
-					(int) nread, amount);
+			     (int)nread, amount);
 			nread -= (nread & 511);	/* Round down to a block */
 		}
 		file_offset  += nread;
@@ -882,17 +882,21 @@ static int do_write(struct fsg_common *common)
 	curlun->filp->f_flags &= ~O_SYNC;	/* Default is not to wait */
 	spin_unlock(&curlun->filp->f_lock);
 
-	/* Get the starting Logical Block Address and check that it's
-	 * not too big */
+	/*
+	 * Get the starting Logical Block Address and check that it's
+	 * not too big
+	 */
 	if (common->cmnd[0] == WRITE_6)
 		lba = get_unaligned_be24(&common->cmnd[1]);
 	else {
 		lba = get_unaligned_be32(&common->cmnd[2]);
 
-		/* We allow DPO (Disable Page Out = don't save data in the
+		/*
+		 * We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = write directly to the
 		 * medium).  We don't implement DPO; we implement FUA by
-		 * performing synchronous output. */
+		 * performing synchronous output.
+		 */
 		if (common->cmnd[1] & ~0x18) {
 			curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 			return -EINVAL;
@@ -920,7 +924,8 @@ static int do_write(struct fsg_common *common)
 		bh = common->next_buffhd_to_fill;
 		if (bh->state == BUF_STATE_EMPTY && get_some_more) {
 
-			/* Figure out how much we want to get:
+			/*
+			 * Figure out how much we want to get:
 			 * Try to get the remaining amount.
 			 * But don't get more than the buffer size.
 			 * And don't try to go past the end of the file.
@@ -928,14 +933,15 @@ static int do_write(struct fsg_common *common)
 			 *	don't go past the next page.
 			 * If this means getting 0, then we were asked
 			 *	to write past the end of file.
-			 * Finally, round down to a block boundary. */
+			 * Finally, round down to a block boundary.
+			 */
 			amount = min(amount_left_to_req, FSG_BUFLEN);
-			amount = min((loff_t) amount, curlun->file_length -
-					usb_offset);
+			amount = min((loff_t)amount,
+				     curlun->file_length - usb_offset);
 			partial_page = usb_offset & (PAGE_CACHE_SIZE - 1);
 			if (partial_page > 0)
 				amount = min(amount,
-	(unsigned int) PAGE_CACHE_SIZE - partial_page);
+	(unsigned int)PAGE_CACHE_SIZE - partial_page);
 
 			if (amount == 0) {
 				get_some_more = 0;
@@ -945,11 +951,13 @@ static int do_write(struct fsg_common *common)
 				curlun->info_valid = 1;
 				continue;
 			}
-			amount -= (amount & 511);
+			amount -= amount & 511;
 			if (amount == 0) {
 
-				/* Why were we were asked to transfer a
-				 * partial block? */
+				/*
+				 * Why were we were asked to transfer a
+				 * partial block?
+				 */
 				get_some_more = 0;
 				continue;
 			}
@@ -961,14 +969,15 @@ static int do_write(struct fsg_common *common)
 			if (amount_left_to_req == 0)
 				get_some_more = 0;
 
-			/* amount is always divisible by 512, hence by
-			 * the bulk-out maxpacket size */
+			/*
+			 * amount is always divisible by 512, hence by
+			 * the bulk-out maxpacket size
+			 */
 			bh->outreq->length = amount;
 			bh->bulk_out_intended_length = amount;
 			bh->outreq->short_not_ok = 1;
 			if (!start_out_transfer(common, bh))
-				/* Don't know what to do if
-				 * common->fsg is NULL */
+				/* Dunno what to do if common->fsg is NULL */
 				return -EIO;
 			common->next_buffhd_to_fill = bh->next;
 			continue;
@@ -994,30 +1003,29 @@ static int do_write(struct fsg_common *common)
 			amount = bh->outreq->actual;
 			if (curlun->file_length - file_offset < amount) {
 				LERROR(curlun,
-	"write %u @ %llu beyond end %llu\n",
-	amount, (unsigned long long) file_offset,
-	(unsigned long long) curlun->file_length);
+				       "write %u @ %llu beyond end %llu\n",
+				       amount, (unsigned long long)file_offset,
+				       (unsigned long long)curlun->file_length);
 				amount = curlun->file_length - file_offset;
 			}
 
 			/* Perform the write */
 			file_offset_tmp = file_offset;
 			nwritten = vfs_write(curlun->filp,
-					(char __user *) bh->buf,
-					amount, &file_offset_tmp);
+					     (char __user *)bh->buf,
+					     amount, &file_offset_tmp);
 			VLDBG(curlun, "file write %u @ %llu -> %d\n", amount,
-					(unsigned long long) file_offset,
-					(int) nwritten);
+			      (unsigned long long)file_offset, (int)nwritten);
 			if (signal_pending(current))
 				return -EINTR;		/* Interrupted! */
 
 			if (nwritten < 0) {
 				LDBG(curlun, "error in file write: %d\n",
-						(int) nwritten);
+				     (int)nwritten);
 				nwritten = 0;
 			} else if (nwritten < amount) {
 				LDBG(curlun, "partial file write: %d/%u\n",
-						(int) nwritten, amount);
+				     (int)nwritten, amount);
 				nwritten -= (nwritten & 511);
 				/* Round down to a block */
 			}
@@ -1090,16 +1098,20 @@ static int do_verify(struct fsg_common *common)
 	unsigned int		amount;
 	ssize_t			nread;
 
-	/* Get the starting Logical Block Address and check that it's
-	 * not too big */
+	/*
+	 * Get the starting Logical Block Address and check that it's
+	 * not too big.
+	 */
 	lba = get_unaligned_be32(&common->cmnd[2]);
 	if (lba >= curlun->num_sectors) {
 		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
 		return -EINVAL;
 	}
 
-	/* We allow DPO (Disable Page Out = don't save data in the
-	 * cache) but we don't implement it. */
+	/*
+	 * We allow DPO (Disable Page Out = don't save data in the
+	 * cache) but we don't implement it.
+	 */
 	if (common->cmnd[1] & ~0x10) {
 		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 		return -EINVAL;
@@ -1124,16 +1136,17 @@ static int do_verify(struct fsg_common *common)
 
 	/* Just try to read the requested blocks */
 	while (amount_left > 0) {
-
-		/* Figure out how much we need to read:
+		/*
+		 * Figure out how much we need to read:
 		 * Try to read the remaining amount, but not more than
 		 * the buffer size.
 		 * And don't try to read past the end of the file.
 		 * If this means reading 0 then we were asked to read
-		 * past the end of file. */
+		 * past the end of file.
+		 */
 		amount = min(amount_left, FSG_BUFLEN);
-		amount = min((loff_t) amount,
-				curlun->file_length - file_offset);
+		amount = min((loff_t)amount,
+			     curlun->file_length - file_offset);
 		if (amount == 0) {
 			curlun->sense_data =
 					SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
@@ -1154,13 +1167,12 @@ static int do_verify(struct fsg_common *common)
 			return -EINTR;
 
 		if (nread < 0) {
-			LDBG(curlun, "error in file verify: %d\n",
-					(int) nread);
+			LDBG(curlun, "error in file verify: %d\n", (int)nread);
 			nread = 0;
 		} else if (nread < amount) {
 			LDBG(curlun, "partial file verify: %d/%u\n",
-					(int) nread, amount);
-			nread -= (nread & 511);	/* Round down to a sector */
+			     (int)nread, amount);
+			nread -= nread & 511;	/* Round down to a sector */
 		}
 		if (nread == 0) {
 			curlun->sense_data = SS_UNRECOVERED_READ_ERROR;
@@ -1202,7 +1214,6 @@ static int do_inquiry(struct fsg_common *common, struct fsg_buffhd *bh)
 	return 36;
 }
 
-
 static int do_request_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 {
 	struct fsg_lun	*curlun = common->curlun;
@@ -1256,13 +1267,12 @@ static int do_request_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 	return 18;
 }
 
-
 static int do_read_capacity(struct fsg_common *common, struct fsg_buffhd *bh)
 {
 	struct fsg_lun	*curlun = common->curlun;
 	u32		lba = get_unaligned_be32(&common->cmnd[2]);
 	int		pmi = common->cmnd[8];
-	u8		*buf = (u8 *) bh->buf;
+	u8		*buf = (u8 *)bh->buf;
 
 	/* Check the PMI and LBA fields */
 	if (pmi > 1 || (pmi == 0 && lba != 0)) {
@@ -1276,13 +1286,12 @@ static int do_read_capacity(struct fsg_common *common, struct fsg_buffhd *bh)
 	return 8;
 }
 
-
 static int do_read_header(struct fsg_common *common, struct fsg_buffhd *bh)
 {
 	struct fsg_lun	*curlun = common->curlun;
 	int		msf = common->cmnd[1] & 0x02;
 	u32		lba = get_unaligned_be32(&common->cmnd[2]);
-	u8		*buf = (u8 *) bh->buf;
+	u8		*buf = (u8 *)bh->buf;
 
 	if (common->cmnd[1] & ~0x02) {		/* Mask away MSF */
 		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
@@ -1299,13 +1308,12 @@ static int do_read_header(struct fsg_common *common, struct fsg_buffhd *bh)
 	return 8;
 }
 
-
 static int do_read_toc(struct fsg_common *common, struct fsg_buffhd *bh)
 {
 	struct fsg_lun	*curlun = common->curlun;
 	int		msf = common->cmnd[1] & 0x02;
 	int		start_track = common->cmnd[6];
-	u8		*buf = (u8 *) bh->buf;
+	u8		*buf = (u8 *)bh->buf;
 
 	if ((common->cmnd[1] & ~0x02) != 0 ||	/* Mask away MSF */
 			start_track > 1) {
@@ -1327,7 +1335,6 @@ static int do_read_toc(struct fsg_common *common, struct fsg_buffhd *bh)
 	return 20;
 }
 
-
 static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 {
 	struct fsg_lun	*curlun = common->curlun;
@@ -1352,10 +1359,12 @@ static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 	changeable_values = (pc == 1);
 	all_pages = (page_code == 0x3f);
 
-	/* Write the mode parameter header.  Fixed values are: default
+	/*
+	 * Write the mode parameter header.  Fixed values are: default
 	 * medium type, no cache control (DPOFUA), and no block descriptors.
 	 * The only variable value is the WriteProtect bit.  We will fill in
-	 * the mode data length later. */
+	 * the mode data length later.
+	 */
 	memset(buf, 0, 8);
 	if (mscmnd == MODE_SENSE) {
 		buf[2] = (curlun->ro ? 0x80 : 0x00);		/* WP, DPOFUA */
@@ -1369,8 +1378,10 @@ static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 
 	/* No block descriptors */
 
-	/* The mode pages, in numerical order.  The only page we support
-	 * is the Caching page. */
+	/*
+	 * The mode pages, in numerical order.  The only page we support
+	 * is the Caching page.
+	 */
 	if (page_code == 0x08 || all_pages) {
 		valid_page = 1;
 		buf[0] = 0x08;		/* Page code */
@@ -1392,8 +1403,10 @@ static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 		buf += 12;
 	}
 
-	/* Check that a valid page was requested and the mode data length
-	 * isn't too long. */
+	/*
+	 * Check that a valid page was requested and the mode data length
+	 * isn't too long.
+	 */
 	len = buf - buf0;
 	if (!valid_page || len > limit) {
 		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
@@ -1408,7 +1421,6 @@ static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 	return len;
 }
 
-
 static int do_start_stop(struct fsg_common *common)
 {
 	struct fsg_lun	*curlun = common->curlun;
@@ -1428,8 +1440,10 @@ static int do_start_stop(struct fsg_common *common)
 	loej  = common->cmnd[4] & 0x02;
 	start = common->cmnd[4] & 0x01;
 
-	/* Our emulation doesn't support mounting; the medium is
-	 * available for use as soon as it is loaded. */
+	/*
+	 * Our emulation doesn't support mounting; the medium is
+	 * available for use as soon as it is loaded.
+	 */
 	if (start) {
 		if (!fsg_lun_is_open(curlun)) {
 			curlun->sense_data = SS_MEDIUM_NOT_PRESENT;
@@ -1470,7 +1484,6 @@ static int do_start_stop(struct fsg_common *common)
 		: 0;
 }
 
-
 static int do_prevent_allow(struct fsg_common *common)
 {
 	struct fsg_lun	*curlun = common->curlun;
@@ -1495,7 +1508,6 @@ static int do_prevent_allow(struct fsg_common *common)
 	return 0;
 }
 
-
 static int do_read_format_capacities(struct fsg_common *common,
 			struct fsg_buffhd *bh)
 {
@@ -1513,7 +1525,6 @@ static int do_read_format_capacities(struct fsg_common *common,
 	return 12;
 }
 
-
 static int do_mode_select(struct fsg_common *common, struct fsg_buffhd *bh)
 {
 	struct fsg_lun	*curlun = common->curlun;
@@ -1595,7 +1606,7 @@ static int pad_with_zeros(struct fsg_dev *fsg)
 		bh->inreq->length = nsend;
 		bh->inreq->zero = 0;
 		start_transfer(fsg, fsg->bulk_in, bh->inreq,
-				&bh->inreq_busy, &bh->state);
+			       &bh->inreq_busy, &bh->state);
 		bh = fsg->common->next_buffhd_to_fill = bh->next;
 		fsg->common->usb_amount_left -= nsend;
 		nkeep = 0;
@@ -1621,7 +1632,7 @@ static int throw_away_data(struct fsg_common *common)
 
 			/* A short packet or an error ends everything */
 			if (bh->outreq->actual != bh->outreq->length ||
-					bh->outreq->status != 0) {
+			    bh->outreq->status != 0) {
 				raise_exception(common,
 						FSG_STATE_ABORT_BULK_OUT);
 				return -EINTR;
@@ -1635,14 +1646,15 @@ static int throw_away_data(struct fsg_common *common)
 		 && common->usb_amount_left > 0) {
 			amount = min(common->usb_amount_left, FSG_BUFLEN);
 
-			/* amount is always divisible by 512, hence by
-			 * the bulk-out maxpacket size */
+			/*
+			 * amount is always divisible by 512, hence by
+			 * the bulk-out maxpacket size.
+			 */
 			bh->outreq->length = amount;
 			bh->bulk_out_intended_length = amount;
 			bh->outreq->short_not_ok = 1;
 			if (!start_out_transfer(common, bh))
-				/* Don't know what to do if
-				 * common->fsg is NULL */
+				/* Dunno what to do if common->fsg is NULL */
 				return -EIO;
 			common->next_buffhd_to_fill = bh->next;
 			common->usb_amount_left -= amount;
@@ -1657,7 +1669,6 @@ static int throw_away_data(struct fsg_common *common)
 	return 0;
 }
 
-
 static int finish_reply(struct fsg_common *common)
 {
 	struct fsg_buffhd	*bh = common->next_buffhd_to_fill;
@@ -1667,10 +1678,12 @@ static int finish_reply(struct fsg_common *common)
 	case DATA_DIR_NONE:
 		break;			/* Nothing to send */
 
-	/* If we don't know whether the host wants to read or write,
+	/*
+	 * If we don't know whether the host wants to read or write,
 	 * this must be CB or CBI with an unknown command.  We mustn't
 	 * try to send or receive any data.  So stall both bulk pipes
-	 * if we can and wait for a reset. */
+	 * if we can and wait for a reset.
+	 */
 	case DATA_DIR_UNKNOWN:
 		if (!common->can_stall) {
 			/* Nothing */
@@ -1695,9 +1708,11 @@ static int finish_reply(struct fsg_common *common)
 				return -EIO;
 			common->next_buffhd_to_fill = bh->next;
 
-		/* For Bulk-only, if we're allowed to stall then send the
+		/*
+		 * For Bulk-only, if we're allowed to stall then send the
 		 * short packet and halt the bulk-in endpoint.  If we can't
-		 * stall, pad out the remaining data with 0's. */
+		 * stall, pad out the remaining data with 0's.
+		 */
 		} else if (common->can_stall) {
 			bh->inreq->zero = 1;
 			if (!start_in_transfer(common, bh))
@@ -1715,8 +1730,10 @@ static int finish_reply(struct fsg_common *common)
 		}
 		break;
 
-	/* We have processed all we want from the data the host has sent.
-	 * There may still be outstanding bulk-out requests. */
+	/*
+	 * We have processed all we want from the data the host has sent.
+	 * There may still be outstanding bulk-out requests.
+	 */
 	case DATA_DIR_FROM_HOST:
 		if (common->residue == 0) {
 			/* Nothing to receive */
@@ -1726,12 +1743,14 @@ static int finish_reply(struct fsg_common *common)
 			raise_exception(common, FSG_STATE_ABORT_BULK_OUT);
 			rc = -EINTR;
 
-		/* We haven't processed all the incoming data.  Even though
+		/*
+		 * We haven't processed all the incoming data.  Even though
 		 * we may be allowed to stall, doing so would cause a race.
 		 * The controller may already have ACK'ed all the remaining
 		 * bulk-out packets, in which case the host wouldn't see a
 		 * STALL.  Not realizing the endpoint was halted, it wouldn't
-		 * clear the halt -- leading to problems later on. */
+		 * clear the halt -- leading to problems later on.
+		 */
 #if 0
 		} else if (common->can_stall) {
 			if (fsg_is_set(common))
@@ -1741,8 +1760,10 @@ static int finish_reply(struct fsg_common *common)
 			rc = -EINTR;
 #endif
 
-		/* We can't stall.  Read in the excess data and throw it
-		 * all away. */
+		/*
+		 * We can't stall.  Read in the excess data and throw it
+		 * all away.
+		 */
 		} else {
 			rc = throw_away_data(common);
 		}
@@ -1751,7 +1772,6 @@ static int finish_reply(struct fsg_common *common)
 	return rc;
 }
 
-
 static int send_status(struct fsg_common *common)
 {
 	struct fsg_lun		*curlun = common->curlun;
@@ -1810,11 +1830,13 @@ static int send_status(struct fsg_common *common)
 
 /*-------------------------------------------------------------------------*/
 
-/* Check whether the command is properly formed and whether its data size
- * and direction agree with the values we already have. */
+/*
+ * Check whether the command is properly formed and whether its data size
+ * and direction agree with the values we already have.
+ */
 static int check_command(struct fsg_common *common, int cmnd_size,
-		enum data_direction data_dir, unsigned int mask,
-		int needs_medium, const char *name)
+			 enum data_direction data_dir, unsigned int mask,
+			 int needs_medium, const char *name)
 {
 	int			i;
 	int			lun = common->cmnd[1] >> 5;
@@ -1825,19 +1847,23 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 	hdlen[0] = 0;
 	if (common->data_dir != DATA_DIR_UNKNOWN)
 		sprintf(hdlen, ", H%c=%u", dirletter[(int) common->data_dir],
-				common->data_size);
+			common->data_size);
 	VDBG(common, "SCSI command: %s;  Dc=%d, D%c=%u;  Hc=%d%s\n",
 	     name, cmnd_size, dirletter[(int) data_dir],
 	     common->data_size_from_cmnd, common->cmnd_size, hdlen);
 
-	/* We can't reply at all until we know the correct data direction
-	 * and size. */
+	/*
+	 * We can't reply at all until we know the correct data direction
+	 * and size.
+	 */
 	if (common->data_size_from_cmnd == 0)
 		data_dir = DATA_DIR_NONE;
 	if (common->data_size < common->data_size_from_cmnd) {
-		/* Host data size < Device data size is a phase error.
+		/*
+		 * Host data size < Device data size is a phase error.
 		 * Carry out the command, but only transfer as much as
-		 * we are allowed. */
+		 * we are allowed.
+		 */
 		common->data_size_from_cmnd = common->data_size;
 		common->phase_error = 1;
 	}
@@ -1845,8 +1871,7 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 	common->usb_amount_left = common->data_size;
 
 	/* Conflicting data directions is a phase error */
-	if (common->data_dir != data_dir
-	 && common->data_size_from_cmnd > 0) {
+	if (common->data_dir != data_dir && common->data_size_from_cmnd > 0) {
 		common->phase_error = 1;
 		return -EINVAL;
 	}
@@ -1854,7 +1879,8 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 	/* Verify the length of the command itself */
 	if (cmnd_size != common->cmnd_size) {
 
-		/* Special case workaround: There are plenty of buggy SCSI
+		/*
+		 * Special case workaround: There are plenty of buggy SCSI
 		 * implementations. Many have issues with cbw->Length
 		 * field passing a wrong command size. For those cases we
 		 * always try to work around the problem by using the length
@@ -1896,8 +1922,10 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 		curlun = NULL;
 		common->bad_lun_okay = 0;
 
-		/* INQUIRY and REQUEST SENSE commands are explicitly allowed
-		 * to use unsupported LUNs; all others may not. */
+		/*
+		 * INQUIRY and REQUEST SENSE commands are explicitly allowed
+		 * to use unsupported LUNs; all others may not.
+		 */
 		if (common->cmnd[0] != INQUIRY &&
 		    common->cmnd[0] != REQUEST_SENSE) {
 			DBG(common, "unsupported LUN %d\n", common->lun);
@@ -1905,11 +1933,13 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 		}
 	}
 
-	/* If a unit attention condition exists, only INQUIRY and
-	 * REQUEST SENSE commands are allowed; anything else must fail. */
+	/*
+	 * If a unit attention condition exists, only INQUIRY and
+	 * REQUEST SENSE commands are allowed; anything else must fail.
+	 */
 	if (curlun && curlun->unit_attention_data != SS_NO_SENSE &&
-			common->cmnd[0] != INQUIRY &&
-			common->cmnd[0] != REQUEST_SENSE) {
+	    common->cmnd[0] != INQUIRY &&
+	    common->cmnd[0] != REQUEST_SENSE) {
 		curlun->sense_data = curlun->unit_attention_data;
 		curlun->unit_attention_data = SS_NO_SENSE;
 		return -EINVAL;
@@ -1935,7 +1965,6 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 	return 0;
 }
 
-
 static int do_scsi_command(struct fsg_common *common)
 {
 	struct fsg_buffhd	*bh;
@@ -2123,8 +2152,10 @@ static int do_scsi_command(struct fsg_common *common)
 				"TEST UNIT READY");
 		break;
 
-	/* Although optional, this command is used by MS-Windows.  We
-	 * support a minimal version: BytChk must be 0. */
+	/*
+	 * Although optional, this command is used by MS-Windows.  We
+	 * support a minimal version: BytChk must be 0.
+	 */
 	case VERIFY:
 		common->data_size_from_cmnd = 0;
 		reply = check_command(common, 10, DATA_DIR_NONE,
@@ -2164,10 +2195,12 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_write(common);
 		break;
 
-	/* Some mandatory commands that we recognize but don't implement.
+	/*
+	 * Some mandatory commands that we recognize but don't implement.
 	 * They don't mean much in this setting.  It's left as an exercise
 	 * for anyone interested to implement RESERVE and RELEASE in terms
-	 * of Posix locks. */
+	 * of Posix locks.
+	 */
 	case FORMAT_UNIT:
 	case RELEASE:
 	case RESERVE:
@@ -2195,7 +2228,7 @@ unknown_cmnd:
 	if (reply == -EINVAL)
 		reply = 0;		/* Error reply length */
 	if (reply >= 0 && common->data_dir == DATA_DIR_TO_HOST) {
-		reply = min((u32) reply, common->data_size_from_cmnd);
+		reply = min((u32)reply, common->data_size_from_cmnd);
 		bh->inreq->length = reply;
 		bh->state = BUF_STATE_FULL;
 		common->residue -= reply;
@@ -2225,7 +2258,8 @@ static int received_cbw(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 				req->actual,
 				le32_to_cpu(cbw->Signature));
 
-		/* The Bulk-only spec says we MUST stall the IN endpoint
+		/*
+		 * The Bulk-only spec says we MUST stall the IN endpoint
 		 * (6.6.1), so it's unavoidable.  It also says we must
 		 * retain this state until the next reset, but there's
 		 * no way to tell the controller driver it should ignore
@@ -2233,7 +2267,8 @@ static int received_cbw(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 		 *
 		 * We aren't required to halt the OUT endpoint; instead
 		 * we can simply accept and discard any data received
-		 * until the next reset. */
+		 * until the next reset.
+		 */
 		wedge_bulk_in_endpoint(fsg);
 		set_bit(IGNORE_BULK_OUT, &fsg->atomic_bitflags);
 		return -EINVAL;
@@ -2246,8 +2281,10 @@ static int received_cbw(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 				"cmdlen %u\n",
 				cbw->Lun, cbw->Flags, cbw->Length);
 
-		/* We can do anything we want here, so let's stall the
-		 * bulk pipes if we are allowed to. */
+		/*
+		 * We can do anything we want here, so let's stall the
+		 * bulk pipes if we are allowed to.
+		 */
 		if (common->can_stall) {
 			fsg_set_halt(fsg, fsg->bulk_out);
 			halt_bulk_in_endpoint(fsg);
@@ -2270,7 +2307,6 @@ static int received_cbw(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	return 0;
 }
 
-
 static int get_next_command(struct fsg_common *common)
 {
 	struct fsg_buffhd	*bh;
@@ -2291,9 +2327,11 @@ static int get_next_command(struct fsg_common *common)
 		/* Don't know what to do if common->fsg is NULL */
 		return -EIO;
 
-	/* We will drain the buffer in software, which means we
+	/*
+	 * We will drain the buffer in software, which means we
 	 * can reuse it for the next filling.  No need to advance
-	 * next_buffhd_to_fill. */
+	 * next_buffhd_to_fill.
+	 */
 
 	/* Wait for the CBW to arrive */
 	while (bh->state != BUF_STATE_FULL) {
@@ -2424,7 +2462,6 @@ reset:
 
 /****************************** ALT CONFIGS ******************************/
 
-
 static int fsg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 {
 	struct fsg_dev *fsg = fsg_from_func(f);
@@ -2452,8 +2489,10 @@ static void handle_exception(struct fsg_common *common)
 	struct fsg_lun		*curlun;
 	unsigned int		exception_req_tag;
 
-	/* Clear the existing signals.  Anything but SIGUSR1 is converted
-	 * into a high-priority EXIT exception. */
+	/*
+	 * Clear the existing signals.  Anything but SIGUSR1 is converted
+	 * into a high-priority EXIT exception.
+	 */
 	for (;;) {
 		int sig =
 			dequeue_signal_lock(current, &current->blocked, &info);
@@ -2497,8 +2536,10 @@ static void handle_exception(struct fsg_common *common)
 			usb_ep_fifo_flush(common->fsg->bulk_out);
 	}
 
-	/* Reset the I/O buffer states and pointers, the SCSI
-	 * state, and the exception.  Then invoke the handler. */
+	/*
+	 * Reset the I/O buffer states and pointers, the SCSI
+	 * state, and the exception.  Then invoke the handler.
+	 */
 	spin_lock_irq(&common->lock);
 
 	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
@@ -2536,9 +2577,11 @@ static void handle_exception(struct fsg_common *common)
 		break;
 
 	case FSG_STATE_RESET:
-		/* In case we were forced against our will to halt a
+		/*
+		 * In case we were forced against our will to halt a
 		 * bulk endpoint, clear the halt now.  (The SuperH UDC
-		 * requires this.) */
+		 * requires this.)
+		 */
 		if (!fsg_is_set(common))
 			break;
 		if (test_and_clear_bit(IGNORE_BULK_OUT,
@@ -2548,9 +2591,11 @@ static void handle_exception(struct fsg_common *common)
 		if (common->ep0_req_tag == exception_req_tag)
 			ep0_queue(common);	/* Complete the status stage */
 
-		/* Technically this should go here, but it would only be
+		/*
+		 * Technically this should go here, but it would only be
 		 * a waste of time.  Ditto for the INTERFACE_CHANGE and
-		 * CONFIG_CHANGE cases. */
+		 * CONFIG_CHANGE cases.
+		 */
 		/* for (i = 0; i < common->nluns; ++i) */
 		/*	common->luns[i].unit_attention_data = */
 		/*		SS_RESET_OCCURRED;  */
@@ -2585,8 +2630,10 @@ static int fsg_main_thread(void *common_)
 {
 	struct fsg_common	*common = common_;
 
-	/* Allow the thread to be killed by a signal, but set the signal mask
-	 * to block everything but INT, TERM, KILL, and USR1. */
+	/*
+	 * Allow the thread to be killed by a signal, but set the signal mask
+	 * to block everything but INT, TERM, KILL, and USR1.
+	 */
 	allow_signal(SIGINT);
 	allow_signal(SIGTERM);
 	allow_signal(SIGKILL);
@@ -2595,9 +2642,11 @@ static int fsg_main_thread(void *common_)
 	/* Allow the thread to be frozen */
 	set_freezable();
 
-	/* Arrange for userspace references to be interpreted as kernel
+	/*
+	 * Arrange for userspace references to be interpreted as kernel
 	 * pointers.  That way we can pass a kernel pointer to a routine
-	 * that expects a __user pointer and it will work okay. */
+	 * that expects a __user pointer and it will work okay.
+	 */
 	set_fs(get_ds());
 
 	/* The main loop */
@@ -2689,7 +2738,6 @@ static inline void fsg_common_put(struct fsg_common *common)
 	kref_put(&common->ref, fsg_common_release);
 }
 
-
 static struct fsg_common *fsg_common_init(struct fsg_common *common,
 					  struct usb_composite_dev *cdev,
 					  struct fsg_config *cfg)
@@ -2735,8 +2783,10 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		fsg_intf_desc.iInterface = rc;
 	}
 
-	/* Create the LUNs, open their backing files, and register the
-	 * LUN devices in sysfs. */
+	/*
+	 * Create the LUNs, open their backing files, and register the
+	 * LUN devices in sysfs.
+	 */
 	curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
 	if (unlikely(!curlun)) {
 		rc = -ENOMEM;
@@ -2790,7 +2840,6 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	}
 	common->nluns = nluns;
 
-
 	/* Data buffers cyclic list */
 	bh = common->buffhds;
 	i = FSG_NUM_BUFFERS;
@@ -2807,7 +2856,6 @@ buffhds_first_it:
 	} while (--i);
 	bh->next = common->buffhds;
 
-
 	/* Prepare inquiryString */
 	if (cfg->release != 0xffff) {
 		i = cfg->release;
@@ -2829,19 +2877,17 @@ buffhds_first_it:
 				     : "File-CD Gadget"),
 		 i);
 
-
-	/* Some peripheral controllers are known not to be able to
+	/*
+	 * Some peripheral controllers are known not to be able to
 	 * halt bulk endpoints correctly.  If one of them is present,
 	 * disable stalls.
 	 */
 	common->can_stall = cfg->can_stall &&
 		!(gadget_is_at91(common->gadget));
 
-
 	spin_lock_init(&common->lock);
 	kref_init(&common->ref);
 
-
 	/* Tell the thread to start working */
 	common->thread_task =
 		kthread_create(fsg_main_thread, common,
@@ -2853,7 +2899,6 @@ buffhds_first_it:
 	init_completion(&common->thread_notifier);
 	init_waitqueue_head(&common->fsg_wait);
 
-
 	/* Information */
 	INFO(common, FSG_DRIVER_DESC ", version: " FSG_DRIVER_VERSION "\n");
 	INFO(common, "Number of LUNs=%d\n", common->nluns);
@@ -2886,18 +2931,15 @@ buffhds_first_it:
 
 	return common;
 
-
 error_luns:
 	common->nluns = i + 1;
 error_release:
 	common->state = FSG_STATE_TERMINATED;	/* The thread is dead */
-	/* Call fsg_common_release() directly, ref might be not
-	 * initialised */
+	/* Call fsg_common_release() directly, ref might be not initialised. */
 	fsg_common_release(&common->ref);
 	return ERR_PTR(rc);
 }
 
-
 static void fsg_common_release(struct kref *ref)
 {
 	struct fsg_common *common = container_of(ref, struct fsg_common, ref);
@@ -2939,7 +2981,6 @@ static void fsg_common_release(struct kref *ref)
 
 /*-------------------------------------------------------------------------*/
 
-
 static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct fsg_dev		*fsg = fsg_from_func(f);
@@ -2959,7 +3000,6 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 	kfree(fsg);
 }
 
-
 static int fsg_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct fsg_dev		*fsg = fsg_from_func(f);
@@ -3042,11 +3082,13 @@ static int fsg_bind_config(struct usb_composite_dev *cdev,
 	fsg->function.disable     = fsg_disable;
 
 	fsg->common               = common;
-	/* Our caller holds a reference to common structure so we
+	/*
+	 * Our caller holds a reference to common structure so we
 	 * don't have to be worry about it being freed until we return
 	 * from this function.  So instead of incrementing counter now
 	 * and decrement in error recovery we increment it only when
-	 * call to usb_add_function() was successful. */
+	 * call to usb_add_function() was successful.
+	 */
 
 	rc = usb_add_function(c, &fsg->function);
 	if (unlikely(rc))
@@ -3057,8 +3099,7 @@ static int fsg_bind_config(struct usb_composite_dev *cdev,
 }
 
 static inline int __deprecated __maybe_unused
-fsg_add(struct usb_composite_dev *cdev,
-	struct usb_configuration *c,
+fsg_add(struct usb_composite_dev *cdev, struct usb_configuration *c,
 	struct fsg_common *common)
 {
 	return fsg_bind_config(cdev, c, common);
@@ -3067,7 +3108,6 @@ fsg_add(struct usb_composite_dev *cdev,
 
 /************************* Module parameters *************************/
 
-
 struct fsg_module_parameters {
 	char		*file[FSG_MAX_LUNS];
 	int		ro[FSG_MAX_LUNS];
@@ -3081,7 +3121,6 @@ struct fsg_module_parameters {
 	int		stall;	/* can_stall */
 };
 
-
 #define _FSG_MODULE_PARAM_ARRAY(prefix, params, name, type, desc)	\
 	module_param_array_named(prefix ## name, params.name, type,	\
 				 &prefix ## params.name ## _count,	\
@@ -3109,7 +3148,6 @@ struct fsg_module_parameters {
 	_FSG_MODULE_PARAM(prefix, params, stall, bool,			\
 			  "false to prevent bulk stalls")
 
-
 static void
 fsg_config_from_params(struct fsg_config *cfg,
 		       const struct fsg_module_parameters *params)
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 0769179..0182242 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -102,7 +102,7 @@ static struct fsg_module_parameters mod_data = {
 };
 FSG_MODULE_PARAMETERS(/* no prefix */, mod_data);
 
-static unsigned long msg_registered = 0;
+static unsigned long msg_registered;
 static void msg_cleanup(void);
 
 static int msg_thread_exits(struct fsg_common *common)
-- 
1.7.1

