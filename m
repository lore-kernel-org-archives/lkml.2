Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab2FZO1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:27:40 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49790 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892Ab2FZO1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:27:37 -0400
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
Subject: [PATCH 3/5] usb: gadget: fsl_udc: Propagate devicetree to gadget drivers
Date: Tue, 26 Jun 2012 11:27:11 -0300
Message-Id: <1340720833-781-4-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com>
References: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fill dev.of_node of gadget drivers, so they can use devicetree

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/usb/gadget/fsl_udc_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index bc6f9bb..a65ca0f 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2560,6 +2560,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	dev_set_name(&udc_controller->gadget.dev, "gadget");
 	udc_controller->gadget.dev.release = fsl_udc_release;
 	udc_controller->gadget.dev.parent = &pdev->dev;
+	udc_controller->gadget.dev.of_node = pdev->dev.of_node;
 	ret = device_register(&udc_controller->gadget.dev);
 	if (ret < 0)
 		goto err_free_irq;
-- 
1.7.10

