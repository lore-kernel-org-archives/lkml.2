Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2GJGcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:32:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59535 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2GJGck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:32:40 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        kishon@ti.com
Subject: [PATCH] usb: twl6030-usb: variable otg not declared in twl6030_usbotg_irq() in linux-next
Date: Mon,  9 Jul 2012 23:32:20 -0700
Message-Id: <1341901940-12277-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.11.1.165.g299666c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ff9cce82 added back 2 lines that were removed by commit
c83a8542 causing build of twl6030-usb to get an error due to otg being
referenced, but not declared. This patch removes those 2 lines again
to restore intent of commit c83a8542.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/usb/otg/twl6030-usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
index a3d0c04..6907d8d 100644
--- a/drivers/usb/otg/twl6030-usb.c
+++ b/drivers/usb/otg/twl6030-usb.c
@@ -302,8 +302,6 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 		twl6030_writeb(twl, TWL_MODULE_USB, 0x1, USB_ID_INT_EN_HI_CLR);
 		twl6030_writeb(twl, TWL_MODULE_USB, 0x10, USB_ID_INT_EN_HI_SET);
 		status = OMAP_MUSB_ID_GROUND;
-		otg->default_a = true;
-		twl->phy.state = OTG_STATE_A_IDLE;
 		twl->linkstat = status;
 		omap_musb_mailbox(status);
 	} else  {
-- 
1.7.11.1.165.g299666c

