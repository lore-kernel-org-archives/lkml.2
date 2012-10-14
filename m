Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2JNQA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 12:00:28 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35571 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab2JNQA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 12:00:27 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/2] Staging: CSR: Fixed 41% of exceeding 80 characters problems on drv.c
Date: Mon, 15 Oct 2012 00:58:26 +0900
Message-Id: <1350230306-32515-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350230306-32515-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350230306-32515-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed 41% of exceeding 80 characters problems on drv.c.
Note that some long strings for printing messages still exceed 80
characters.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/drv.c |  338 ++++++++++++++++++++++++---------------------
 1 file changed, 181 insertions(+), 157 deletions(-)

diff --git a/drivers/staging/csr/drv.c b/drivers/staging/csr/drv.c
index baefcd2..627a113 100644
--- a/drivers/staging/csr/drv.c
+++ b/drivers/staging/csr/drv.c
@@ -43,23 +43,23 @@
 #include "unifi_native.h"
 
 /* Module parameter variables */
-int buswidth = 0;			   /* 0 means use default, values 1,4 */
-int sdio_clock = 50000;		 /* kHz */
+int buswidth = 0;		/* 0 means use default, values 1,4 */
+int sdio_clock = 50000;		/* kHz */
 int unifi_debug = 0;
 /* fw_init prevents f/w initialisation on error. */
 int fw_init[MAX_UNIFI_DEVS] = {-1, -1};
 int use_5g = 0;
-int led_mask = 0;			   /* 0x0c00 for dev-pc-1503c, dev-pc-1528a */
+int led_mask = 0;		/* 0x0c00 for dev-pc-1503c, dev-pc-1528a */
 int disable_hw_reset = 0;
 int disable_power_control = 0;
-int enable_wol = UNIFI_WOL_OFF; /* 0 for none, 1 for SDIO IRQ, 2 for PIO */
+int enable_wol = UNIFI_WOL_OFF;	/* 0 for none, 1 for SDIO IRQ, 2 for PIO */
 #if (defined CSR_SUPPORT_SME) && (defined CSR_SUPPORT_WEXT)
 int tl_80211d = (int)CSR_WIFI_SME_80211D_TRUST_LEVEL_MIB;
 #endif
-int sdio_block_size = -1;	  /* Override SDIO block size */
-int sdio_byte_mode = 0;		/* 0 for block mode + padding, 1 for byte mode */
+int sdio_block_size = -1;	/* Override SDIO block size */
+int sdio_byte_mode = 0;	/* 0 for block mode + padding, 1 for byte mode */
 int coredump_max = CSR_WIFI_HIP_NUM_COREDUMP_BUFFERS;
-int run_bh_once = -1;		  /* Set for scheduled interrupt mode, -1 = default */
+int run_bh_once = -1;	/* Set for scheduled interrupt mode, -1 = default */
 int bh_priority = -1;
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
 #define UNIFI_LOG_HIP_SIGNALS_FILTER_BULKDATA   (1 << 1)
@@ -90,47 +90,48 @@ module_param(bh_priority, int, S_IRUGO|S_IWUSR);
 module_param(log_hip_signals, int, S_IRUGO|S_IWUSR);
 #endif
 
-MODULE_PARM_DESC(buswidth, "SDIO bus width (0=default), set 1 for 1-bit or 4 for 4-bit mode");
+MODULE_PARM_DESC(buswidth,
+	"SDIO bus width (0=default), set 1 for 1-bit or 4 for 4-bit mode");
 MODULE_PARM_DESC(sdio_clock, "SDIO bus frequency in kHz, (default = 50 MHz)");
 MODULE_PARM_DESC(unifi_debug, "Diagnostic reporting level");
 MODULE_PARM_DESC(fw_init, "Set to 0 to prevent f/w initialization on error");
 MODULE_PARM_DESC(use_5g, "Use the 5G (802.11a) radio band");
 MODULE_PARM_DESC(led_mask, "LED mask flags");
 MODULE_PARM_DESC(disable_hw_reset, "Set to 1 to disable hardware reset");
