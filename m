Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab0G3SP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:15:59 -0400
Received: from kroah.org ([198.145.64.141]:58873 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760064Ab0G3R4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:46 2010
Message-Id: <20100730175146.502271351@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Neukum <oneukum@suse.de>
Subject: [138/205] USB: sisusbvga: Fix for USB 3.0
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 20a12f007feee1cfa761b431047271d1141d8031 upstream.

Super speed is also fast enough to let sisusbvga operate.
Therefor expand the checks.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/sisusbvga/sisusb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -2442,7 +2442,8 @@ sisusb_open(struct inode *inode, struct
 	}
 
 	if (!sisusb->devinit) {
-		if (sisusb->sisusb_dev->speed == USB_SPEED_HIGH) {
+		if (sisusb->sisusb_dev->speed == USB_SPEED_HIGH ||
+		    sisusb->sisusb_dev->speed == USB_SPEED_SUPER) {
 			if (sisusb_init_gfxdevice(sisusb, 0)) {
 				mutex_unlock(&sisusb->lock);
 				dev_err(&sisusb->sisusb_dev->dev, "Failed to initialize device\n");
@@ -3177,7 +3178,7 @@ static int sisusb_probe(struct usb_inter
 
 	sisusb->present = 1;
 
-	if (dev->speed == USB_SPEED_HIGH) {
+	if (dev->speed == USB_SPEED_HIGH || dev->speed == USB_SPEED_SUPER) {
 		int initscreen = 1;
 #ifdef INCL_SISUSB_CON
 		if (sisusb_first_vc > 0 &&


