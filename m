Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1AUId4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:33:56 -0500
Received: from www.tglx.de ([62.245.132.106]:40375 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab1AUIdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:33:54 -0500
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: balbi@ti.com
Subject: [PATCH v3] OMAP2/3: clock: fix fint calculation for DPLL_FREQSEL
From: John Ogness <john.ogness@linutronix.de>
References: <87ei8726wf.fsf@vostro.fn.ogness.net>
	<20110120111645.GB2223@legolas.emea.dhcp.ti.com>
	<8739on1wdd.fsf_-_@vostro.fn.ogness.net>
	<20110121031553.GA2448@legolas.emea.dhcp.ti.com>
Date: Fri, 21 Jan 2011 09:33:33 +0100
In-Reply-To: <20110121031553.GA2448@legolas.emea.dhcp.ti.com> (Felipe Balbi's message of "Fri\, 21 Jan 2011 05\:15\:53 +0200")
Message-ID: <87y66e3bc2.fsf_-_@vostro.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

In OMAP35X TRM Rev 2010-05 Figure 7-18 "DPLL With EMI Reduction
Feature", it is shown that the internal frequency is calculated by
CLK_IN/(N+1). However, the value passed to _dpll_test_fint() is
already "N+1" since Linux is using the values to divide by. In the
technical reference manual, "N" is referring to the divider's register
value (0-127).

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
patch v3:
Patch against linux-next-20110121.
I have improved the commit message so that it is acceptable for the
git commit log.

 arch/arm/mach-omap2/clkt_dpll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clkt_dpll.c b/arch/arm/mach-omap2/clkt_dpll.c
index 337392c..acb7ae5 100644
--- a/arch/arm/mach-omap2/clkt_dpll.c
+++ b/arch/arm/mach-omap2/clkt_dpll.c
@@ -77,7 +77,7 @@ static int _dpll_test_fint(struct clk *clk, u8 n)
 	dd = clk->dpll_data;
 
 	/* DPLL divider must result in a valid jitter correction val */
-	fint = clk->parent->rate / (n + 1);
+	fint = clk->parent->rate / n;
 	if (fint < DPLL_FINT_BAND1_MIN) {
 
 		pr_debug("rejecting n=%d due to Fint failure, "
-- 
1.5.6.5
