Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab0C3XMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:12:33 -0400
Received: from kroah.org ([198.145.64.141]:48929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab0C3XM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:26 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:32 2010
Message-Id: <20100330225831.752121564@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryan May <rmay31@gmail.com>, Rohan Hart <rohan.hart17@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [38/89] USB: fix usbstorage for 2770:915d delivers no FAT
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryan May <rmay31@gmail.com>

commit 10d2cdb6102669279bee2d9a00a22431b74583d5 upstream.

Resolves kernel.org bug 14914.

Remove entry for 2770:915d (usb digital camera with mass storage
support) from unusual_devs.h. The fix triggered by the entry causes
the file system on the camera to be completely inaccessible (no
partition table, the device is not mountable).

The patch works, but let me clarify a few things about it.  All the
patch does is remove the entry for this device from the
drivers/usb/storage/unusual_devs.h, which is supposed to help with a
problem with the device's reported size (I think).  I'm pretty sure it
was originally added for a reason, so I'm not sure removing it won't
cause other problems to reappear.  Also, I should note that this
unusual_devs.h entry was present (and activating workarounds) in
2.6.29, but in that version everything works fine.  Starting with
2.6.30, things no longer work.

Signed-off-by: Ryan May <rmay31@gmail.com>
Cc: Rohan Hart <rohan.hart17@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1827,13 +1827,6 @@ UNUSUAL_DEV(  0x2735, 0x100b, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_GO_SLOW ),
 
-/* Reported by Rohan Hart <rohan.hart17@gmail.com> */
-UNUSUAL_DEV(  0x2770, 0x915d, 0x0010, 0x0010,
-		"INTOVA",
-		"Pixtreme",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY ),
-
 /* Reported by Frederic Marchal <frederic.marchal@wowcompany.com>
  * Mio Moov 330
  */


