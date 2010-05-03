Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0ECTKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:10:12 -0400
Received: from penguin.host-ns.co.uk ([213.229.84.196]:27569 "EHLO
	penguin.host-ns.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab0ECTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:10:10 -0400
X-Greylist: delayed 2369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2010 15:10:10 EDT
Subject: Patch for wlan-ng/hfa384x_usb.c
From: Adam Latham <adam.latham@unisontorbay.org.uk>
Reply-To: adam.latham@unisontorbay.org.uk
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Elwell <Andrew.Elwell@gmail.com>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Svenne Krap <svenne@krap.dk>, Jiri Kosina <jkosina@suse.cz>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 19:30:32 +0100
Message-ID: <1272911432.1902.1.camel@ubuntu.ubuntu-domain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - penguin.host-ns.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - unisontorbay.org.uk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 42dac4d32d75f5aa03f44c06e88795c829df5734 Mon Sep 17 00:00:00 2001
From: Adam <adam.latham@unisontorbay.org.uk>
Date: Mon, 3 May 2010 08:31:06 +0100
Subject: [PATCH] Staging: wlan-ng: fix various whitespace and 80 char issues in hfa384x_usb.c

This is a patch to fix various whitespace and 80 character style issues found by checkpatch.pl tool

Signed-off-by: Adam Latham <adam.latham@unisontorbay.org.uk>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 5df56f0..b7a319f 100644
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
@@ -451,7 +451,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
 	if (test_bit(WORK_RX_HALT, &hw->usb_flags)) {
 		int ret;
 
-		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock! */
+		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock!*/
 
 		ret = usb_clear_halt(hw->usb, hw->endp_in);
 		if (ret != 0) {
@@ -1226,7 +1226,7 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 *
 * Arguments:
 *	hw		device structure
-*	ctlx	 	CTLX ptr
+*	ctlx		CTLX ptr
 *	completor	functor object to decide what to
 *			do with the CTLX's result.
 *
@@ -2133,7 +2133,7 @@ exit_proc:
 *	0		success
 *	>0		f/w reported error - f/w status code
 *	<0		driver reported error
-*	-ENODATA 	length mismatch between argument and retrieved
+*	-ENODATA	length mismatch between argument and retrieved
 *			record.
 *
 * Side effects:
@@ -2619,7 +2619,7 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 			pr_debug("First cmd_initialize() failed (result %d),\n",
 				 result1);
 			pr_debug
-			    ("but second attempt succeeded. All should be ok\n");
+			    ("but second attempt succeeded.All should be ok\n");
 		}
 	} else if (result2 != 0) {
 		printk(KERN_WARNING
@@ -3442,7 +3442,7 @@ static void hfa384x_usbin_txcompl(wlandevice_t *wlandev,
 {
 	u16 status;
 
-	status = le16_to_cpu(usbin->type);	/* yeah I know it says type... */
+	status = le16_to_cpu(usbin->type);	/* yeah I know it says type...*/
 
 	/* Was there an error? */
 	if (HFA384x_TXSTATUS_ISERROR(status))
@@ -3583,7 +3583,7 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 	struct sk_buff *skb;
 	hfa384x_t *hw = wlandev->priv;
 
-	/* Don't forget the status, time, and data_len fields are in host order */
+	/* Don't forget: status, time, and data_len fields are in host order */
 	/* Figure out how big the frame is */
 	fc = le16_to_cpu(rxdesc->frame_control);
 	hdrlen = p80211_headerlen(fc);
@@ -3632,7 +3632,8 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		caphdr->encoding = htonl(1);	/* cck */
 	}
 
-	/* Copy the 802.11 header to the skb (ctl frames may be less than a full header) */
+	/* Copy the 802.11 header to the skb */
+	/* (ctl frames may be less than a full header)  */
 	datap = skb_put(skb, hdrlen);
 	memcpy(datap, &(rxdesc->frame_control), hdrlen);
 
@@ -3644,7 +3645,8 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		/* check for unencrypted stuff if WEP bit set. */
 		if (*(datap - hdrlen + 1) & 0x40)	/* wep set */
 			if ((*(datap) == 0xaa) && (*(datap + 1) == 0xaa))
-				*(datap - hdrlen + 1) &= 0xbf;	/* clear wep; it's the 802.2 header! */
+				*(datap - hdrlen + 1) &= 0xbf;	/* clear wep; */
+						/* it's the 802.2 header! */
 	}
 
 	if (hw->sniff_fcs) {
-- 
1.7.0.4




