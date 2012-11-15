Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab2KOVUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:20:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2KOVUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:20:50 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] ARM: tegra: Add AUXDATA for Tegra30 host1x
Date: Thu, 15 Nov 2012 22:07:58 +0100
Message-Id: <1353013679-16773-6-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
References: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:MaQdVcmGs+OOlpqIXkJYg+poarT3m2I6MPFbRH5r2SH
 txL5V/CtRbtHHIv64JMclYtbOK81rRcgSU6ujZtcNWJPHpCitA
 U7rZt4Mofc5QrAVyKzvu+cWC/smGkno3kbIxI00jJAXLulXCZ4
 E4f9uARVVhUrxAX8JrVM97qT+LdlwXqnWAxHmfVWYi2imeEPWP
 RMdSQk0BZN1oIsE+8d0OCAtBJ1FGjsPHsKmrS6pNgkplQbY1Lx
 utu8i43nJvjwOtngBJXwRCNimzRJnR7qshmf4PXBU2Ssw9/ltV
 BOkWZ2vRcvadPSVGTMein96w45KtVX3pUMiY/yOOghiIp7JLE2
 03txUdt/ExmNfejAzDL7kdLkihXffIE1jLG6Gfj94YBJkWnPg+
 UJqLrKmQjrlg59B+zX7QR1hFZuF5jaaeZoRfVqJZooRRcs19pq
 YM93u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the OF_DEV_AUXDATA table entries required to associate the proper
names with host1x and its children. In turn, this allows the devices to
find the required clocks.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/mach-tegra/board-dt-tegra30.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index cd30338..6497d12 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -57,6 +57,12 @@ struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DA00, "spi_tegra.3", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DC00, "spi_tegra.4", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DE00, "spi_tegra.5", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-host1x", 0x50000000, "host1x", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-dc", 0x54200000, "tegradc.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-dc", 0x54240000, "tegradc.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-hdmi", 0x54280000, "hdmi", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-dsi", 0x54300000, "dsi", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-tvo", 0x542c0000, "tvo", NULL),
 	{}
 };
 
@@ -82,6 +88,9 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "sbc4",	"pll_p",	100000000,	false},
 	{ "sbc5",	"pll_p",	100000000,	false},
 	{ "sbc6",	"pll_p",	100000000,	false},
+	{ "host1x",	"pll_c",	150000000,	false},
+	{ "disp1",	"pll_p",	600000000,	false},
+	{ "disp2",	"pll_p",	600000000,	false},
 	{ NULL,		NULL,		0,		0},
 };
 
-- 
1.8.0

