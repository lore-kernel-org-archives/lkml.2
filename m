Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2BTDOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 22:14:54 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45023 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2BTDOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 22:14:52 -0500
From: santosh nayak <santoshprasadnayak@gmail.com>
To: mfm@muteddisk.com
Cc: dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        santosh.iitg@gmail.com, Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] Staging: usbip: Remove commented code.
Date: Mon, 20 Feb 2012 08:44:05 +0530
Message-Id: <1329707645-25978-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak  <santoshprasadnayak@gmail.com>

Remove commented code of old style lock initilization

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/staging/usbip/stub_dev.c |    2 --
 drivers/staging/usbip/vhci_hcd.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 03420e2..fa870e3 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -297,7 +297,6 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 	sdev->devid		= (busnum << 16) | devnum;
 	sdev->ud.side		= USBIP_STUB;
 	sdev->ud.status		= SDEV_ST_AVAILABLE;
-	/* sdev->ud.lock = SPIN_LOCK_UNLOCKED; */
 	spin_lock_init(&sdev->ud.lock);
 	sdev->ud.tcp_socket	= NULL;
 
@@ -306,7 +305,6 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 	INIT_LIST_HEAD(&sdev->priv_free);
 	INIT_LIST_HEAD(&sdev->unlink_free);
 	INIT_LIST_HEAD(&sdev->unlink_tx);
-	/* sdev->priv_lock = SPIN_LOCK_UNLOCKED; */
 	spin_lock_init(&sdev->priv_lock);
 
 	init_waitqueue_head(&sdev->tx_waitq);
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 8d96ab0..dca9bf1 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -895,14 +895,12 @@ static void vhci_device_init(struct vhci_device *vdev)
 
 	vdev->ud.side   = USBIP_VHCI;
 	vdev->ud.status = VDEV_ST_NULL;
-	/* vdev->ud.lock   = SPIN_LOCK_UNLOCKED; */
 	spin_lock_init(&vdev->ud.lock);
 
 	INIT_LIST_HEAD(&vdev->priv_rx);
 	INIT_LIST_HEAD(&vdev->priv_tx);
 	INIT_LIST_HEAD(&vdev->unlink_tx);
 	INIT_LIST_HEAD(&vdev->unlink_rx);
-	/* vdev->priv_lock = SPIN_LOCK_UNLOCKED; */
 	spin_lock_init(&vdev->priv_lock);
 
 	init_waitqueue_head(&vdev->waitq_tx);
-- 
1.7.3.1