-MODULE_PARM_DESC(disable_power_control, "Set to 1 to disable SDIO power control");
-MODULE_PARM_DESC(enable_wol, "Enable wake-on-wlan function 0=off, 1=SDIO, 2=PIO");
+MODULE_PARM_DESC(disable_power_control,
+	"Set to 1 to disable SDIO power control");
+MODULE_PARM_DESC(enable_wol,
+	"Enable wake-on-wlan function 0=off, 1=SDIO, 2=PIO");
 #if (defined CSR_SUPPORT_SME) && (defined CSR_SUPPORT_WEXT)
 MODULE_PARM_DESC(tl_80211d, "802.11d Trust Level (1-6, default = 5)");
 #endif
 MODULE_PARM_DESC(sdio_block_size, "Set to override SDIO block size");
 MODULE_PARM_DESC(sdio_byte_mode, "Set to 1 for byte mode SDIO");
-MODULE_PARM_DESC(coredump_max, "Number of chip mini-coredump buffers to allocate");
+MODULE_PARM_DESC(coredump_max,
+	"Number of chip mini-coredump buffers to allocate");
 MODULE_PARM_DESC(run_bh_once, "Run BH only when firmware interrupts");
 MODULE_PARM_DESC(bh_priority, "Modify the BH thread priority");
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-MODULE_PARM_DESC(log_hip_signals, "Set to 1 to enable HIP signal offline logging");
+MODULE_PARM_DESC(log_hip_signals,
+	"Set to 1 to enable HIP signal offline logging");
 #endif
 
 
 /* Callback for event logging to UDI clients */
 static void udi_log_event(ul_client_t *client,
-						  const u8 *signal, int signal_len,
-						  const bulk_data_param_t *bulkdata,
-						  int dir);
+		const u8 *signal, int signal_len,
+		const bulk_data_param_t *bulkdata, int dir);
 
 static void udi_set_log_filter(ul_client_t *pcli,
-							   unifiio_filter_t *udi_filter);
-
+		unifiio_filter_t *udi_filter);
 
 /* Mutex to protect access to  priv->sme_cli */
 DEFINE_SEMAPHORE(udi_mutex);
 
