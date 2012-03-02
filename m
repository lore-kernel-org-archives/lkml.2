Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab2CBWZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:25:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39038 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab2CBWZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:25:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.186.1 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>
Subject: [PATCH v3 1/5] ARM: tegra: do not hide dma declarations
Date: Fri,  2 Mar 2012 17:25:37 -0500
Message-Id: <1330727137-11052-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330727075-10974-1-git-send-email-alan@signal11.us>
References: <1330727075-10974-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The declarations are actually required for the device
definitions, and are still valid even if the dma controller
is disabled:

arch/arm/mach-tegra/devices.c:559:12: error: 'TEGRA_DMA_REQ_SEL_I2S_1' undeclared here (not in a function)
arch/arm/mach-tegra/devices.c:577:12: error: 'TEGRA_DMA_REQ_SEL_I2S2_1' undeclared here (not in a function)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
---
 arch/arm/mach-tegra/include/mach/dma.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/dma.h b/arch/arm/mach-tegra/include/mach/dma.h
index 3c93390..9077092 100644
--- a/arch/arm/mach-tegra/include/mach/dma.h
+++ b/arch/arm/mach-tegra/include/mach/dma.h
@@ -51,8 +51,6 @@
 #define TEGRA_DMA_REQ_SEL_OWR			25
 #define TEGRA_DMA_REQ_SEL_INVALID		31
 
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-
 struct tegra_dma_req;
 struct tegra_dma_channel;
 
@@ -151,5 +149,3 @@ void tegra_dma_free_channel(struct tegra_dma_channel *ch);
 int __init tegra_dma_init(void);
 
 #endif
-
-#endif
-- 
1.7.0.4

