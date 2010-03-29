Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0C2PnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:43:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab0C2PnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:43:17 -0400
Date: Mon, 29 Mar 2010 11:42:37 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Torrey Hoffman <thoffman@arnor.net>
Subject: [PATCH] ati_remote: add some missing devices from lirc_atiusb
Message-ID: <20100329154237.GB26097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The (out-of-tree) lirc_atiusb driver has a much longer list of devices
it supports. Some of them look like they may just be guesses at possible
device IDs, but a few are definitely confirmed devices. This adds the
nVidia-branded RF receiver and the X10 Lola Wireless Video Sender device
(which contains an RF receiver) to the list of devices in ati_remote.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/input/misc/ati_remote.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/ati_remote.c b/drivers/input/misc/ati_remote.c
index 614b65d..e8bbc61 100644
--- a/drivers/input/misc/ati_remote.c
+++ b/drivers/input/misc/ati_remote.c
@@ -98,10 +98,12 @@
  * Module and Version Information, Module Parameters
  */
 
-#define ATI_REMOTE_VENDOR_ID	0x0bc7
-#define ATI_REMOTE_PRODUCT_ID	0x004
-#define LOLA_REMOTE_PRODUCT_ID	0x002
-#define MEDION_REMOTE_PRODUCT_ID 0x006
+#define ATI_REMOTE_VENDOR_ID		0x0bc7
+#define LOLA_REMOTE_PRODUCT_ID		0x0002
+#define LOLA2_REMOTE_PRODUCT_ID		0x0003
+#define ATI_REMOTE_PRODUCT_ID		0x0004
+#define NVIDIA_REMOTE_PRODUCT_ID	0x0005
+#define MEDION_REMOTE_PRODUCT_ID	0x0006
 
 #define DRIVER_VERSION	        "2.2.1"
 #define DRIVER_AUTHOR           "Torrey Hoffman <thoffman@arnor.net>"
@@ -142,8 +144,10 @@ MODULE_PARM_DESC(repeat_delay, "Delay before sending repeats, default = 500 msec
 #define err(format, arg...) printk(KERN_ERR format , ## arg)
 
 static struct usb_device_id ati_remote_table[] = {
-	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID) },
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA_REMOTE_PRODUCT_ID) },
+	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA2_REMOTE_PRODUCT_ID) },
+	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID) },
+	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, NVIDIA_REMOTE_PRODUCT_ID) },
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, MEDION_REMOTE_PRODUCT_ID) },
 	{}	/* Terminating entry */
 };

-- 
Jarod Wilson
jarod@redhat.com

