Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965557Ab2C3WAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:00:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965539Ab2C3VRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:17:42 -0400
Message-Id: <20120330194828.681235444@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Tikhomirov <av.tikhomirov@samsung.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 020/175] usb: dwc3: use proper function for setting endpoint name
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Tikhomirov <av.tikhomirov@samsung.com>

commit 27a78d6a283d6782438f72306746afe4bf44c215 upstream.

It's wrong to use the size of array as an argument for strncat.
Memory corruption is possible. strlcat is exactly what we need here.

Signed-off-by: Anton Tikhomirov <av.tikhomirov@samsung.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -485,16 +485,16 @@ static int dwc3_gadget_ep_enable(struct
 
 	switch (usb_endpoint_type(desc)) {
 	case USB_ENDPOINT_XFER_CONTROL:
-		strncat(dep->name, "-control", sizeof(dep->name));
+		strlcat(dep->name, "-control", sizeof(dep->name));
 		break;
 	case USB_ENDPOINT_XFER_ISOC:
-		strncat(dep->name, "-isoc", sizeof(dep->name));
+		strlcat(dep->name, "-isoc", sizeof(dep->name));
 		break;
 	case USB_ENDPOINT_XFER_BULK:
-		strncat(dep->name, "-bulk", sizeof(dep->name));
+		strlcat(dep->name, "-bulk", sizeof(dep->name));
 		break;
 	case USB_ENDPOINT_XFER_INT:
-		strncat(dep->name, "-int", sizeof(dep->name));
+		strlcat(dep->name, "-int", sizeof(dep->name));
 		break;
 	default:
 		dev_err(dwc->dev, "invalid endpoint transfer type\n");


