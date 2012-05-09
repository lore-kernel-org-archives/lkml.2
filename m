Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2EIGbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:31:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38711 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322Ab2EIFwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:47 -0400
Message-Id: <20120509055034.892269140@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shubhrajyoti D <shubhrajyoti@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 038/167] [PATCH] usb: musb: omap: fix the error check for pm_runtime_get_sync
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti D <shubhrajyoti@ti.com>

commit ad579699c4f0274bf522a9252ff9b20c72197e48 upstream.

pm_runtime_get_sync returns a signed integer. In case of errors
it returns a negative value. This patch fixes the error check
by making it signed instead of unsigned thus preventing register
access if get_sync_fails. Also passes the error cause to the
debug message.

Cc:  Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/musb/omap2430.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 0fb4ce8..c7785e8 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -282,7 +282,8 @@ static void musb_otg_notifier_work(struct work_struct *data_notifier_work)
 
 static int omap2430_musb_init(struct musb *musb)
 {
-	u32 l, status = 0;
+	u32 l;
+	int status = 0;
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *plat = dev->platform_data;
 	struct omap_musb_board_data *data = plat->board_data;
@@ -301,7 +302,7 @@ static int omap2430_musb_init(struct musb *musb)
 
 	status = pm_runtime_get_sync(dev);
 	if (status < 0) {
-		dev_err(dev, "pm_runtime_get_sync FAILED");
+		dev_err(dev, "pm_runtime_get_sync FAILED %d\n", status);
 		goto err1;
 	}
 
-- 
1.7.10



