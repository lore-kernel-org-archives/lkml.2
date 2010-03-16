Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965973Ab0CPCbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:31:51 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:47584 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937358Ab0CPCbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tLMCEinplEu12x/6D3EMcqpu+B02qtwfHJH3K7m6wO8+uUS0QcxhMQ+bsEwaH/G8YV
         68j94rIeSGLu7s667U6JzZ65ZFH+HaKWvYnR1+rc/SXwiwtxwMgkU4oWnojd+EsXgQA0
         +9hQCwzfJabhvB+9o7RuIwcw9nvpCHKnsJN8g=
From: ehames@gmail.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Edgardo Hames <ehames@gmail.com>
Subject: [PATCH 2/2] Staging: wlan-ng: rework after feedback
Date: Mon, 15 Mar 2010 23:00:40 -0300
Message-Id: <1268704840-7166-2-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268704840-7166-1-git-send-email-ehames@gmail.com>
References: <1268704840-7166-1-git-send-email-ehames@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edgardo Hames <ehames@gmail.com>

This patch includes the feedback received from Richard Kennedy.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 2400242..a41db5d 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -2612,19 +2612,18 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	if (result1 != 0) {
 		if (result2 != 0) {
 			printk(KERN_ERR
-				"cmd_initialize() failed on two attempts,"
-				" results %d and %d\n", result1, result2);
+				"cmd_initialize() failed on two attempts, results %d and %d\n",
+				result1, result2);
 			usb_kill_urb(&hw->rx_urb);
 			goto done;
 		} else {
 			pr_debug("First cmd_initialize() failed (result %d),\n",
 				 result1);
-			pr_debug("but second attempt succeeded."
-				 " All should be ok\n");
+			pr_debug("but second attempt succeeded. All should be ok\n");
 		}
 	} else if (result2 != 0) {
-		printk(KERN_WARNING "First cmd_initialize() succeeded,"
-			" but second attempt failed (result=%d)\n", result2);
+		printk(KERN_WARNING "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
+			result2);
 		printk(KERN_WARNING
 		       "Most likely the card will be functional\n");
 		goto done;
@@ -3382,9 +3381,7 @@ retry:
 			 * our request has been acknowledged. Odd,
 			 * but our OUT URB is still alive...
 			 */
-			pr_debug("Causality violation: "
-				 "please reboot Universe, or email "
-				 "linux-wlan-devel@lists.linux-wlan.com\n");
+			pr_debug("Causality violation: please reboot Universe\n");
 			ctlx->state = CTLX_RESP_COMPLETE;
 			break;
 
@@ -3848,8 +3845,8 @@ retry:
 
 		default:
 			/* This is NOT a valid CTLX "success" state! */
-			printk(KERN_ERR "Illegal CTLX[%d]"
-				" success state(%s, %d) in OUT URB\n",
+			printk(KERN_ERR
+				"Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
 				le16_to_cpu(ctlx->outbuf.type),
 				ctlxstr(ctlx->state), urb->status);
 			break;
-- 
1.6.3.3

