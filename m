Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1ATKmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:42:25 -0500
Received: from www.tglx.de ([62.245.132.106]:55358 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab1ATKmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:42:24 -0500
To: paul@pwsan.com
Cc: tony@atomide.com
Cc: r-woodruff2@ti.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] omap2: fix DPLL_FREQSEL calculation
From: John Ogness <john.ogness@linutronix.de>
Date: Thu, 20 Jan 2011 11:42:24 +0100
Message-ID: <87ei8726wf.fsf@vostro.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes the calculation of the internal frequency. The value
of "n" is one less than the actual divider. 0 is a valid value.

An example where the internal frequency is calculated correctly can be
found here: clkt_dpll.c:_dpll_test_fint()

This patch is against linux-next-20110120.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 arch/arm/mach-omap2/dpll3xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/dpll3xxx.c	2011-01-20 11:20:41.706860086 +0100
+++ b/arch/arm/mach-omap2/dpll3xxx.c	2011-01-20 11:21:27.966860086 +0100
@@ -93,7 +93,7 @@ static u16 _omap3_dpll_compute_freqsel(s
 	unsigned long fint;
 	u16 f = 0;
 
-	fint = clk->dpll_data->clk_ref->rate / n;
+	fint = clk->dpll_data->clk_ref->rate / (n + 1);
 
 	pr_debug("clock: fint is %lu\n", fint);
 
