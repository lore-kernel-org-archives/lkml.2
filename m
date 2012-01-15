Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2AOLgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 06:36:25 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:35964 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2AOLgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 06:36:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Neil Zhang <zhangwm@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] usb: mv-otg - Fix build if CONFIG_USB is not set
Date: Sun, 15 Jan 2012 12:36:16 +0100
Message-Id: <1326627376-12883-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "usb_remove_hcd" [drivers/usb/otg/mv_otg.ko] undefined!
ERROR: "usb_add_hcd" [drivers/usb/otg/mv_otg.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
--
Inpired by drivers/usb/otg/msm_otg.c. Is this correct?

 drivers/usb/otg/mv_otg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/otg/mv_otg.c b/drivers/usb/otg/mv_otg.c
index db0d4fc..b5fbe14 100644
--- a/drivers/usb/otg/mv_otg.c
+++ b/drivers/usb/otg/mv_otg.c
@@ -202,6 +202,7 @@ static void mv_otg_init_irq(struct mv_otg *mvotg)
 
 static void mv_otg_start_host(struct mv_otg *mvotg, int on)
 {
+#ifdef CONFIG_USB
 	struct otg_transceiver *otg = &mvotg->otg;
 	struct usb_hcd *hcd;
 
@@ -216,6 +217,7 @@ static void mv_otg_start_host(struct mv_otg *mvotg, int on)
 		usb_add_hcd(hcd, hcd->irq, IRQF_SHARED);
 	else
 		usb_remove_hcd(hcd);
+#endif /* CONFIG_USB */
 }
 
 static void mv_otg_start_periphrals(struct mv_otg *mvotg, int on)
-- 
1.7.0.4

