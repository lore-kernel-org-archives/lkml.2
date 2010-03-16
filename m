Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965989Ab0CPCcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:32:05 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56860 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937407Ab0CPCbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:31:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=u7U9kTo98n/WGUI0PRAaB0mYjNohIntSW19+PjUp8Fg5+oM5ZOKLBioo6OyRzIGKSg
         LF5uEOdGc860+UkaVhyihM2kstkCp1LTRXqj1kt6m8fRp/sve7Yxl0/6eV0VfGgJ6PZB
         WqEaPmmIDBBGmW3/Fm2HAcruPyE0/LmrOf1hM=
From: ehames@gmail.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Edgardo Hames <ehames@gmail.com>
Subject: [PATCH 1/2] Staging: wlan-ng: fix coding style in hfa834x_usb.c
Date: Mon, 15 Mar 2010 23:00:39 -0300
Message-Id: <1268704840-7166-1-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edgardo Hames <ehames@gmail.com>

This is a patch in hfa834x_usb.c to fix typedef declarations and long lines.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |  159 +++++++++++++++++----------------
 1 files changed, 81 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 5df56f0..2400242 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -62,9 +62,9 @@
 *
 * hfa384x_drvr_xxxconfig  An example of the drvr level abstraction. These
 *			functions are wrappers for the RID get/set
-*			sequence. They 	call copy_[to|from]_bap() and
-*			cmd_access().	These functions operate on the
-*			RIDs and buffers without validation.  The caller
+*			sequence. They call copy_[to|from]_bap() and
+*			cmd_access(). These functions operate on the
+*			RIDs and buffers without validation. The caller
 *			is responsible for that.
 *
 * API wrapper functions:
@@ -144,7 +144,6 @@ enum cmd_mode {
 	DOWAIT = 0,
 	DOASYNC
 };
-typedef enum cmd_mode CMD_MODE;
 
 #define THROTTLE_JIFFIES	(HZ/8)
 #define URB_ASYNC_UNLINK 0
@@ -206,12 +205,11 @@ static void unlocked_usbctlx_complete(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx);
 struct usbctlx_completor {
 	int (*complete) (struct usbctlx_completor *);
 };
-typedef struct usbctlx_completor usbctlx_completor_t;
 
 static int
 hfa384x_usbctlx_complete_sync(hfa384x_t *hw,
 			      hfa384x_usbctlx_t *ctlx,
-			      usbctlx_completor_t *completor);
+			      struct usbctlx_completor *completor);
 
 static int
 unlocked_usbctlx_cancel_async(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx);
