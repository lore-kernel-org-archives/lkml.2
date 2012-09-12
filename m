Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2ILUaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:30:52 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45036 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2ILUau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:30:50 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Stigge <stigge@antcom.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [PATCH] usb: gadget: lpc32xx_udc: Fix compatibility with STOTG04
Date: Wed, 12 Sep 2012 17:30:10 -0300
Message-Id: <1347481810-21554-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STOTG04 is an replacement for ISP1301.

Most of the registers on STOTG04 are the same as on ISP1301, but the
register ISP1301_I2C_OTG_CONTROL_2 (address 0x10) doesn't exist on the
ST part.

This is a work around for this by using the interrupt source register that
should behave the same on both parts and has the needed information.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/usb/gadget/lpc32xx_udc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
index f696fb9..21a9861 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -2930,10 +2930,10 @@ static void vbus_work(struct work_struct *work)
 
 		/* Get the VBUS status from the transceiver */
 		value = i2c_smbus_read_byte_data(udc->isp1301_i2c_client,
-						 ISP1301_I2C_OTG_CONTROL_2);
+						 ISP1301_I2C_INTERRUPT_SOURCE);
 
 		/* VBUS on or off? */
-		if (value & OTG_B_SESS_VLD)
+		if (value & INT_SESS_VLD)
 			udc->vbus = 1;
 		else
 			udc->vbus = 0;
-- 
1.7.10

