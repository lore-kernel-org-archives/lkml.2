Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1HPCw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:52:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab1HPCwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:52:25 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:53 2011
Message-Id: <20110816024453.390079876@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:42:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nick Bowler <nbowler@elliptictech.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [08/26] USB: usb-storage: unusual_devs entry for ARM V2M
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------
 motherboard.

From: Nick Bowler <nbowler@elliptictech.com>

commit a871e4f5519d8c52430052e1d340dd5710eb5ad6 upstream.

Connecting the V2M to a Linux host results in a constant stream of
errors spammed to the console, all of the form

  sd 1:0:0:0: ioctl_internal_command return code = 8070000
     : Sense Key : 0x4 [current]
     : ASC=0x0 ASCQ=0x0

The errors appear to be otherwise harmless.  Add an unusual_devs entry
which eliminates all of the error messages.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1988,6 +1988,16 @@ UNUSUAL_DEV(  0x4146, 0xba01, 0x0100, 0x
 		"Micro Mini 1GB",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
 
+/*
+ * Nick Bowler <nbowler@elliptictech.com>
+ * SCSI stack spams (otherwise harmless) error messages.
+ */
+UNUSUAL_DEV(  0xc251, 0x4003, 0x0100, 0x0100,
+		"Keil Software, Inc.",
+		"V2M MotherBoard",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NOT_LOCKABLE),
+
 /* Reported by Andrew Simmons <andrew.simmons@gmail.com> */
 UNUSUAL_DEV(  0xed06, 0x4500, 0x0001, 0x0001,
 		"DataStor",


