Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2KCK6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 06:58:52 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62865
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab2KCK6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245665"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/16] drivers/usb/wusbcore: use WARN
Date: Sat,  3 Nov 2012 11:58:25 +0100
Message-Id: <1351940317-14812-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/wusbcore/wa-xfer.c |    3 +--
 drivers/usb/wusbcore/wusbhc.c  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 57c01ab..1b80601 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -1124,9 +1124,8 @@ int wa_urb_dequeue(struct wahc *wa, struct urb *urb)
 		switch (seg->status) {
 		case WA_SEG_NOTREADY:
 		case WA_SEG_READY:
-			printk(KERN_ERR "xfer %p#%u: dequeue bad state %u\n",
+			WARN(1, KERN_ERR "xfer %p#%u: dequeue bad state %u\n",
 			       xfer, cnt, seg->status);
-			WARN_ON(1);
 			break;
 		case WA_SEG_DELAYED:
 			seg->status = WA_SEG_ABORTED;
diff --git a/drivers/usb/wusbcore/wusbhc.c b/drivers/usb/wusbcore/wusbhc.c
index 0faca16..bb5e649 100644
--- a/drivers/usb/wusbcore/wusbhc.c
+++ b/drivers/usb/wusbcore/wusbhc.c
@@ -435,9 +435,8 @@ static void __exit wusbcore_exit(void)
 		char buf[256];
 		bitmap_scnprintf(buf, sizeof(buf), wusb_cluster_id_table,
 				 CLUSTER_IDS);
-		printk(KERN_ERR "BUG: WUSB Cluster IDs not released "
+		WARN(1, KERN_ERR "BUG: WUSB Cluster IDs not released "
 		       "on exit: %s\n", buf);
-		WARN_ON(1);
 	}
 	usb_unregister_notify(&wusb_usb_notifier);
 	destroy_workqueue(wusbd);

