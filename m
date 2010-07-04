Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0GDBqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 21:46:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36483 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab0GDBqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 21:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MPaCKK3ygnDVaePg5it/rB0gn0zFJsQIGjIQJ4VNero1jOxbZT7h2DKCZbcccoGtno
         IlR2eqZHdzK1Hu1ODcV5BaKX7QWBonQSANiZtQBfk8+7ukIb3XmvFeNVMzgYXBsH1MkD
         ppDjVXo2Z9ZoEZGBvJyUqaSZgY8X8qVv1+6k8=
From: Edgardo Hames <ehames@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH 2/2] Staging: wlan-ng: fix checkpatch warnings.
Date: Sat,  3 Jul 2010 22:46:26 -0300
Message-Id: <1278207986-14309-2-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278207986-14309-1-git-send-email-ehames@gmail.com>
References: <1278207986-14309-1-git-send-email-ehames@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed long lines, removed typedef and NULL check.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   99 +++++++++++++++++----------------
 drivers/staging/wlan-ng/prism2fw.c    |   10 ++-
 2 files changed, 57 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 25bfb42..a21cfa9 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -175,7 +175,8 @@ hfa384x_usbin_txcompl(wlandevice_t *wlandev, union hfa384x_usbin * usbin);
 
 static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb);
 
-static void hfa384x_usbin_info(wlandevice_t *wlandev, union hfa384x_usbin * usbin);
+static void hfa384x_usbin_info(wlandevice_t *wlandev,
+			       union hfa384x_usbin *usbin);
 
 static void
 hfa384x_usbout_tx(wlandevice_t *wlandev, union hfa384x_usbout *usbout);
@@ -198,9 +199,11 @@ static void hfa384x_usbctlx_completion_task(unsigned long data);
 
 static void hfa384x_usbctlx_reaper_task(unsigned long data);
 
-static int hfa384x_usbctlx_submit(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx);
+static int hfa384x_usbctlx_submit(struct hfa384x *hw,
+				  struct hfa384x_usbctlx *ctlx);
 
