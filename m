Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2KOVVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:21:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2KOVUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:20:48 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] ARM: tegra: Add Tegra20 host1x clock support
Date: Thu, 15 Nov 2012 22:07:56 +0100
Message-Id: <1353013679-16773-4-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
References: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:U6PekiaaAUZlM1JqFeySnkgPVTRgeWmsUaH4syU2wlG
 wB9tcnpYRBRqfUOinPd5MO6hDhFQBk2uIEGTTmGfuBrIpTvDHa
 Bq7QLb741c7/KGzszKFMoTveaPK3w5N9UoW06dm9ki7MsSqBTW
 cM+WcE5QsZ/CGkxc6KBLXmxJGoQUblTAZ4Y1Knwknm2YVrTKGM
 pK33C+RriuseuPfvwo+D6p78OldLnZxTniEix0HdEz6MutUzIU
 xCvYtaIgOFf8XY/qGy4N52Ti2rARw1Tc3nG94k/Lv7wrs7t0Km
 /gaD9D7wQb4DOqw+53AEImL+lgBR4NQQySb3lLOMB7Bxmw3NCg
 KfFKm7Lq18d+8Jdth5afYsmODSVm1mRtKlAlTXhdThe8r3shoS
 dW0meeBvUkqQVRTN1CPijJPUPBPXPXE5++QW6cKtSvfqPwMSpc
 dxMsR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the pll_d frequency table with a few entries to support common
HDMI and LVDS display modes and setup the clock parents for the two
display controllers and HDMI.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/mach-tegra/tegra20_clocks_data.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
index 9615ee3..a23a073 100644
--- a/arch/arm/mach-tegra/tegra20_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
@@ -246,11 +246,16 @@ static struct clk_pll_freq_table tegra_pll_d_freq_table[] = {
 	{ 19200000, 216000000, 135, 12, 1, 3},
 	{ 26000000, 216000000, 216, 26, 1, 4},
 
+	{ 12000000, 297000000,  99,  4, 1, 4 },
+	{ 12000000, 339000000, 113,  4, 1, 4 },
+
 	{ 12000000, 594000000, 594, 12, 1, 8},
 	{ 13000000, 594000000, 594, 13, 1, 8},
 	{ 19200000, 594000000, 495, 16, 1, 8},
 	{ 26000000, 594000000, 594, 26, 1, 8},
 
+	{ 12000000, 616000000, 616, 12, 1, 8},
+
 	{ 12000000, 1000000000, 1000, 12, 1, 12},
 	{ 13000000, 1000000000, 1000, 13, 1, 12},
 	{ 19200000, 1000000000, 625,  12, 1, 8},
@@ -1036,9 +1041,6 @@ static struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("usbd",	"utmip-pad",	NULL),
 	CLK_DUPLICATE("usbd",	"tegra-ehci.0",	NULL),
 	CLK_DUPLICATE("usbd",	"tegra-otg",	NULL),
-	CLK_DUPLICATE("hdmi",	"tegradc.0",	"hdmi"),
-	CLK_DUPLICATE("hdmi",	"tegradc.1",	"hdmi"),
-	CLK_DUPLICATE("host1x",	"tegra_grhost",	"host1x"),
 	CLK_DUPLICATE("2d",	"tegra_grhost",	"gr2d"),
 	CLK_DUPLICATE("3d",	"tegra_grhost",	"gr3d"),
 	CLK_DUPLICATE("epp",	"tegra_grhost",	"epp"),
@@ -1051,6 +1053,9 @@ static struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.1", "fast-clk"),
 	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
 	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
+	CLK_DUPLICATE("pll_p", "tegradc.0", "parent"),
+	CLK_DUPLICATE("pll_p", "tegradc.1", "parent"),
+	CLK_DUPLICATE("pll_d_out0", "hdmi", "parent"),
 };
 
 #define CLK(dev, con, ck)	\
-- 
1.8.0

