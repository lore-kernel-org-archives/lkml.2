Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2LJKU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:20:59 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35344 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab2LJKU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:20:57 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <paul@pwsan.com>, <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 02/23] mfd: omap-usb-tll: Avoid creating copy of platform data
Date: Mon, 10 Dec 2012 12:20:12 +0200
Message-ID: <1355134833-5199-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1355134833-5199-1-git-send-email-rogerq@ti.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a pointer to the platform data should suffice.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-tll.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 0db0dfa..18fefdb 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -98,7 +98,7 @@
 struct usbtll_omap {
 	struct clk				*usbtll_p1_fck;
 	struct clk				*usbtll_p2_fck;
-	struct usbtll_omap_platform_data	platdata;
+	struct usbtll_omap_platform_data	*pdata;
 	/* secure the register updates */
 	spinlock_t				lock;
 };
@@ -223,8 +223,7 @@ static int __devinit usbtll_omap_probe(struct platform_device *pdev)
 
 	spin_lock_init(&tll->lock);
 
-	for (i = 0; i < OMAP3_HS_USB_PORTS; i++)
-		tll->platdata.port_mode[i] = pdata->port_mode[i];
+	tll->pdata = pdata;
 
 	tll->usbtll_p1_fck = clk_get(dev, "usb_tll_hs_usb_ch0_clk");
 	if (IS_ERR(tll->usbtll_p1_fck)) {
@@ -362,7 +361,7 @@ static int __devexit usbtll_omap_remove(struct platform_device *pdev)
 static int usbtll_runtime_resume(struct device *dev)
 {
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
-	struct usbtll_omap_platform_data	*pdata = &tll->platdata;
+	struct usbtll_omap_platform_data	*pdata = tll->pdata;
 	unsigned long				flags;
 
 	dev_dbg(dev, "usbtll_runtime_resume\n");
@@ -388,7 +387,7 @@ static int usbtll_runtime_resume(struct device *dev)
 static int usbtll_runtime_suspend(struct device *dev)
 {
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
-	struct usbtll_omap_platform_data	*pdata = &tll->platdata;
+	struct usbtll_omap_platform_data	*pdata = tll->pdata;
 	unsigned long				flags;
 
 	dev_dbg(dev, "usbtll_runtime_suspend\n");
-- 
1.7.4.1

