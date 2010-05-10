Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab0EJW7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:59:37 -0400
Received: from kroah.org ([198.145.64.141]:51653 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791Ab0EJW5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:42 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:36 2010
Message-Id: <20100510223536.332841187@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [21/98] USB: dont choose configs with no interfaces
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 62f9cfa3ece58268b3e92ca59c23b175f86205aa upstream.

This patch (as1372) fixes a bug in the routine that chooses the
default configuration to install when a new USB device is detected.
The algorithm is supposed to look for a config whose first interface
is for a non-vendor-specific class.  But the way it's currently
written, it will also accept a config with no interfaces at all, which
is not very useful.  (Believe it or not, such things do exist.)

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Andrew Victor <avictor.za@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -120,7 +120,7 @@ int usb_choose_configuration(struct usb_
 		 * than a vendor-specific driver. */
 		else if (udev->descriptor.bDeviceClass !=
 						USB_CLASS_VENDOR_SPEC &&
-				(!desc || desc->bInterfaceClass !=
+				(desc && desc->bInterfaceClass !=
 						USB_CLASS_VENDOR_SPEC)) {
 			best = c;
 			break;


