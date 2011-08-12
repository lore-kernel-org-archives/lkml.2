Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1HLWzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:55:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37317 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1HLWzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:55:24 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 09/12] arm/tegra: Convert pinmux driver to a platform device
Date: Fri, 12 Aug 2011 16:54:54 -0600
Message-Id: <1313189697-21287-10-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/pinmux.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
index f80d507..05fa1a3 100644
--- a/arch/arm/mach-tegra/pinmux.c
+++ b/arch/arm/mach-tegra/pinmux.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 
 #include <mach/iomap.h>
 #include <mach/pinmux.h>
@@ -665,6 +666,26 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
 	}
 }
 
+static int __init tegra_pinmux_probe(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver tegra_pinmux_driver = {
+	.driver		= {
+		.name	= "tegra-pinmux",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tegra_pinmux_probe,
+};
+
+static int __init tegra_pinmux_init(void)
+{
+	return platform_driver_register(&tegra_pinmux_driver);
+}
+postcore_initcall(tegra_pinmux_init);
+
+
 #ifdef	CONFIG_DEBUG_FS
 
 #include <linux/debugfs.h>
-- 
1.7.0.4