@@ -232,13 +230,13 @@ usbctlx_get_rridresult(const hfa384x_usb_rridresp_t *rridresp,
 /* Low level req/resp CTLX formatters and submitters */
 static int
 hfa384x_docmd(hfa384x_t *hw,
-	      CMD_MODE mode,
+	      enum cmd_mode mode,
 	      hfa384x_metacmd_t *cmd,
 	      ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data);
 
 static int
 hfa384x_dorrid(hfa384x_t *hw,
-	       CMD_MODE mode,
+	       enum cmd_mode mode,
 	       u16 rid,
 	       void *riddata,
 	       unsigned int riddatalen,
@@ -246,7 +244,7 @@ hfa384x_dorrid(hfa384x_t *hw,
 
 static int
 hfa384x_dowrid(hfa384x_t *hw,
-	       CMD_MODE mode,
+	       enum cmd_mode mode,
 	       u16 rid,
 	       void *riddata,
 	       unsigned int riddatalen,
@@ -254,7 +252,7 @@ hfa384x_dowrid(hfa384x_t *hw,
 
 static int
 hfa384x_dormem(hfa384x_t *hw,
-	       CMD_MODE mode,
+	       enum cmd_mode mode,
 	       u16 page,
 	       u16 offset,
 	       void *data,
@@ -263,7 +261,7 @@ hfa384x_dormem(hfa384x_t *hw,
 
 static int
 hfa384x_dowmem(hfa384x_t *hw,
-	       CMD_MODE mode,
+	       enum cmd_mode mode,
 	       u16 page,
 	       u16 offset,
 	       void *data,
@@ -351,7 +349,8 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
 	hw->rx_urb_skb = skb;
 
 	result = -ENOLINK;
-	if (!hw->wlandev->hwremoved && !test_bit(WORK_RX_HALT, &hw->usb_flags)) {
+	if (!hw->wlandev->hwremoved &&
+			!test_bit(WORK_RX_HALT, &hw->usb_flags)) {
 		result = SUBMIT_URB(&hw->rx_urb, memflags);
 
 		/* Check whether we need to reset the RX pipe */
@@ -451,7 +450,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
 	if (test_bit(WORK_RX_HALT, &hw->usb_flags)) {
 		int ret;
 
-		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock! */
+		usb_kill_urb(&hw->rx_urb); /* Cannot be holding spinlock! */
 
 		ret = usb_clear_halt(hw->usb, hw->endp_in);
 		if (ret != 0) {
@@ -668,26 +667,26 @@ usbctlx_get_rridresult(const hfa384x_usb_rridresp_t *rridresp,
 * when processing a CTLX that returns a hfa384x_cmdresult_t structure.
 ----------------------------------------------------------------*/
 struct usbctlx_cmd_completor {
-	usbctlx_completor_t head;
+	struct usbctlx_completor head;
 
 	const hfa384x_usb_cmdresp_t *cmdresp;
 	hfa384x_cmdresult_t *result;
 };
-typedef struct usbctlx_cmd_completor usbctlx_cmd_completor_t;
 
-static int usbctlx_cmd_completor_fn(usbctlx_completor_t *head)
+static inline int usbctlx_cmd_completor_fn(struct usbctlx_completor *head)
 {
-	usbctlx_cmd_completor_t *complete = (usbctlx_cmd_completor_t *) head;
+	struct usbctlx_cmd_completor *complete;
+
+	complete = (struct usbctlx_cmd_completor *) head;
 	return usbctlx_get_status(complete->cmdresp, complete->result);
 }
 
-static inline usbctlx_completor_t *init_cmd_completor(usbctlx_cmd_completor_t *
-						      completor,
-						      const
-						      hfa384x_usb_cmdresp_t *
-						      cmdresp,
-						      hfa384x_cmdresult_t *
-						      result)
+static inline struct usbctlx_completor *init_cmd_completor(
+						struct usbctlx_cmd_completor
+							*completor,
+						const hfa384x_usb_cmdresp_t
+							*cmdresp,
+						hfa384x_cmdresult_t *result)
 {
 	completor->head.complete = usbctlx_cmd_completor_fn;
 	completor->cmdresp = cmdresp;
@@ -701,19 +700,19 @@ static inline usbctlx_completor_t *init_cmd_completor(usbctlx_cmd_completor_t *
 * when processing a CTLX that reads a RID.
 ----------------------------------------------------------------*/
 struct usbctlx_rrid_completor {
-	usbctlx_completor_t head;
+	struct usbctlx_completor head;
 
 	const hfa384x_usb_rridresp_t *rridresp;
 	void *riddata;
 	unsigned int riddatalen;
 };
-typedef struct usbctlx_rrid_completor usbctlx_rrid_completor_t;
 
-static int usbctlx_rrid_completor_fn(usbctlx_completor_t *head)
+static int usbctlx_rrid_completor_fn(struct usbctlx_completor *head)
 {
-	usbctlx_rrid_completor_t *complete = (usbctlx_rrid_completor_t *) head;
+	struct usbctlx_rrid_completor *complete;
 	hfa384x_rridresult_t rridresult;
 
+	complete = (struct usbctlx_rrid_completor *) head;
 	usbctlx_get_rridresult(complete->rridresp, &rridresult);
 
 	/* Validate the length, note body len calculation in bytes */
@@ -729,12 +728,13 @@ static int usbctlx_rrid_completor_fn(usbctlx_completor_t *head)
 	return 0;
 }
 
-static inline usbctlx_completor_t *init_rrid_completor(usbctlx_rrid_completor_t
-						       *completor,
-						       const
-						       hfa384x_usb_rridresp_t *
-						       rridresp, void *riddata,
-						       unsigned int riddatalen)
+static inline struct usbctlx_completor *init_rrid_completor(
+						struct usbctlx_rrid_completor
+							*completor,
+						const hfa384x_usb_rridresp_t
+							*rridresp,
+						void *riddata,
+						unsigned int riddatalen)
 {
 	completor->head.complete = usbctlx_rrid_completor_fn;
 	completor->rridresp = rridresp;
@@ -747,14 +747,14 @@ static inline usbctlx_completor_t *init_rrid_completor(usbctlx_rrid_completor_t
 * Completor object:
 * Interprets the results of a synchronous RID-write
 ----------------------------------------------------------------*/
-typedef usbctlx_cmd_completor_t usbctlx_wrid_completor_t;
+typedef struct usbctlx_cmd_completor usbctlx_wrid_completor_t;
 #define init_wrid_completor  init_cmd_completor
 
 /*----------------------------------------------------------------
 * Completor object:
 * Interprets the results of a synchronous memory-write
 ----------------------------------------------------------------*/
-typedef usbctlx_cmd_completor_t usbctlx_wmem_completor_t;
+typedef struct usbctlx_cmd_completor usbctlx_wmem_completor_t;
 #define init_wmem_completor  init_cmd_completor
 
 /*----------------------------------------------------------------
@@ -762,7 +762,7 @@ typedef usbctlx_cmd_completor_t usbctlx_wmem_completor_t;
 * Interprets the results of a synchronous memory-read
 ----------------------------------------------------------------*/
 struct usbctlx_rmem_completor {
-	usbctlx_completor_t head;
+	struct usbctlx_completor head;
 
 	const hfa384x_usb_rmemresp_t *rmemresp;
 	void *data;
@@ -770,7 +770,7 @@ struct usbctlx_rmem_completor {
 };
 typedef struct usbctlx_rmem_completor usbctlx_rmem_completor_t;
 
-static int usbctlx_rmem_completor_fn(usbctlx_completor_t *head)
+static int usbctlx_rmem_completor_fn(struct usbctlx_completor *head)
 {
 	usbctlx_rmem_completor_t *complete = (usbctlx_rmem_completor_t *) head;
 
@@ -779,11 +779,13 @@ static int usbctlx_rmem_completor_fn(usbctlx_completor_t *head)
 	return 0;
 }
 
-static inline usbctlx_completor_t *init_rmem_completor(usbctlx_rmem_completor_t
-						       *completor,
-						       hfa384x_usb_rmemresp_t
-						       *rmemresp, void *data,
-						       unsigned int len)
+static inline struct usbctlx_completor *init_rmem_completor(
+						usbctlx_rmem_completor_t
+							*completor,
+						hfa384x_usb_rmemresp_t
+							*rmemresp,
+						void *data,
+						unsigned int len)
 {
 	completor->head.complete = usbctlx_rmem_completor_fn;
 	completor->rmemresp = rmemresp;
@@ -1226,7 +1228,7 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 *
 * Arguments:
 *	hw		device structure
-*	ctlx	 	CTLX ptr
+*	ctlx		CTLX ptr
 *	completor	functor object to decide what to
 *			do with the CTLX's result.
 *
@@ -1244,7 +1246,7 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 ----------------------------------------------------------------*/
 static int hfa384x_usbctlx_complete_sync(hfa384x_t *hw,
 					 hfa384x_usbctlx_t *ctlx,
-					 usbctlx_completor_t *completor)
+					 struct usbctlx_completor *completor)
 {
 	unsigned long flags;
 	int result;
@@ -1359,7 +1361,7 @@ cleanup:
 ----------------------------------------------------------------*/
 static int
 hfa384x_docmd(hfa384x_t *hw,
-	      CMD_MODE mode,
+	      enum cmd_mode mode,
 	      hfa384x_metacmd_t *cmd,
 	      ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data)
 {
@@ -1394,7 +1396,7 @@ hfa384x_docmd(hfa384x_t *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_cmd_completor_t completor;
+		struct usbctlx_cmd_completor completor;
 
 		result =
 		    hfa384x_usbctlx_complete_sync(hw, ctlx,
@@ -1448,7 +1450,7 @@ done:
 ----------------------------------------------------------------*/
 static int
 hfa384x_dorrid(hfa384x_t *hw,
-	       CMD_MODE mode,
+	       enum cmd_mode mode,
 	       u16 rid,
 	       void *riddata,
 	       unsigned int riddatalen,
@@ -1481,7 +1483,7 @@ hfa384x_dorrid(hfa384x_t *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_rrid_completor_t completor;
+		struct usbctlx_rrid_completor completor;
 
 		result =
 		    hfa384x_usbctlx_complete_sync(hw, ctlx,
@@ -1506,7 +1508,7 @@ done:
 *
 * Arguments:
 *	hw		device structure
-*	CMD_MODE	DOWAIT or DOASYNC
+*	enum cmd_mode	DOWAIT or DOASYNC
 *	rid		RID code
 *	riddata		Data portion of RID formatted for MAC
 *	riddatalen	Length of the data portion in bytes
@@ -1529,7 +1531,7 @@ done:
 ----------------------------------------------------------------*/
 static int
 hfa384x_dowrid(hfa384x_t *hw,
-	       CMD_MODE mode,
+	       enum cmd_mode mode,
 	       u16 rid,
 	       void *riddata,
 	       unsigned int riddatalen,
@@ -1616,7 +1618,7 @@ done:
 ----------------------------------------------------------------*/
 static int
 hfa384x_dormem(hfa384x_t *hw,
-	       CMD_MODE mode,
+	       enum cmd_mode mode,
 	       u16 page,
 	       u16 offset,
 	       void *data,
@@ -1707,7 +1709,7 @@ done:
 ----------------------------------------------------------------*/
 static int
 hfa384x_dowmem(hfa384x_t *hw,
-	       CMD_MODE mode,
+	       enum cmd_mode mode,
 	       u16 page,
 	       u16 offset,
 	       void *data,
@@ -2075,12 +2077,9 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 			    (j * HFA384x_USB_RWMEM_MAXLEN);
 
 			writepage = HFA384x_ADDR_CMD_MKPAGE(dlbufaddr +
-							    (j *
-							     HFA384x_USB_RWMEM_MAXLEN));
-			writeoffset =
-			    HFA384x_ADDR_CMD_MKOFF(dlbufaddr +
-						   (j *
-						    HFA384x_USB_RWMEM_MAXLEN));
+						(j * HFA384x_USB_RWMEM_MAXLEN));
+			writeoffset = HFA384x_ADDR_CMD_MKOFF(dlbufaddr +
+						(j * HFA384x_USB_RWMEM_MAXLEN));
 
 			writelen = burnlen - (j * HFA384x_USB_RWMEM_MAXLEN);
 			writelen = writelen > HFA384x_USB_RWMEM_MAXLEN ?
@@ -2133,7 +2132,7 @@ exit_proc:
 *	0		success
 *	>0		f/w reported error - f/w status code
 *	<0		driver reported error
-*	-ENODATA 	length mismatch between argument and retrieved
+*	-ENODATA	length mismatch between argument and retrieved
 *			record.
 *
 * Side effects:
@@ -2451,7 +2450,9 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 		currpage = HFA384x_ADDR_CMD_MKPAGE(pdaloc[i].cardaddr);
 		curroffset = HFA384x_ADDR_CMD_MKOFF(pdaloc[i].cardaddr);
 
-		result = hfa384x_dormem_wait(hw, currpage, curroffset, buf, len);	/* units of bytes */
+		/* units of bytes */
+		result = hfa384x_dormem_wait(hw, currpage, curroffset, buf,
+						len);
 
 		if (result) {
 			printk(KERN_WARNING
@@ -2611,20 +2612,19 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	if (result1 != 0) {
 		if (result2 != 0) {
 			printk(KERN_ERR
-			       "cmd_initialize() failed on two attempts, results %d and %d\n",
-			       result1, result2);
+				"cmd_initialize() failed on two attempts,"
+				" results %d and %d\n", result1, result2);
 			usb_kill_urb(&hw->rx_urb);
 			goto done;
 		} else {
 			pr_debug("First cmd_initialize() failed (result %d),\n",
 				 result1);
-			pr_debug
-			    ("but second attempt succeeded. All should be ok\n");
+			pr_debug("but second attempt succeeded."
+				 " All should be ok\n");
 		}
 	} else if (result2 != 0) {
-		printk(KERN_WARNING
-		       "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
-		       result2);
+		printk(KERN_WARNING "First cmd_initialize() succeeded,"
+			" but second attempt failed (result=%d)\n", result2);
 		printk(KERN_WARNING
 		       "Most likely the card will be functional\n");
 		goto done;
@@ -3382,8 +3382,9 @@ retry:
 			 * our request has been acknowledged. Odd,
 			 * but our OUT URB is still alive...
 			 */
-			pr_debug
-			    ("Causality violation: please reboot Universe, or email linux-wlan-devel@lists.linux-wlan.com\n");
+			pr_debug("Causality violation: "
+				 "please reboot Universe, or email "
+				 "linux-wlan-devel@lists.linux-wlan.com\n");
 			ctlx->state = CTLX_RESP_COMPLETE;
 			break;
 
@@ -3442,7 +3443,7 @@ static void hfa384x_usbin_txcompl(wlandevice_t *wlandev,
 {
 	u16 status;
 
-	status = le16_to_cpu(usbin->type);	/* yeah I know it says type... */
+	status = le16_to_cpu(usbin->type); /* yeah I know it says type... */
 
 	/* Was there an error? */
 	if (HFA384x_TXSTATUS_ISERROR(status))
@@ -3583,7 +3584,7 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 	struct sk_buff *skb;
 	hfa384x_t *hw = wlandev->priv;
 
-	/* Don't forget the status, time, and data_len fields are in host order */
+	/* Remember the status, time, and data_len fields are in host order */
 	/* Figure out how big the frame is */
 	fc = le16_to_cpu(rxdesc->frame_control);
 	hdrlen = p80211_headerlen(fc);
@@ -3632,7 +3633,8 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		caphdr->encoding = htonl(1);	/* cck */
 	}
 
-	/* Copy the 802.11 header to the skb (ctl frames may be less than a full header) */
+	/* Copy the 802.11 header to the skb
+	   (ctl frames may be less than a full header) */
 	datap = skb_put(skb, hdrlen);
 	memcpy(datap, &(rxdesc->frame_control), hdrlen);
 
@@ -3644,7 +3646,8 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		/* check for unencrypted stuff if WEP bit set. */
 		if (*(datap - hdrlen + 1) & 0x40)	/* wep set */
 			if ((*(datap) == 0xaa) && (*(datap + 1) == 0xaa))
-				*(datap - hdrlen + 1) &= 0xbf;	/* clear wep; it's the 802.2 header! */
+				/* clear wep; it's the 802.2 header! */
+				*(datap - hdrlen + 1) &= 0xbf;
 	}
 
 	if (hw->sniff_fcs) {
@@ -3845,10 +3848,10 @@ retry:
 
 		default:
 			/* This is NOT a valid CTLX "success" state! */
-			printk(KERN_ERR
-			       "Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
-			       le16_to_cpu(ctlx->outbuf.type),
-			       ctlxstr(ctlx->state), urb->status);
+			printk(KERN_ERR "Illegal CTLX[%d]"
+				" success state(%s, %d) in OUT URB\n",
+				le16_to_cpu(ctlx->outbuf.type),
+				ctlxstr(ctlx->state), urb->status);
 			break;
 		}		/* switch */
 	} else {
-- 
1.6.3.3

