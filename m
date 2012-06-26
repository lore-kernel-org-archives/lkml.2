Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab2FZO1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:27:36 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49790 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2FZO1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:27:34 -0400
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
Subject: [PATCH 2/5] usb: gadget: s3c-hsotg: Propagate devicetree to gadget drivers
Date: Tue, 26 Jun 2012 11:27:10 -0300
Message-Id: <1340720833-781-3-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com>
References: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fill dev.of_node of gadget drivers, so they can use devicetree

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index f4abb0e..fed2f28 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2954,6 +2954,7 @@ static int s3c_hsotg_udc_start(struct usb_gadget *gadget,
 	driver->driver.bus = NULL;
 	hsotg->driver = driver;
 	hsotg->gadget.dev.driver = &driver->driver;
+	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
 	hsotg->gadget.dev.dma_mask = hsotg->dev->dma_mask;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 
-- 
1.7.10

