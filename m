Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab2DZSNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:13:39 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:35594 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab2DZSNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:13:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mkrufky@linuxtv.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/1] DVB: dib0700, remove double \n's from log
Date: Thu, 26 Apr 2012 20:13:33 +0200
Message-Id: <1335464013-14817-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err() already adds \n to the end of the format string. So remove one
more \n from formatting strings in the dib0700 driver.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 02290c6..20af8a3 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -766,13 +766,13 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 	/* Starting in firmware 1.20, the RC info is provided on a bulk pipe */
 	purb = usb_alloc_urb(0, GFP_KERNEL);
 	if (purb == NULL) {
-		err("rc usb alloc urb failed\n");
+		err("rc usb alloc urb failed");
 		return -ENOMEM;
 	}
 
 	purb->transfer_buffer = kzalloc(RC_MSG_SIZE_V1_20, GFP_KERNEL);
 	if (purb->transfer_buffer == NULL) {
-		err("rc kzalloc failed\n");
+		err("rc kzalloc failed");
 		usb_free_urb(purb);
 		return -ENOMEM;
 	}
@@ -784,7 +784,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 
 	ret = usb_submit_urb(purb, GFP_ATOMIC);
 	if (ret) {
-		err("rc submit urb failed\n");
+		err("rc submit urb failed");
 		kfree(purb->transfer_buffer);
 		usb_free_urb(purb);
 	}
-- 
1.7.9.2


