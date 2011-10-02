Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1JBOtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:49:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab1JBOrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/30] ARM: omap2/n8x0: work around modular omap mmc
Date: Sun,  2 Oct 2011 16:45:41 +0200
Message-Id: <1317566760-25681-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:wOcnvMdD0rCUg+ahcvNCpE+fIMtR5znTCH777mNLY/N
 nSxAHu8r5pKHwMZnKn4wZyHY1Fj8S7UQrcUmcj2Lz/JAxR3qSz
 geO+8hpQYhBFX4rCKuifZbYFngcY7CtbvWcpkBx+25TTIwhyi2
 +lXaJKBLV0/vnzVxjKbCHr1EBg5p76M3crcEV5EpR2+8Yj8zMt
 hsYC8yP/zXXeNrt7yrGiPmpTGUgt4KU/AZbmu+STbL7LMr8Ryj
 rWObQ5Ewkk0n4Y9GpGaOvcRBbwTfvNdtALVOnJScn0HMveyo+/
 pgbA8RgXS7qNP6IbHUbySDKKRNnTY3Bi3DsUO9EeVbp4owwMhc
 Q7dUbSryOQYGxPX+jfcTsYsWMXlAPd8OQw4xwdJDJvMgmN1aeE
 AHfQ8rbeQBy2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the omap driver is built as a module for n8x0,
n8x0_mmc_set_power_menelaus cannot call into the driver:

arch/arm/mach-omap2/board-n8x0.c:374: undefined reference to `omap_mmc_notify_cover_event'

As a workaround, do not provide that device in this case. This needs
to be fixed properly, e.g. by converting n8x0 to be probed through the
device tree and moving that code into the driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/board-n8x0.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index e11f0c5..403325d 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -193,8 +193,9 @@ static struct omap_onenand_platform_data board_onenand_data[] = {
 };
 #endif
 
-#if defined(CONFIG_MENELAUS) &&						\
-	(defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE))
+#if defined(CONFIG_MENELAUS) && defined(CONFIG_MMC_OMAP)
+/* || defined(CONFIG_MMC_OMAP_MODULE)) */
+/* FIXME: cannot call omap_mmc_notify_cover_event for ONFIG_MMC_OMAP_MODULE */
 
 /*
  * On both N800 and N810, only the first of the two MMC controllers is in use.
-- 
1.7.5.4

