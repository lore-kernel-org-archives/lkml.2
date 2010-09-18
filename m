Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0IRTcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:32:07 -0400
Received: from kroah.org ([198.145.64.141]:43388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab0IRTPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:12 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:01 2010
Message-Id: <20100918191301.436134282@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Toby Gray <toby.gray@realvnc.com>, Oliver Neukum <oliver@neukum.name>
Subject: [048/129] USB: cdc-acm: Adding second ACM channel support for various Nokia and one Samsung phones
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Toby Gray <toby.gray@realvnc.com>

commit 4035e45632c2a8bb4edae83c20447051bd9a9604 upstream.

S60 phones from Nokia and Samsung expose two ACM channels. The first is a modem
with a standard AT-command interface, which is picked up correctly by CDC-ACM.

The second ACM port is marked as having a vendor-specific protocol. This means
that the ACM driver will not claim the second channel by default.

This adds support for the second ACM channel for the following devices:
    Nokia E63
    Nokia E75
    Nokia 6760 Slide
    Nokia E52
    Nokia E55
    Nokia E72
    Nokia X6
    Nokia N97 Mini
    Nokia 5800 Xpressmusic
    Nokia E90
    Samsung GTi8510 (INNOV8)

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
Cc: Oliver Neukum <oliver@neukum.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1487,6 +1487,11 @@ static int acm_reset_resume(struct usb_i
 		USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM, \
 		USB_CDC_ACM_PROTO_VENDOR)
 
+#define SAMSUNG_PCSUITE_ACM_INFO(x) \
+		USB_DEVICE_AND_INTERFACE_INFO(0x04e7, x, \
+		USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM, \
+		USB_CDC_ACM_PROTO_VENDOR)
+
 /*
  * USB driver structure.
  */
@@ -1597,6 +1602,17 @@ static const struct usb_device_id acm_id
 	{ NOKIA_PCSUITE_ACM_INFO(0x0108), }, /* Nokia 5320 XpressMusic 2G */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01f5), }, /* Nokia N97, RM-505 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x02e3), }, /* Nokia 5230, RM-588 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0178), }, /* Nokia E63 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x010e), }, /* Nokia E75 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x02d9), }, /* Nokia 6760 Slide */
+	{ NOKIA_PCSUITE_ACM_INFO(0x01d0), }, /* Nokia E52 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0223), }, /* Nokia E72 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0275), }, /* Nokia X6 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x026c), }, /* Nokia N97 Mini */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0154), }, /* Nokia 5800 XpressMusic */
+	{ NOKIA_PCSUITE_ACM_INFO(0x04ce), }, /* Nokia E90 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x01d4), }, /* Nokia E55 */
+	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
 


