Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab2FYUWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:22:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58282 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab2FYUV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:21:57 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [RFC 1/2] usb: gadget: lpc32xx_udc: Propagate devicetree information
Date: Mon, 25 Jun 2012 17:21:43 -0300
Message-Id: <1340655704-30398-2-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340655704-30398-1-git-send-email-aletes.xgr@gmail.com>
References: <1340655704-30398-1-git-send-email-aletes.xgr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fills the gadget.dev.of_node, so gadget drivers can use devicetree nodes

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/usb/gadget/lpc32xx_udc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
index 93a901b..551c0e9 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -3005,6 +3005,7 @@ static int lpc32xx_start(struct usb_gadget_driver *driver,
 
 	udc->driver = driver;
 	udc->gadget.dev.driver = &driver->driver;
+	udc->gadget.dev.of_node = udc->dev->of_node;
 	udc->enabled = 1;
 	udc->selfpowered = 1;
 	udc->vbus = 0;
-- 
1.7.10

