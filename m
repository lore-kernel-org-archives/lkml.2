Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab2DXWiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:38:51 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804Ab2DXWir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:47 -0400
Message-Id: <20120424223255.538488051@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kishon Vijay Abraham I <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 24/42] usb: musb: omap: fix crash when musb glue (omap) gets initialized
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 3006dc8c627d738693e910c159630e4368c9e86c upstream.

pm_runtime_enable is being called after omap2430_musb_init. Hence
pm_runtime_get_sync in omap2430_musb_init does not have any effect (does
not enable clocks) resulting in a crash during register access. It is
fixed here.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/omap2430.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -464,14 +464,14 @@ static int __init omap2430_probe(struct
 		goto err2;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+
 	ret = platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
 		goto err2;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-
 	return 0;
 
 err2:


