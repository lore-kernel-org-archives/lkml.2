Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1G2RVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:21:00 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39969 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1G2RU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:20:59 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 1/2]drivers:staging:usbip:stub_dev.c change SPIN_LOCK_UNLOCKED to __SPIN_LOCK_UNLOCKED
Date: Fri, 29 Jul 2011 10:20:36 -0700
Message-Id: <1311960037-9581-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below updates SPIN_LOCK_UNLOCKED to __SPIN_LOCK_UNLOCKED since it is 
deprected according to my search results.
Note: Keep in mind I am not sure if this is the correct change for this(still learning)
even though it's commented out and such.(figured to give this a try and see).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/usbip/stub_dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index fce22f2..fe09105 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -301,7 +301,7 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 	sdev->devid		= (busnum << 16) | devnum;
 	sdev->ud.side		= USBIP_STUB;
 	sdev->ud.status		= SDEV_ST_AVAILABLE;
-	/* sdev->ud.lock = SPIN_LOCK_UNLOCKED; */
+	/* sdev->ud.lock = __SPIN_LOCK_UNLOCKED(ud.lock); */
 	spin_lock_init(&sdev->ud.lock);
 	sdev->ud.tcp_socket	= NULL;
 
@@ -310,7 +310,7 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 	INIT_LIST_HEAD(&sdev->priv_free);
 	INIT_LIST_HEAD(&sdev->unlink_free);
 	INIT_LIST_HEAD(&sdev->unlink_tx);
-	/* sdev->priv_lock = SPIN_LOCK_UNLOCKED; */
+	/* sdev->priv_lock = __SPIN_LOCK_UNLOCKED(priv_lock); */
 	spin_lock_init(&sdev->priv_lock);
 
 	init_waitqueue_head(&sdev->tx_waitq);
-- 
1.7.6

