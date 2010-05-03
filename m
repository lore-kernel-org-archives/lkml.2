Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0ECTmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:42:11 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:51080 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0ECTmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:42:09 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCH 2.6.34-rc6] mxc: gadget: Fix bitfield for calculating maximum packet size
Date: Mon,  3 May 2010 14:41:03 -0500
Message-Id: <1272915663-21562-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

The max packet length bit mask used for isochronous endpoints
should be 0x7FF instead of 0x8FF. 0x8FF will actually clear
higher-order bits in the max packet length field.

This patch applies to 2.6.34-rc6.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 drivers/usb/gadget/fsl_udc_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index fa3d142..08a9a62 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -489,7 +489,7 @@ static int fsl_ep_enable(struct usb_ep *_ep,
 	case USB_ENDPOINT_XFER_ISOC:
 		/* Calculate transactions needed for high bandwidth iso */
 		mult = (unsigned char)(1 + ((max >> 11) & 0x03));
-		max = max & 0x8ff;	/* bit 0~10 */
+		max = max & 0x7ff;	/* bit 0~10 */
 		/* 3 transactions at most */
 		if (mult > 3)
 			goto en_done;
-- 
1.6.0.4

