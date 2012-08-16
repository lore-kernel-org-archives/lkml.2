Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab2HPLBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:01:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33887 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab2HPLBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:01:12 -0400
From: Matthias Brugger <mbrugger@iseebcn.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthias Brugger <mbrugger@iseebcn.com>
Subject: [PATCH] usb/musb/omap2430.c Delete unused variable.
Date: Thu, 16 Aug 2012 13:00:25 +0200
Message-Id: <1345114825-10331-1-git-send-email-mbrugger@iseebcn.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120816101917.GK10736@arwen.pp.htv.fi>
References: <20120816101917.GK10736@arwen.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ret is always evaluated as true, so we don't need to check it.

Signed-off-by: Matthias Brugger <mbrugger@iseebcn.com>
---
 drivers/usb/musb/omap2430.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 5fdb9da..2d207c6 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -140,7 +140,6 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 	struct usb_otg	*otg = musb->xceiv->otg;
 	u8		devctl;
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
-	int ret = 1;
 	/* HDRC controls CPEN, but beware current surges during device
 	 * connect.  They can trigger transient overcurrent conditions
 	 * that must be ignored.
@@ -164,12 +163,11 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 				if (time_after(jiffies, timeout)) {
 					dev_err(musb->controller,
 					"configured as A device timeout");
-					ret = -EINVAL;
 					break;
 				}
 			}
 
-			if (ret && otg->set_vbus)
+			if (otg->set_vbus)
 				otg_set_vbus(otg, 1);
 		} else {
 			musb->is_active = 1;
-- 
1.7.9.5

