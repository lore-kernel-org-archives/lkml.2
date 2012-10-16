Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2JPKK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:10:29 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3618 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2JPKKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:10:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 16 Oct 2012 03:10:16 -0700
From: Sivaram Nair <sivaramn@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <sivaramn@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: add tegra_timer clock
Date: Tue, 16 Oct 2012 13:08:36 +0300
Message-ID: <1350382116-18024-3-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1350382116-18024-1-git-send-email-sivaramn@nvidia.com>
References: <1350382116-18024-1-git-send-email-sivaramn@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sivaram Nair <sivaramn@nvidia.com>

This undoes commit 20f4665831cec65d6e5d33587bba28ffa536b91d by bringing
back the tegra_timer clock.  tegra_timer is indeed a clock (hidden by
the PERIPH_CLK macro) which should be added to the tegra_list_clks.

The above commit caused tegra_init_timer() failing to get the clk
reference.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 arch/arm/mach-tegra/tegra20_clocks_data.c |    1 +
 arch/arm/mach-tegra/tegra30_clocks_data.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
index cc9b5fd..8d398a3 100644
--- a/arch/arm/mach-tegra/tegra20_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
@@ -953,6 +953,7 @@ PERIPH_CLK(pcie_xclk,	NULL,		  "pcie_xclk",  74,     0,	26000000,  mux_clk_m,
 static struct clk *tegra_list_clks[] = {
 	&tegra_apbdma,
 	&tegra_rtc,
+	&tegra_timer,
 	&tegra_i2s1,
 	&tegra_i2s2,
 	&tegra_spdif_out,
diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index d92cb55..3d2e553 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -1143,6 +1143,7 @@ struct clk *tegra_list_clks[] = {
 	&tegra_apbdma,
 	&tegra_rtc,
 	&tegra_kbc,
+	&tegra_timer,
 	&tegra_kfuse,
 	&tegra_fuse,
 	&tegra_fuse_burn,
-- 
1.7.0.4

