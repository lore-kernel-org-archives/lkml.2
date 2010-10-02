Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0JBFmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 01:42:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61904 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0JBFmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 01:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ErL1bgT7LAWmkQeN5sqjmETn0KN9RlE7zyADEPerIPF4ENmF7r3u7hzg3lbJnjMIDJ
         9EkrMmrop26nNxgfjnJj82t+OrXVqV28yCCUVvfvcYbnWyDf9mTKbYJQzOMgnnMa/AaX
         4EqR/T65Qw1JRhf7sUQtudKYr+IMenjL3M06Y=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: Li Yang <leoli@freescale.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rahul Ruikar <rahul.ruikar@gmail.com>,
        Rahul Ruikar <raul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: fsl_udc_core: Fix error path
Date: Sat,  2 Oct 2010 11:11:36 +0530
Message-Id: <1285998096-3385-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <raul.ruikar@gmail.com>
---
 drivers/usb/gadget/fsl_udc_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 08a9a62..491fc7a 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2340,8 +2340,10 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	udc_controller->gadget.dev.release = fsl_udc_release;
 	udc_controller->gadget.dev.parent = &pdev->dev;
 	ret = device_register(&udc_controller->gadget.dev);
-	if (ret < 0)
+	if (ret < 0) {
+		put_device(&udc_controller->gadget.dev);
 		goto err_free_irq;
+	}
 
 	/* setup QH and epctrl for ep0 */
 	ep0_setup(udc_controller);
-- 
1.7.2.3