-static void unlocked_usbctlx_complete(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx);
+static void unlocked_usbctlx_complete(struct hfa384x *hw,
+				      struct hfa384x_usbctlx *ctlx);
 
 struct usbctlx_completor {
 	int (*complete) (struct usbctlx_completor *);
@@ -214,9 +217,11 @@ hfa384x_usbctlx_complete_sync(struct hfa384x *hw,
 static int
 unlocked_usbctlx_cancel_async(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx);
 
-static void hfa384x_cb_status(struct hfa384x *hw, const struct hfa384x_usbctlx *ctlx);
+static void hfa384x_cb_status(struct hfa384x *hw,
+			      const struct hfa384x_usbctlx *ctlx);
 
-static void hfa384x_cb_rrid(struct hfa384x *hw, const struct hfa384x_usbctlx *ctlx);
+static void hfa384x_cb_rrid(struct hfa384x *hw,
+			    const struct hfa384x_usbctlx *ctlx);
 
 static int
 usbctlx_get_status(const struct hfa384x_usb_statusresp *cmdresp,
@@ -612,10 +617,8 @@ void hfa384x_destroy(struct hfa384x *hw)
 		hfa384x_drvr_stop(hw);
 	hw->state = HFA384x_STATE_PREINIT;
 
-	if (hw->scanresults) {
-		kfree(hw->scanresults);
-		hw->scanresults = NULL;
-	}
+	kfree(hw->scanresults);
+	hw->scanresults = NULL;
 
 	/* Now to clean out the auth queue */
 	while ((skb = skb_dequeue(&hw->authq)))
@@ -681,12 +684,13 @@ static inline int usbctlx_cmd_completor_fn(struct usbctlx_completor *head)
 	return usbctlx_get_status(complete->cmdresp, complete->result);
 }
 
-static inline struct usbctlx_completor *init_cmd_completor(
-						struct usbctlx_cmd_completor
-							*completor,
-						const struct hfa384x_usb_statusresp
-							*cmdresp,
-						struct hfa384x_statusresult *result)
+static inline
+struct usbctlx_completor *init_cmd_completor(struct usbctlx_cmd_completor
+						*completor,
+					     const struct hfa384x_usb_statusresp
+						*cmdresp,
+					     struct hfa384x_statusresult
+						*result)
 {
 	completor->head.complete = usbctlx_cmd_completor_fn;
 	completor->cmdresp = cmdresp;
@@ -728,13 +732,13 @@ static int usbctlx_rrid_completor_fn(struct usbctlx_completor *head)
 	return 0;
 }
 
-static inline struct usbctlx_completor *init_rrid_completor(
-						struct usbctlx_rrid_completor
-							*completor,
-						const struct hfa384x_usb_rridresp
-							*rridresp,
-						void *riddata,
-						unsigned int riddatalen)
+static inline
+struct usbctlx_completor *init_rrid_completor(struct usbctlx_rrid_completor
+						*completor,
+					      const struct hfa384x_usb_rridresp
+						*rridresp,
+					      void *riddata,
+					      unsigned int riddatalen)
 {
 	completor->head.complete = usbctlx_rrid_completor_fn;
 	completor->rridresp = rridresp;
@@ -743,18 +747,8 @@ static inline struct usbctlx_completor *init_rrid_completor(
 	return &(completor->head);
 }
 
-/*----------------------------------------------------------------
-* Completor object:
-* Interprets the results of a synchronous RID-write
-----------------------------------------------------------------*/
-typedef struct usbctlx_cmd_completor usbctlx_wrid_completor_t;
 #define init_wrid_completor  init_cmd_completor
 
-/*----------------------------------------------------------------
-* Completor object:
-* Interprets the results of a synchronous memory-write
-----------------------------------------------------------------*/
-typedef struct usbctlx_cmd_completor usbctlx_wmem_completor_t;
 #define init_wmem_completor  init_cmd_completor
 
 /*----------------------------------------------------------------
@@ -768,11 +762,10 @@ struct usbctlx_rmem_completor {
 	void *data;
 	unsigned int len;
 };
-typedef struct usbctlx_rmem_completor usbctlx_rmem_completor_t;
 
 static int usbctlx_rmem_completor_fn(struct usbctlx_completor *head)
 {
-	usbctlx_rmem_completor_t *complete = (usbctlx_rmem_completor_t *) head;
+	struct usbctlx_rmem_completor *complete = (struct usbctlx_rmem_completor *) head;
 
 	pr_debug("rmemresp:len=%d\n", complete->rmemresp->frmlen);
 	memcpy(complete->data, complete->rmemresp->data, complete->len);
@@ -780,7 +773,7 @@ static int usbctlx_rmem_completor_fn(struct usbctlx_completor *head)
 }
 
 static inline struct usbctlx_completor *init_rmem_completor(
-						usbctlx_rmem_completor_t
+						struct usbctlx_rmem_completor
 							*completor,
 						struct hfa384x_usb_rmemresp
 							*rmemresp,
@@ -815,7 +808,8 @@ static inline struct usbctlx_completor *init_rmem_completor(
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-static void hfa384x_cb_status(struct hfa384x *hw, const struct hfa384x_usbctlx *ctlx)
+static void hfa384x_cb_status(struct hfa384x *hw,
+			      const struct hfa384x_usbctlx *ctlx)
 {
 	if (ctlx->usercb != NULL) {
 		struct hfa384x_statusresult cmdresult;
@@ -852,7 +846,8 @@ static void hfa384x_cb_status(struct hfa384x *hw, const struct hfa384x_usbctlx *
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-static void hfa384x_cb_rrid(struct hfa384x *hw, const struct hfa384x_usbctlx *ctlx)
+static void hfa384x_cb_rrid(struct hfa384x *hw,
+			    const struct hfa384x_usbctlx *ctlx)
 {
 	if (ctlx->usercb != NULL) {
 		struct hfa384x_rridresult rridresult;
@@ -869,7 +864,8 @@ static void hfa384x_cb_rrid(struct hfa384x *hw, const struct hfa384x_usbctlx *ct
 	}
 }
 
-static inline int hfa384x_docmd_wait(struct hfa384x *hw, struct hfa384x_metacmd *cmd)
+static inline int hfa384x_docmd_wait(struct hfa384x *hw,
+				     struct hfa384x_metacmd *cmd)
 {
 	return hfa384x_docmd(hw, DOWAIT, cmd, NULL, NULL, NULL);
 }
@@ -1207,7 +1203,8 @@ int hfa384x_cmd_download(struct hfa384x *hw, u16 mode, u16 lowaddr,
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_corereset(struct hfa384x *hw, int holdtime, int settletime, int genesis)
+int hfa384x_corereset(struct hfa384x *hw, int holdtime, int settletime,
+		      int genesis)
 {
 	int result = 0;
 
@@ -1568,7 +1565,7 @@ hfa384x_dowrid(struct hfa384x *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_wrid_completor_t completor;
+		struct usbctlx_cmd_completor completor;
 		struct hfa384x_statusresult wridresult;
 
 		result = hfa384x_usbctlx_complete_sync(hw,
@@ -1660,7 +1657,7 @@ hfa384x_dormem(struct hfa384x *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_rmem_completor_t completor;
+		struct usbctlx_rmem_completor completor;
 
 		result =
 		    hfa384x_usbctlx_complete_sync(hw, ctlx,
@@ -1750,7 +1747,7 @@ hfa384x_dowmem(struct hfa384x *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_wmem_completor_t completor;
+		struct usbctlx_cmd_completor completor;
 		struct hfa384x_statusresult wmemresult;
 
 		result = hfa384x_usbctlx_complete_sync(hw,
@@ -1997,7 +1994,8 @@ int hfa384x_drvr_flashdl_disable(struct hfa384x *hw)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_flashdl_write(struct hfa384x *hw, u32 daddr, void *buf, u32 len)
+int hfa384x_drvr_flashdl_write(struct hfa384x *hw, u32 daddr, void *buf,
+			       u32 len)
 {
 	int result = 0;
 	u32 dlbufaddr;
@@ -2622,7 +2620,8 @@ int hfa384x_drvr_start(struct hfa384x *hw)
 			pr_debug("but second attempt succeeded. All should be ok\n");
 		}
 	} else if (result2 != 0) {
-		printk(KERN_WARNING "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
+		printk(KERN_WARNING
+			"First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
 			result2);
 		printk(KERN_WARNING
 		       "Most likely the card will be functional\n");
@@ -2997,7 +2996,8 @@ static int unlocked_usbctlx_cancel_async(struct hfa384x *hw,
 * Call context:
 *	Either, assume interrupt
 ----------------------------------------------------------------*/
-static void unlocked_usbctlx_complete(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx)
+static void unlocked_usbctlx_complete(struct hfa384x *hw,
+				      struct hfa384x_usbctlx *ctlx)
 {
 	/* Timers have been stopped, and ctlx should be in
 	 * a terminal state. Retire it from the "active"
@@ -3676,7 +3676,8 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-static void hfa384x_usbin_info(wlandevice_t *wlandev, union hfa384x_usbin *usbin)
+static void hfa384x_usbin_info(wlandevice_t *wlandev,
+			       union hfa384x_usbin *usbin)
 {
 	usbin->infofrm.info.framelen =
 	    le16_to_cpu(usbin->infofrm.info.framelen);
@@ -4054,7 +4055,8 @@ static void hfa384x_usb_throttlefn(unsigned long data)
 * Call context:
 *	process or interrupt
 ----------------------------------------------------------------*/
-static int hfa384x_usbctlx_submit(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx)
+static int hfa384x_usbctlx_submit(struct hfa384x *hw,
+				  struct hfa384x_usbctlx *ctlx)
 {
 	unsigned long flags;
 	int ret;
@@ -4095,7 +4097,8 @@ static int hfa384x_usbctlx_submit(struct hfa384x *hw, struct hfa384x_usbctlx *ct
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-static void hfa384x_usbout_tx(wlandevice_t *wlandev, union hfa384x_usbout *usbout)
+static void hfa384x_usbout_tx(wlandevice_t *wlandev,
+			      union hfa384x_usbout *usbout)
 {
 	prism2sta_ev_alloc(wlandev);
 }
diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 5ee9836..88c55ee 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -402,7 +402,7 @@ int crcimage(imgchunk_t *fchunk, unsigned int nfchunks, s3crcrec_t *s3crc,
 			/*  some crc records don't match with the length of */
 			/*  the actual data, so we're not checking right */
 			/*  now */
-			/* if ( crcstart-2 >= cstart && crcend <= cend ) break; */
+			/* if (crcstart-2 >= cstart && crcend <= cend) break; */
 
 			/* note the -2 below, it's to make sure the chunk has */
 			/*   space for the CRC value */
@@ -675,7 +675,7 @@ int plugimage(imgchunk_t *fchunk, unsigned int nfchunks,
 		pstart = s3plug[i].addr;
 		pend = s3plug[i].addr + s3plug[i].len;
 		/* find the matching PDR (or filename) */
-		if (s3plug[i].itemcode != 0xffffffffUL) {	/* not filename */
+		if (s3plug[i].itemcode != 0xffffffffUL) { /* not filename */
 			for (j = 0; j < pda->nrec; j++) {
 				if (s3plug[i].itemcode ==
 				    le16_to_cpu(pda->rec[j]->code))
@@ -684,7 +684,7 @@ int plugimage(imgchunk_t *fchunk, unsigned int nfchunks,
 		} else {
 			j = -1;
 		}
-		if (j >= pda->nrec && j != -1) {	/*  if no matching PDR, fail */
+		if (j >= pda->nrec && j != -1) { /*  if no matching PDR, fail */
 			printk(KERN_WARNING
 			       "warning: Failed to find PDR for "
 			       "plugrec 0x%04x.\n", s3plug[i].itemcode);
@@ -712,7 +712,9 @@ int plugimage(imgchunk_t *fchunk, unsigned int nfchunks,
 			continue;
 		}
 
-		/* Validate plug address against chunk data and identify chunk */
+		/* Validate plug address against chunk data 
+		 * and identify chunk
+		 */
 		for (c = 0; c < nfchunks; c++) {
 			cstart = fchunk[c].addr;
 			cend = fchunk[c].addr + fchunk[c].len;
-- 
1.6.3.3

