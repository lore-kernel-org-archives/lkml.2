Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab2BAV2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:28:49 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57579 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757470Ab2BAVTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:22 -0500
X-Sasl-enc: TVpz5Rxq3kOprup0XlhgbiUNbFxKDFOPWy9WQ9AKc2Sv 1328131161
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:49 2012
Message-Id: <20120201210049.001562700@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@amd.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [58/89] usb: gadget: storage: endian fix
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit a85016390135d577c457876d0e905095600751de upstream.

Fix some endian issues for storage gadgets.

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/storage_common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -598,16 +598,16 @@ static __maybe_unused struct usb_ss_cap_
 		| USB_5GBPS_OPERATION),
 	.bFunctionalitySupport = USB_LOW_SPEED_OPERATION,
 	.bU1devExitLat =	USB_DEFAULT_U1_DEV_EXIT_LAT,
-	.bU2DevExitLat =	USB_DEFAULT_U2_DEV_EXIT_LAT,
+	.bU2DevExitLat =	cpu_to_le16(USB_DEFAULT_U2_DEV_EXIT_LAT),
 };
 
 static __maybe_unused struct usb_bos_descriptor fsg_bos_desc = {
 	.bLength =		USB_DT_BOS_SIZE,
 	.bDescriptorType =	USB_DT_BOS,
 
-	.wTotalLength =		USB_DT_BOS_SIZE
+	.wTotalLength =		cpu_to_le16(USB_DT_BOS_SIZE
 				+ USB_DT_USB_EXT_CAP_SIZE
-				+ USB_DT_USB_SS_CAP_SIZE,
+				+ USB_DT_USB_SS_CAP_SIZE),
 
 	.bNumDeviceCaps =	2,
 };


