Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1BSW24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 17:28:56 -0500
Received: from smtp-out.google.com ([74.125.121.67]:52449 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1BSW0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 17:26:38 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/21] ARM: tegra: clock: Don't BUG on changing an enabled PLL
Date: Sat, 19 Feb 2011 14:25:51 -0800
Message-Id: <1298154371-5641-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298154371-5641-1-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
To: linux-tegra@vger.kernel.org
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/tegra2_clocks.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 240f921..db27e59 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -620,7 +620,6 @@ static int tegra2_pll_clk_set_rate(struct clk *c, unsigned long rate)
 	const struct clk_pll_table *sel;
 
 	pr_debug("%s: %s %lu\n", __func__, c->name, rate);
-	BUG_ON(c->refcnt != 0);
 
 	input_rate = c->parent->rate;
 	for (sel = c->pll_table; sel->input_rate != 0; sel++) {
-- 
1.7.3.1

