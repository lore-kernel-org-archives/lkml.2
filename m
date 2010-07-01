Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0GAJRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:17:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51113 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0GAJRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:17:10 -0400
Date: Thu, 01 Jul 2010 11:17:47 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: storage_common: comments updated
To: linux-usb@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Message-id: <35e07b59ee0738c2019d2b81958890a472941a0e.1277902597.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated comment to describe why printing macros are needed even
thought they are copied form the composite.h.  Also, made multiline
comments follow the coding standard.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
The macros made me, the creator of the storage_common.c, wonder if they
are required and if so what for so if I had doubts clarifying them may
be especially valuable for others.

At the same time, it's purely a comment and formatting update so I
dunno if it's worth including in the kernel.

 drivers/usb/gadget/storage_common.c |   60 ++++++++++++++++++++++++-----------
 1 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 04c462f..557b119 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -84,14 +84,23 @@
 #define LWARN(lun, fmt, args...)  dev_warn(&(lun)->dev, fmt, ## args)
 #define LINFO(lun, fmt, args...)  dev_info(&(lun)->dev, fmt, ## args)
 
-/* Keep those macros in sync with thos in
- * include/linux/ubs/composite.h or else GCC will complain.  If they
+/*
+ * Keep those macros in sync with thos in
+ * include/linux/usb/composite.h or else GCC will complain.  If they
  * are identical (the same names of arguments, white spaces in the
  * same places) GCC will allow redefinition otherwise (even if some
- * white space is removed or added) warning will be issued.  No
- * checking if those symbols is defined is performed because warning
- * is desired when those macros were defined by someone else to mean
- * something else. */
+ * white space is removed or added) warning will be issued.
+ *
+ * Those macros are needed here because File Storage Gadget does not
+ * include the composite.h header.  For composite gadgets those macros
+ * are redundant since composite.h is included any way.
+ *
+ * No checking if those symbols is defined is performed because
+ * warning is desired when those macros were defined to mean something
+ * else.  In particular, we want those macros do the same thing in
+ * File Storage Gadget and Mass Storage Function (and composite
+ * gadgets using MSF).
+ */
 #define DBG(d, fmt, args...)     dev_dbg(&(d)->gadget->dev , fmt , ## args)
 #define VDBG(d, fmt, args...)    dev_vdbg(&(d)->gadget->dev , fmt , ## args)
 #define ERROR(d, fmt, args...)   dev_err(&(d)->gadget->dev , fmt , ## args)
@@ -313,9 +322,12 @@ struct fsg_buffhd {
 	enum fsg_buffer_state		state;
 	struct fsg_buffhd		*next;
 
-	/* The NetChip 2280 is faster, and handles some protocol faults
-	 * better, if we don't submit any short bulk-out read requests.
-	 * So we will record the intended request length here. */
+	/*
+	 * The NetChip 2280 is faster, and handles some protocol
+	 * faults better, if we don't submit any short bulk-out read
+	 * requests.  So we will record the intended request length
+	 * here.
+	 */
 	unsigned int			bulk_out_intended_length;
 
 	struct usb_request		*inreq;
@@ -395,8 +407,10 @@ fsg_intf_desc = {
 	.iInterface =		FSG_STRING_INTERFACE,
 };
 
-/* Three full-speed endpoint descriptors: bulk-in, bulk-out,
- * and interrupt-in. */
+/*
+ * Three full-speed endpoint descriptors: bulk-in, bulk-out, and
+ * interrupt-in.
+ */
 
 static struct usb_endpoint_descriptor
 fsg_fs_bulk_in_desc = {
@@ -547,8 +561,10 @@ static struct usb_gadget_strings	fsg_stringtab = {
 
  /*-------------------------------------------------------------------------*/
 
-/* If the next two routines are called while the gadget is registered,
- * the caller must own fsg->filesem for writing. */
+/*
+ * If the next two routines are called while the gadget is registered,
+ * the caller must own fsg->filesem for writing.
+ */
 
 static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 {
@@ -587,8 +603,10 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 		goto out;
 	}
 
-	/* If we can't read the file, it's no good.
-	 * If we can't write the file, use it read-only. */
+	/*
+	 * If we can't read the file, it's no good.
+	 * If we can't write the file, use it read-only.
+	 */
 	if (!filp->f_op || !(filp->f_op->read || filp->f_op->aio_read)) {
 		LINFO(curlun, "file not readable: %s\n", filename);
 		goto out;
@@ -646,8 +664,10 @@ static void fsg_lun_close(struct fsg_lun *curlun)
 
 /*-------------------------------------------------------------------------*/
 
-/* Sync the file data, don't bother with the metadata.
- * This code was copied from fs/buffer.c:sys_fdatasync(). */
+/*
+ * Sync the file data, don't bother with the metadata.
+ * This code was copied from fs/buffer.c:sys_fdatasync().
+ */
 static int fsg_lun_fsync_sub(struct fsg_lun *curlun)
 {
 	struct file	*filp = curlun->filp;
@@ -728,8 +748,10 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 	if (sscanf(buf, "%d", &i) != 1)
 		return -EINVAL;
 
-	/* Allow the write-enable status to change only while the backing file
-	 * is closed. */
+	/*
+	 * Allow the write-enable status to change only while the
+	 * backing file is closed.
+	 */
 	down_read(filesem);
 	if (fsg_lun_is_open(curlun)) {
 		LDBG(curlun, "read-only status change prevented\n");
-- 
1.7.1

