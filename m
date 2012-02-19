Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2BSMSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 07:18:42 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:61726 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370Ab2BSMSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 07:18:40 -0500
MIME-Version: 1.0
Date: Sun, 19 Feb 2012 17:48:39 +0530
Message-ID: <CAOD=uF4st80fB0+uwXNNbHtN4YpoFWwu4EUhwmVi+v=0euu=sQ@mail.gmail.com>
Subject: [PATCH] Staging: driver usbip: Code cleanup
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: mfm@muteddisk.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Code cleanup: removed commented code of old style lock initilization

Signed-off-by: Santosh <santoshprasadnayak@gmail.com>
---
 drivers/staging/usbip/stub_dev.c |    2 --
 drivers/staging/usbip/vhci_hcd.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 03420e2..fa870e3 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -297,7 +297,6 @@ static struct stub_device
*stub_device_alloc(struct usb_device *udev,
        sdev->devid             = (busnum << 16) | devnum;
        sdev->ud.side           = USBIP_STUB;
        sdev->ud.status         = SDEV_ST_AVAILABLE;
-       /* sdev->ud.lock = SPIN_LOCK_UNLOCKED; */
        spin_lock_init(&sdev->ud.lock);
        sdev->ud.tcp_socket     = NULL;

@@ -306,7 +305,6 @@ static struct stub_device
*stub_device_alloc(struct usb_device *udev,
        INIT_LIST_HEAD(&sdev->priv_free);
        INIT_LIST_HEAD(&sdev->unlink_free);
        INIT_LIST_HEAD(&sdev->unlink_tx);
-       /* sdev->priv_lock = SPIN_LOCK_UNLOCKED; */
        spin_lock_init(&sdev->priv_lock);

        init_waitqueue_head(&sdev->tx_waitq);
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 8d96ab0..dca9bf1 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -895,14 +895,12 @@ static void vhci_device_init(struct vhci_device *vdev)

        vdev->ud.side   = USBIP_VHCI;
        vdev->ud.status = VDEV_ST_NULL;
-       /* vdev->ud.lock   = SPIN_LOCK_UNLOCKED; */
        spin_lock_init(&vdev->ud.lock);
