Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1BVCmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:42:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:62617 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1BVCl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:41:27 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: konkers@android.com, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mike@compulab.co.il,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 6/7] ARM: tegra: common: Enable core clocks
Date: Mon, 21 Feb 2011 18:39:51 -0800
Message-Id: <1298342392-21236-7-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298342392-21236-1-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the cpu, emc (memory controller) and csite (debug and
trace controller) clocks during init to prevent them from
being disabled by the bootloader clock disabling code.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/common.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 14fa533..516e100 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -56,6 +56,9 @@ static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
 	{ "sclk",	"pll_p_out4",	108000000,	true },
 	{ "hclk",	"sclk",		108000000,	true },
 	{ "pclk",	"hclk",		54000000,	true },
+	{ "csite",	NULL,		0,		true },
+	{ "emc",	NULL,		0,		true },
+	{ "cpu",	NULL,		0,		true },
 	{ NULL,		NULL,		0,		0},
 };
 
-- 
1.7.3.1

