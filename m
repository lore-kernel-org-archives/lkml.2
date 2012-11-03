Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2KCUas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 16:30:48 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:36725
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757078Ab2KCUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 16:30:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161264929"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Tony Lindgren <tony@atomide.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] arch/arm/mach-omap2/dpll3xxx.c: drop if around WARN_ON
Date: Sat,  3 Nov 2012 21:30:23 +0100
Message-Id: <1351974625-10282-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Just use WARN_ON rather than an if containing only WARN_ON(1).

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) WARN_ON(1);
+ WARN_ON(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/arm/mach-omap2/dpll3xxx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index eacf51f..ed855b0 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -478,8 +478,7 @@ int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
 		if (!soc_is_am33xx() && !cpu_is_omap44xx() && !cpu_is_omap3630()) {
 			freqsel = _omap3_dpll_compute_freqsel(clk,
 						dd->last_rounded_n);
-			if (!freqsel)
-				WARN_ON(1);
+			WARN_ON(!freqsel);
 		}
 
 		pr_debug("clock: %s: set rate: locking rate to %lu.\n",

