Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab1ERKnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:43:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34082 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab1ERKnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:43:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=JRqReXt2e3HxmiBAHVYBVxL4I64apgNZkoq0+Fw3+vQprPc5hgam6RBH0Wu7CalQ3G
         /rfD4sitM3G7iRfjYLYpNi0kVQ57VD8bNi4xPGwvkeFrlsY9p4Cv4Q3RgP0gVgXUP0wU
         1p39nuqxdXA2s4yzCxxRp/JVBaKMOk7e294bY=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, jj@chaosbits.net, imirkin@alum.mit.edu,
        devel@driverdev.osuosl.org, jlee@novell.com, acho@novell.com
Subject: [PATCH 6/7] staging/keucr: fix keucr transport coding style
Date: Wed, 18 May 2011 18:40:14 +0800
Message-Id: <db91eb0f15afe2e467a1752ec29c5503d27f490c.1305714525.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix keucr transport.c transport.h coding style

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/transport.c |  385 ++++++++++++++++++++-----------------
 drivers/staging/keucr/transport.h |   81 +++++---
 2 files changed, 258 insertions(+), 208 deletions(-)

diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index 0114276..d48f592 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -15,7 +15,9 @@
 /***********************************************************************
  * Data transfer routines
  ***********************************************************************/
-//----- usb_stor_blocking_completion() ---------------------
+/*
+ * usb_stor_blocking_completion()
+ */
 static void usb_stor_blocking_completion(struct urb *urb)
 {
 	struct completion *urb_done_ptr = urb->context;
@@ -24,7 +26,9 @@ static void usb_stor_blocking_completion(struct urb *urb)
 	complete(urb_done_ptr);
 }
 
-//----- usb_stor_msg_common() ---------------------
+/*
+ * usb_stor_msg_common()
+ */
 static int usb_stor_msg_common(struct us_data *us, int timeout)
 {
 	struct completion urb_done;
@@ -54,20 +58,18 @@ static int usb_stor_msg_common(struct us_data *us, int timeout)
 
 	set_bit(US_FLIDX_URB_ACTIVE, &us->dflags);
 
-	if (test_bit(US_FLIDX_ABORTING, &us->dflags))
-	{
-		if (test_and_clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags))
-		{
+	if (test_bit(US_FLIDX_ABORTING, &us->dflags)) {
+		if (test_and_clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags)) {
 			/* pr_info("-- cancelling URB\n"); */
 			usb_unlink_urb(us->current_urb);
 		}
 	}
 
-	timeleft = wait_for_completion_interruptible_timeout(&urb_done, timeout ? : MAX_SCHEDULE_TIMEOUT);
+	timeleft = wait_for_completion_interruptible_timeout(&urb_done,
+					timeout ? : MAX_SCHEDULE_TIMEOUT);
 	clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags);
 
