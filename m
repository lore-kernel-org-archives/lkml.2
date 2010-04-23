Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab0DWPOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:14:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35107 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab0DWPOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o+yHjVRIcUIVJvnku/BfmQcI/IsUm3eA7nwwxSYDDbDTRDxH9ceL+UqELqlf3ZQzGo
         BElUR/hjmYbVTyn7NNtwPTjp2V1/npeMFYIWy2RjNhDw+hUWyt18Ml7PdgYKpHho/s1b
         aJg9TVytAcchzdl2bq3iSHioEp1zT2Xinr5t8=
From: Alessandro Ghedini <al3xbio@gmail.com>
To: gregkh@suse.de, Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com,
       svenne@krap.dk, jkosina@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Alessandro Ghedini <al3xbio@gmail.com>
Subject: [PATCH] Staging: wlan-ng: fix many style issues in hfa384x_usb.c
Date: Fri, 23 Apr 2010 17:15:06 +0200
Message-Id: <1272035706-12212-1-git-send-email-al3xbio@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all the errors and most of the checkpatch.pl warnings
and other style issues in the hfa384x_usb.c file

Signed-off-by: Alessandro Ghedini <al3xbio@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |  140 ++++++++++++++++++---------------
 1 files changed, 77 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 5df56f0..7cf3934 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -62,7 +62,7 @@
 *
 * hfa384x_drvr_xxxconfig  An example of the drvr level abstraction. These
 *			functions are wrappers for the RID get/set
-*			sequence. They 	call copy_[to|from]_bap() and
+*			sequence. They call copy_[to|from]_bap() and
 *			cmd_access().	These functions operate on the
 *			RIDs and buffers without validation.  The caller
 *			is responsible for that.
@@ -351,7 +351,8 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
 	hw->rx_urb_skb = skb;
 
 	result = -ENOLINK;
