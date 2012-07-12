Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161890Ab2GLWlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:41:20 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49910 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161877Ab2GLWlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [ 099/187] usb-storage: revert commit afff07e61a52 (Add 090c:1000 to unusal-devs)
Date: Thu, 12 Jul 2012 15:34:15 -0700
Message-Id: <20120712191531.580274734@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0070513b5e005161a7a7fd9a3f48f982b41eb094 upstream.

This patch (as1560) reverts commit
afff07e61a5243e14ee3f0a272a0380cd744a8a3 (usb-storage: Add 090c:1000
to unusal-devs).  It is no longer needed, because usb-storage now
tells the sd driver to try READ CAPACITY(10) before READ CAPACITY(16)
for every USB mass-storage device.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Hans de Goede <hdegoede@redhat.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1107,13 +1107,6 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9
 		USB_SC_RBC, USB_PR_BULK, NULL,
 		0 ),
 
-/* Feiya QDI U2 DISK, reported by Hans de Goede <hdegoede@redhat.com> */
-UNUSUAL_DEV( 0x090c, 0x1000, 0x0000, 0xffff,
-		"Feiya",
-		"QDI U2 DISK",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_READ_CAPACITY_16 ),
-
 /* aeb */
 UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
 		"Feiya",


