Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966782Ab2JZW0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 18:26:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37093 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966765Ab2JZW0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 18:26:00 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging:comedi: Use pr_ or dev_ printks in drivers/usbduxfaxt.c
Date: Sat, 27 Oct 2012 07:25:53 +0900
Message-Id: <1351290353-5954-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: printk() should include KERN_ facility level

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 060d853dc..b4e987b 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -370,9 +370,8 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 		return;
 
 	default:
-		printk("comedi%d: usbduxfast: non-zero urb status received in "
-		       "ai intr context: %d\n",
-		       udfs->comedidev->minor, urb->status);
+		pr_err("non-zero urb status received in ai intr context: %d\n",
+		       urb->status);
 		s->async->events |= COMEDI_CB_EOA;
 		s->async->events |= COMEDI_CB_ERROR;
 		comedi_event(udfs->comedidev, s);
@@ -454,7 +453,8 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
 			      1,      /* Length */
 			      EZTIMEOUT);    /* Timeout */
 	if (ret < 0) {
-		printk("comedi_: usbduxfast_: control msg failed (start)\n");
+		dev_err(&udfs->interface->dev,
+			"control msg failed (start)\n");
 		return ret;
 	}
 
-- 
1.7.9.5

