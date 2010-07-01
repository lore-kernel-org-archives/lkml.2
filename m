Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab0GAV4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:56:46 -0400
Received: from kroah.org ([198.145.64.141]:60760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804Ab0GAVNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:21 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:50 2010
Message-Id: <20100701174250.305229695@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans de Goede <hdegoede@redhat.com>
Subject: [046/200] USB: unusual-dev: Add bad sense flag for Appotech ax203 based picture frames
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit a78f4f1a16d87f3d33158d036af94e48e32f8aad upstream.

These Appotech controllers are found in Picture Frames, they provide a
(buggy) emulation of a cdrom drive which contains the windows software
Uploading of pictures happens over the corresponding /dev/sg device.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1853,6 +1853,21 @@ UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* Reported by Hans de Goede <hdegoede@redhat.com>
+ * These Appotech controllers are found in Picture Frames, they provide a
+ * (buggy) emulation of a cdrom drive which contains the windows software
+ * Uploading of pictures happens over the corresponding /dev/sg device. */
+UNUSUAL_DEV( 0x1908, 0x1315, 0x0000, 0x0000,
+		"BUILDWIN",
+		"Photo Frame",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_BAD_SENSE ),
+UNUSUAL_DEV( 0x1908, 0x1320, 0x0000, 0x0000,
+		"BUILDWIN",
+		"Photo Frame",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_BAD_SENSE ),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",


