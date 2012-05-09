Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab2EIGcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:32:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38705 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755219Ab2EIFwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:46 -0400
Message-Id: <20120509055034.752013456@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kishon Vijay Abraham I <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 037/167] [PATCH] usb: musb: omap: fix crash when musb glue (omap) gets
 initialized
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 3006dc8c627d738693e910c159630e4368c9e86c upstream.

pm_runtime_enable is being called after omap2430_musb_init. Hence
pm_runtime_get_sync in omap2430_musb_init does not have any effect (does
not enable clocks) resulting in a crash during register access. It is
fixed here.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/musb/omap2430.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 3dfd122..0fb4ce8 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -453,14 +453,14 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
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
-- 
1.7.10



