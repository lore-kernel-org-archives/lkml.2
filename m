Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236Ab2KVTv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:51:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030271Ab2KVTvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:50 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 38/46] staging: line6: drop CONFIG_LINE6_USB_RAW
Date: Thu, 22 Nov 2012 20:49:17 +0100
Message-Id: <1353613765-18690-39-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that both pod.c and variax.c have removed their raw sysfs attrs, the
CONFIG_LINE6_USB_RAW config option can be dropped.  The drivers are
being stripped down to just PCM and MIDI I/O so there is less state and
filtering.  Therefore it's no longer necessary to have a special sysfs
attr to bypass the filtering ("raw").

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/Kconfig  | 11 -----------
 drivers/staging/line6/driver.c | 14 --------------
 2 files changed, 25 deletions(-)

diff --git a/drivers/staging/line6/Kconfig b/drivers/staging/line6/Kconfig
index a5ded12..2a84767 100644
--- a/drivers/staging/line6/Kconfig
+++ b/drivers/staging/line6/Kconfig
@@ -51,17 +51,6 @@ config LINE6_USB_DUMP_PCM
 
 	  If unsure, say N.
 
-config LINE6_USB_RAW
-	bool "raw data communication"
-	default n
-	help
-	  Say Y here to create special files which allow to send raw data
-	  to the device. This bypasses any sanity checks, so if you discover
-	  the code to erase the firmware, feel free to render your device
-	  useless, but only after reading the GPL section "NO WARRANTY".
-
-	  If unsure, say N.
-
 config LINE6_USB_IMPULSE_RESPONSE
 	bool "measure impulse response"
 	default n
diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 3c27051..c0986f5 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -681,20 +681,6 @@ ssize_t line6_nop_write(struct device *dev, struct device_attribute *attr,
 }
 
 /*
-	"write" request on "raw" special file.
-*/
-#ifdef CONFIG_LINE6_USB_RAW
-ssize_t line6_set_raw(struct device *dev, struct device_attribute *attr,
-		      const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	line6_send_raw_message(line6, buf, count);
-	return count;
-}
-#endif
-
-/*
 	Generic destructor.
 */
 static void line6_destruct(struct usb_interface *interface)
-- 
1.8.0

