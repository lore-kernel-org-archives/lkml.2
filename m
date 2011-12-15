Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809Ab1LOXFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:05:36 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48414 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759773Ab1LOXFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:05:34 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Kosina <trivial@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 3/3] usb: musb: remove a bit of indentation
Date: Fri, 16 Dec 2011 01:05:10 +0200
Message-Id: <1323990310-11905-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1323990310-11905-1-git-send-email-felipe.contreras@gmail.com>
References: <1323990310-11905-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use dev instead of musb->controller.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/musb/omap2430.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index a615538..31fc8a2 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -344,20 +344,19 @@ static void omap2430_musb_enable(struct musb *musb)
 
 	case USB_EVENT_ID:
 		otg_init(musb->xceiv);
-		if (data->interface_type == MUSB_INTERFACE_UTMI) {
-			devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
-			/* start the session */
-			devctl |= MUSB_DEVCTL_SESSION;
-			musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
-			while (musb_readb(musb->mregs, MUSB_DEVCTL) &
-						MUSB_DEVCTL_BDEVICE) {
-				cpu_relax();
-
-				if (time_after(jiffies, timeout)) {
-					dev_err(musb->controller,
-					"configured as A device timeout");
-					break;
-				}
+		if (data->interface_type != MUSB_INTERFACE_UTMI)
+			break;
+		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
+		/* start the session */
+		devctl |= MUSB_DEVCTL_SESSION;
+		musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
+		while (musb_readb(musb->mregs, MUSB_DEVCTL) &
+				MUSB_DEVCTL_BDEVICE) {
+			cpu_relax();
+
+			if (time_after(jiffies, timeout)) {
+				dev_err(dev, "configured as A device timeout");
+				break;
 			}
 		}
 		break;
-- 
1.7.8.rc1.14.g248db

