Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab1ERKmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:42:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34082 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab1ERKmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=w6t+KqDaz5opNqTit5tKpXhQ0fMheXM8iDeZ1a37qPDKva3Cr4+1JnsFXIprp3Xtjo
         6Xs9F9HrN8f/cipf8r2ZJ7hVVRtYAdI4KEEQnxp8z/ZhfD61iXFNonkpIFgsHEpWlNDl
         Fgjd2URl7tENV1xd9jdAid4RmSqDKBqwHAb9k=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, jj@chaosbits.net, imirkin@alum.mit.edu,
        devel@driverdev.osuosl.org, jlee@novell.com, acho@novell.com
Subject: [PATCH 3/7] staging/keucr: fix keucr scsiglue coding style
Date: Wed, 18 May 2011 18:40:11 +0800
Message-Id: <3f9936663e3686f9002bcf4eca256a22727873fe.1305714525.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix keucr scsiglue.c coding style

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/scsiglue.c |  157 ++++++++++++++++++++++---------------
 1 files changed, 93 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
index 5e35d94..135f7f2 100644
--- a/drivers/staging/keucr/scsiglue.c
+++ b/drivers/staging/keucr/scsiglue.c
@@ -15,14 +15,18 @@
 #include "transport.h"
 
 /* Host functions */
-//----- host_info() ---------------------
-static const char* host_info(struct Scsi_Host *host)
+/*
+ * host_info()
+ */
+static const char *host_info(struct Scsi_Host *host)
 {
 	/* pr_info("scsiglue --- host_info\n"); */
 	return "SCSI emulation for USB Mass Storage devices";
 }
 