-s32 CsrHipResultToStatus(CsrResult csrResult)
-{
+s32 CsrHipResultToStatus(CsrResult csrResult) {
 	s32 r = -EIO;
 
-	switch (csrResult)
-	{
+	switch (csrResult) {
 	case CSR_RESULT_SUCCESS:
 		r = 0;
 		break;
@@ -156,52 +157,51 @@ s32 CsrHipResultToStatus(CsrResult csrResult)
 		r = -EIO;
 		break;
 	default:
-		/*unifi_warning(card->ospriv, "CsrHipResultToStatus: Unrecognised csrResult error code: %d\n", csrResult);*/
+		/*unifi_warning(card->ospriv, 
+		 * "CsrHipResultToStatus: Unrecognised csrResult 
+		 * error code: %d\n", csrResult);*/
 		r = -EIO;
 	}
 	return r;
 }
 
 
-static const char*
-trace_putest_cmdid(unifi_putest_command_t putest_cmd)
-{
-	switch (putest_cmd)
-	{
-		case UNIFI_PUTEST_START:
-			return "START";
-		case UNIFI_PUTEST_STOP:
-			return "STOP";
-		case UNIFI_PUTEST_SET_SDIO_CLOCK:
-			return "SET CLOCK";
-		case UNIFI_PUTEST_CMD52_READ:
-			return "CMD52R";
-		case UNIFI_PUTEST_CMD52_BLOCK_READ:
-			return "CMD52BR";
-		case UNIFI_PUTEST_CMD52_WRITE:
-			return "CMD52W";
-		case UNIFI_PUTEST_DL_FW:
-			return "D/L FW";
-		case UNIFI_PUTEST_DL_FW_BUFF:
-			return "D/L FW BUFFER";
-		case UNIFI_PUTEST_COREDUMP_PREPARE:
-			return "PREPARE COREDUMP";
-		case UNIFI_PUTEST_GP_READ16:
-			return "GP16R";
-		case UNIFI_PUTEST_GP_WRITE16:
-			return "GP16W";
-		default:
-			return "ERROR: unrecognised command";
+static const char* trace_putest_cmdid(unifi_putest_command_t putest_cmd) {
+	switch (putest_cmd) {
+	case UNIFI_PUTEST_START:
+		return "START";
+	case UNIFI_PUTEST_STOP:
+		return "STOP";
+	case UNIFI_PUTEST_SET_SDIO_CLOCK:
+		return "SET CLOCK";
+	case UNIFI_PUTEST_CMD52_READ:
+		return "CMD52R";
+	case UNIFI_PUTEST_CMD52_BLOCK_READ:
+		return "CMD52BR";
+	case UNIFI_PUTEST_CMD52_WRITE:
+		return "CMD52W";
+	case UNIFI_PUTEST_DL_FW:
+		return "D/L FW";
+	case UNIFI_PUTEST_DL_FW_BUFF:
+		return "D/L FW BUFFER";
+	case UNIFI_PUTEST_COREDUMP_PREPARE:
+		return "PREPARE COREDUMP";
+	case UNIFI_PUTEST_GP_READ16:
+		return "GP16R";
+	case UNIFI_PUTEST_GP_WRITE16:
+		return "GP16W";
+	default:
+		return "ERROR: unrecognised command";
 	}
- }
+}
 
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-int uf_register_hip_offline_debug(unifi_priv_t *priv)
-{
+int uf_register_hip_offline_debug(unifi_priv_t *priv) {
 	ul_client_t *udi_cli;
 	int i;
 
-	udi_cli = ul_register_client(priv, CLI_USING_WIRE_FORMAT, udi_log_event);
+	udi_cli = ul_register_client(priv, CLI_USING_WIRE_FORMAT,
+		udi_log_event);
 	if (udi_cli == NULL) {
 		/* Too many clients already using this device */
 		unifi_error(priv, "Too many UDI clients already open\n");
@@ -222,11 +222,9 @@ int uf_register_hip_offline_debug(unifi_priv_t *priv)
 	return 0;
 }
 
-int uf_unregister_hip_offline_debug(unifi_priv_t *priv)
-{
+int uf_unregister_hip_offline_debug(unifi_priv_t *priv) {
 	ul_client_t *udi_cli = priv->logging_client;
-	if (udi_cli == NULL)
-	{
+	if (udi_cli == NULL) {
 		unifi_error(priv, "Unknown HIP client unregister request\n");
 		return -ERANGE;
 	}
@@ -244,7 +242,6 @@ int uf_unregister_hip_offline_debug(unifi_priv_t *priv)
 }
 #endif
 
-
 /*
  * ---------------------------------------------------------------------------
  *  unifi_open
@@ -259,9 +256,7 @@ int uf_unregister_hip_offline_debug(unifi_priv_t *priv)
  *	  Linux error code.
  * ---------------------------------------------------------------------------
  */
-static int
-unifi_open(struct inode *inode, struct file *file)
-{
+static int unifi_open(struct inode *inode, struct file *file) {
 	int devno;
 	unifi_priv_t *priv;
 	ul_client_t *udi_cli;
@@ -283,9 +278,11 @@ unifi_open(struct inode *inode, struct file *file)
 	}
 
 	/* Register this instance in the client's list. */
-	/* The minor number determines the nature of the client (Unicli or SME). */
+	/* The minor number determines the nature of the client
+	 * (Unicli or SME). */
 	if (MINOR(inode->i_rdev) & 0x1) {
-		udi_cli = ul_register_client(priv, CLI_USING_WIRE_FORMAT, udi_log_event);
+		udi_cli = ul_register_client(priv, CLI_USING_WIRE_FORMAT,
+			udi_log_event);
 		if (udi_cli == NULL) {
 			/* Too many clients already using this device */
 			unifi_error(priv, "Too many clients already open\n");
@@ -293,7 +290,8 @@ unifi_open(struct inode *inode, struct file *file)
 			func_exit();
 			return -ENOSPC;
 		}
-		unifi_trace(priv, UDBG1, "Client is registered to /dev/unifiudi%d\n", devno);
+		unifi_trace(priv, UDBG1,
+			"Client is registered to /dev/unifiudi%d\n", devno);
 	} else {
 		/*
 		 * Even-numbered device nodes are the control application.
@@ -317,13 +315,11 @@ unifi_open(struct inode *inode, struct file *file)
 
 #ifdef CSR_SUPPORT_SME
 		udi_cli = ul_register_client(priv,
-									 CLI_USING_WIRE_FORMAT | CLI_SME_USERSPACE,
-									 sme_log_event);
+			CLI_USING_WIRE_FORMAT | CLI_SME_USERSPACE,
+			sme_log_event);
 #else
 		/* Config client for native driver */
-		udi_cli = ul_register_client(priv,
-									 0,
-									 sme_native_log_event);
+		udi_cli = ul_register_client(priv, 0, sme_native_log_event);
 #endif
 		if (udi_cli == NULL) {
 			/* Too many clients already using this device */
@@ -340,17 +336,16 @@ unifi_open(struct inode *inode, struct file *file)
 		 * This is the SME userspace helper or unifi_manager.
 		 * Not used in the SME embedded version.
 		 */
-		unifi_trace(priv, UDBG1, "SME client (id:%d s:0x%X) is registered\n",
-					udi_cli->client_id, udi_cli->sender_id);
+		unifi_trace(priv, UDBG1,
+			"SME client (id:%d s:0x%X) is registered\n",
+			udi_cli->client_id, udi_cli->sender_id);
 		/* Store the SME UniFi Linux Client */
 		if (priv->sme_cli == NULL) {
 			priv->sme_cli = udi_cli;
 		}
-
 		up(&udi_mutex);
 	}
 
-
 	/*
 	 * Store the pointer to the client.
 	 * All char driver's entry points will pass this pointer.
@@ -362,9 +357,7 @@ unifi_open(struct inode *inode, struct file *file)
 } /* unifi_open() */
 
 
-static int
-unifi_release(struct inode *inode, struct file *filp)
-{
+static int unifi_release(struct inode *inode, struct file *filp) {
 	ul_client_t *udi_cli = (void*)filp->private_data;
 	int devno;
 	unifi_priv_t *priv;
@@ -373,23 +366,25 @@ unifi_release(struct inode *inode, struct file *filp)
 
 	priv = uf_find_instance(udi_cli->instance);
 	if (!priv) {
-		unifi_error(priv, "unifi_close: instance for device not found\n");
+		unifi_error(priv,
+			"unifi_close: instance for device not found\n");
 		return -ENODEV;
 	}
 
 	devno = MINOR(inode->i_rdev) >> 1;
 
-	/* Even device nodes are the config client (i.e. SME or unifi_manager) */
+	/* Even device nodes are the config client
+	 * (i.e. SME or unifi_manager) */
 	if ((MINOR(inode->i_rdev) & 0x1) == 0) {
-
 		if (priv->sme_cli != udi_cli) {
-			unifi_notice(priv, "Surprise closing config device: not the sme client\n");
+			unifi_notice(priv,
+				"Surprise closing config device: not the sme client\n");
 		}
 		unifi_notice(priv, "SME client close (unifi%d)\n", devno);
 
 		/*
-		 * Clear sme_cli before calling unifi_sys_... so it doesn't try to
-		 * queue a reply to the (now gone) SME.
+		 * Clear sme_cli before calling unifi_sys_...
+		 * so it doesn't try to queue a reply to the (now gone) SME.
 		 */
 		down(&udi_mutex);
 		priv->sme_cli = NULL;
@@ -398,24 +393,27 @@ unifi_release(struct inode *inode, struct file *filp)
 #ifdef CSR_SME_USERSPACE
 		/* Power-down when config client closes */
 		{
-			CsrWifiRouterCtrlWifiOffReq req = {{CSR_WIFI_ROUTER_CTRL_HIP_REQ, 0, 0, 0, NULL}};
+			CsrWifiRouterCtrlWifiOffReq req =
+			{{CSR_WIFI_ROUTER_CTRL_HIP_REQ, 0, 0, 0, NULL}};
 			CsrWifiRouterCtrlWifiOffReqHandler(priv, &req.common);
 		}
 
 		uf_sme_deinit(priv);
 
-	   /* It is possible that a blocking SME request was made from another process
-		* which did not get read by the SME before the WifiOffReq.
-		* So check for a pending request which will go unanswered and cancel
-		* the wait for event. As only one blocking request can be in progress at
-		* a time, up to one event should be completed.
-		*/
-	   uf_sme_cancel_request(priv, 0);
+		/* It is possible that a blocking SME request was made from
+		 * another process which did not get read by the SME before
+		 * the WifiOffReq.
+		 * So check for a pending request which will go unanswered
+		 * and cancel the wait for event. As only one blocking request
+		 * can be in progress at a time, up to one event should be
+		 * completed.
+		 */
+		uf_sme_cancel_request(priv, 0);
 
 #endif /* CSR_SME_USERSPACE */
 	} else {
-
-		unifi_trace(priv, UDBG2, "UDI client close (unifiudi%d)\n", devno);
+		unifi_trace(priv, UDBG2, "UDI client close (unifiudi%d)\n",
+			devno);
 
 		/* If the pointer matches the logging client, stop logging. */
 		down(&priv->udi_logging_mutex);
@@ -438,7 +436,6 @@ unifi_release(struct inode *inode, struct file *filp)
 } /* unifi_release() */
 
 
-
 /*
  * ---------------------------------------------------------------------------
  *  unifi_read
@@ -455,9 +452,8 @@ unifi_release(struct inode *inode, struct file *filp)
  *	  number of bytes read or an error code on failure
  * ---------------------------------------------------------------------------
  */
-static ssize_t
-unifi_read(struct file *filp, char *p, size_t len, loff_t *poff)
-{
+static ssize_t unifi_read(struct file *filp, char *p,
+	size_t len, loff_t *poff) {
 	ul_client_t *pcli = (void*)filp->private_data;
 	unifi_priv_t *priv;
 	udi_log_t *logptr = NULL;
@@ -480,14 +476,15 @@ unifi_read(struct file *filp, char *p, size_t len, loff_t *poff)
 
 	if (list_empty(&pcli->udi_log)) {
 		if (filp->f_flags & O_NONBLOCK) {
-			/* Non-blocking - just return if the udi_log is empty */
+			/* Non-blocking -
+			 * just return if the udi_log is empty */
 			return 0;
 		} else {
 			/* Blocking - wait on the UDI wait queue */
 			if (wait_event_interruptible(pcli->udi_wq,
-				!list_empty(&pcli->udi_log)))
-			{
-				unifi_error(priv, "unifi_read: wait_event_interruptible failed.");
+				!list_empty(&pcli->udi_log))) {
+				unifi_error(priv,
+					"unifi_read: wait_event_interruptible failed.");
 				return -ERESTARTSYS;
 			}
 		}
@@ -512,7 +509,8 @@ unifi_read(struct file *filp, char *p, size_t len, loff_t *poff)
 	msgptr = &logptr->msg;
 	msglen = msgptr->length;
 	if (msglen > len) {
-		printk(KERN_WARNING "truncated read to %d actual msg len is %lu\n", msglen, (long unsigned int)len);
+		printk(KERN_WARNING "truncated read to %d actual msg len is %lu\n",
+			msglen, (long unsigned int)len);
 		msglen = len;
 	}
 
@@ -533,7 +531,6 @@ unifi_read(struct file *filp, char *p, size_t len, loff_t *poff)
 } /* unifi_read() */
 
 
-
 /*
  * ---------------------------------------------------------------------------
  * udi_send_signal_unpacked
@@ -567,9 +564,9 @@ udi_send_signal_unpacked(unifi_priv_t *priv, unsigned char* data, uint data_len)
 	/* Number of bytes in the signal */
 	signal_size = SigGetSize(sigptr);
 	if (!signal_size || (signal_size > data_len)) {
-		unifi_error(priv, "unifi_sme_mlme_req - Invalid signal 0x%x size should be %d bytes\n",
-					sigptr->SignalPrimitiveHeader.SignalId,
-					signal_size);
+		unifi_error(priv,
+			"unifi_sme_mlme_req - Invalid signal 0x%x size should be %d bytes\n",
+			sigptr->SignalPrimitiveHeader.SignalId, signal_size);
 		return -EINVAL;
 	}
 	bytecount = signal_size;
@@ -577,23 +574,28 @@ udi_send_signal_unpacked(unifi_priv_t *priv, unsigned char* data, uint data_len)
 	/* Get a pointer to the information of the first data reference */
 	datarefptr = (CSR_DATAREF*)&sigptr->u;
 
-	/* Initialize the offset in the data buffer, bulk data is right after the signal. */
+	/* Initialize the offset in the data buffer,
+	 * bulk data is right after the signal. */
 	bulk_data_offset = signal_size;
 
-	/* store the references and the size of the bulk data to the bulkdata structure */
+	/* store the references and the size of the bulk data
+	 * to the bulkdata structure */
 	for (i = 0; i < UNIFI_MAX_DATA_REFERENCES; i++) {
 		/* the length of the bulk data is in the signal */
 		if ((datarefptr+i)->DataLength) {
 			void *dest;
 
-			csrResult = unifi_net_data_malloc(priv, &bulk_data.d[i], (datarefptr+i)->DataLength);
+			csrResult = unifi_net_data_malloc(priv,
+				&bulk_data.d[i], (datarefptr+i)->DataLength);
 			if (csrResult != CSR_RESULT_SUCCESS) {
-				unifi_error(priv, "udi_send_signal_unpacked: failed to allocate request_data.\n");
+				unifi_error(priv,
+					"udi_send_signal_unpacked: failed to allocate request_data.\n");
 				return -EIO;
 			}
 
 			dest = (void*)bulk_data.d[i].os_data_ptr;
-			memcpy(dest, data + bulk_data_offset, bulk_data.d[i].data_length);
+			memcpy(dest, data + bulk_data_offset,
+				bulk_data.d[i].data_length);
 		} else {
 			bulk_data.d[i].data_length = 0;
 		}
@@ -604,12 +606,14 @@ udi_send_signal_unpacked(unifi_priv_t *priv, unsigned char* data, uint data_len)
 	}
 
 
-	unifi_trace(priv, UDBG3, "SME Send: signal 0x%.4X\n", sigptr->SignalPrimitiveHeader.SignalId);
+	unifi_trace(priv, UDBG3, "SME Send: signal 0x%.4X\n",
+		sigptr->SignalPrimitiveHeader.SignalId);
 
 	/* Send the signal. */
 	r = ul_send_signal_unpacked(priv, sigptr, &bulk_data);
 	if (r < 0) {
-		unifi_error(priv, "udi_send_signal_unpacked: send failed (%d)\n", r);
+		unifi_error(priv,
+			"udi_send_signal_unpacked: send failed (%d)\n", r);
 		for(i=0;i<UNIFI_MAX_DATA_REFERENCES;i++) {
 			if(bulk_data.d[i].data_length != 0) {
 				unifi_net_data_free(priv, &bulk_data.d[i]);
@@ -643,9 +647,8 @@ udi_send_signal_unpacked(unifi_priv_t *priv, unsigned char* data, uint data_len)
  *	  must use the wire formatted structures.
  * ---------------------------------------------------------------------------
  */
-static int
-udi_send_signal_raw(unifi_priv_t *priv, unsigned char *buf, int buflen)
-{
+static int udi_send_signal_raw(unifi_priv_t *priv, unsigned char *buf,
+	int buflen) {
 	int signal_size;
 	int sig_id;
 	bulk_data_param_t data_ptrs;
@@ -666,13 +669,15 @@ udi_send_signal_raw(unifi_priv_t *priv, unsigned char *buf, int buflen)
 	signal_size -= GET_PACKED_DATAREF_LEN(buf, 0);
 	signal_size -= GET_PACKED_DATAREF_LEN(buf, 1);
 	if ((signal_size <= 0) || (signal_size > buflen)) {
-		unifi_error(priv, "udi_send_signal_raw - Couldn't find length of signal 0x%x\n",
-					sig_id);
+		unifi_error(priv,
+			"udi_send_signal_raw - Couldn't find length of signal 0x%x\n",
+			sig_id);
 		func_exit();
 		return -EINVAL;
 	}
-	unifi_trace(priv, UDBG2, "udi_send_signal_raw: signal 0x%.4X len:%d\n",
-				sig_id, signal_size);
+	unifi_trace(priv, UDBG2,
+		"udi_send_signal_raw: signal 0x%.4X len:%d\n",
+		sig_id, signal_size);
 	/* Zero the data ref arrays */
 	memset(&data_ptrs, 0, sizeof(data_ptrs));
 
@@ -684,17 +689,19 @@ udi_send_signal_raw(unifi_priv_t *priv, unsigned char *buf, int buflen)
 	num_data_refs = 0;
 	bytecount = signal_size;
 
-	for (i = 0; i < UNIFI_MAX_DATA_REFERENCES; ++i)
-	{
+	for (i = 0; i < UNIFI_MAX_DATA_REFERENCES; ++i)	{
 		unsigned int len = GET_PACKED_DATAREF_LEN(buf, i);
-		unifi_trace(priv, UDBG3, "udi_send_signal_raw: data_ref length = %d\n", len);
+		unifi_trace(priv, UDBG3,
+			"udi_send_signal_raw: data_ref length = %d\n", len);
 
 		if (len != 0) {
 			void *dest;
 
-			csrResult = unifi_net_data_malloc(priv, &data_ptrs.d[i], len);
+			csrResult = unifi_net_data_malloc(priv,
+				&data_ptrs.d[i], len);
 			if (csrResult != CSR_RESULT_SUCCESS) {
-				unifi_error(priv, "udi_send_signal_raw: failed to allocate request_data.\n");
+				unifi_error(priv,
+					"udi_send_signal_raw: failed to allocate request_data.\n");
 				return -EIO;
 			}
 
@@ -707,20 +714,24 @@ udi_send_signal_raw(unifi_priv_t *priv, unsigned char *buf, int buflen)
 		data_ptrs.d[i].data_length = len;
 	}
 
-	unifi_trace(priv, UDBG3, "Queueing signal 0x%.4X from UDI with %u data refs\n",
-		  sig_id,
-		  num_data_refs);
+	unifi_trace(priv, UDBG3,
+		"Queueing signal 0x%.4X from UDI with %u data refs\n",
+		sig_id, num_data_refs);
 
 	if (bytecount > buflen) {
-		unifi_error(priv, "udi_send_signal_raw: Not enough data (%d instead of %d)\n", buflen, bytecount);
+		unifi_error(priv,
+			"udi_send_signal_raw: Not enough data (%d instead of %d)\n",
+			buflen, bytecount);
 		func_exit();
 		return -EINVAL;
 	}
 
-	/* Send the signal calling the function that uses the wire-formatted signals. */
+	/* Send the signal calling the function that uses 
+	 * the wire-formatted signals. */
 	r = ul_send_signal_raw(priv, buf, signal_size, &data_ptrs);
 	if (r < 0) {
-		unifi_error(priv, "udi_send_signal_raw: send failed (%d)\n", r);
+		unifi_error(priv,
+			"udi_send_signal_raw: send failed (%d)\n", r);
 		func_exit();
 		return -EIO;
 	}
@@ -728,20 +739,22 @@ udi_send_signal_raw(unifi_priv_t *priv, unsigned char *buf, int buflen)
 #ifdef CSR_NATIVE_LINUX
 	if (sig_id == CSR_MLME_POWERMGT_REQUEST_ID) {
 		int power_mode = CSR_GET_UINT16_FROM_LITTLE_ENDIAN((buf +
-											  SIZEOF_SIGNAL_HEADER + (UNIFI_MAX_DATA_REFERENCES*SIZEOF_DATAREF)));
+			SIZEOF_SIGNAL_HEADER +
+			(UNIFI_MAX_DATA_REFERENCES*SIZEOF_DATAREF)));
 #ifdef CSR_SUPPORT_WEXT
 		/* Overide the wext power mode to the new value */
 		priv->wext_conf.power_mode = power_mode;
 #endif
 		/* Configure deep sleep signaling */
-		if (power_mode || (priv->interfacePriv[0]->connected == UnifiNotConnected)) {
+		if (power_mode || (priv->interfacePriv[0]->connected ==
+			UnifiNotConnected)) {
 			csrResult = unifi_configure_low_power_mode(priv->card,
-												   UNIFI_LOW_POWER_ENABLED,
-												   UNIFI_PERIODIC_WAKE_HOST_DISABLED);
+				UNIFI_LOW_POWER_ENABLED,
+				UNIFI_PERIODIC_WAKE_HOST_DISABLED);
 		} else {
 			csrResult = unifi_configure_low_power_mode(priv->card,
-												   UNIFI_LOW_POWER_DISABLED,
-												   UNIFI_PERIODIC_WAKE_HOST_DISABLED);
+				UNIFI_LOW_POWER_DISABLED,
+				UNIFI_PERIODIC_WAKE_HOST_DISABLED);
 		}
 	}
 #endif
@@ -771,9 +784,8 @@ udi_send_signal_raw(unifi_priv_t *priv, unsigned char *buf, int buflen)
  *	  number of bytes written or an error code on failure
  * ---------------------------------------------------------------------------
  */
-static ssize_t
-unifi_write(struct file *filp, const char *p, size_t len, loff_t *poff)
-{
+static ssize_t unifi_write(struct file *filp, const char *p, size_t len,
+	loff_t *poff) {
 	ul_client_t *pcli = (ul_client_t*)filp->private_data;
 	unifi_priv_t *priv;
 	unsigned char *buf;
@@ -811,7 +823,8 @@ unifi_write(struct file *filp, const char *p, size_t len, loff_t *poff)
 
 		csrResult = unifi_net_data_malloc(priv, &bulkdata.d[0], len);
 		if (csrResult != CSR_RESULT_SUCCESS) {
-			unifi_error(priv, "unifi_write: failed to allocate request_data.\n");
+			unifi_error(priv,
+				"unifi_write: failed to allocate request_data.\n");
 			func_exit();
 			return -ENOMEM;
 		}
@@ -820,7 +833,8 @@ unifi_write(struct file *filp, const char *p, size_t len, loff_t *poff)
 
 		/* Get the data from the AMP client. */
 		if (copy_from_user((void*)user_data_buf, p, len)) {
-			unifi_error(priv, "unifi_write: copy from user failed\n");
+			unifi_error(priv,
+				"unifi_write: copy from user failed\n");
 			unifi_net_data_free(priv, &bulkdata.d[0]);
 			func_exit();
 			return -EFAULT;
@@ -832,18 +846,22 @@ unifi_write(struct file *filp, const char *p, size_t len, loff_t *poff)
 		/* Number of bytes in the signal */
 		sig_id = GET_SIGNAL_ID(bulkdata.d[0].os_data_ptr);
 		signal_size = len;
-		signal_size -= GET_PACKED_DATAREF_LEN(bulkdata.d[0].os_data_ptr, 0);
-		signal_size -= GET_PACKED_DATAREF_LEN(bulkdata.d[0].os_data_ptr, 1);
+		signal_size -=
+			GET_PACKED_DATAREF_LEN(bulkdata.d[0].os_data_ptr, 0);
+		signal_size -=
+			GET_PACKED_DATAREF_LEN(bulkdata.d[0].os_data_ptr, 1);
 		if ((signal_size <= 0) || (signal_size > len)) {
-			unifi_error(priv, "unifi_write - Couldn't find length of signal 0x%x\n",
-						sig_id);
+			unifi_error(priv,
+				"unifi_write - Couldn't find length of signal 0x%x\n",
+				sig_id);
 			unifi_net_data_free(priv, &bulkdata.d[0]);
 			func_exit();
 			return -EINVAL;
 		}
 
-		unifi_trace(priv, UDBG2, "unifi_write: signal 0x%.4X len:%d\n",
-					sig_id, signal_size);
+		unifi_trace(priv, UDBG2,
+			"unifi_write: signal 0x%.4X len:%d\n",
+			sig_id, signal_size);
 
 		/* Allocate a buffer for the signal */
 		signal_buf = kmalloc(signal_size, GFP_KERNEL);
@@ -866,10 +884,13 @@ unifi_write(struct file *filp, const char *p, size_t len, loff_t *poff)
 			bulkdata.d[0].os_data_ptr = NULL;
 		}
 
-		/* Send the signal calling the function that uses the wire-formatted signals. */
-		r = ul_send_signal_raw(priv, signal_buf, signal_size, &bulkdata);
+		/* Send the signal calling the function that uses
+		 * the wire-formatted signals. */
+		r = ul_send_signal_raw(priv, signal_buf, signal_size,
+			&bulkdata);
 		if (r < 0) {
-			unifi_error(priv, "unifi_write: send failed (%d)\n", r);
+			unifi_error(priv,
+				"unifi_write: send failed (%d)\n", r);
 			if (bulkdata.d[0].os_data_ptr != NULL) {
 				unifi_net_data_free(priv, &bulkdata.d[0]);
 			}
@@ -894,9 +915,10 @@ unifi_write(struct file *filp, const char *p, size_t len, loff_t *poff)
 
 	/*
 	 * In SME userspace build read() contains a SYS or MGT message.
-	 * Note that even though the SME sends one signal at a time, we can not
-	 * use unifi_net_data_malloc because in the early stages, before having
-	 * initialised the core, it will fail since the I/O block size is unknown.
+	 * Note that even though the SME sends one signal at a time,
+	 * we can not use unifi_net_data_malloc because in the early
+	 * stages, before having initialised the core, it will fail
+	 * since the I/O block size is unknown.
 	 */
 #ifdef CSR_SME_USERSPACE
 	if (pcli->configuration & CLI_SME_USERSPACE) {
@@ -906,10 +928,12 @@ unifi_write(struct file *filp, const char *p, size_t len, loff_t *poff)
 	}
 #endif
 
-	/* ul_send_signal_raw will  do a sanity check of len against signal content */
+	/* ul_send_signal_raw will  do a sanity check of len against
+	 * signal content */
 
 	/*
-	 * udi_send_signal_raw() and udi_send_signal_unpacked() return the number of bytes consumed.
+	 * udi_send_signal_raw() and udi_send_signal_unpacked() return
+	 * the number of bytes consumed.
 	 * A write call can pass multiple signal concatenated together.
 	 */
 	bytes_written = 0;
-- 
1.7.9.5

