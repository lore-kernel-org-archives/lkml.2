Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab2KOVWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:22:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50533 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2KOVUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:20:48 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] ARM: tegra: Add Tegra30 host1x clock support
Date: Thu, 15 Nov 2012 22:07:59 +0100
Message-Id: <1353013679-16773-7-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
References: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:D5N89TzkvoE3OaUjaAmoHKmyI/DBWgleVxkHap62MxJ
 qTDiVsUXHcUoBKnnsq7GnU47WT9EBNS0RZ4a1qP1UhJZWoBkRs
 1CXCd5M/f+mfIn4tm1nXCGYcdunBRH5UKStHwTO/6foE0YU13l
 1gV1NcSrFqqFgR+prt8uTkC4oAGgfvvuv3svWKtpAKFAwQCNGw
 LFs2IPn8frkG3QRhkXN1X9CEtucM5N4psmThn/GBnws1BubuO8
 XMiPv4gb5ocEZIt+H+cc+4kJu4Z1HnD0JzoWENehQqp7n4cMea
 h4qdGX9Jco7wuhJr9qky4KxwOTN9f/dul+Ue1x+KV8Gqg7DskQ
 HyvX84a4yBU188gvf9GY9aSR04pLPRPnKYvzImLg+qV8o15nEU
 8Y4XIqff5f2ayNTtH4OMCY7ISg1YQSA/+C8K/EfWD1LvLTkNY2
 TBoJ8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup the clock parents for the two display controllers and HDMI.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/mach-tegra/tegra30_clocks_data.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index 7bc8b1d..6942c7a 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -1298,8 +1298,6 @@ struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("usbd", "utmip-pad", NULL),
 	CLK_DUPLICATE("usbd", "tegra-ehci.0", NULL),
 	CLK_DUPLICATE("usbd", "tegra-otg", NULL),
-	CLK_DUPLICATE("hdmi", "tegradc.0", "hdmi"),
-	CLK_DUPLICATE("hdmi", "tegradc.1", "hdmi"),
 	CLK_DUPLICATE("dsib", "tegradc.0", "dsib"),
 	CLK_DUPLICATE("dsia", "tegradc.1", "dsia"),
 	CLK_DUPLICATE("bsev", "tegra-avp", "bsev"),
@@ -1337,6 +1335,9 @@ struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
 	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
 	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.4", "fast-clk"),
+	CLK_DUPLICATE("pll_p", "tegradc.0", "parent"),
+	CLK_DUPLICATE("pll_p", "tegradc.1", "parent"),
+	CLK_DUPLICATE("pll_d2_out0", "hdmi", "parent"),
 };
 
 struct clk *tegra_ptr_clks[] = {
-- 
1.8.0

