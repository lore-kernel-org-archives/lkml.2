Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab2DXWgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:36:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab2DXWgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:16 -0400
Message-Id: <20120424223245.906736674@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kishon Vijay Abraham I <kishon@ti.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 46/62] usb: musb: omap: fix the error check for pm_runtime_get_sync
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/omap2430.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -281,7 +281,8 @@ static void musb_otg_notifier_work(struc
 
 static int omap2430_musb_init(struct musb *musb)
 {
-	u32 l, status = 0;
+	u32 l;
+	int status = 0;
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *plat = dev->platform_data;
 	struct omap_musb_board_data *data = plat->board_data;
@@ -300,7 +301,7 @@ static int omap2430_musb_init(struct mus
 
 	status = pm_runtime_get_sync(dev);
 	if (status < 0) {
-		dev_err(dev, "pm_runtime_get_sync FAILED");
+		dev_err(dev, "pm_runtime_get_sync FAILED %d\n", status);
 		goto err1;
 	}
 