-	if (!hw->wlandev->hwremoved && !test_bit(WORK_RX_HALT, &hw->usb_flags)) {
+	if (!hw->wlandev->hwremoved &&
+				!test_bit(WORK_RX_HALT, &hw->usb_flags)) {
 		result = SUBMIT_URB(&hw->rx_urb, memflags);
 
 		/* Check whether we need to reset the RX pipe */
@@ -451,7 +452,8 @@ static void hfa384x_usb_defer(struct work_struct *data)
 	if (test_bit(WORK_RX_HALT, &hw->usb_flags)) {
 		int ret;
 
-		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock! */
+		/* Cannot be holding spinlock! */
+		usb_kill_urb(&hw->rx_urb);
 
 		ret = usb_clear_halt(hw->usb, hw->endp_in);
 		if (ret != 0) {
@@ -1226,7 +1228,7 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 *
 * Arguments:
 *	hw		device structure
-*	ctlx	 	CTLX ptr
+*	ctlx		CTLX ptr
 *	completor	functor object to decide what to
 *			do with the CTLX's result.
 *
@@ -1958,8 +1960,10 @@ int hfa384x_drvr_flashdl_disable(hfa384x_t *hw)
 
 	pr_debug("flashdl_enable\n");
 
-	/* There isn't much we can do at this point, so I don't */
-	/*  bother  w/ the return value */
+	/*
+	 * There isn't much we can do at this point,
+	 * so I don't bother w/ the return value
+	 */
 	hfa384x_cmd_download(hw, HFA384x_PROGMODE_DISABLE, 0, 0, 0);
 	hw->dlstate = HFA384x_DLSTATE_DISABLED;
 
@@ -2020,8 +2024,10 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 
 	printk(KERN_INFO "Download %d bytes to flash @0x%06x\n", len, daddr);
 
-	/* Convert to flat address for arithmetic */
-	/* NOTE: dlbuffer RID stores the address in AUX format */
+	/*
+	 * Convert to flat address for arithmetic
+	 * NOTE: dlbuffer RID stores the address in AUX format
+	 */
 	dlbufaddr =
 	    HFA384x_ADDR_AUX_MKFLAT(hw->bufinfo.page, hw->bufinfo.offset);
 	pr_debug("dlbuf.page=0x%04x dlbuf.offset=0x%04x dlbufaddr=0x%08x\n",
@@ -2070,19 +2076,13 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 
 		/* copy the data to the flash download buffer */
 		for (j = 0; j < nwrites; j++) {
-			writebuf = buf +
-			    (i * hw->bufinfo.len) +
-			    (j * HFA384x_USB_RWMEM_MAXLEN);
-
-			writepage = HFA384x_ADDR_CMD_MKPAGE(dlbufaddr +
-							    (j *
-							     HFA384x_USB_RWMEM_MAXLEN));
-			writeoffset =
-			    HFA384x_ADDR_CMD_MKOFF(dlbufaddr +
-						   (j *
-						    HFA384x_USB_RWMEM_MAXLEN));
-
-			writelen = burnlen - (j * HFA384x_USB_RWMEM_MAXLEN);
+			int pos = j * HFA384x_USB_RWMEM_MAXLEN;
+			writebuf = buf + (i * hw->bufinfo.len) + pos;
+
+			writepage = HFA384x_ADDR_CMD_MKPAGE(dlbufaddr + pos);
+			writeoffset = HFA384x_ADDR_CMD_MKOFF(dlbufaddr + pos);
+
+			writelen = burnlen - pos;
 			writelen = writelen > HFA384x_USB_RWMEM_MAXLEN ?
 			    HFA384x_USB_RWMEM_MAXLEN : writelen;
 
@@ -2109,9 +2109,12 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 
 exit_proc:
 
-	/* Leave the firmware in the 'post-prog' mode.  flashdl_disable will */
-	/*  actually disable programming mode.  Remember, that will cause the */
-	/*  the firmware to effectively reset itself. */
+	/*
+	 * Leave the firmware in the 'post-prog' mode.
+	 * flashdl_disable will actually disable programming mode.
+	 * Remember, that will cause the the firmware to
+	 * effectively reset itself.
+	 */
 
 	return result;
 }
@@ -2133,7 +2136,7 @@ exit_proc:
 *	0		success
 *	>0		f/w reported error - f/w status code
 *	<0		driver reported error
-*	-ENODATA 	length mismatch between argument and retrieved
+*	-ENODATA	length mismatch between argument and retrieved
 *			record.
 *
 * Side effects:
@@ -2177,9 +2180,8 @@ int hfa384x_drvr_getconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len)
  * Call context:
  *       Any
  ----------------------------------------------------------------*/
-int
-hfa384x_drvr_getconfig_async(hfa384x_t *hw,
-			     u16 rid, ctlx_usercb_t usercb, void *usercb_data)
+int hfa384x_drvr_getconfig_async(hfa384x_t *hw, u16 rid,
+				 ctlx_usercb_t usercb, void *usercb_data)
 {
 	return hfa384x_dorrid_async(hw, rid, NULL, 0,
 				    hfa384x_cb_rrid, usercb, usercb_data);
@@ -2208,14 +2210,11 @@ hfa384x_drvr_getconfig_async(hfa384x_t *hw,
  * Call context:
  *       process
  ----------------------------------------------------------------*/
-int
-hfa384x_drvr_setconfig_async(hfa384x_t *hw,
-			     u16 rid,
-			     void *buf,
-			     u16 len, ctlx_usercb_t usercb, void *usercb_data)
+int hfa384x_drvr_setconfig_async(hfa384x_t *hw, u16 rid, void *buf, u16 len,
+				 ctlx_usercb_t usercb, void *usercb_data)
 {
-	return hfa384x_dowrid_async(hw, rid, buf, len,
-				    hfa384x_cb_status, usercb, usercb_data);
+	return hfa384x_dowrid_async(hw, rid, buf, len, hfa384x_cb_status,
+				    usercb, usercb_data);
 }
 
 /*----------------------------------------------------------------
@@ -2244,8 +2243,10 @@ int hfa384x_drvr_ramdl_disable(hfa384x_t *hw)
 
 	pr_debug("ramdl_disable()\n");
 
-	/* There isn't much we can do at this point, so I don't */
-	/*  bother  w/ the return value */
+	/*
+	 * There isn't much we can do at this point,
+	 * so I don't bother  w/ the return value
+	 */
 	hfa384x_cmd_download(hw, HFA384x_PROGMODE_DISABLE, 0, 0, 0);
 	hw->dlstate = HFA384x_DLSTATE_DISABLED;
 
@@ -2368,10 +2369,11 @@ int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 	/* Do blocking wmem's */
 	for (i = 0; i < nwrites; i++) {
 		/* make address args */
-		curraddr = daddr + (i * HFA384x_USB_RWMEM_MAXLEN);
+		int pos = i * HFA384x_USB_RWMEM_MAXLEN;
+		curraddr = daddr + pos;
 		currpage = HFA384x_ADDR_CMD_MKPAGE(curraddr);
 		curroffset = HFA384x_ADDR_CMD_MKOFF(curraddr);
-		currlen = len - (i * HFA384x_USB_RWMEM_MAXLEN);
+		currlen = len - pos;
 		if (currlen > HFA384x_USB_RWMEM_MAXLEN)
 			currlen = HFA384x_USB_RWMEM_MAXLEN;
 
@@ -2379,8 +2381,7 @@ int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		result = hfa384x_dowmem_wait(hw,
 					     currpage,
 					     curroffset,
-					     data +
-					     (i * HFA384x_USB_RWMEM_MAXLEN),
+					     data + pos,
 					     currlen);
 
 		if (result)
@@ -2451,7 +2452,11 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 		currpage = HFA384x_ADDR_CMD_MKPAGE(pdaloc[i].cardaddr);
 		curroffset = HFA384x_ADDR_CMD_MKOFF(pdaloc[i].cardaddr);
 
-		result = hfa384x_dormem_wait(hw, currpage, curroffset, buf, len);	/* units of bytes */
+		result = hfa384x_dormem_wait(hw,
+					     currpage,
+					     curroffset,
+					     buf,
+					     len); /* units of bytes */
 
 		if (result) {
 			printk(KERN_WARNING
@@ -2556,7 +2561,9 @@ int hfa384x_drvr_setconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len)
 
 int hfa384x_drvr_start(hfa384x_t *hw)
 {
-	int result, result1, result2;
+	int result;
+	int result1;
+	int result2;
 	u16 status;
 
 	might_sleep();
@@ -2610,20 +2617,21 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	result = result2 = hfa384x_cmd_initialize(hw);
 	if (result1 != 0) {
 		if (result2 != 0) {
-			printk(KERN_ERR
-			       "cmd_initialize() failed on two attempts, results %d and %d\n",
-			       result1, result2);
+			printk
+			   (KERN_ERR "cmd_initialize() failed on two attempts,"
+			    " results %d and %d\n",
+			    result1, result2);
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
+		printk(KERN_WARNING "First cmd_initialize() succeeded, "
+		       "but second attempt failed (result=%d)\n",
 		       result2);
 		printk(KERN_WARNING
 		       "Most likely the card will be functional\n");
@@ -3066,8 +3074,7 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 		list_move_tail(&head->list, &hw->ctlxq.active);
 
 		/* Fill the out packet */
-		usb_fill_bulk_urb(&(hw->ctlx_urb), hw->usb,
-				  hw->endp_out,
+		usb_fill_bulk_urb(&(hw->ctlx_urb), hw->usb, hw->endp_out,
 				  &(head->outbuf), ROUNDUP64(head->outbufsize),
 				  hfa384x_ctlxout_callback, hw);
 		hw->ctlx_urb.transfer_flags |= USB_QUEUE_BULK;
@@ -3236,8 +3243,8 @@ static void hfa384x_usbin_callback(struct urb *urb)
 	}
 
 	/* Handle any USB-IN packet */
-	/* Note: the check of the sw_support field, the type field doesn't
-	 *       have bit 12 set like the docs suggest.
+	/* Note: the check of the sw_support field,
+	 * the type field doesn't have bit 12 set like the docs suggest.
 	 */
 	type = le16_to_cpu(usbin->type);
 	if (HFA384x_USB_ISRXFRM(type)) {
@@ -3379,11 +3386,11 @@ retry:
 		case CTLX_REQ_SUBMITTED:
 			/*
 			 * We have received our response URB before
-			 * our request has been acknowledged. Odd,
-			 * but our OUT URB is still alive...
+			 * our request has been acknowledged.
+			 * Odd, but our OUT URB is still alive...
 			 */
 			pr_debug
-			    ("Causality violation: please reboot Universe, or email linux-wlan-devel@lists.linux-wlan.com\n");
+			    ("Causality violation: please reboot Universe\n");
 			ctlx->state = CTLX_RESP_COMPLETE;
 			break;
 
@@ -3442,7 +3449,7 @@ static void hfa384x_usbin_txcompl(wlandevice_t *wlandev,
 {
 	u16 status;
 
-	status = le16_to_cpu(usbin->type);	/* yeah I know it says type... */
+	status = le16_to_cpu(usbin->type); /* yeah I know it says type... */
 
 	/* Was there an error? */
 	if (HFA384x_TXSTATUS_ISERROR(status))
@@ -3583,8 +3590,10 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 	struct sk_buff *skb;
 	hfa384x_t *hw = wlandev->priv;
 
-	/* Don't forget the status, time, and data_len fields are in host order */
-	/* Figure out how big the frame is */
+	/*
+	 * The status, time, and data_len fields are in host order
+	 * Figure out how big the frame is
+	 */
 	fc = le16_to_cpu(rxdesc->frame_control);
 	hdrlen = p80211_headerlen(fc);
 	datalen = le16_to_cpu(rxdesc->data_len);
@@ -3632,7 +3641,10 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		caphdr->encoding = htonl(1);	/* cck */
 	}
 
-	/* Copy the 802.11 header to the skb (ctl frames may be less than a full header) */
+	/*
+	 * Copy the 802.11 header to the skb
+	 * (ctl frames may be less than a full header)
+	 */
 	datap = skb_put(skb, hdrlen);
 	memcpy(datap, &(rxdesc->frame_control), hdrlen);
 
@@ -3644,7 +3656,8 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		/* check for unencrypted stuff if WEP bit set. */
 		if (*(datap - hdrlen + 1) & 0x40)	/* wep set */
 			if ((*(datap) == 0xaa) && (*(datap + 1) == 0xaa))
-				*(datap - hdrlen + 1) &= 0xbf;	/* clear wep; it's the 802.2 header! */
+				/* clear wep; it's the 802.2 header! */
+				*(datap - hdrlen + 1) &= 0xbf;
 	}
 
 	if (hw->sniff_fcs) {
@@ -3846,7 +3859,8 @@ retry:
 		default:
 			/* This is NOT a valid CTLX "success" state! */
 			printk(KERN_ERR
-			       "Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
+			       "Illegal CTLX[%d] success state(%s, %d)"
+			       " in OUT URB\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       ctlxstr(ctlx->state), urb->status);
 			break;
-- 
1.7.0.5

