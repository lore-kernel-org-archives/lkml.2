Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1ITIun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:50:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64334 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1ITIul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:50:41 -0400
Subject: [PATCH] usb: musb: OMAP4430: Remove a redundant omap4430_phy_init
 call in usb_musb_init
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 16:50:29 +0800
Message-ID: <1316508629.14514.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code calls omap4430_phy_init() twice in usb_musb_init().
Calling omap4430_phy_init() once is enough.
This patch removes the first omap4430_phy_init() call, which using an
uninitialized pointer as parameter.

This patch elimates below build warning:
arch/arm/mach-omap2/usb-musb.c: In function 'usb_musb_init':
arch/arm/mach-omap2/usb-musb.c:141: warning: 'dev' may be used uninitialized in this function

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-omap2/usb-musb.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
index a65145b..19e4dac 100644
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@ -137,9 +137,6 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
 	musb_plat.mode = board_data->mode;
 	musb_plat.extvbus = board_data->extvbus;
 
-	if (cpu_is_omap44xx())
-		omap4430_phy_init(dev);
-
 	if (cpu_is_omap3517() || cpu_is_omap3505()) {
 		oh_name = "am35x_otg_hs";
 		name = "musb-am35x";
-- 
1.7.4.1



