Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab0FBLjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:39:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab0FBLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:38:53 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 07/11] OMAP2: Devkit8000: Remove en-/disable for tv panel
Date: Wed,  2 Jun 2010 13:37:47 +0200
Message-Id: <1275478671-24563-8-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275478671-24563-1-git-send-email-weber@corscience.de>
References: <1275478671-24563-1-git-send-email-weber@corscience.de>
X-Provags-ID: V01U2FsdGVkX1+c0WOCul5dz9FkYOBWFsg3htn9AUhW0Bbm8tU
 s0lpuUhu3+aiJ2UJ/tPH1XPlYxYCxCU+N3dj+ENR3+MQfIeJJr
 yN0woEt81cHkN59U9L0FA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devkit8000_panel_enable_tv and devkit8000_panel_disable_tv are already
done in DSS2 code. So they are no longer needed in board code.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 59877b1..095dc7a 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -158,16 +158,6 @@ static void devkit8000_panel_disable_dvi(struct omap_dss_device *dssdev)
 		gpio_set_value(dssdev->reset_gpio, 0);
 }
 
-static int devkit8000_panel_enable_tv(struct omap_dss_device *dssdev)
-{
-
-	return 0;
-}
-
-static void devkit8000_panel_disable_tv(struct omap_dss_device *dssdev)
-{
-}
-
 static struct regulator_consumer_supply devkit8000_vmmc1_supply = {
 	.supply			= "vmmc",
 };
@@ -201,8 +191,6 @@ static struct omap_dss_device devkit8000_tv_device = {
 	.driver_name            = "venc",
 	.type                   = OMAP_DISPLAY_TYPE_VENC,
 	.phy.venc.type          = OMAP_DSS_VENC_TYPE_SVIDEO,
-	.platform_enable        = devkit8000_panel_enable_tv,
-	.platform_disable       = devkit8000_panel_disable_tv,
 };
 
 
-- 
1.7.1

