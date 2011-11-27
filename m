Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1K0Dln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 22:41:43 -0500
Received: from d1.icnet.pl ([212.160.220.21]:56287 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab1K0Dlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 22:41:42 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 3/5] ARM: OMAP1: Fix dpll1 reprogramming not actually allowed
Date: Sun, 27 Nov 2011 04:32:29 +0100
Message-Id: <1322364751-29980-4-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DPLL1 reprogramming to a different rate is actually blocked inside
omap1_select_table_rate(), resulting in the defalut rate of 60 MHz
always used instead of the one selected in .config. Fix it.

Created against linux-3.2-rc2, tested on Amstrad Delta on top of
linux-omap/fixes.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/clock.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index 3899176..962adbc 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -200,10 +200,6 @@ int omap1_select_table_rate(struct clk *clk, unsigned long rate)
 		if (ptr->xtal != ref_rate)
 			continue;
 
-		/* DPLL1 cannot be reprogrammed without risking system crash */
-		if (likely(dpll1_rate != 0) && ptr->pll_rate != dpll1_rate)
-			continue;
-
 		/* Can check only after xtal frequency check */
 		if (ptr->rate <= rate)
 			break;
-- 
1.7.3.4

