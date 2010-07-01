Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0GAWQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:16:46 -0400
Received: from kroah.org ([198.145.64.141]:47263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569Ab0GAUtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:50 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:29 2010
Message-Id: <20100701173429.889491983@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans de Goede <hdegoede@redhat.com>
Subject: [patch 036/164] USB: unusual-dev: Add bad sense flag for Appotech ax203 based picture frames
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1858,6 +1858,21 @@ UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x
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


