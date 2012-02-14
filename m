Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658Ab2BNIyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 03:54:55 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:49660 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756454Ab2BNIyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 03:54:53 -0500
MIME-Version: 1.0
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] arm: omap: usb-host: fix compile warning
Date: Tue, 14 Feb 2012 10:54:46 +0200
Message-Id: <1329209686-25551-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.9
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when commit 3528c58 (OMAP: omap_device: when
building return platform_device instead of
omap_device) started returning a platform_device
instead of a omap_device pointer when building
a device, it failed to convert all users introducing
a compile warning when building
arch/arm/mach-omap2/usb-host.c.

This patch fixes that warning.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/usb-host.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index 771dc78..f51348d 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -486,7 +486,7 @@ static void setup_4430ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
 void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 {
 	struct omap_hwmod	*oh[2];
-	struct omap_device	*od;
+	struct platform_device	*pdev;
 	int			bus_id = -1;
 	int			i;
 
@@ -522,11 +522,11 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 		return;
 	}
 
-	od = omap_device_build_ss(OMAP_USBHS_DEVICE, bus_id, oh, 2,
+	pdev = omap_device_build_ss(OMAP_USBHS_DEVICE, bus_id, oh, 2,
 				(void *)&usbhs_data, sizeof(usbhs_data),
 				omap_uhhtll_latency,
 				ARRAY_SIZE(omap_uhhtll_latency), false);
-	if (IS_ERR(od)) {
+	if (IS_ERR(pdev)) {
 		pr_err("Could not build hwmod devices %s,%s\n",
 			USBHS_UHH_HWMODNAME, USBHS_TLL_HWMODNAME);
 		return;
-- 
1.7.9

