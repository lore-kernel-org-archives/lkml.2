Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1LAUOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:14:19 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48011 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1LAUOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:14:15 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 1/2 v2] ARM: OMAP1: Fix ckctl value used for dpll1 defualt rate
Date: Thu,  1 Dec 2011 21:13:01 +0100
Message-Id: <1322770382-30718-2-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <201112012023.04635.jkrzyszt@tis.icnet.pl>
References: <201112012023.04635.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the exact value found in omap1_rate_table, otherwise I have been
experiencing issues with correct timekeeping on my Amstrad Delta.

Created and tested on top of linux-omap/fixes, not yet in 3.2-rc.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
v2 changes:
* previous 2/5, refreshed directly on linux-omap/fixes after 1/5
  left for the next merge window.

 arch/arm/mach-omap1/clock_data.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/clock_data.c b/arch/arm/mach-omap1/clock_data.c
index 1297bb5..b001299 100644
--- a/arch/arm/mach-omap1/clock_data.c
+++ b/arch/arm/mach-omap1/clock_data.c
@@ -934,7 +934,7 @@ void __init omap1_clk_late_init(void)
 	if (omap1_select_table_rate(&virtual_ck_mpu, ~0)) {
 		pr_err("System frequencies not set, using default. Check your config.\n");
 		omap_writew(0x2290, DPLL_CTL);
-		omap_writew(cpu_is_omap7xx() ? 0x3005 : 0x1005, ARM_CKCTL);
+		omap_writew(cpu_is_omap7xx() ? 0x2005 : 0x0005, ARM_CKCTL);
 		ck_dpll1.rate = OMAP1_DPLL1_SANE_VALUE;
 	}
 	propagate_rate(&ck_dpll1);
-- 
1.7.3.4

