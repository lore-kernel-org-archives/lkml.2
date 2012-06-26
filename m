Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab2FZO1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:27:42 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:61655 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab2FZO1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:27:40 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Li Yang <leoli@freescale.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Roland Stigge <stigge@antcom.de>
Subject: [PATCH 4/5] usb: gadget: at91_udc: Propagate devicetree to gadget drivers
Date: Tue, 26 Jun 2012 11:27:12 -0300
Message-Id: <1340720833-781-5-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com>
References: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fill dev.of_node of gadget drivers, so they can use devicetree

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/usb/gadget/at91_udc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 1a4430f..c9e66df 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1634,6 +1634,7 @@ static int at91_start(struct usb_gadget *gadget,
 	udc = container_of(gadget, struct at91_udc, gadget);
 	udc->driver = driver;
 	udc->gadget.dev.driver = &driver->driver;
+	udc->gadget.dev.of_node = udc->pdev->dev.of_node;
 	dev_set_drvdata(&udc->gadget.dev, &driver->driver);
 	udc->enabled = 1;
 	udc->selfpowered = 1;
-- 
1.7.10

