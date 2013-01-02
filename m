Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3ABPCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:02:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50891 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab3ABPB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:01:57 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 21/22] mfd: omap-usb-host: Don't spam console on clk_set_parent failure
Date: Wed, 2 Jan 2013 17:00:41 +0200
Message-ID: <1357138842-28964-22-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357138842-28964-1-git-send-email-rogerq@ti.com>
References: <1357138842-28964-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_set_parent is expected to fail on OMAP3 platforms. We don't
consider that as fatal so don't spam console.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 9166df3..bf2a06a 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -672,32 +672,32 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[0])) {
-		/* for OMAP3 , the clk set paretn fails */
+		/* for OMAP3, clk_set_parent fails */
 		ret = clk_set_parent(omap->utmi_p1_gfclk,
 					omap->xclk60mhsp1_ck);
 		if (ret != 0)
-			dev_err(dev, "xclk60mhsp1_ck set parent"
-				"failed error:%d\n", ret);
+			dev_dbg(dev, "xclk60mhsp1_ck set parent failed: %d\n",
+					ret);
 	} else if (is_ehci_tll_mode(pdata->port_mode[0])) {
 		ret = clk_set_parent(omap->utmi_p1_gfclk,
 					omap->init_60m_fclk);
 		if (ret != 0)
-			dev_err(dev, "init_60m_fclk set parent"
-				"failed error:%d\n", ret);
+			dev_dbg(dev, "P0 init_60m_fclk set parent failed: %d\n",
+					ret);
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[1])) {
 		ret = clk_set_parent(omap->utmi_p2_gfclk,
 					omap->xclk60mhsp2_ck);
 		if (ret != 0)
-			dev_err(dev, "xclk60mhsp2_ck set parent"
-					"failed error:%d\n", ret);
+			dev_dbg(dev, "xclk60mhsp2_ck set parent failed: %d\n",
+					ret);
 	} else if (is_ehci_tll_mode(pdata->port_mode[1])) {
 		ret = clk_set_parent(omap->utmi_p2_gfclk,
 						omap->init_60m_fclk);
 		if (ret != 0)
-			dev_err(dev, "init_60m_fclk set parent"
-				"failed error:%d\n", ret);
+			dev_dbg(dev, "P1 init_60m_fclk set parent failed: %d\n",
+					ret);
 	}
 
 	omap_usbhs_init(dev);
-- 
1.7.4.1