-	if (timeleft <= 0)
-	{
+	if (timeleft <= 0) {
 		/* pr_info("%s -- cancelling URB\n",
 			timeleft == 0 ? "Timeout" : "Signal"); */
 		usb_kill_urb(us->current_urb);
@@ -76,7 +78,9 @@ static int usb_stor_msg_common(struct us_data *us, int timeout)
 	return us->current_urb->status;
 }
 
-//----- usb_stor_control_msg() ---------------------
+/*
+ * usb_stor_control_msg()
+ */
 int usb_stor_control_msg(struct us_data *us, unsigned int pipe,
 		 u8 request, u8 requesttype, u16 value, u16 index,
 		 void *data, u16 size, int timeout)
@@ -94,7 +98,7 @@ int usb_stor_control_msg(struct us_data *us, unsigned int pipe,
 
 	/* fill and submit the URB */
 	usb_fill_control_urb(us->current_urb, us->pusb_dev, pipe,
-			 (unsigned char*) us->cr, data, size,
+			 (unsigned char *) us->cr, data, size,
 			 usb_stor_blocking_completion, NULL);
 	status = usb_stor_msg_common(us, timeout);
 
@@ -104,14 +108,16 @@ int usb_stor_control_msg(struct us_data *us, unsigned int pipe,
 	return status;
 }
 
-//----- usb_stor_clear_halt() ---------------------
+/*
+ * usb_stor_clear_halt()
+ */
 int usb_stor_clear_halt(struct us_data *us, unsigned int pipe)
 {
 	int result;
 	int endp = usb_pipeendpoint(pipe);
 
 	/* pr_info("transport --- usb_stor_clear_halt\n"); */
-	if (usb_pipein (pipe))
+	if (usb_pipein(pipe))
 		endp |= USB_DIR_IN;
 
 	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
@@ -121,13 +127,16 @@ int usb_stor_clear_halt(struct us_data *us, unsigned int pipe)
 
 	/* reset the endpoint toggle */
 	if (result >= 0)
-		//usb_settoggle(us->pusb_dev, usb_pipeendpoint(pipe), usb_pipeout(pipe), 0);
-                usb_reset_endpoint(us->pusb_dev, endp);
+		/* usb_settoggle(us->pusb_dev, usb_pipeendpoint(pipe),
+						usb_pipeout(pipe), 0); */
+		usb_reset_endpoint(us->pusb_dev, endp);
 
 	return result;
 }
 
-//----- interpret_urb_result() ---------------------
+/*
+ * interpret_urb_result()
+ */
 static int interpret_urb_result(struct us_data *us, unsigned int pipe,
 		unsigned int length, int result, unsigned int partial)
 {
@@ -135,16 +144,14 @@ static int interpret_urb_result(struct us_data *us, unsigned int pipe,
 	switch (result) {
 	/* no error code; did we send all the data? */
 	case 0:
-		if (partial != length)
-		{
+		if (partial != length) {
 			/* pr_info("-- short transfer\n"); */
 			return USB_STOR_XFER_SHORT;
 		}
 		/* pr_info("-- transfer complete\n"); */
 		return USB_STOR_XFER_GOOD;
 	case -EPIPE:
-		if (usb_pipecontrol(pipe))
-		{
+		if (usb_pipecontrol(pipe)) {
 			/* pr_info("-- stall on control pipe\n"); */
 			return USB_STOR_XFER_STALLED;
 		}
@@ -170,7 +177,9 @@ static int interpret_urb_result(struct us_data *us, unsigned int pipe,
 	}
 }
 
-//----- usb_stor_bulk_transfer_buf() ---------------------
+/*
+ * usb_stor_bulk_transfer_buf()
+ */
 int usb_stor_bulk_transfer_buf(struct us_data *us, unsigned int pipe,
 	void *buf, unsigned int length, unsigned int *act_len)
 {
@@ -179,17 +188,21 @@ int usb_stor_bulk_transfer_buf(struct us_data *us, unsigned int pipe,
 	/* pr_info("transport --- usb_stor_bulk_transfer_buf\n"); */
 
 	/* fill and submit the URB */
-	usb_fill_bulk_urb(us->current_urb, us->pusb_dev, pipe, buf, length, usb_stor_blocking_completion, NULL);
+	usb_fill_bulk_urb(us->current_urb, us->pusb_dev, pipe, buf,
+				length, usb_stor_blocking_completion, NULL);
 	result = usb_stor_msg_common(us, 0);
 
 	/* store the actual length of the data transferred */
 	if (act_len)
 		*act_len = us->current_urb->actual_length;
 
-	return interpret_urb_result(us, pipe, length, result, us->current_urb->actual_length);
+	return interpret_urb_result(us, pipe, length, result,
+					us->current_urb->actual_length);
 }
 
-//----- usb_stor_bulk_transfer_sglist() ---------------------
+/*
+ * usb_stor_bulk_transfer_sglist()
+ */
 static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 		struct scatterlist *sg, int num_sg, unsigned int length,
 		unsigned int *act_len)
@@ -201,22 +214,21 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 		return USB_STOR_XFER_ERROR;
 
 	/* initialize the scatter-gather request block */
-	result = usb_sg_init(&us->current_sg, us->pusb_dev, pipe, 0, sg, num_sg, length, GFP_NOIO);
-	if (result)
-	{
+	result = usb_sg_init(&us->current_sg, us->pusb_dev, pipe, 0,
+					sg, num_sg, length, GFP_NOIO);
+	if (result) {
 		/* pr_info("usb_sg_init returned %d\n", result); */
 		return USB_STOR_XFER_ERROR;
 	}
 
-	/* since the block has been initialized successfully, it's now okay to cancel it */
+	/* since the block has been initialized successfully,
+					it's now okay to cancel it */
 	set_bit(US_FLIDX_SG_ACTIVE, &us->dflags);
 
 	/* did an abort/disconnect occur during the submission? */
-	if (test_bit(US_FLIDX_ABORTING, &us->dflags))
-	{
+	if (test_bit(US_FLIDX_ABORTING, &us->dflags)) {
 		/* cancel the request, if it hasn't been cancelled already */
-		if (test_and_clear_bit(US_FLIDX_SG_ACTIVE, &us->dflags))
-		{
+		if (test_and_clear_bit(US_FLIDX_SG_ACTIVE, &us->dflags)) {
 			/* pr_info("-- cancelling sg request\n"); */
 			usb_sg_cancel(&us->current_sg);
 		}
@@ -230,11 +242,15 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 	if (act_len)
 		*act_len = us->current_sg.bytes;
 
-	return interpret_urb_result(us, pipe, length, result, us->current_sg.bytes);
+	return interpret_urb_result(us, pipe, length,
+					result, us->current_sg.bytes);
 }
 
-//----- usb_stor_bulk_srb() ---------------------
-int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe, struct scsi_cmnd* srb)
+/*
+ * usb_stor_bulk_srb()
+ */
+int usb_stor_bulk_srb(struct us_data *us, unsigned int pipe,
+					struct scsi_cmnd *srb)
 {
 	unsigned int partial;
 	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
@@ -245,8 +261,10 @@ int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe, struct scsi_cmnd* s
 	return result;
 }
 
-//----- usb_stor_bulk_transfer_sg() ---------------------
-int usb_stor_bulk_transfer_sg(struct us_data* us, unsigned int pipe,
+/*
+ * usb_stor_bulk_transfer_sg()
+ */
+int usb_stor_bulk_transfer_sg(struct us_data *us, unsigned int pipe,
 		void *buf, unsigned int length_left, int use_sg, int *residual)
 {
 	int result;
@@ -254,18 +272,16 @@ int usb_stor_bulk_transfer_sg(struct us_data* us, unsigned int pipe,
 
 	/* pr_info("transport --- usb_stor_bulk_transfer_sg\n"); */
 	/* are we scatter-gathering? */
-	if (use_sg)
-	{
+	if (use_sg) {
 		/* use the usb core scatter-gather primitives */
 		result = usb_stor_bulk_transfer_sglist(us, pipe,
 				(struct scatterlist *) buf, use_sg,
 				length_left, &partial);
 		length_left -= partial;
-	}
-	else
-	{
+	} else {
 		/* no scatter-gather, just make the request */
-		result = usb_stor_bulk_transfer_buf(us, pipe, buf, length_left, &partial);
+		result = usb_stor_bulk_transfer_buf(us, pipe, buf,
+							length_left, &partial);
 		length_left -= partial;
 	}
 
@@ -278,7 +294,9 @@ int usb_stor_bulk_transfer_sg(struct us_data* us, unsigned int pipe,
 /***********************************************************************
  * Transport routines
  ***********************************************************************/
-//----- usb_stor_invoke_transport() ---------------------
+/*
+ * usb_stor_invoke_transport()
+ */
 void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
 	int need_auto_sense;
@@ -288,27 +306,25 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	usb_stor_print_cmd(srb);
 	/* send the command to the transport layer */
 	scsi_set_resid(srb, 0);
-	result = us->transport(srb, us); //usb_stor_Bulk_transport;
-	
-	/* if the command gets aborted by the higher layers, we need to short-circuit all other processing */
-	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags))
-	{
+	result = us->transport(srb, us); /* usb_stor_Bulk_transport; */
+
+	/* if the command gets aborted by the higher layers,
+		we need to short-circuit all other processing */
+	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 		/* pr_info("-- command was aborted\n"); */
 		srb->result = DID_ABORT << 16;
 		goto Handle_Errors;
 	}
 
 	/* if there is a transport error, reset and don't auto-sense */
-	if (result == USB_STOR_TRANSPORT_ERROR)
-	{
+	if (result == USB_STOR_TRANSPORT_ERROR) {
 		/* pr_info("-- transport indicates error, resetting\n"); */
 		srb->result = DID_ERROR << 16;
 		goto Handle_Errors;
 	}
 
 	/* if the transport provided its own sense data, don't auto-sense */
-	if (result == USB_STOR_TRANSPORT_NO_SENSE)
-	{
+	if (result == USB_STOR_TRANSPORT_NO_SENSE) {
 		srb->result = SAM_STAT_CHECK_CONDITION;
 		return;
 	}
@@ -318,21 +334,19 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* Determine if we need to auto-sense */
 	need_auto_sense = 0;
 
-	if ((us->protocol == USB_PR_CB || us->protocol == USB_PR_DPCM_USB) && srb->sc_data_direction != DMA_FROM_DEVICE)
-	{
+	if ((us->protocol == USB_PR_CB || us->protocol == USB_PR_DPCM_USB) &&
+				srb->sc_data_direction != DMA_FROM_DEVICE) {
 		/* pr_info("-- CB transport device requiring auto-sense\n"); */
 		need_auto_sense = 1;
 	}
 
-	if (result == USB_STOR_TRANSPORT_FAILED)
-	{
+	if (result == USB_STOR_TRANSPORT_FAILED) {
 		/* pr_info("-- transport indicates command failure\n"); */
 		need_auto_sense = 1;
 	}
 
 	/* Now, if we need to do the auto-sense, let's do it */
-	if (need_auto_sense)
-	{
+	if (need_auto_sense) {
 		int temp_result;
 		struct scsi_eh_save ses;
 
@@ -341,11 +355,13 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, US_SENSE_SIZE);
 
 		/* we must do the protocol translation here */
-		if (us->subclass == USB_SC_RBC || us->subclass == USB_SC_SCSI || us->subclass == USB_SC_CYP_ATACB)
+		if (us->subclass == USB_SC_RBC ||
+			us->subclass == USB_SC_SCSI ||
+			us->subclass == USB_SC_CYP_ATACB) {
 			srb->cmd_len = 6;
-		else
+		} else {
 			srb->cmd_len = 12;
-
+		}
 		/* issue the auto-sense command */
 		scsi_set_resid(srb, 0);
 		temp_result = us->transport(us->srb, us);
@@ -353,14 +369,12 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		/* let's clean up right away */
 		scsi_eh_restore_cmnd(srb, &ses);
 
-		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags))
-		{
+		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 			/* pr_info("-- auto-sense aborted\n"); */
 			srb->result = DID_ABORT << 16;
 			goto Handle_Errors;
 		}
-		if (temp_result != USB_STOR_TRANSPORT_GOOD)
-		{
+		if (temp_result != USB_STOR_TRANSPORT_GOOD) {
 			/* pr_info("-- auto-sense failure\n"); */
 			srb->result = DID_ERROR << 16;
 			if (!(us->fflags & US_FL_SCM_MULT_TARG))
@@ -374,16 +388,17 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		if (result == USB_STOR_TRANSPORT_GOOD &&
 			(srb->sense_buffer[2] & 0xaf) == 0 &&
 			srb->sense_buffer[12] == 0 &&
-			srb->sense_buffer[13] == 0)
-		{
+			srb->sense_buffer[13] == 0) {
 			srb->result = SAM_STAT_GOOD;
 			srb->sense_buffer[0] = 0x0;
 		}
 	}
 
 	/* Did we transfer less than the minimum amount required? */
-	if (srb->result == SAM_STAT_GOOD &&	scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
-		srb->result = (DID_ERROR << 16);//v02 | (SUGGEST_RETRY << 24);
+	if (srb->result == SAM_STAT_GOOD && scsi_bufflen(srb) -
+				scsi_get_resid(srb) < srb->underflow)
+		srb->result = (DID_ERROR << 16);
+		/* v02 | (SUGGEST_RETRY << 24); */
 
 	return;
 
@@ -397,8 +412,7 @@ Handle_Errors:
 	result = usb_stor_port_reset(us);
 	mutex_lock(&us->dev_mutex);
 
-	if (result < 0)
-	{
+	if (result < 0) {
 		scsi_lock(us_to_host(us));
 		usb_stor_report_device_reset(us);
 		scsi_unlock(us_to_host(us));
@@ -407,10 +421,12 @@ Handle_Errors:
 	clear_bit(US_FLIDX_RESETTING, &us->dflags);
 }
 
-//----- ENE_stor_invoke_transport() ---------------------
+/*
+ * ENE_stor_invoke_transport()
+ */
 void ENE_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
-	int result=0;
+	int result = 0;
 
 	/* pr_info("transport --- ENE_stor_invoke_transport\n"); */
 	usb_stor_print_cmd(srb);
@@ -418,50 +434,51 @@ void ENE_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	scsi_set_resid(srb, 0);
 	if (!(us->MS_Status.Ready || us->SM_Status.Ready))
 		result = ENE_InitMedia(us);
-	
+
 	if (us->Power_IsResum == true) {
 		result = ENE_InitMedia(us);
-		us->Power_IsResum = false;		
-	}	
-	
-	if (us->MS_Status.Ready)	result = MS_SCSIIrp(us, srb);
-	if (us->SM_Status.Ready)	result = SM_SCSIIrp(us, srb);
-
-	/* if the command gets aborted by the higher layers, we need to short-circuit all other processing */
-	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags))
-	{
+		us->Power_IsResum = false;
+	}
+
+	if (us->MS_Status.Ready)
+		result = MS_SCSIIrp(us, srb);
+	if (us->SM_Status.Ready)
+		result = SM_SCSIIrp(us, srb);
+
+	/* if the command gets aborted by the higher layers,
+		we need to short-circuit all other processing */
+	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 		/* pr_info("-- command was aborted\n"); */
 		srb->result = DID_ABORT << 16;
 		goto Handle_Errors;
 	}
 
 	/* if there is a transport error, reset and don't auto-sense */
-	if (result == USB_STOR_TRANSPORT_ERROR)
-	{
+	if (result == USB_STOR_TRANSPORT_ERROR) {
 		/* pr_info("-- transport indicates error, resetting\n"); */
 		srb->result = DID_ERROR << 16;
 		goto Handle_Errors;
 	}
 
 	/* if the transport provided its own sense data, don't auto-sense */
-	if (result == USB_STOR_TRANSPORT_NO_SENSE)
-	{
+	if (result == USB_STOR_TRANSPORT_NO_SENSE) {
 		srb->result = SAM_STAT_CHECK_CONDITION;
 		return;
 	}
 
 	srb->result = SAM_STAT_GOOD;
-	if (result == USB_STOR_TRANSPORT_FAILED)
-	{
+	if (result == USB_STOR_TRANSPORT_FAILED) {
 		/* pr_info("-- transport indicates command failure\n"); */
-		//need_auto_sense = 1;
+		/* need_auto_sense = 1; */
 		BuildSenseBuffer(srb, us->SrbStatus);
 		srb->result = SAM_STAT_CHECK_CONDITION;
 	}
 
 	/* Did we transfer less than the minimum amount required? */
-	if (srb->result == SAM_STAT_GOOD && scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
-		srb->result = (DID_ERROR << 16);//v02 | (SUGGEST_RETRY << 24);
+	if (srb->result == SAM_STAT_GOOD && scsi_bufflen(srb) -
+					scsi_get_resid(srb) < srb->underflow)
+		srb->result = (DID_ERROR << 16);
+		/* v02 | (SUGGEST_RETRY << 24); */
 
 	return;
 
@@ -475,8 +492,7 @@ Handle_Errors:
 	result = usb_stor_port_reset(us);
 	mutex_lock(&us->dev_mutex);
 
-	if (result < 0)
-	{
+	if (result < 0) {
 		scsi_lock(us_to_host(us));
 		usb_stor_report_device_reset(us);
 		scsi_unlock(us_to_host(us));
@@ -485,47 +501,58 @@ Handle_Errors:
 	clear_bit(US_FLIDX_RESETTING, &us->dflags);
 }
 
-//----- BuildSenseBuffer() -------------------------------------------
+/*
+ * BuildSenseBuffer()
+ */
 void BuildSenseBuffer(struct scsi_cmnd *srb, int SrbStatus)
 {
-    BYTE    *buf = srb->sense_buffer;
-    BYTE    asc;
+	BYTE    *buf = srb->sense_buffer;
+	BYTE    asc;
 
 	pr_info("transport --- BuildSenseBuffer\n");
-    switch (SrbStatus)
-    {
-        case SS_NOT_READY:        asc = 0x3a;    break;  // sense key = 0x02
-        case SS_MEDIUM_ERR:       asc = 0x0c;    break;  // sense key = 0x03
-        case SS_ILLEGAL_REQUEST:  asc = 0x20;    break;  // sense key = 0x05
-        default:                  asc = 0x00;    break;  // ??
-    }
-
-    memset(buf, 0, 18);
-    buf[0x00] = 0xf0;
-    buf[0x02] = SrbStatus;
-    buf[0x07] = 0x0b;
-    buf[0x0c] = asc;
+	switch (SrbStatus) {
+	case SS_NOT_READY:
+		asc = 0x3a;
+		break;  /*  sense key = 0x02 */
+	case SS_MEDIUM_ERR:
+		asc = 0x0c;
+		break;  /*  sense key = 0x03 */
+	case SS_ILLEGAL_REQUEST:
+		asc = 0x20;
+		break;  /*  sense key = 0x05 */
+	default:
+		asc = 0x00;
+		break;  /*  ?? */
+	}
+
+	memset(buf, 0, 18);
+	buf[0x00] = 0xf0;
+	buf[0x02] = SrbStatus;
+	buf[0x07] = 0x0b;
+	buf[0x0c] = asc;
 }
 
-//----- usb_stor_stop_transport() ---------------------
+/*
+ * usb_stor_stop_transport()
+ */
 void usb_stor_stop_transport(struct us_data *us)
 {
 	/* pr_info("transport --- usb_stor_stop_transport\n"); */
 
-	if (test_and_clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags))
-	{
+	if (test_and_clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags)) {
 		/* pr_info("-- cancelling URB\n"); */
 		usb_unlink_urb(us->current_urb);
 	}
 
-	if (test_and_clear_bit(US_FLIDX_SG_ACTIVE, &us->dflags))
-	{
+	if (test_and_clear_bit(US_FLIDX_SG_ACTIVE, &us->dflags)) {
 		/* pr_info("-- cancelling sg request\n"); */
 		usb_sg_cancel(&us->current_sg);
 	}
 }
 
-//----- usb_stor_Bulk_max_lun() ---------------------
+/*
+ * usb_stor_Bulk_max_lun()
+ */
 int usb_stor_Bulk_max_lun(struct us_data *us)
 {
 	int result;
@@ -549,7 +576,9 @@ int usb_stor_Bulk_max_lun(struct us_data *us)
 	return 0;
 }
 
-//----- usb_stor_Bulk_transport() ---------------------
+/*
+ * usb_stor_Bulk_transport()
+ */
 int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
@@ -563,8 +592,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	/* pr_info("transport --- usb_stor_Bulk_transport\n"); */
 	/* Take care of BULK32 devices; set extra byte to 0 */
-	if (unlikely(us->fflags & US_FL_BULK32))
-	{
+	if (unlikely(us->fflags & US_FL_BULK32)) {
 		cbwlen = 32;
 		us->iobuf[31] = 0;
 	}
@@ -583,14 +611,15 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	memset(bcb->CDB, 0, sizeof(bcb->CDB));
 	memcpy(bcb->CDB, srb->cmnd, bcb->Length);
 
-	// send command
+	/*  send command */
 	/* send it to out endpoint */
 	/* pr_info("Bulk Command S 0x%x T 0x%x L %d F %d Trg %d LUN %d CL %d\n",
 			le32_to_cpu(bcb->Signature), bcb->Tag,
 			le32_to_cpu(bcb->DataTransferLength), bcb->Flags,
 			(bcb->Lun >> 4), (bcb->Lun & 0x0F),
 			bcb->Length); */
-	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcb, cbwlen, NULL);
+	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
+						bcb, cbwlen, NULL);
 	/* pr_info("Bulk command transfer result=%d\n", result); */
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -598,10 +627,10 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (unlikely(us->fflags & US_FL_GO_SLOW))
 		udelay(125);
 
-	// R/W data
-	if (transfer_length)
-	{
-		unsigned int pipe = srb->sc_data_direction == DMA_FROM_DEVICE ? us->recv_bulk_pipe : us->send_bulk_pipe;
+	/*  R/W data */
+	if (transfer_length) {
+		unsigned int pipe = srb->sc_data_direction ==
+		DMA_FROM_DEVICE ? us->recv_bulk_pipe : us->send_bulk_pipe;
 		result = usb_stor_bulk_srb(us, pipe, srb);
 		/* pr_info("Bulk data transfer result 0x%x\n", result); */
 		if (result == USB_STOR_XFER_ERROR)
@@ -613,20 +642,21 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	/* get CSW for device status */
 	/* pr_info("Attempting to get CSW...\n"); */
-	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, &cswlen);
+	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs,
+						US_BULK_CS_WRAP_LEN, &cswlen);
 
-	if (result == USB_STOR_XFER_SHORT && cswlen == 0)
-	{
+	if (result == USB_STOR_XFER_SHORT && cswlen == 0) {
 		/* pr_info("Received 0-length CSW; retrying...\n"); */
-		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, &cswlen);
+		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs,
+						US_BULK_CS_WRAP_LEN, &cswlen);
 	}
 
 	/* did the attempt to read the CSW fail? */
-	if (result == USB_STOR_XFER_STALLED)
-	{
+	if (result == USB_STOR_XFER_STALLED) {
 		/* get the status again */
 		/* pr_info("Attempting to get CSW (2nd try)...\n"); */
-		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, NULL);
+		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs,
+						US_BULK_CS_WRAP_LEN, NULL);
 	}
 
 	/* if we still have a failure at this point, we're in trouble */
@@ -639,21 +669,19 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* pr_info("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
 				le32_to_cpu(bcs->Signature),
 				bcs->Tag, residue, bcs->Status); */
-	if (!(bcs->Tag == us->tag || (us->fflags & US_FL_BULK_IGNORE_TAG)) || bcs->Status > US_BULK_STAT_PHASE)
-	{
+	if (!(bcs->Tag == us->tag ||
+		(us->fflags & US_FL_BULK_IGNORE_TAG)) ||
+		bcs->Status > US_BULK_STAT_PHASE) {
 		/* pr_info("Bulk logical error\n"); */
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	if (!us->bcs_signature)
-	{
+	if (!us->bcs_signature) {
 		us->bcs_signature = bcs->Signature;
-		//if (us->bcs_signature != cpu_to_le32(US_BULK_CS_SIGN))
+		/* if (us->bcs_signature != cpu_to_le32(US_BULK_CS_SIGN)) */
 		/* pr_info("Learnt BCS signature 0x%08X\n",
 				le32_to_cpu(us->bcs_signature)); */
-	}
-	else if (bcs->Signature != us->bcs_signature)
-	{
+	} else if (bcs->Signature != us->bcs_signature) {
 		/* pr_info("Signature mismatch: got %08X, expecting %08X\n",
 			  le32_to_cpu(bcs->Signature),
 			  le32_to_cpu(us->bcs_signature)); */
@@ -662,8 +690,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	/* try to compute the actual residue, based on how much data
 	 * was really transferred and what the device tells us */
-	if (residue && !(us->fflags & US_FL_IGNORE_RESIDUE))
-	{
+	if (residue && !(us->fflags & US_FL_IGNORE_RESIDUE)) {
 
 		/* Heuristically detect devices that generate bogus residues
 		 * by seeing what happens with INQUIRY and READ CAPACITY
@@ -674,34 +701,31 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 					((srb->cmnd[0] == INQUIRY &&
 						transfer_length == 36) ||
 					(srb->cmnd[0] == READ_CAPACITY &&
-						transfer_length == 8)))
-		{
+						transfer_length == 8))) {
 			us->fflags |= US_FL_IGNORE_RESIDUE;
 
-		}
-		else
-		{
+		} else {
 			residue = min(residue, transfer_length);
-			scsi_set_resid(srb, max(scsi_get_resid(srb), (int) residue));
+			scsi_set_resid(srb, max(scsi_get_resid(srb),
+							(int) residue));
 		}
 	}
 
 	/* based on the status code, we report good or bad */
-	switch (bcs->Status)
-	{
-		case US_BULK_STAT_OK:
-			if (fake_sense)
-			{
-				memcpy(srb->sense_buffer, usb_stor_sense_invalidCDB, sizeof(usb_stor_sense_invalidCDB));
-				return USB_STOR_TRANSPORT_NO_SENSE;
-			}
-			return USB_STOR_TRANSPORT_GOOD;
-
-		case US_BULK_STAT_FAIL:
-			return USB_STOR_TRANSPORT_FAILED;
-
-		case US_BULK_STAT_PHASE:
-			return USB_STOR_TRANSPORT_ERROR;
+	switch (bcs->Status) {
+	case US_BULK_STAT_OK:
+		if (fake_sense) {
+			memcpy(srb->sense_buffer, usb_stor_sense_invalidCDB,
+					sizeof(usb_stor_sense_invalidCDB));
+			return USB_STOR_TRANSPORT_NO_SENSE;
+		}
+		return USB_STOR_TRANSPORT_GOOD;
+
+	case US_BULK_STAT_FAIL:
+		return USB_STOR_TRANSPORT_FAILED;
+
+	case US_BULK_STAT_PHASE:
+		return USB_STOR_TRANSPORT_ERROR;
 	}
 	return USB_STOR_TRANSPORT_ERROR;
 }
@@ -709,7 +733,9 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 /***********************************************************************
  * Reset routines
  ***********************************************************************/
-//----- usb_stor_reset_common() ---------------------
+/*
+ * usb_stor_reset_common()
+ */
 static int usb_stor_reset_common(struct us_data *us,
 		u8 request, u8 requesttype,
 		u16 value, u16 index, void *data, u16 size)
@@ -718,22 +744,23 @@ static int usb_stor_reset_common(struct us_data *us,
 	int result2;
 
 	/* pr_info("transport --- usb_stor_reset_common\n"); */
-	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
-	{
+	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
 		/* pr_info("No reset during disconnect\n"); */
 		return -EIO;
 	}
 
-	result = usb_stor_control_msg(us, us->send_ctrl_pipe, request, requesttype, value, index, data, size,	5*HZ);
-	if (result < 0)
-	{
+	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
+			request, requesttype, value, index, data, size,	5*HZ);
+
+	if (result < 0) {
 		/* pr_info("Soft reset failed: %d\n", result); */
 		return result;
 	}
 
-	wait_event_interruptible_timeout(us->delay_wait, test_bit(US_FLIDX_DISCONNECTING, &us->dflags),	HZ*6);
-	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
-	{
+	wait_event_interruptible_timeout(us->delay_wait,
+			test_bit(US_FLIDX_DISCONNECTING, &us->dflags),	HZ*6);
+
+	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
 		/* pr_info("Reset interrupted by disconnect\n"); */
 		return -EIO;
 	}
@@ -747,14 +774,16 @@ static int usb_stor_reset_common(struct us_data *us,
 	/* return a result code based on the result of the clear-halts */
 	if (result >= 0)
 		result = result2;
-	//if (result < 0)
+	/* if (result < 0) */
 		/* pr_info("Soft reset failed\n"); */
-	//else
+	/* else */
 		/* pr_info("Soft reset done\n"); */
 	return result;
 }
 
-//----- usb_stor_Bulk_reset() ---------------------
+/*
+ * usb_stor_Bulk_reset()
+ */
 int usb_stor_Bulk_reset(struct us_data *us)
 {
 	/* pr_info("transport --- usb_stor_Bulk_reset\n"); */
@@ -763,7 +792,9 @@ int usb_stor_Bulk_reset(struct us_data *us)
 				 0, us->ifnum, NULL, 0);
 }
 
-//----- usb_stor_port_reset() ---------------------
+/*
+ * usb_stor_port_reset()
+ */
 int usb_stor_port_reset(struct us_data *us)
 {
 	int result;
diff --git a/drivers/staging/keucr/transport.h b/drivers/staging/keucr/transport.h
index ddfec53..7529615 100644
--- a/drivers/staging/keucr/transport.h
+++ b/drivers/staging/keucr/transport.h
@@ -8,7 +8,7 @@
 /* command block wrapper */
 struct bulk_cb_wrap {
 	__le32	Signature;			/* contains 'USBC' */
-	__u32	Tag;					/* unique per command id */
+	__u32	Tag;				/* unique per command id */
 	__le32	DataTransferLength;	/* size of data */
 	__u8	Flags;				/* direction in bit 0 */
 	__u8	Lun;					/* LUN normally 0 */
@@ -49,9 +49,9 @@ struct bulk_cs_wrap {
 
 /* Transport return codes */
 #define USB_STOR_TRANSPORT_GOOD	0	/* Transport good, command good	*/
-#define USB_STOR_TRANSPORT_FAILED	1	/* Transport good, command failed   */
-#define USB_STOR_TRANSPORT_NO_SENSE	2	/* Command failed, no auto-sense    */
-#define USB_STOR_TRANSPORT_ERROR	3	/* Transport bad (i.e. device dead) */
+#define USB_STOR_TRANSPORT_FAILED 1	/* Transport good, command failed */
+#define USB_STOR_TRANSPORT_NO_SENSE 2	/* Command failed, no auto-sense */
+#define USB_STOR_TRANSPORT_ERROR 3	/* Transport bad (i.e. device dead) */
 
 /*
  * We used to have USB_STOR_XFER_ABORTED and USB_STOR_TRANSPORT_ABORTED
@@ -64,11 +64,11 @@ struct bulk_cs_wrap {
 /* CBI accept device specific command */
 #define US_CBI_ADSC		0
 extern int usb_stor_Bulk_transport(struct scsi_cmnd *, struct us_data*);
-extern int usb_stor_Bulk_max_lun(struct us_data*);
-extern int usb_stor_Bulk_reset(struct us_data*);
+extern int usb_stor_Bulk_max_lun(struct us_data *);
+extern int usb_stor_Bulk_reset(struct us_data *);
 extern void usb_stor_print_cmd(struct scsi_cmnd *);
 extern void usb_stor_invoke_transport(struct scsi_cmnd *, struct us_data*);
-extern void usb_stor_stop_transport(struct us_data*);
+extern void usb_stor_stop_transport(struct us_data *);
 extern int usb_stor_control_msg(struct us_data *us, unsigned int pipe,
 		u8 request, u8 requesttype, u16 value, u16 index,
 		void *data, u16 size, int timeout);
@@ -77,23 +77,26 @@ extern int usb_stor_bulk_transfer_buf(struct us_data *us, unsigned int pipe,
 		void *buf, unsigned int length, unsigned int *act_len);
 extern int usb_stor_bulk_transfer_sg(struct us_data *us, unsigned int pipe,
 		void *buf, unsigned int length, int use_sg, int *residual);
-extern int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
-		struct scsi_cmnd* srb);
+extern int usb_stor_bulk_srb(struct us_data *us, unsigned int pipe,
+		struct scsi_cmnd *srb);
 extern int usb_stor_port_reset(struct us_data *us);
 
 /* Protocol handling routines */
 enum xfer_buf_dir	{TO_XFER_BUF, FROM_XFER_BUF};
-extern unsigned int usb_stor_access_xfer_buf(struct us_data*, unsigned char *buffer,
-	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **,
-	unsigned int *offset, enum xfer_buf_dir dir);
-extern void usb_stor_set_xfer_buf(struct us_data*, unsigned char *buffer, unsigned int buflen, struct scsi_cmnd *srb,
+extern unsigned int usb_stor_access_xfer_buf(struct us_data*,
+	unsigned char *buffer, unsigned int buflen, struct scsi_cmnd *srb,
+	struct scatterlist **, unsigned int *offset, enum xfer_buf_dir dir);
+extern void usb_stor_set_xfer_buf(struct us_data*, unsigned char *buffer,
+	unsigned int buflen, struct scsi_cmnd *srb,
 	unsigned int dir);
 
-// ENE scsi function
-extern void ENE_stor_invoke_transport(struct scsi_cmnd *, struct us_data*);
-extern int ENE_InitMedia(struct us_data*);
-extern int ENE_MSInit(struct us_data*);
-extern int ENE_SMInit(struct us_data*);
+/*
+ * ENE scsi function
+ */
+extern void ENE_stor_invoke_transport(struct scsi_cmnd *, struct us_data *);
+extern int ENE_InitMedia(struct us_data *);
+extern int ENE_MSInit(struct us_data *);
+extern int ENE_SMInit(struct us_data *);
 extern int ENE_SendScsiCmd(struct us_data*, BYTE, void*, int);
 extern int ENE_LoadBinCode(struct us_data*, BYTE);
 extern int ENE_Read_BYTE(struct us_data*, WORD index, void *buf);
@@ -101,35 +104,51 @@ extern int ENE_Read_Data(struct us_data*, void *buf, unsigned int length);
 extern int ENE_Write_Data(struct us_data*, void *buf, unsigned int length);
 extern void BuildSenseBuffer(struct scsi_cmnd *, int);
 
-// ENE scsi function
+/*
+ * ENE scsi function
+ */
 extern int MS_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb);
 extern int SM_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb);
 
-// ENE MS function
-extern int 	MS_CardInit(struct us_data *us);
+/*
+ * ENE MS function
+ */
+extern int	MS_CardInit(struct us_data *us);
 extern void	MS_LibFreeAllocatedArea(struct us_data *us);
 extern void	MS_LibFreeWriteBuf(struct us_data *us);
 extern int	MS_LibFreeLogicalMap(struct us_data *us);
-extern int	MS_LibForceSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk);
-extern int	MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, DWORD *PageBuf, MS_LibTypeExtdat *ExtraDat);
-extern int	MS_ReaderCopyBlock(struct us_data *us, WORD oldphy, WORD newphy, WORD PhyBlockAddr, BYTE PageNum, PBYTE buf, WORD len);
+extern int	MS_LibForceSetLogicalPair(struct us_data *us, WORD logblk,
+								WORD phyblk);
+extern int	MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr,
+					BYTE PageNum, DWORD *PageBuf,
+					MS_LibTypeExtdat *ExtraDat);
+extern int	MS_ReaderCopyBlock(struct us_data *us, WORD oldphy,
+					WORD newphy, WORD PhyBlockAddr,
+					BYTE PageNum, PBYTE buf, WORD len);
 extern int	MS_ReaderEraseBlock(struct us_data *us, DWORD PhyBlockAddr);
-extern int	MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData);
+extern int	MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock,
+							BYTE *PageData);
 extern int	MS_LibAllocLogicalMap(struct us_data *us);
 extern int	MS_LibSetBootBlockMark(struct us_data *us, WORD phyblk);
-extern int	MS_LibSetLogicalBlockMark(struct us_data *us, WORD phyblk, WORD mark);
+extern int	MS_LibSetLogicalBlockMark(struct us_data *us, WORD phyblk,
+								WORD mark);
 extern int	MS_LibSetInitialErrorBlock(struct us_data *us, WORD phyblk);
 extern int	MS_LibScanLogicalBlockNumber(struct us_data *us, WORD phyblk);
 extern int	MS_LibAllocWriteBuf(struct us_data *us);
 void		MS_LibClearWriteBuf(struct us_data *us);
-void		MS_LibPhy2LogRange(WORD PhyBlock, WORD *LogStart, WORD *LogEnde);
-extern int	MS_LibReadExtra(struct us_data *us, DWORD PhyBlock, BYTE PageNum, MS_LibTypeExtdat *ExtraDat);
-extern int	MS_LibReadExtraBlock(struct us_data *us, DWORD PhyBlock, BYTE PageNum, BYTE blen, void *buf);
+void		MS_LibPhy2LogRange(WORD PhyBlock, WORD *LogStart,
+							WORD *LogEnde);
+extern int	MS_LibReadExtra(struct us_data *us, DWORD PhyBlock,
+				BYTE PageNum, MS_LibTypeExtdat *ExtraDat);
+extern int	MS_LibReadExtraBlock(struct us_data *us, DWORD PhyBlock,
+					BYTE PageNum, BYTE blen, void *buf);
 extern int	MS_LibSetAcquiredErrorBlock(struct us_data *us, WORD phyblk);
 extern int	MS_LibErasePhyBlock(struct us_data *us, WORD phyblk);
 extern int	MS_LibErrorPhyBlock(struct us_data *us, WORD phyblk);
-extern int	MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, BYTE OverwriteFlag);
-extern int	MS_LibSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk);
+extern int	MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr,
+					BYTE PageNum, BYTE OverwriteFlag);
+extern int	MS_LibSetLogicalPair(struct us_data *us,
+					WORD logblk, WORD phyblk);
 extern int	MS_LibCheckDisableBlock(struct us_data *us, WORD PhyBlock);
 extern int	MS_CountFreeBlock(struct us_data *us, WORD PhyBlock);
 extern int	MS_LibSearchBlockFromLogical(struct us_data *us, WORD logblk);
-- 
1.7.1