-//----- slave_alloc() ---------------------
+/*
+ * slave_alloc()
+ */
 static int slave_alloc(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
@@ -38,14 +42,15 @@ static int slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-//----- slave_configure() ---------------------
+/*
+ * slave_configure()
+ */
 static int slave_configure(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
 
 	/* pr_info("scsiglue --- slave_configure\n"); */
-	if (us->fflags & (US_FL_MAX_SECTORS_64 | US_FL_MAX_SECTORS_MIN))
-	{
+	if (us->fflags & (US_FL_MAX_SECTORS_64 | US_FL_MAX_SECTORS_MIN)) {
 		unsigned int max_sectors = 64;
 
 		if (us->fflags & US_FL_MAX_SECTORS_MIN)
@@ -55,9 +60,9 @@ static int slave_configure(struct scsi_device *sdev)
 					      max_sectors);
 	}
 
-	if (sdev->type == TYPE_DISK)
-	{
-		if (us->subclass != USB_SC_SCSI && us->subclass != USB_SC_CYP_ATACB)
+	if (sdev->type == TYPE_DISK) {
+		if (us->subclass != USB_SC_SCSI &&
+			us->subclass != USB_SC_CYP_ATACB)
 			sdev->use_10_for_ms = 1;
 		sdev->use_192_bytes_for_3f = 1;
 		if (us->fflags & US_FL_NO_WP_DETECT)
@@ -72,13 +77,12 @@ static int slave_configure(struct scsi_device *sdev)
 		sdev->retry_hwerror = 1;
 		sdev->allow_restart = 1;
 		sdev->last_sector_bug = 1;
-	}
-	else
-	{
+	} else {
 		sdev->use_10_for_ms = 1;
 	}
 
-	if ((us->protocol == USB_PR_CB || us->protocol == USB_PR_CBI) && sdev->scsi_level == SCSI_UNKNOWN)
+	if ((us->protocol == USB_PR_CB || us->protocol == USB_PR_CBI) &&
+					sdev->scsi_level == SCSI_UNKNOWN)
 		us->max_lun = 0;
 
 	if (us->fflags & US_FL_NOT_LOCKABLE)
@@ -88,24 +92,25 @@ static int slave_configure(struct scsi_device *sdev)
 }
 
 /* This is always called with scsi_lock(host) held */
-//----- queuecommand() ---------------------
-static int queuecommand_lck(struct scsi_cmnd *srb, void (*done)(struct scsi_cmnd *))
+/*
+ * queuecommand()
+ */
+static int queuecommand_lck(struct scsi_cmnd *srb,
+				void (*done)(struct scsi_cmnd *))
 {
 	struct us_data *us = host_to_us(srb->device->host);
 
 	/* pr_info("scsiglue --- queuecommand\n"); */
 
 	/* check for state-transition errors */
-	if (us->srb != NULL)
-	{
+	if (us->srb != NULL) {
 		/* pr_info("Error in %s: us->srb = %p\n"
 				 __FUNCTION__, us->srb); */
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* fail the command if we are disconnecting */
-	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
-	{
+	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
 		pr_info("Fail command during disconnect\n");
 		srb->result = DID_NO_CONNECT << 16;
 		done(srb);
@@ -127,7 +132,9 @@ static DEF_SCSI_QCMD(queuecommand)
  ***********************************************************************/
 
 /* Command timeout and abort */
-//----- command_abort() ---------------------
+/*
+ * command_abort()
+ */
 static int command_abort(struct scsi_cmnd *srb)
 {
 	struct us_data *us = host_to_us(srb->device->host);
@@ -135,16 +142,14 @@ static int command_abort(struct scsi_cmnd *srb)
 	/* pr_info("scsiglue --- command_abort\n"); */
 
 	scsi_lock(us_to_host(us));
-	if (us->srb != srb)
-	{
+	if (us->srb != srb) {
 		scsi_unlock(us_to_host(us));
 		printk ("-- nothing to abort\n");
 		return FAILED;
 	}
 
 	set_bit(US_FLIDX_TIMED_OUT, &us->dflags);
-	if (!test_bit(US_FLIDX_RESETTING, &us->dflags))
-	{
+	if (!test_bit(US_FLIDX_RESETTING, &us->dflags)) {
 		set_bit(US_FLIDX_ABORTING, &us->dflags);
 		usb_stor_stop_transport(us);
 	}
@@ -155,8 +160,12 @@ static int command_abort(struct scsi_cmnd *srb)
 	return SUCCESS;
 }
 
-/* This invokes the transport reset mechanism to reset the state of the device */
-//----- device_reset() ---------------------
+/* This invokes the transport reset mechanism to reset the state of the
+ * device.
+ */
+/*
+ * device_reset()
+ */
 static int device_reset(struct scsi_cmnd *srb)
 {
 	struct us_data *us = host_to_us(srb->device->host);
@@ -172,7 +181,9 @@ static int device_reset(struct scsi_cmnd *srb)
 	return result < 0 ? FAILED : SUCCESS;
 }
 
-//----- bus_reset() ---------------------
+/*
+ * bus_reset()
+ */
 static int bus_reset(struct scsi_cmnd *srb)
 {
 	struct us_data *us = host_to_us(srb->device->host);
@@ -183,7 +194,9 @@ static int bus_reset(struct scsi_cmnd *srb)
 	return result < 0 ? FAILED : SUCCESS;
 }
 
-//----- usb_stor_report_device_reset() ---------------------
+/*
+ * usb_stor_report_device_reset()
+ */
 void usb_stor_report_device_reset(struct us_data *us)
 {
 	int i;
@@ -191,14 +204,15 @@ void usb_stor_report_device_reset(struct us_data *us)
 
 	/* pr_info("scsiglue --- usb_stor_report_device_reset\n"); */
 	scsi_report_device_reset(host, 0, 0);
-	if (us->fflags & US_FL_SCM_MULT_TARG)
-	{
+	if (us->fflags & US_FL_SCM_MULT_TARG) {
 		for (i = 1; i < host->max_id; ++i)
 			scsi_report_device_reset(host, 0, i);
 	}
 }
 
-//----- usb_stor_report_bus_reset() ---------------------
+/*
+ * usb_stor_report_bus_reset()
+ */
 void usb_stor_report_bus_reset(struct us_data *us)
 {
 	struct Scsi_Host *host = us_to_host(us);
@@ -218,8 +232,11 @@ void usb_stor_report_bus_reset(struct us_data *us)
 #define SPRINTF(args...) \
 	do { if (pos < buffer+length) pos += sprintf(pos, ## args); } while (0)
 
-//----- proc_info() ---------------------
-static int proc_info (struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int inout)
+/*
+ * proc_info()
+ */
+static int proc_info(struct Scsi_Host *host, char *buffer, char **start,
+					off_t offset, int length, int inout)
 {
 	struct us_data *us = host_to_us(host);
 	char *pos = buffer;
@@ -258,8 +275,7 @@ static int proc_info (struct Scsi_Host *host, char *buffer, char **start, off_t
 	SPRINTF("    Transport: %s\n", us->transport_name);
 
 	/* show the device flags */
-	if (pos < buffer + length)
-	{
+	if (pos < buffer + length) {
 		pos += sprintf(pos, "       Quirks:");
 
 #define US_FLAG(name, value) \
@@ -274,11 +290,11 @@ US_DO_ALL_FLAGS
 	*start = buffer + offset;
 
 	if ((pos - buffer) < offset)
-		return (0);
+		return 0;
 	else if ((pos - buffer - offset) < length)
-		return (pos - buffer - offset);
+		return pos - buffer - offset;
 	else
-		return (length);
+		return length;
 }
 
 /***********************************************************************
@@ -286,8 +302,11 @@ US_DO_ALL_FLAGS
  ***********************************************************************/
 
 /* Output routine for the sysfs max_sectors file */
-//----- show_max_sectors() ---------------------
-static ssize_t show_max_sectors(struct device *dev, struct device_attribute *attr, char *buf)
+/*
+ * show_max_sectors()
+ */
+static ssize_t show_max_sectors(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
@@ -296,19 +315,22 @@ static ssize_t show_max_sectors(struct device *dev, struct device_attribute *att
 }
 
 /* Input routine for the sysfs max_sectors file */
-//----- store_max_sectors() ---------------------
-static ssize_t store_max_sectors(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+/*
+ * store_max_sectors()
+ */
+static ssize_t store_max_sectors(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	unsigned short ms;
 
 	/* pr_info("scsiglue --- ssize_t store_max_sectors\n"); */
-	if (sscanf(buf, "%hu", &ms) > 0 && ms <= SCSI_DEFAULT_MAX_SECTORS)
-	{
+	if (sscanf(buf, "%hu", &ms) > 0 && ms <= SCSI_DEFAULT_MAX_SECTORS) {
 		blk_queue_max_hw_sectors(sdev->request_queue, ms);
 		return strlen(buf);
 	}
-	return -EINVAL;	
+	return -EINVAL;
 }
 
 static DEVICE_ATTR(max_sectors, S_IRUGO | S_IWUSR, show_max_sectors, store_max_sectors);
@@ -316,7 +338,9 @@ static struct device_attribute *sysfs_device_attr_list[] = {&dev_attr_max_sector
 
 /* this defines our host template, with which we'll allocate hosts */
 
-//----- usb_stor_host_template() ---------------------
+/*
+ * usb_stor_host_template()
+ */
 struct scsi_host_template usb_stor_host_template = {
 	/* basic userland interface stuff */
 	.name =				"eucr-storage",
@@ -379,7 +403,9 @@ unsigned char usb_stor_sense_invalidCDB[18] = {
  * Scatter-gather transfer buffer access routines
  ***********************************************************************/
 
-//----- usb_stor_access_xfer_buf() ---------------------
+/*
+ * usb_stor_access_xfer_buf()
+ */
 unsigned int usb_stor_access_xfer_buf(struct us_data *us, unsigned char *buffer,
 	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **sgptr,
 	unsigned int *offset, enum xfer_buf_dir dir)
@@ -393,28 +419,25 @@ unsigned int usb_stor_access_xfer_buf(struct us_data *us, unsigned char *buffer,
 		sg = scsi_sglist(srb);
 
 	cnt = 0;
-	while (cnt < buflen && sg)
-	{
-		struct page *page = sg_page(sg) + ((sg->offset + *offset) >> PAGE_SHIFT);
+	while (cnt < buflen && sg) {
+		struct page *page = sg_page(sg) +
+					((sg->offset + *offset) >> PAGE_SHIFT);
 		unsigned int poff = (sg->offset + *offset) & (PAGE_SIZE-1);
 		unsigned int sglen = sg->length - *offset;
 
-		if (sglen > buflen - cnt)
-		{
+		if (sglen > buflen - cnt) {
 			/* Transfer ends within this s-g entry */
 			sglen = buflen - cnt;
 			*offset += sglen;
-		}
-		else
-		{
+		} else {
 			/* Transfer continues to next s-g entry */
 			*offset = 0;
 			sg = sg_next(sg);
 		}
 
-		while (sglen > 0)
-		{
-			unsigned int plen = min(sglen, (unsigned int)PAGE_SIZE - poff);
+		while (sglen > 0) {
+			unsigned int plen = min(sglen,
+						(unsigned int)PAGE_SIZE - poff);
 			unsigned char *ptr = kmap(page);
 
 			if (dir == TO_XFER_BUF)
@@ -436,18 +459,24 @@ unsigned int usb_stor_access_xfer_buf(struct us_data *us, unsigned char *buffer,
 	return cnt;
 }
 
-/* Store the contents of buffer into srb's transfer buffer and set the SCSI residue. */
-//----- usb_stor_set_xfer_buf() ---------------------
-void usb_stor_set_xfer_buf(struct us_data *us, unsigned char *buffer, unsigned int buflen, struct scsi_cmnd *srb,
-	unsigned int dir)
+/*
+ * Store the contents of buffer into srb's transfer
+ * buffer and set the SCSI residue.
+ */
+/*
+ * usb_stor_set_xfer_buf()
+ */
+void usb_stor_set_xfer_buf(struct us_data *us, unsigned char *buffer,
+		unsigned int buflen, struct scsi_cmnd *srb, unsigned int dir)
 {
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
 
 	/* pr_info("transport --- usb_stor_set_xfer_buf\n"); */
-	// TO_XFER_BUF = 0, FROM_XFER_BUF = 1
+	/* TO_XFER_BUF = 0, FROM_XFER_BUF = 1 */
 	buflen = min(buflen, scsi_bufflen(srb));
-	buflen = usb_stor_access_xfer_buf(us, buffer, buflen, srb, &sg, &offset, dir);
+	buflen = usb_stor_access_xfer_buf(us, buffer, buflen, srb,
+						&sg, &offset, dir);
 	if (buflen < scsi_bufflen(srb))
 		scsi_set_resid(srb, scsi_bufflen(srb) - buflen);
 }
-- 
1.7.1

