Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2GNHk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 03:40:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36808 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2GNHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 03:40:55 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] staging/winbond: use err and remove nr
Date: Sat, 14 Jul 2012 13:25:37 +0545
Message-Id: <1342251637-16327-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err can be used get return status of the  usb_control_msg, rather using
nr and assigning it to err when the function returns error.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/winbond/wbusb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index c3751a7..ef36054 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -747,20 +747,18 @@ static int wb35_probe(struct usb_interface *intf,
 	struct usb_host_interface *interface;
 	struct ieee80211_hw *dev;
 	struct wbsoft_priv *priv;
-	int nr, err;
+	int err;
 	u32 ltmp;
 
 	usb_get_dev(udev);
 
 	/* Check the device if it already be opened */
-	nr = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+	err = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			     0x01,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 			     0x0, 0x400, &ltmp, 4, HZ * 100);
-	if (nr < 0) {
-		err = nr;
+	if (err < 0)
 		goto error;
-	}
 
 	/* Is already initialized? */
 	ltmp = cpu_to_le32(ltmp);
-- 
1.7.9.5

