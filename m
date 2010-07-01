Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab0GASXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:23:05 -0400
Received: from kroah.org ([198.145.64.141]:35444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711Ab0GASXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:00 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:09 2010
Message-Id: <20100701173209.681364795@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [patch 034/149] USB: mxc: gadget: Fix bitfield for calculating maximum packet size
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

commit 88e3b59b5adce5b12e205af0e34d518ba0dcdc0c upstream.

The max packet length bit mask used for isochronous endpoints
should be 0x7FF instead of 0x8FF. 0x8FF will actually clear
higher-order bits in the max packet length field.

This patch applies to 2.6.34-rc6.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/fsl_udc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -489,7 +489,7 @@ static int fsl_ep_enable(struct usb_ep *
 	case USB_ENDPOINT_XFER_ISOC:
 		/* Calculate transactions needed for high bandwidth iso */
 		mult = (unsigned char)(1 + ((max >> 11) & 0x03));
-		max = max & 0x8ff;	/* bit 0~10 */
+		max = max & 0x7ff;	/* bit 0~10 */
 		/* 3 transactions at most */
 		if (mult > 3)
 			goto en_done;


