Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1K0Dlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 22:41:31 -0500
Received: from d1.icnet.pl ([212.160.220.21]:56249 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab1K0Dl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 22:41:28 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 2/5] ARM: OMAP1: Fix ckctl value used for dpll1 defualt rate
Date: Sun, 27 Nov 2011 04:32:28 +0100
Message-Id: <1322364751-29980-3-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the exact value found in omap1_rate_table, otherwise I have been
experiencing issues with correct timekeeping on my Amstrad Delta.

Created and tested on top of patch "ARM: OMAP1: Fix dpll1 default rate
reprogramming method".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/clock_data.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/clock_data.c b/arch/arm/mach-omap1/clock_data.c
index 4550415..201b1f2 100644
--- a/arch/arm/mach-omap1/clock_data.c
+++ b/arch/arm/mach-omap1/clock_data.c
@@ -937,7 +937,7 @@ void __init omap1_clk_late_init(void)
 		/*
 		 * Reprogramming the DPLL is tricky, it must be done from SRAM.
 		 */
-		omap_sram_reprogram_clock(0x2290, 0x1005);
+		omap_sram_reprogram_clock(0x2290, 0x0005);
 		ck_dpll1.rate = OMAP1_DPLL1_SANE_VALUE;
 	}
 	propagate_rate(&ck_dpll1);
-- 
1.7.3.4

