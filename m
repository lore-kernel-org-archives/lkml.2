Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0DUR3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:29:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38734 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab0DUR3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IU9Cdtvy/ZsJ8BPqolLTmfl6JOxAqNYIjH0oduwjcqyCGnIoZv4N50Cy/9+dehAqd8
         dv/R4cKfoniFHnoDfhHrzcnYoop/EsUvzRlJYbuOwg9F6MfRlZfNG0FGpkYTzIz0Dm7N
         hbxvhqS9zEhXmCdtBMFYVXhSwOVPxXexoAgtc=
From: Alessandro Ghedini <al3xbio@gmail.com>
To: gregkh@suse.de, Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com,
       svenne@krap.dk, jkosina@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Alessandro Ghedini <al3xbio@gmail.com>
Subject: [PATCH] Staging: wlan-ng: fix many style warnings in hfa384x_usb.c
Date: Wed, 21 Apr 2010 19:29:10 +0200
Message-Id: <1271870950-19305-1-git-send-email-al3xbio@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes most of the style warnings found with checkpatch.pl in the
hfa384x_usb.c file.

Signed-off-by: Alessandro Ghedini <al3xbio@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   59 ++++++++++++++++++--------------
 1 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 5df56f0..db819be 100644
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
@@ -351,7 +351,9 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
 	hw->rx_urb_skb = skb;
 
 	result = -ENOLINK;
-	if (!hw->wlandev->hwremoved && !test_bit(WORK_RX_HALT, &hw->usb_flags)) {
+	if (!hw->wlandev->hwremoved && \
+			!test_bit(WORK_RX_HALT, &hw->usb_flags)) {
+
 		result = SUBMIT_URB(&hw->rx_urb, memflags);
 
 		/* Check whether we need to reset the RX pipe */
@@ -451,7 +453,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
 	if (test_bit(WORK_RX_HALT, &hw->usb_flags)) {
 		int ret;
 
-		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock! */
+		usb_kill_urb(&hw->rx_urb); /* Cannot be holding spinlock! */
 
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
@@ -2075,12 +2077,9 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 			    (j * HFA384x_USB_RWMEM_MAXLEN);
 
 			writepage = HFA384x_ADDR_CMD_MKPAGE(dlbufaddr +
-							    (j *
-							     HFA384x_USB_RWMEM_MAXLEN));
-			writeoffset =
-			    HFA384x_ADDR_CMD_MKOFF(dlbufaddr +
-						   (j *
-						    HFA384x_USB_RWMEM_MAXLEN));
+					(j * HFA384x_USB_RWMEM_MAXLEN));
+			writeoffset = HFA384x_ADDR_CMD_MKOFF(dlbufaddr +
+					(j * HFA384x_USB_RWMEM_MAXLEN));
 
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
@@ -2451,7 +2450,8 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 		currpage = HFA384x_ADDR_CMD_MKPAGE(pdaloc[i].cardaddr);
 		curroffset = HFA384x_ADDR_CMD_MKOFF(pdaloc[i].cardaddr);
 
-		result = hfa384x_dormem_wait(hw, currpage, curroffset, buf, len);	/* units of bytes */
+		result = hfa384x_dormem_wait(hw, currpage, curroffset, \
+					buf, len); /* units of bytes */
 
 		if (result) {
 			printk(KERN_WARNING
@@ -2610,20 +2610,21 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	result = result2 = hfa384x_cmd_initialize(hw);
 	if (result1 != 0) {
 		if (result2 != 0) {
-			printk(KERN_ERR
-			       "cmd_initialize() failed on two attempts, results %d and %d\n",
+			printk(KERN_ERR "cmd_initialize() failed on two" \
+					"attempts, results %d and %d\n",
 			       result1, result2);
 			usb_kill_urb(&hw->rx_urb);
 			goto done;
 		} else {
 			pr_debug("First cmd_initialize() failed (result %d),\n",
 				 result1);
-			pr_debug
-			    ("but second attempt succeeded. All should be ok\n");
+			pr_debug("but second attempt succeeded. " \
+						"All should be ok\n");
 		}
 	} else if (result2 != 0) {
 		printk(KERN_WARNING
-		       "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
+		       "First cmd_initialize() succeeded, but second " \
+					"attempt failed (result=%d)\n",
 		       result2);
 		printk(KERN_WARNING
 		       "Most likely the card will be functional\n");
@@ -3382,8 +3383,9 @@ retry:
 			 * our request has been acknowledged. Odd,
 			 * but our OUT URB is still alive...
 			 */
-			pr_debug
-			    ("Causality violation: please reboot Universe, or email linux-wlan-devel@lists.linux-wlan.com\n");
+			pr_debug("Causality violation: please reboot " \
+				"Universe, or email " \
+				"linux-wlan-devel@lists.linux-wlan.com\n");
 			ctlx->state = CTLX_RESP_COMPLETE;
 			break;
 
@@ -3442,7 +3444,7 @@ static void hfa384x_usbin_txcompl(wlandevice_t *wlandev,
 {
 	u16 status;
 
-	status = le16_to_cpu(usbin->type);	/* yeah I know it says type... */
+	status = le16_to_cpu(usbin->type); /* yeah I know it says type... */
 
 	/* Was there an error? */
 	if (HFA384x_TXSTATUS_ISERROR(status))
@@ -3583,8 +3585,10 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 	struct sk_buff *skb;
 	hfa384x_t *hw = wlandev->priv;
 
-	/* Don't forget the status, time, and data_len fields are in host order */
-	/* Figure out how big the frame is */
+	/* Don't forget the status, time, and data_len fields are in
+	 * host order
+	 * Figure out how big the frame is
+	 */
 	fc = le16_to_cpu(rxdesc->frame_control);
 	hdrlen = p80211_headerlen(fc);
 	datalen = le16_to_cpu(rxdesc->data_len);
@@ -3632,7 +3636,9 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		caphdr->encoding = htonl(1);	/* cck */
 	}
 
-	/* Copy the 802.11 header to the skb (ctl frames may be less than a full header) */
+	/* Copy the 802.11 header to the skb (ctl frames may be less
+	 * than a full header)
+	 */
 	datap = skb_put(skb, hdrlen);
 	memcpy(datap, &(rxdesc->frame_control), hdrlen);
 
@@ -3644,7 +3650,8 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		/* check for unencrypted stuff if WEP bit set. */
 		if (*(datap - hdrlen + 1) & 0x40)	/* wep set */
 			if ((*(datap) == 0xaa) && (*(datap + 1) == 0xaa))
-				*(datap - hdrlen + 1) &= 0xbf;	/* clear wep; it's the 802.2 header! */
+				/* clear wep; it's the 802.2 header! */
+				*(datap - hdrlen + 1) &= 0xbf;
 	}
 
 	if (hw->sniff_fcs) {
@@ -3845,8 +3852,8 @@ retry:
 
 		default:
 			/* This is NOT a valid CTLX "success" state! */
-			printk(KERN_ERR
-			       "Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
+			printk(KERN_ERR "Illegal CTLX[%d] success " \
+					"state(%s, %d) in OUT URB\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       ctlxstr(ctlx->state), urb->status);
 			break;
-- 
1.7.0.4

