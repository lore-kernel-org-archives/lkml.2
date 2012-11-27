Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2K0GyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:54:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19856 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab2K0Gx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:53:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 26 Nov 2012 22:53:45 -0800
From: Sivaram Nair <sivaramn@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Sivaram Nair <sivaramn@nvidia.com>
Subject: [PATCH 1/1] ARM: tegra: replace long if statement group
Date: Tue, 27 Nov 2012 08:53:33 +0200
Message-ID: <1353999213-4889-1-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The long list of if statements are replaced with corresponding
switch cases.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 arch/arm/mach-tegra/tegra30_clocks.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra30_clocks.c b/arch/arm/mach-tegra/tegra30_clocks.c
index d714777..753addd 100644
--- a/arch/arm/mach-tegra/tegra30_clocks.c
+++ b/arch/arm/mach-tegra/tegra30_clocks.c
@@ -444,21 +444,23 @@ static unsigned long clk_measure_input_freq(void)
 	clk_writel(OSC_FREQ_DET_TRIG | 1, OSC_FREQ_DET);
 	do {} while (clk_readl(OSC_FREQ_DET_STATUS) & OSC_FREQ_DET_BUSY);
 	clock_autodetect = clk_readl(OSC_FREQ_DET_STATUS);
-	if (clock_autodetect >= 732 - 3 && clock_autodetect <= 732 + 3) {
+
+	switch (clock_autodetect) {
+	case (732 - 3)...(732 + 3):
 		return 12000000;
-	} else if (clock_autodetect >= 794 - 3 && clock_autodetect <= 794 + 3) {
+	case (794 - 3)...(794 + 3):
 		return 13000000;
-	} else if (clock_autodetect >= 1172 - 3 && clock_autodetect <= 1172 + 3) {
+	case (1172 - 3)...(1172 + 3):
 		return 19200000;
-	} else if (clock_autodetect >= 1587 - 3 && clock_autodetect <= 1587 + 3) {
+	case (1587 - 3)...(1587 + 3):
 		return 26000000;
-	} else if (clock_autodetect >= 1025 - 3 && clock_autodetect <= 1025 + 3) {
+	case (1025 - 3)...(1025 + 3):
 		return 16800000;
-	} else if (clock_autodetect >= 2344 - 3 && clock_autodetect <= 2344 + 3) {
+	case (2344 - 3)...(2344 + 3):
 		return 38400000;
-	} else if (clock_autodetect >= 2928 - 3 && clock_autodetect <= 2928 + 3) {
+	case (2928 - 3)...(2928 + 3):
 		return 48000000;
-	} else {
+	default:
 		pr_err("%s: Unexpected clock autodetect value %d", __func__,
 			clock_autodetect);
 		BUG();
-- 
1.7.9.5

