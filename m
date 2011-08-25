Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1HYXoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:44:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33333 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1HYXoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:44:17 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v3 09/13] arm/tegra: Convert pinmux driver to a platform device
Date: Thu, 25 Aug 2011 17:43:40 -0600
Message-Id: <1314315824-9687-10-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/pinmux.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
index f80d507..ed316f9 100644
--- a/arch/arm/mach-tegra/pinmux.c
+++ b/arch/arm/mach-tegra/pinmux.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 
 #include <mach/iomap.h>
 #include <mach/pinmux.h>
@@ -665,6 +666,25 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
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
 #ifdef	CONFIG_DEBUG_FS
 
 #include <linux/debugfs.h>
-- 
1.7.0.4

