Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1BJGoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:44:01 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1BJGn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:43:59 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 15/15] ARM: tegra: Use writel_relaxed in tegra_init_cache
Date: Wed,  9 Feb 2011 22:43:24 -0800
Message-Id: <1297320204-31882-16-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 84a7197..34559d1 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -63,8 +63,8 @@ void __init tegra_init_cache(void)
 #ifdef CONFIG_CACHE_L2X0
 	void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
 
-	writel(0x331, p + L2X0_TAG_LATENCY_CTRL);
-	writel(0x441, p + L2X0_DATA_LATENCY_CTRL);
+	writel_relaxed(0x331, p + L2X0_TAG_LATENCY_CTRL);
+	writel_relaxed(0x441, p + L2X0_DATA_LATENCY_CTRL);
 
 	l2x0_init(p, 0x6C080001, 0x8200c3fe);
 #endif
-- 
1.7.3.1

