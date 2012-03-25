Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2CYTIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 15:08:40 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36538 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab2CYTIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 15:08:39 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/usb/misc/usbtest.c: add kfrees
Date: Sun, 25 Mar 2012 21:08:32 +0200
Message-Id: <1332702512-20440-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Free the two previously allocated buffers before exiting the function in an
error case.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/misc/usbtest.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 959145b..7bd0bfc 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -2276,6 +2276,8 @@ usbtest_probe(struct usb_interface *intf, const struct usb_device_id *id)
 			if (status < 0) {
 				WARNING(dev, "couldn't get endpoints, %d\n",
 						status);
+				kfree(dev->buf);
+				kfree(dev);
 				return status;
 			}
 			/* may find bulk or ISO pipes */

