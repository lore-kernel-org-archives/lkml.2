Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1HVOAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:00:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48321 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1HVOAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:00:43 -0400
From: Julia Lawall <julia@diku.dk>
To: Matt Mooney <mfm@muteddisk.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drivers/staging/usbip/userspace/libsrc/vhci_driver.c: test the just-initialized value
Date: Mon, 22 Aug 2011 16:00:33 +0200
Message-Id: <1314021636-11528-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the just-initialized value rather than some other one.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier x,y,f!={PTR_ERR,ERR_PTR,ERR_CAST};
statement S;
@@

x = f(...);
(
if (\(x == NULL\|IS_ERR(x)\)) S
|
*if (\(y == NULL\|IS_ERR(y)\))
 { ... when != x
   return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/usbip/userspace/libsrc/vhci_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index abbc285..2697877 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -133,7 +133,7 @@ static int check_usbip_device(struct sysfs_class_device *cdev)
 			     strlen(vhci_driver->hc_device->path))) {
 			/* found usbip device */
 			usbip_cdev = calloc(1, sizeof(*usbip_cdev));
-			if (!cdev) {
+			if (!usbip_cdev) {
 				dbg("calloc failed");
 				return -1;
 			}

